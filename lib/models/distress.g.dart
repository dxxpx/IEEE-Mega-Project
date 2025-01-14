// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'distress.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Distress> _$distressSerializer = new _$DistressSerializer();

class _$DistressSerializer implements StructuredSerializer<Distress> {
  @override
  final Iterable<Type> types = const [Distress, _$Distress];
  @override
  final String wireName = 'Distress';

  @override
  Iterable<Object?> serialize(Serializers serializers, Distress object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'time',
      serializers.serialize(object.time, specifiedType: const FullType(String)),
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(String)),
      'userId',
      serializers.serialize(object.userId,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  Distress deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DistressBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'time':
          result.time = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'userId':
          result.userId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Distress extends Distress {
  @override
  final String time;
  @override
  final String type;
  @override
  final String userId;

  factory _$Distress([void Function(DistressBuilder)? updates]) =>
      (new DistressBuilder()..update(updates))._build();

  _$Distress._({required this.time, required this.type, required this.userId})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(time, r'Distress', 'time');
    BuiltValueNullFieldError.checkNotNull(type, r'Distress', 'type');
    BuiltValueNullFieldError.checkNotNull(userId, r'Distress', 'userId');
  }

  @override
  Distress rebuild(void Function(DistressBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DistressBuilder toBuilder() => new DistressBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Distress &&
        time == other.time &&
        type == other.type &&
        userId == other.userId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, time.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Distress')
          ..add('time', time)
          ..add('type', type)
          ..add('userId', userId))
        .toString();
  }
}

class DistressBuilder implements Builder<Distress, DistressBuilder> {
  _$Distress? _$v;

  String? _time;
  String? get time => _$this._time;
  set time(String? time) => _$this._time = time;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  DistressBuilder();

  DistressBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _time = $v.time;
      _type = $v.type;
      _userId = $v.userId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Distress other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Distress;
  }

  @override
  void update(void Function(DistressBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Distress build() => _build();

  _$Distress _build() {
    final _$result = _$v ??
        new _$Distress._(
            time: BuiltValueNullFieldError.checkNotNull(
                time, r'Distress', 'time'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'Distress', 'type'),
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'Distress', 'userId'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
