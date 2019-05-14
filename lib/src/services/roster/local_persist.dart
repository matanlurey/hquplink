import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';
import 'package:swlegion/swlegion.dart';

import 'persistence.dart';

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

  final _onFetch = <Reference<T>, StreamController<T>>{};

  @override
  fetch(entity) {
    return _onFetch.putIfAbsent(entity, () {
      StreamController<T> controller;
      return controller = StreamController.broadcast(
        onCancel: () {
          _onFetch.remove(controller);
        },
        onListen: () {
          controller
            ..add(_data.lookup(entity))
            ..addStream(_data.onUpdated
                .where((ref) => entity == ref)
                .map(_data.lookup));
        },
      );
    }).stream;
  }

  StreamController<List<T>> _onList;
  StreamSubscription<void> _onListUpdated;
  StreamSubscription<void> _onListDeleted;

  @override
  list() {
    _onList ??= StreamController.broadcast(
      onCancel: () {
        _onList = null;
        _onListUpdated?.cancel();
        _onListDeleted?.cancel();
      },
      onListen: () {
        void update() {
          _onList?.add(_data._delegate.build().asList());
        }

        _onListDeleted = _data.onDeleted.listen((_) {
          update();
        });

        _onListUpdated = _data.onUpdated.listen((_) {
          update();
        });

        // Initial data.
        update();
      },
    );
    return _onList.stream;
  }
}

/// Known reasons that [LocalPersistance] notifies the provided callback.
enum LocalDataAction {
  updated,
  deleted,
}
