import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:hackfest/models/serializers.dart';

part 'appstate.g.dart';

abstract class Appstate implements Built<Appstate, AppstateBuilder> {
  Appstate._();
  factory Appstate([void Function(AppstateBuilder) updates]) = _$Appstate;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Appstate.serializer, this)
        as Map<String, dynamic>;
  }

  static Appstate fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Appstate.serializer, json)!;
  }

  static Serializer<Appstate> get serializer => _$appstateSerializer;
  String? get name;
  String? get mail;
  String? get primaryphno;
  String? get secondaryphno;
  String? get location;
  String? get adhar;
  int? get people;
  String? get ages;
  String? get userId;
  String? get password;
}
