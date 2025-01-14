// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Users> _$usersSerializer = new _$UsersSerializer();

class _$UsersSerializer implements StructuredSerializer<Users> {
  @override
  final Iterable<Type> types = const [Users, _$Users];
  @override
  final String wireName = 'Users';

  @override
  Iterable<Object?> serialize(Serializers serializers, Users object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'mail',
      serializers.serialize(object.mail, specifiedType: const FullType(String)),
      'primaryphno',
      serializers.serialize(object.primaryphno,
          specifiedType: const FullType(String)),
      'secondaryphno',
      serializers.serialize(object.secondaryphno,
          specifiedType: const FullType(String)),
      'location',
      serializers.serialize(object.location,
          specifiedType: const FullType(String)),
      'adhar',
      serializers.serialize(object.adhar,
          specifiedType: const FullType(String)),
      'userId',
      serializers.serialize(object.userId,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.name;
    if (value != null) {
      result
        ..add('name')
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
            specifiedType: const FullType(List, const [const FullType(int)])));
    }
    return result;
  }

  @override
  Users deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new UsersBuilder();

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
              specifiedType: const FullType(String))! as String;
          break;
        case 'primaryphno':
          result.primaryphno = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'secondaryphno':
          result.secondaryphno = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'location':
          result.location = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'adhar':
          result.adhar = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'people':
          result.people = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'ages':
          result.ages = serializers.deserialize(value,
                  specifiedType:
                      const FullType(List, const [const FullType(int)]))
              as List<int>?;
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

class _$Users extends Users {
  @override
  final String? name;
  @override
  final String mail;
  @override
  final String primaryphno;
  @override
  final String secondaryphno;
  @override
  final String location;
  @override
  final String adhar;
  @override
  final int? people;
  @override
  final List<int>? ages;
  @override
  final String userId;

  factory _$Users([void Function(UsersBuilder)? updates]) =>
      (new UsersBuilder()..update(updates))._build();

  _$Users._(
      {this.name,
      required this.mail,
      required this.primaryphno,
      required this.secondaryphno,
      required this.location,
      required this.adhar,
      this.people,
      this.ages,
      required this.userId})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(mail, r'Users', 'mail');
    BuiltValueNullFieldError.checkNotNull(primaryphno, r'Users', 'primaryphno');
    BuiltValueNullFieldError.checkNotNull(
        secondaryphno, r'Users', 'secondaryphno');
    BuiltValueNullFieldError.checkNotNull(location, r'Users', 'location');
    BuiltValueNullFieldError.checkNotNull(adhar, r'Users', 'adhar');
    BuiltValueNullFieldError.checkNotNull(userId, r'Users', 'userId');
  }

  @override
  Users rebuild(void Function(UsersBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UsersBuilder toBuilder() => new UsersBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Users &&
        name == other.name &&
        mail == other.mail &&
        primaryphno == other.primaryphno &&
        secondaryphno == other.secondaryphno &&
        location == other.location &&
        adhar == other.adhar &&
        people == other.people &&
        ages == other.ages &&
        userId == other.userId;
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
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Users')
          ..add('name', name)
          ..add('mail', mail)
          ..add('primaryphno', primaryphno)
          ..add('secondaryphno', secondaryphno)
          ..add('location', location)
          ..add('adhar', adhar)
          ..add('people', people)
          ..add('ages', ages)
          ..add('userId', userId))
        .toString();
  }
}

class UsersBuilder implements Builder<Users, UsersBuilder> {
  _$Users? _$v;

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

  List<int>? _ages;
  List<int>? get ages => _$this._ages;
  set ages(List<int>? ages) => _$this._ages = ages;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  UsersBuilder();

  UsersBuilder get _$this {
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
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Users other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Users;
  }

  @override
  void update(void Function(UsersBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Users build() => _build();

  _$Users _build() {
    final _$result = _$v ??
        new _$Users._(
            name: name,
            mail: BuiltValueNullFieldError.checkNotNull(mail, r'Users', 'mail'),
            primaryphno: BuiltValueNullFieldError.checkNotNull(
                primaryphno, r'Users', 'primaryphno'),
            secondaryphno: BuiltValueNullFieldError.checkNotNull(
                secondaryphno, r'Users', 'secondaryphno'),
            location: BuiltValueNullFieldError.checkNotNull(
                location, r'Users', 'location'),
            adhar:
                BuiltValueNullFieldError.checkNotNull(adhar, r'Users', 'adhar'),
            people: people,
            ages: ages,
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'Users', 'userId'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
