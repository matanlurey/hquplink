import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:hquplink/models.dart';
import 'package:swlegion/swlegion.dart';

/// Data persistance for the app.
abstract class Roster {
  /// Returns armies 
  Stream<BuiltList<Army>> armies();
  Stream<BuiltList<Squad>> squads(Reference<Army> army);
}
