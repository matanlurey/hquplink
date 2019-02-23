import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:swlegion/swlegion.dart';

import 'army.dart';
import 'squad.dart';

part 'local.g.dart';

abstract class LocalData implements Built<LocalData, LocalDataBuilder> {
  static Serializer<LocalData> get serializer => _$localDataSerializer;

  LocalData._();
  factory LocalData(void Function(LocalDataBuilder) _) = _$LocalData;

  /// Saved armies.
  BuiltList<Army> get armies;

  /// Saved squads.
  BuiltListMultimap<Reference<Army>, Squad> get squads;
}
