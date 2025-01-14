// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disaster_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<DisasterUpdate> _$disasterUpdateSerializer =
    new _$DisasterUpdateSerializer();

class _$DisasterUpdateSerializer
    implements StructuredSerializer<DisasterUpdate> {
  @override
  final Iterable<Type> types = const [DisasterUpdate, _$DisasterUpdate];
  @override
  final String wireName = 'DisasterUpdate';

  @override
  Iterable<Object?> serialize(Serializers serializers, DisasterUpdate object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(String)),
      'location',
      serializers.serialize(object.location,
          specifiedType: const FullType(String)),
      'suggestion',
      serializers.serialize(object.suggestion,
          specifiedType: const FullType(String)),
      'time',
      serializers.serialize(object.time, specifiedType: const FullType(String)),
      'isSevere',
      serializers.serialize(object.isSevere,
          specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  DisasterUpdate deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DisasterUpdateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'location':
          result.location = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'suggestion':
          result.suggestion = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'time':
          result.time = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'isSevere':
          result.isSevere = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$DisasterUpdate extends DisasterUpdate {
  @override
  final String type;
  @override
  final String location;
  @override
  final String suggestion;
  @override
  final String time;
  @override
  final bool isSevere;

  factory _$DisasterUpdate([void Function(DisasterUpdateBuilder)? updates]) =>
      (new DisasterUpdateBuilder()..update(updates))._build();

  _$DisasterUpdate._(
      {required this.type,
      required this.location,
      required this.suggestion,
      required this.time,
      required this.isSevere})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(type, r'DisasterUpdate', 'type');
    BuiltValueNullFieldError.checkNotNull(
        location, r'DisasterUpdate', 'location');
    BuiltValueNullFieldError.checkNotNull(
        suggestion, r'DisasterUpdate', 'suggestion');
    BuiltValueNullFieldError.checkNotNull(time, r'DisasterUpdate', 'time');
    BuiltValueNullFieldError.checkNotNull(
        isSevere, r'DisasterUpdate', 'isSevere');
  }

  @override
  DisasterUpdate rebuild(void Function(DisasterUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisasterUpdateBuilder toBuilder() =>
      new DisasterUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisasterUpdate &&
        type == other.type &&
        location == other.location &&
        suggestion == other.suggestion &&
        time == other.time &&
        isSevere == other.isSevere;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, suggestion.hashCode);
    _$hash = $jc(_$hash, time.hashCode);
    _$hash = $jc(_$hash, isSevere.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisasterUpdate')
          ..add('type', type)
          ..add('location', location)
          ..add('suggestion', suggestion)
          ..add('time', time)
          ..add('isSevere', isSevere))
        .toString();
  }
}

class DisasterUpdateBuilder
    implements Builder<DisasterUpdate, DisasterUpdateBuilder> {
  _$DisasterUpdate? _$v;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _location;
  String? get location => _$this._location;
  set location(String? location) => _$this._location = location;

  String? _suggestion;
  String? get suggestion => _$this._suggestion;
  set suggestion(String? suggestion) => _$this._suggestion = suggestion;

  String? _time;
  String? get time => _$this._time;
  set time(String? time) => _$this._time = time;

  bool? _isSevere;
  bool? get isSevere => _$this._isSevere;
  set isSevere(bool? isSevere) => _$this._isSevere = isSevere;

  DisasterUpdateBuilder();

  DisasterUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _location = $v.location;
      _suggestion = $v.suggestion;
      _time = $v.time;
      _isSevere = $v.isSevere;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisasterUpdate other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DisasterUpdate;
  }

  @override
  void update(void Function(DisasterUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisasterUpdate build() => _build();

  _$DisasterUpdate _build() {
    final _$result = _$v ??
        new _$DisasterUpdate._(
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'DisasterUpdate', 'type'),
            location: BuiltValueNullFieldError.checkNotNull(
                location, r'DisasterUpdate', 'location'),
            suggestion: BuiltValueNullFieldError.checkNotNull(
                suggestion, r'DisasterUpdate', 'suggestion'),
            time: BuiltValueNullFieldError.checkNotNull(
                time, r'DisasterUpdate', 'time'),
            isSevere: BuiltValueNullFieldError.checkNotNull(
                isSevere, r'DisasterUpdate', 'isSevere'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
