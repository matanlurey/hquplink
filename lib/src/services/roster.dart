import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/widgets.dart';
import 'package:hquplink/models.dart';
import 'package:meta/meta.dart';
import 'package:swlegion/catalog.dart';
import 'package:swlegion/swlegion.dart';
import 'package:uuid/uuid.dart';

/// Represents a connection to a persisted data model [T].
abstract class Persistent<T extends Indexable<T>> {
  const factory Persistent({
    @required Future<void> Function(Reference<T>) onDelete,
    @required Future<T> Function(T) onUpdate,
    @required Stream<T> Function(Reference<T>) onFetch,
    @required Stream<List<T>> Function() onList,
  }) = _Persistent<T>;

  /// Deletes [entity], returns a future that completes on deletion.
  Future<void> delete(Reference<T> entity);

  /// Updates [entity], returns a future that completes with the saved entity.
  ///
  /// If [Indexable.id] is not specified, it is assumed that the entity has not
  /// ever been initially created, and the update method should set an `id`.
  Future<T> update(T entity);

  /// Returns a stream (initial data, and updates) for the provided [entity].
  Stream<T> fetch(Reference<T> entity);

  /// Returns a stream of all entities of the type [T].
  Stream<List<T>> list();
}

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

class _Persistent<T extends Indexable<T>> implements Persistent<T> {
  final Future<void> Function(Reference<T>) onDelete;
  final Future<T> Function(T) onUpdate;
  final Stream<T> Function(Reference<T>) onFetch;
  final Stream<List<T>> Function() onList;

  const _Persistent({
    @required this.onDelete,
    @required this.onUpdate,
    @required this.onFetch,
    @required this.onList,
  })  : assert(onDelete != null),
        assert(onUpdate != null),
        assert(onFetch != null),
        assert(onList != null);

  @override
  delete(entity) => onDelete(entity);

  @override
  update(entity) => onUpdate(entity);

  @override
  fetch(entity) => onFetch(entity);

  @override
  list() => onList();
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
  final LocalDataChanged _onChanged;
  final Uuid _idGenerator;

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

  String _nextId(Type entityType) => _idGenerator.v5('', '$entityType');

  void _updateArmyAggregations(Reference<Army> reference) {
    final armies = _localData.armies;
    final index = _indexOf(armies, reference.id);
    final squads = _localData.squads[reference];
    armies[index] = armies[index].rebuild((b) {
      return b.totalPoints = squads.build().fold(
        0,
        (sum, squad) {
          final unit = catalog.toUnit(squad.card);
          final upgrades = squad.upgrades.map(catalog.toUpgrade).fold<int>(
                0,
                (s, u) => s + u.points,
              );
          return sum + unit.points + upgrades;
        },
      );
    });
  }

  @override
  armies() {
    return Persistent(
      onDelete: (army) async {
        _localData.armies.removeAt(_indexOf(_localData.armies, army.id));
        _localData.squads.removeAll(army.toRef());
        _onChanged(_localData.build());
      },
      onUpdate: (army) async {
        final armies = _localData.armies;
        if (army.id == null) {
          army = army.rebuild((b) => b.id = _nextId(Army));
          armies.add(army);
        } else {
          armies[_indexOf(armies, army.id)] = army;
        }
        _onChanged(_localData.build());
        return army;
      },
      onFetch: (army) async* {
        final armies = _localData.armies;
        yield armies[_indexOf(armies, army.id)];
      },
      onList: () async* {
        yield _localData.armies.build().asList();
      },
    );
  }

  @override
  squads(army) {
    army = army.toRef();
    final squads = _localData.squads[army];
    return Persistent(
      onDelete: (squad) async {
        _localData.squads.remove(army, squads[_indexOf(squads, squad.id)]);
        _updateArmyAggregations(army);
        _onChanged(_localData.build());
      },
      onUpdate: (squad) async {
        if (squad.id == null) {
          squad = squad.rebuild((b) => b.id = _nextId(Squad));
          _localData.squads.add(army, squad);
        } else {
          squads[_indexOf(squads, squad.id)] = squad;
        }
        _updateArmyAggregations(army);
        _onChanged(_localData.build());
        return squad;
      },
      onFetch: (squad) async* {
        yield squads[_indexOf(squads, squad.id)];
      },
      onList: () async* {
        yield squads.build().asList();
      },
    );
  }
}
