import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:hquplink/models.dart';
import 'package:meta/meta.dart';
import 'package:swlegion/swlegion.dart';
import 'package:uuid/uuid.dart';

/// Represents a connection to a persisted data model [T].
abstract class Persistent<T extends Indexable<T>> {
  const factory Persistent({
    @required Future<void> Function(Reference<T>) onDelete,
    @required Future<T> Function(T) onUpdate,
    @required Stream<T> Function(Reference<T>) onFetch,
    @required Stream<List<T>> Function() onList,
  }) = _Persistent;

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
abstract class DataBackend {
  /// Armies persisted.
  Persistent<Army> armies();

  /// Squads persisted for the provided [army].
  Persistent<Squad> squads(Reference<Army> army);
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

class _LocalDataBackend implements DataBackend {
  final Uuid _idGenerator;

  /// Data that is read/wrote to by this backend.
  LocalDataBuilder _data;

  _LocalDataBackend({
    Uuid idGenerator,
    LocalData initialData,
  })  : _idGenerator = idGenerator ?? Uuid(),
        _data = initialData?.toBuilder() ?? LocalDataBuilder();

  String _generateId<T>() => _idGenerator.v5('', T.toString());

  int _findById<T extends Indexable<T>>(List<T> list, String id) {
    final length = list.length;
    for (var i = 0; i < length; i++) {
      if (list[i].id == id) {
        return i;
      }
    }
    throw StateError('No entity $T found');
  }

  @override
  armies() {
    return Persistent(
      onDelete: (army) async {
        _data.armies.removeWhere((a) => a.id == army.id);
      },
      onUpdate: (army) async {
        if (army.id == null) {
          army = army.rebuild((b) => b.id = _generateId<Army>());
          _data.armies.add(army);
          return;
        } else {}
      },
      onFetch: (army) async* {
        yield _armies[_findById(_armies, army.id)];
      },
      onList: () async* {
        yield _armies.toList();
      },
    );
  }

  @override
  squads(army) {
    army = army.toRef();
    return Persistent(
      onDelete: (squad) async {
        final squads = _squads[army];
        squads.removeAt(_findById(squads, squad.id));
      },
      onUpdate: (squad) async {
        final squads = _squads.putIfAbsent(army, () => []);
        if (squad.id == null) {
          squads.add(squad.rebuild((b) => b.id = _generateId<Squad>()));
          return;
        } else {
          squads[_findById(squads, squad.id)] = squad;
        }
      },
      onFetch: (squad) async* {
        final squads = _squads[army];
        yield squads[_findById(squads, squad.id)];
      },
      onList: () async* {
        yield _squads[army]?.toList() ?? const [];
      },
    );
  }
}
