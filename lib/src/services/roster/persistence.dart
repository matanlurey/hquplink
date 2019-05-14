import 'dart:async';

import 'package:swlegion/swlegion.dart';

/// Represents access to a persisted data model [T].
abstract class Persistent<T extends Indexable<T>> {
  /// Deletes [entity], returns a [Future] that completes on deletion.
  Future<void> delete(Reference<T> entity);

  /// Deletes all entities related to this collection.
  Future<void> clear();

  /// Updates [entity], returns a [Future] that completes with the saved entity.
  ///
  /// If [Indexable.id] is not specified, it is assumed that the entity has not
  /// ever been initially created, and the returned entity should be assigned an
  /// identifier.
  Future<T> update(T entity);

  /// Returns a stream (initial data, and updates) for the provided [entity].
  Stream<T> fetch(Reference<T> entity);

  /// Returns a stream of all entities of the type [T].
  Stream<List<T>> list();
}
