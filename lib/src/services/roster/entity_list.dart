import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';
import 'package:swlegion/swlegion.dart';

/// Wraps and provides hooks for modifications to `ListBuilder<T>`.
class EntityList<T extends Indexable<T>> {
  final ListBuilder<T> _delegate;

  final T Function(T) _assignId;

  StreamController<Reference<T>> _onUpdated;
  StreamController<Reference<T>> _onDeleted;

  EntityList(
    this._delegate, {
    @required T Function(T) assignId,
  })  : assert(assignId != null),
        _assignId = assignId;

  Stream<Reference<T>> get onUpdated {
    _onUpdated ??= StreamController.broadcast(
      onCancel: () {
        _onUpdated = null;
      },
    );
    return _onUpdated.stream;
  }

  Stream<Reference<T>> get onDeleted {
    _onDeleted ??= StreamController.broadcast(
      onCancel: () {
        _onDeleted = null;
      },
    );
    return _onDeleted.stream;
  }

  int _indexOf(String id) {
    final list = _delegate;
    final length = list.length;
    for (var i = 0; i < length; i++) {
      if (list[i].id == id) {
        return i;
      }
    }
    return -1;
  }

  List<T> toList() => _delegate.build().asList();

  /// Removes [reference]'s entity from the backing store.
  bool remove(Reference<T> reference) {
    final index = _indexOf(reference.id);
    if (index == -1) {
      return false;
    }
    _delegate.removeAt(index);
    _onDeleted?.add(reference);
    return true;
  }

  /// Clears all entities.
  ///
  /// **NOTE**: This does not invoke notifiers.
  void clear() {
    _delegate.clear();
  }

  /// Inserts or updates [entity] from the backing store.
  T update(T entity) {
    if (entity.id == null) {
      entity = _assignId(entity);
      _delegate.add(entity);
    } else {
      _delegate[_indexOf(entity.id)] = entity;
    }
    _onUpdated?.add(entity.toRef());
    return entity;
  }

  /// Finds the entity [T] by `Reference<T>`.
  T lookup(Reference<T> entity) {
    return _delegate[_indexOf(entity.id)];
  }
}
