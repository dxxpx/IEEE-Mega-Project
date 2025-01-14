import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:hackfest/models/serializers.dart';

part 'disaster_update.g.dart';

abstract class DisasterUpdate
    implements Built<DisasterUpdate, DisasterUpdateBuilder> {
  DisasterUpdate._();
  factory DisasterUpdate([void Function(DisasterUpdateBuilder) updates]) =
      _$DisasterUpdate;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(DisasterUpdate.serializer, this)
        as Map<String, dynamic>;
  }

  static DisasterUpdate fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(DisasterUpdate.serializer, json)!;
  }

  static Serializer<DisasterUpdate> get serializer =>
      _$disasterUpdateSerializer;
  String get type;
  String get location;
  String get suggestion;
  String get time;
  bool get isSevere;
}
