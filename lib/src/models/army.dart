import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:swlegion/swlegion.dart';

part 'army.g.dart';

/// Represents squads packaged together as an army list.
abstract class Army with Indexable<Army> implements Built<Army, ArmyBuilder> {
  static Serializer<Army> get serializer => _$armySerializer;

  Army._();
  factory Army(void Function(ArmyBuilder) _) = _$Army;

  @override
  @nullable
  String get id;

  /// Commands cards in the army list.
  @BuiltValueField(compare: false, wireName: 'commands')
  BuiltList<Reference<CommandCard>> get commandCards;

  /// Name of the army.
  @BuiltValueField(compare: false)
  String get name;

  /// Maximum number of points allowed for this army.
  ///
  /// **NOTE**: A value of `0` should be considered to be `∞`.
  @BuiltValueField(compare: false, wireName: 'max_points')
  int get maxPoints;

  /// Total number of aggregate points of squads.
  ///
  /// **NOTE**: This is an _aggregation_ currently enforced by the client!
  @BuiltValueField(compare: false, wireName: 'points')
  int get totalPoints;

  /// Returns whether [totalPoints] is over the [maxPoints] allowed.
  ///
  /// Respects the semantics of [maxPoints] of `0` being infinite (`∞`).
  bool get withinMaxPoints => totalPoints < maxPoints || maxPoints == 0;

  /// Featured units that make up the bulk of this army list.
  @BuiltValueField(compare: false, wireName: 'featured')
  BuiltList<Reference<Unit>> get featuredUnits;
}
