// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'army.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Army> _$armySerializer = new _$ArmySerializer();

class _$ArmySerializer implements StructuredSerializer<Army> {
  @override
  final Iterable<Type> types = const [Army, _$Army];
  @override
  final String wireName = 'Army';

  @override
  Iterable serialize(Serializers serializers, Army object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'commands',
      serializers.serialize(object.commandCards,
          specifiedType: const FullType(BuiltList, const [
            const FullType(Reference, const [const FullType(CommandCard)])
          ])),
      'faction',
      serializers.serialize(object.faction,
          specifiedType: const FullType(Faction)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'max_points',
      serializers.serialize(object.maxPoints,
          specifiedType: const FullType(int)),
      'points',
      serializers.serialize(object.totalPoints,
          specifiedType: const FullType(int)),
      'featured',
      serializers.serialize(object.featuredUnits,
          specifiedType: const FullType(BuiltList, const [
            const FullType(Reference, const [const FullType(Unit)])
          ])),
    ];
    if (object.id != null) {
      result
        ..add('id')
        ..add(serializers.serialize(object.id,
            specifiedType: const FullType(String)));
    }

    return result;
  }

  @override
  Army deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ArmyBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'commands':
          result.commandCards.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, const [
                const FullType(Reference, const [const FullType(CommandCard)])
              ])) as BuiltList);
          break;
        case 'faction':
          result.faction = serializers.deserialize(value,
              specifiedType: const FullType(Faction)) as Faction;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'max_points':
          result.maxPoints = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'points':
          result.totalPoints = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'featured':
          result.featuredUnits.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, const [
                const FullType(Reference, const [const FullType(Unit)])
              ])) as BuiltList);
          break;
      }
    }

    return result.build();
  }
}

class _$Army extends Army {
  @override
  final String id;
  @override
  final BuiltList<Reference<CommandCard>> commandCards;
  @override
  final Faction faction;
  @override
  final String name;
  @override
  final int maxPoints;
  @override
  final int totalPoints;
  @override
  final BuiltList<Reference<Unit>> featuredUnits;

  factory _$Army([void updates(ArmyBuilder b)]) =>
      (new ArmyBuilder()..update(updates)).build();

  _$Army._(
      {this.id,
      this.commandCards,
      this.faction,
      this.name,
      this.maxPoints,
      this.totalPoints,
      this.featuredUnits})
      : super._() {
    if (commandCards == null) {
      throw new BuiltValueNullFieldError('Army', 'commandCards');
    }
    if (faction == null) {
      throw new BuiltValueNullFieldError('Army', 'faction');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('Army', 'name');
    }
    if (maxPoints == null) {
      throw new BuiltValueNullFieldError('Army', 'maxPoints');
    }
    if (totalPoints == null) {
      throw new BuiltValueNullFieldError('Army', 'totalPoints');
    }
    if (featuredUnits == null) {
      throw new BuiltValueNullFieldError('Army', 'featuredUnits');
    }
  }

  @override
  Army rebuild(void updates(ArmyBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  ArmyBuilder toBuilder() => new ArmyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Army && id == other.id;
  }

  @override
  int get hashCode {
    return $jf($jc(0, id.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Army')
          ..add('id', id)
          ..add('commandCards', commandCards)
          ..add('faction', faction)
          ..add('name', name)
          ..add('maxPoints', maxPoints)
          ..add('totalPoints', totalPoints)
          ..add('featuredUnits', featuredUnits))
        .toString();
  }
}

class ArmyBuilder implements Builder<Army, ArmyBuilder> {
  _$Army _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  ListBuilder<Reference<CommandCard>> _commandCards;
  ListBuilder<Reference<CommandCard>> get commandCards =>
      _$this._commandCards ??= new ListBuilder<Reference<CommandCard>>();
  set commandCards(ListBuilder<Reference<CommandCard>> commandCards) =>
      _$this._commandCards = commandCards;

  Faction _faction;
  Faction get faction => _$this._faction;
  set faction(Faction faction) => _$this._faction = faction;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  int _maxPoints;
  int get maxPoints => _$this._maxPoints;
  set maxPoints(int maxPoints) => _$this._maxPoints = maxPoints;

  int _totalPoints;
  int get totalPoints => _$this._totalPoints;
  set totalPoints(int totalPoints) => _$this._totalPoints = totalPoints;

  ListBuilder<Reference<Unit>> _featuredUnits;
  ListBuilder<Reference<Unit>> get featuredUnits =>
      _$this._featuredUnits ??= new ListBuilder<Reference<Unit>>();
  set featuredUnits(ListBuilder<Reference<Unit>> featuredUnits) =>
      _$this._featuredUnits = featuredUnits;

  ArmyBuilder();

  ArmyBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _commandCards = _$v.commandCards?.toBuilder();
      _faction = _$v.faction;
      _name = _$v.name;
      _maxPoints = _$v.maxPoints;
      _totalPoints = _$v.totalPoints;
      _featuredUnits = _$v.featuredUnits?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Army other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Army;
  }

  @override
  void update(void updates(ArmyBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Army build() {
    _$Army _$result;
    try {
      _$result = _$v ??
          new _$Army._(
              id: id,
              commandCards: commandCards.build(),
              faction: faction,
              name: name,
              maxPoints: maxPoints,
              totalPoints: totalPoints,
              featuredUnits: featuredUnits.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'commandCards';
        commandCards.build();

        _$failedField = 'featuredUnits';
        featuredUnits.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Army', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
