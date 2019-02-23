import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:swlegion/swlegion.dart';

part 'squad.g.dart';

/// Represents a [card] and any number of [upgrades] added to an army.
abstract class Squad
    with Indexable<Squad>
    implements Built<Squad, SquadBuilder> {
  static Serializer<Squad> get serializer => _$squadSerializer;

  Squad._();
  factory Squad(void Function(SquadBuilder) _) = _$Squad;

  @override
  @nullable
  String get id;

  /// Which [Unit] card this squad represents.
  @BuiltValueField(compare: false)
  Reference<Unit> get card;

  /// Upgrades the squad has added to [card].
  @BuiltValueField(compare: false)
  BuiltList<Reference<Upgrade>> get upgrades;
}
