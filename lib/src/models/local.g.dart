// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<LocalData> _$localDataSerializer = new _$LocalDataSerializer();

class _$LocalDataSerializer implements StructuredSerializer<LocalData> {
  @override
  final Iterable<Type> types = const [LocalData, _$LocalData];
  @override
  final String wireName = 'LocalData';

  @override
  Iterable serialize(Serializers serializers, LocalData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'armies',
      serializers.serialize(object.armies,
          specifiedType:
              const FullType(BuiltList, const [const FullType(Army)])),
      'squads',
      serializers.serialize(object.squads,
          specifiedType: const FullType(BuiltListMultimap, const [
            const FullType(Reference, const [const FullType(Army)]),
            const FullType(Squad)
          ])),
    ];

    return result;
  }

  @override
  LocalData deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new LocalDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'armies':
          result.armies.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(Army)]))
              as BuiltList);
          break;
        case 'squads':
          result.squads.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltListMultimap, const [
                const FullType(Reference, const [const FullType(Army)]),
                const FullType(Squad)
              ])) as BuiltListMultimap);
          break;
      }
    }

    return result.build();
  }
}

class _$LocalData extends LocalData {
  @override
  final BuiltList<Army> armies;
  @override
  final BuiltListMultimap<Reference<Army>, Squad> squads;

  factory _$LocalData([void updates(LocalDataBuilder b)]) =>
      (new LocalDataBuilder()..update(updates)).build();

  _$LocalData._({this.armies, this.squads}) : super._() {
    if (armies == null) {
      throw new BuiltValueNullFieldError('LocalData', 'armies');
    }
    if (squads == null) {
      throw new BuiltValueNullFieldError('LocalData', 'squads');
    }
  }

  @override
  LocalData rebuild(void updates(LocalDataBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  LocalDataBuilder toBuilder() => new LocalDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LocalData &&
        armies == other.armies &&
        squads == other.squads;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, armies.hashCode), squads.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('LocalData')
          ..add('armies', armies)
          ..add('squads', squads))
        .toString();
  }
}

class LocalDataBuilder implements Builder<LocalData, LocalDataBuilder> {
  _$LocalData _$v;

  ListBuilder<Army> _armies;
  ListBuilder<Army> get armies => _$this._armies ??= new ListBuilder<Army>();
  set armies(ListBuilder<Army> armies) => _$this._armies = armies;

  ListMultimapBuilder<Reference<Army>, Squad> _squads;
  ListMultimapBuilder<Reference<Army>, Squad> get squads =>
      _$this._squads ??= new ListMultimapBuilder<Reference<Army>, Squad>();
  set squads(ListMultimapBuilder<Reference<Army>, Squad> squads) =>
      _$this._squads = squads;

  LocalDataBuilder();

  LocalDataBuilder get _$this {
    if (_$v != null) {
      _armies = _$v.armies?.toBuilder();
      _squads = _$v.squads?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LocalData other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$LocalData;
  }

  @override
  void update(void updates(LocalDataBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$LocalData build() {
    _$LocalData _$result;
    try {
      _$result = _$v ??
          new _$LocalData._(armies: armies.build(), squads: squads.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'armies';
        armies.build();
        _$failedField = 'squads';
        squads.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'LocalData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
