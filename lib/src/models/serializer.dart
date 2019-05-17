import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:swlegion/swlegion.dart';

import 'army.dart';
import 'local.dart';
import 'squad.dart';

part 'serializer.g.dart';

/// Additional serializers (that add on to the one's from `swlegion`).
@SerializersFor([
  Army,
  LocalData,
  Squad,
])
final Serializers addSerializers = _$addSerializers;

/// All serializers necessary to encode/decode app state to/from JSON.
///
/// **NOTE**: This does not (yet) support the standard JSON format.
final Serializers appSerializers = (SerializersBuilder()
      ..addAll(serializers.serializers)
      ..addAll(addSerializers.serializers)
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Army)]),
        () => ListBuilder<Army>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [
          FullType(Reference, [FullType(CommandCard)])
        ]),
        () => ListBuilder<Reference<CommandCard>>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [
          FullType(Reference, [FullType(Unit)])
        ]),
        () => ListBuilder<Reference<Unit>>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [
          FullType(Reference, [FullType(Upgrade)])
        ]),
        () => ListBuilder<Reference<Upgrade>>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltListMultimap, [
          FullType(Reference, [FullType(Army)]),
          FullType(Squad),
        ]),
        () => ListMultimapBuilder<Reference<Army>, Squad>(),
      ))
    .build();

// UNUSED: https://github.com/google/built_value.dart/issues/608.
class ReferenceBuilder<T> {
  const ReferenceBuilder() : assert(false, 'Should not be used');
}
