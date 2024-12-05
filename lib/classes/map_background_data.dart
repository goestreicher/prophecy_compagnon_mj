import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'map_background_data.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MapBackgroundData {
  MapBackgroundData({
    required this.imageData,
    required this.imageWidth,
    required this.imageHeight,
    required this.realWidth,
    required this.realHeight,
  });

  double get pixelsPerMeter => imageWidth / realWidth;

  @JsonKey(fromJson: base64ToImageData, toJson: imageDataToBase64)
    final Uint8List imageData;
  @JsonKey(includeFromJson: false, includeToJson: false)
    String get hash => sha256.convert(utf8.encode(imageDataToBase64(imageData))).toString();
  final int imageWidth;
  final int imageHeight;
  double realWidth;
  double realHeight;

  factory MapBackgroundData.fromJson(Map<String, dynamic> json) => _$MapBackgroundDataFromJson(json);
  Map<String, dynamic> toJson() => _$MapBackgroundDataToJson(this);
}

String imageDataToBase64(Uint8List data) {
  return base64Encode(data);
}

Uint8List base64ToImageData(String data) {
  return base64Decode(data);
}