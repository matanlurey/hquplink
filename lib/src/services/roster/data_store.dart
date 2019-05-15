import 'package:flutter/widgets.dart';
import 'package:hquplink/models.dart';
import 'package:swlegion/swlegion.dart';

import 'persistence.dart';

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
