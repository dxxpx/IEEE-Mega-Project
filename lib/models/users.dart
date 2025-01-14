import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:hackfest/models/serializers.dart';

part 'users.g.dart';

abstract class Users implements Built<Users, UsersBuilder> {
  Users._();
  factory Users([void Function(UsersBuilder) updates]) = _$Users;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Users.serializer, this)
        as Map<String, dynamic>;
  }

  static Users fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Users.serializer, json)!;
  }

  static Serializer<Users> get serializer => _$usersSerializer;
  String? get name;
  String get mail;
  String get primaryphno;
  String get secondaryphno;
  String get location;
  String get adhar;
  int? get people;
  List<int>? get ages;
  String get userId;
}
