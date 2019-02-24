import 'dart:async';

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
abstract class DataStore {
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

/// An in-memory local representation of [DataStore].
///
/// This backend does not support [Persistent.fetch] and [Persistent.list]
/// completely (any mutations do not trigger another stream notification).
class _LocalStore implements DataStore {
  final List<Army> _armies;
  final Map<Reference<Army>, List<Squad>> _squads;
  final Uuid _idGenerator;

  _LocalStore.empty({
    Uuid idGenerator,
  })  : _armies = [],
        _squads = {},
        _idGenerator = idGenerator ?? Uuid();

  // TODO: Implement constructor that has a useful DSL for testing.

  int _indexOf<T extends Indexable<T>>(List<T> list, String id) {
    final length = list.length;
    for (var i = 0; i < length; i++) {
      if (list[i].id == id) {
        return i;
      }
    }
    return -1;
  }

  String _nextId(Type entityType) => _idGenerator.v5('', '$entityType');

  @override
  armies() {
    return Persistent(
      onDelete: (army) async {
        _armies.removeAt(_indexOf(_armies, army.id));
      },
      onUpdate: (army) async {
        if (army.id == null) {
          army = army.rebuild((b) => b.id = _nextId(Army));
          _armies.add(army);
          return army;
        }
        _armies[_indexOf(_armies, army.id)] = army;
      },
      onFetch: (army) async* {
        yield _armies[_indexOf(_armies, army.id)];
      },
      onList: () async* {
        yield List.unmodifiable(_armies);
      },
    );
  }

  @override
  squads(army) {
    final squads = _squads.putIfAbsent(army.toRef(), () => []);
    return Persistent(
      onDelete: (squad) async {
        squads.removeAt(_indexOf(squads, squad.id));
      },
      onUpdate: (squad) async {
        if (squad.id == null) {
          squad = squad.rebuild((b) => b.id = _nextId(Squad));
          squads.add(squad);
          return squad;
        }
        squads[_indexOf(squads, squad.id)] = squad;
      },
      onFetch: (squad) async* {
        yield squads[_indexOf(squads, squad.id)];
      },
      onList: () async* {
        yield List.unmodifiable(squads);
      },
    );
  }
}
