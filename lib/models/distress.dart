import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:hackfest/models/serializers.dart';
part 'distress.g.dart';

abstract class Distress implements Built<Distress, DistressBuilder> {
  Distress._();
  factory Distress([void Function(DistressBuilder) updates]) = _$Distress;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Distress.serializer, this)
        as Map<String, dynamic>;
  }

  static Distress fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Distress.serializer, json)!;
  }

  static Serializer<Distress> get serializer => _$distressSerializer;
  String get time;
  String get type;
  String get userId;
}
