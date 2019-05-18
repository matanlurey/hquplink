import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:hquplink/models.dart';
import 'package:swlegion/catalog.dart';
import 'package:swlegion/swlegion.dart';
import 'package:uuid/uuid.dart';

import 'data_store.dart';
import 'entity_list.dart';
import 'persistence.dart';

/// Implements a limited local data store for entities [T].
class LocalPersistance<T extends Indexable<T>> implements Persistent<T> {
  /// Backing data store for the collection of [T].
  final EntityList<T> _data;

  /// Invoked when the backing store has been updated.
  final void Function(Reference<T>, LocalDataAction) _notifyChanged;

  LocalPersistance(this._data, this._notifyChanged);

  @override
  clear() async {
    _data.clear();
    _notifyChanged(null, null);
  }

  @override
  delete(entity) async {
    _data.remove(entity);
    _notifyChanged(entity, LocalDataAction.deleted);
  }

  @override
  update(entity) async {
    final result = _data.update(entity);
    _notifyChanged(result.toRef(), LocalDataAction.updated);
    return result;
  }

  @override
  fetch(entity) {
    StreamController<T> controller;
    controller = StreamController.broadcast(
      onListen: () {
        controller
          ..add(_data.lookup(entity))
          ..addStream(
            _data.onUpdated.where((ref) => entity == ref).map(_data.lookup),
          );
      },
    );
    return controller.stream;
  }

  @override
  list() {
    StreamSubscription<void> onListUpdated;
    StreamSubscription<void> onListDeleted;
    StreamController<List<T>> controller;
    controller = StreamController.broadcast(
      onCancel: () {
        onListUpdated.cancel();
        onListDeleted.cancel();
      },
      onListen: () {
        void update() {
          controller.add(_data.toList());
        }

        onListDeleted = _data.onDeleted.listen((_) {
          update();
        });

        onListUpdated = _data.onUpdated.listen((_) {
          update();
        });

        // Initial data.
        update();
      },
    );
    return controller.stream;
  }
}

/// Known reasons that [LocalPersistance] notifies the provided callback.
enum LocalDataAction {
  updated,
  deleted,
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
    _squadsForArmy[army]?.clear();
  }

  void _scheduleDataChanged() {
    if (_scheduledChange) {
      return;
    }
    _scheduledChange = true;
    scheduleMicrotask(() {
      _scheduledChange = false;
      _onChanged(_localData.build());
    });
  }

  LocalPersistance<Army> _armies;

  @override
  armies() {
    if (_armies == null) {
      final list = EntityList<Army>(
        () => _localData.armies,
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

  final _squadsForArmy = <Reference<Army>, LocalPersistance<Squad>>{};

  @override
  squads(army) {
    army = army.toRef();
    var squad = _squadsForArmy[army];
    if (squad == null) {
      final list = EntityList<Squad>(
        () => _localData.squads[army],
        assignId: (squad) {
          return squad.rebuild((b) => b.id = _nextId(Squad));
        },
      );
      squad = _squadsForArmy[army] = LocalPersistance(list, (_, __) {
        _updateArmyAggregations(army);
        _scheduleDataChanged();
      });
    }
    return squad;
  }
}
