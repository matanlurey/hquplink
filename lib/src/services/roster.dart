import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/widgets.dart';
import 'package:hquplink/models.dart';
import 'package:swlegion/catalog.dart';
import 'package:swlegion/swlegion.dart';
import 'package:uuid/uuid.dart';

import 'roster/local_persist.dart';
import 'roster/persistence.dart';

/// Data persistance backend for the app.
abstract class DataStore {
  /// Finds a [DataStore] for the provided [Widget] tree at [context].
  static DataStore of(BuildContext context) {
    final host = context.inheritFromWidgetOfExactType(_HostDataStore);
    return (host as _HostDataStore)._dataStore;
  }

  /// Hosts a [DataStore] at the provided [Widget] tree at [child].
  static Widget at(DataStore store, Widget child) {
    return _HostDataStore(child, store);
  }

  /// Armies persisted.
  Persistent<Army> armies();

  /// Squads persisted for the provided [army].
  Persistent<Squad> squads(Reference<Army> army);
}

class _HostDataStore extends InheritedWidget {
  final DataStore _dataStore;

  const _HostDataStore(Widget child, this._dataStore) : super(child: child);

  @override
  updateShouldNotify(_HostDataStore oldWidget) {
    return _dataStore != oldWidget._dataStore;
  }
}

/// Fired when [LocalData] is mutated in a [DataStore].
typedef LocalDataChanged = void Function(LocalData);

/// An in-memory local representation of [DataStore].
///
/// This backend does not support [Persistent.fetch] and [Persistent.list]
/// completely (any mutations do not trigger another stream notification).
class LocalStore implements DataStore {
  static void _doNothing(LocalData _) => _;

  final LocalDataBuilder _localData;
  final Uuid _idGenerator;

  final LocalDataChanged _onChanged;
  var _scheduledChange = false;

  LocalStore({
    Uuid idGenerator,
    LocalDataChanged onChanged = _doNothing,
  })  : _localData = LocalDataBuilder(),
        _idGenerator = idGenerator ?? Uuid(),
        _onChanged = onChanged;

  LocalStore.from(
    LocalData data, {
    Uuid idGenerator,
    LocalDataChanged onChanged = _doNothing,
  })  : _localData = data.toBuilder(),
        _idGenerator = idGenerator ?? Uuid(),
        _onChanged = onChanged;

  int _indexOf<T extends Indexable<T>>(ListBuilder<T> list, String id) {
    final length = list.length;
    for (var i = 0; i < length; i++) {
      if (list[i].id == id) {
        return i;
      }
    }
    return -1;
  }

  String _nextId(Type entityType) {
    return _idGenerator.v1(
      options: <String, String>{'entityType': '$entityType'},
    );
  }

  void _updateArmyAggregations(Reference<Army> reference) {
    final armies = _localData.armies;
    final index = _indexOf(armies, reference.id);
    if (index == -1) {
      return;
    }
    final squads = _localData.squads[reference].build();
    final totalPoints = squads.fold<int>(0, (sum, squad) {
      final unit = catalog.toUnit(squad.card);
      final allUpgrades = squad.upgrades.map(catalog.toUpgrade);
      final sumUpgrades = allUpgrades.fold<int>(
        0,
        (s, u) => s + u.points,
      );
      return sum + unit.points + sumUpgrades;
    });
    this
        .armies()
        .update(armies[index].rebuild((b) => b.totalPoints = totalPoints));
  }

  void _clearSquads(Reference<Army> army) {
    _squads[army]?.clear();
  }

  void _scheduleDataChanged() {
    if (_scheduledChange) {
      return;
    }
    _scheduledChange = true;
    scheduleMicrotask(() {
      _onChanged(_localData.build());
    });
  }

  LocalPersistance<Army> _armies;

  @override
  armies() {
    if (_armies == null) {
      final list = EntityList<Army>(
        _localData.armies,
        assignId: (army) {
          return army.rebuild((b) => b.id = _nextId(Army));
        },
      );
      _armies = LocalPersistance(list, (ref, action) {
        _scheduleDataChanged();
        if (action == LocalDataAction.deleted) {
          _clearSquads(ref);
        }
      });
    }
    return _armies;
  }

  final _squads = <Reference<Army>, LocalPersistance<Squad>>{};

  @override
  squads(army) {
    army = army.toRef();
    var squad = _squads[army];
    if (squad == null) {
      final list = EntityList<Squad>(
        _localData.squads[army],
        assignId: (squad) {
          return squad.rebuild((b) => b.id = _nextId(Squad));
        },
      );
      squad = _squads[army] = LocalPersistance(list, (_, __) {
        _updateArmyAggregations(army);
        _scheduleDataChanged();
      });
    }
    return squad;
  }
}
