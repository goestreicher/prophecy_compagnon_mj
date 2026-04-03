import 'package:json_annotation/json_annotation.dart';

mixin class CustomProperties {
  bool hasProperty(String name) => properties.containsKey(name);
  T property<T>(String name) => properties[name] as T;

  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<String, dynamic> properties = <String, dynamic>{};
}