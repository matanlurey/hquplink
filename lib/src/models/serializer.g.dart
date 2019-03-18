// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializer.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$addSerializers = (new Serializers().toBuilder()
      ..add(Army.serializer)
      ..add(AttackDice.serializer)
      ..add(AttackSurge.serializer)
      ..add(DefenseDice.serializer)
      ..add(Faction.serializer)
      ..add(ForceAlignment.serializer)
      ..add(LocalData.serializer)
      ..add(Rank.serializer)
      ..add(Squad.serializer)
      ..add(Unit.serializer)
      ..add(UnitType.serializer)
      ..add(UpgradeSlot.serializer)
      ..add(Weapon.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Army)]),
          () => new ListBuilder<Army>())
      ..addBuilderFactory(
          const FullType(BuiltListMultimap, const [
            const FullType(Reference, const [const FullType(Army)]),
            const FullType(Squad)
          ]),
          () => new ListMultimapBuilder<Reference<Army>, Squad>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(Reference, const [const FullType(CommandCard)])
          ]),
          () => new ListBuilder<Reference<CommandCard>>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(Reference, const [const FullType(Unit)])
          ]),
          () => new ListBuilder<Reference<Unit>>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(AttackDice), const FullType(int)]),
          () => new MapBuilder<AttackDice, int>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(WeaponKeyword), const FullType(Object)]),
          () => new MapBuilder<WeaponKeyword, Object>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(UpgradeSlot), const FullType(int)]),
          () => new MapBuilder<UpgradeSlot, int>())
      ..addBuilderFactory(
          const FullType(BuiltSet, const [const FullType(Weapon)]),
          () => new SetBuilder<Weapon>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(UnitKeyword), const FullType(Object)]),
          () => new MapBuilder<UnitKeyword, Object>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Wave)]),
          () => new ListBuilder<Wave>())
      ..addBuilderFactory(
          const FullType(Reference, const [const FullType(Unit)]),
          () => new ReferenceBuilder<Unit>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(Reference, const [const FullType(Upgrade)])
          ]),
          () => new ListBuilder<Reference<Upgrade>>()))
    .build();

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
