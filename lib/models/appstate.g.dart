// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appstate.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Appstate> _$appstateSerializer = new _$AppstateSerializer();

class _$AppstateSerializer implements StructuredSerializer<Appstate> {
  @override
  final Iterable<Type> types = const [Appstate, _$Appstate];
  @override
  final String wireName = 'Appstate';

  @override
  Iterable<Object?> serialize(Serializers serializers, Appstate object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.name;
    if (value != null) {
      result
        ..add('name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.mail;
    if (value != null) {
      result
        ..add('mail')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.primaryphno;
    if (value != null) {
      result
        ..add('primaryphno')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.secondaryphno;
    if (value != null) {
      result
        ..add('secondaryphno')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.location;
    if (value != null) {
      result
        ..add('location')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.adhar;
    if (value != null) {
      result
        ..add('adhar')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.people;
    if (value != null) {
      result
        ..add('people')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.ages;
    if (value != null) {
      result
        ..add('ages')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.userId;
    if (value != null) {
      result
        ..add('userId')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.password;
    if (value != null) {
      result
        ..add('password')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Appstate deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AppstateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'mail':
          result.mail = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'primaryphno':
          result.primaryphno = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'secondaryphno':
          result.secondaryphno = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'location':
          result.location = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'adhar':
          result.adhar = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'people':
          result.people = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'ages':
          result.ages = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'userId':
          result.userId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'password':
          result.password = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$Appstate extends Appstate {
  @override
  final String? name;
  @override
  final String? mail;
  @override
  final String? primaryphno;
  @override
  final String? secondaryphno;
  @override
  final String? location;
  @override
  final String? adhar;
  @override
  final int? people;
  @override
  final String? ages;
  @override
  final String? userId;
  @override
  final String? password;

  factory _$Appstate([void Function(AppstateBuilder)? updates]) =>
      (new AppstateBuilder()..update(updates))._build();

  _$Appstate._(
      {this.name,
      this.mail,
      this.primaryphno,
      this.secondaryphno,
      this.location,
      this.adhar,
      this.people,
      this.ages,
      this.userId,
      this.password})
      : super._();

  @override
  Appstate rebuild(void Function(AppstateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppstateBuilder toBuilder() => new AppstateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Appstate &&
        name == other.name &&
        mail == other.mail &&
        primaryphno == other.primaryphno &&
        secondaryphno == other.secondaryphno &&
        location == other.location &&
        adhar == other.adhar &&
        people == other.people &&
        ages == other.ages &&
        userId == other.userId &&
        password == other.password;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, mail.hashCode);
    _$hash = $jc(_$hash, primaryphno.hashCode);
    _$hash = $jc(_$hash, secondaryphno.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, adhar.hashCode);
    _$hash = $jc(_$hash, people.hashCode);
    _$hash = $jc(_$hash, ages.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Appstate')
          ..add('name', name)
          ..add('mail', mail)
          ..add('primaryphno', primaryphno)
          ..add('secondaryphno', secondaryphno)
          ..add('location', location)
          ..add('adhar', adhar)
          ..add('people', people)
          ..add('ages', ages)
          ..add('userId', userId)
          ..add('password', password))
        .toString();
  }
}

class AppstateBuilder implements Builder<Appstate, AppstateBuilder> {
  _$Appstate? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _mail;
  String? get mail => _$this._mail;
  set mail(String? mail) => _$this._mail = mail;

  String? _primaryphno;
  String? get primaryphno => _$this._primaryphno;
  set primaryphno(String? primaryphno) => _$this._primaryphno = primaryphno;

  String? _secondaryphno;
  String? get secondaryphno => _$this._secondaryphno;
  set secondaryphno(String? secondaryphno) =>
      _$this._secondaryphno = secondaryphno;

  String? _location;
  String? get location => _$this._location;
  set location(String? location) => _$this._location = location;

  String? _adhar;
  String? get adhar => _$this._adhar;
  set adhar(String? adhar) => _$this._adhar = adhar;

  int? _people;
  int? get people => _$this._people;
  set people(int? people) => _$this._people = people;

  String? _ages;
  String? get ages => _$this._ages;
  set ages(String? ages) => _$this._ages = ages;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  AppstateBuilder();

  AppstateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _mail = $v.mail;
      _primaryphno = $v.primaryphno;
      _secondaryphno = $v.secondaryphno;
      _location = $v.location;
      _adhar = $v.adhar;
      _people = $v.people;
      _ages = $v.ages;
      _userId = $v.userId;
      _password = $v.password;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Appstate other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Appstate;
  }

  @override
  void update(void Function(AppstateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Appstate build() => _build();

  _$Appstate _build() {
    final _$result = _$v ??
        new _$Appstate._(
            name: name,
            mail: mail,
            primaryphno: primaryphno,
            secondaryphno: secondaryphno,
            location: location,
            adhar: adhar,
            people: people,
            ages: ages,
            userId: userId,
            password: password);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
