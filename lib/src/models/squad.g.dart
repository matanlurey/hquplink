// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'squad.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Squad> _$squadSerializer = new _$SquadSerializer();

class _$SquadSerializer implements StructuredSerializer<Squad> {
  @override
  final Iterable<Type> types = const [Squad, _$Squad];
  @override
  final String wireName = 'Squad';

  @override
  Iterable serialize(Serializers serializers, Squad object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'card',
      serializers.serialize(object.card,
          specifiedType:
              const FullType(Reference, const [const FullType(Unit)])),
      'upgrades',
      serializers.serialize(object.upgrades,
          specifiedType: const FullType(BuiltList, const [
            const FullType(Reference, const [const FullType(Upgrade)])
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
  Squad deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SquadBuilder();

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
        case 'card':
          result.card = serializers.deserialize(value,
                  specifiedType:
                      const FullType(Reference, const [const FullType(Unit)]))
              as Reference<Unit>;
          break;
        case 'upgrades':
          result.upgrades.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, const [
                const FullType(Reference, const [const FullType(Upgrade)])
              ])) as BuiltList);
          break;
      }
    }

    return result.build();
  }
}

class _$Squad extends Squad {
  @override
  final String id;
  @override
  final Reference<Unit> card;
  @override
  final BuiltList<Reference<Upgrade>> upgrades;

  factory _$Squad([void updates(SquadBuilder b)]) =>
      (new SquadBuilder()..update(updates)).build();

  _$Squad._({this.id, this.card, this.upgrades}) : super._() {
    if (card == null) {
      throw new BuiltValueNullFieldError('Squad', 'card');
    }
    if (upgrades == null) {
      throw new BuiltValueNullFieldError('Squad', 'upgrades');
    }
  }

  @override
  Squad rebuild(void updates(SquadBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  SquadBuilder toBuilder() => new SquadBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Squad && id == other.id;
  }

  @override
  int get hashCode {
    return $jf($jc(0, id.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Squad')
          ..add('id', id)
          ..add('card', card)
          ..add('upgrades', upgrades))
        .toString();
  }
}

class SquadBuilder implements Builder<Squad, SquadBuilder> {
  _$Squad _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  Reference<Unit> _card;
  Reference<Unit> get card => _$this._card;
  set card(Reference<Unit> card) => _$this._card = card;

  ListBuilder<Reference<Upgrade>> _upgrades;
  ListBuilder<Reference<Upgrade>> get upgrades =>
      _$this._upgrades ??= new ListBuilder<Reference<Upgrade>>();
  set upgrades(ListBuilder<Reference<Upgrade>> upgrades) =>
      _$this._upgrades = upgrades;

  SquadBuilder();

  SquadBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _card = _$v.card;
      _upgrades = _$v.upgrades?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Squad other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Squad;
  }

  @override
  void update(void updates(SquadBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Squad build() {
    _$Squad _$result;
    try {
      _$result =
          _$v ?? new _$Squad._(id: id, card: card, upgrades: upgrades.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'upgrades';
        upgrades.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Squad', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
