import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

class OffsetJsonConverter extends JsonConverter<Offset, Map<String, dynamic>> {
  const OffsetJsonConverter();

  @override
  Offset fromJson(Map<String, dynamic> json) => offsetFromJson(json);

  @override
  Map<String, dynamic> toJson(Offset object) => offsetToJson(object);
}

Offset offsetFromJson(Map<String, dynamic> m) {
  return Offset(
    m["dx"]! as double,
    m["dy"]! as double
  );
}

Map<String, dynamic> offsetToJson(Offset o) {
  return {
    "dx": o.dx,
    "dy": o.dy,
  };
}