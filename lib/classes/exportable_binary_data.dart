import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:json_annotation/json_annotation.dart';

import 'storage/storable.dart';

part 'exportable_binary_data.g.dart';

class BinaryDataStore extends JsonStoreAdapter<ExportableBinaryData> {
  BinaryDataStore();

  @override
  String storeCategory() => 'binaries';

  @override
  String key(ExportableBinaryData object) => object.hash;

  @override
  Future<ExportableBinaryData> fromJsonRepresentation(Map<String, dynamic> j) async => ExportableBinaryData.fromJson(j);

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(ExportableBinaryData object) async => object.toJson();
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ExportableBinaryData {
  ExportableBinaryData({ required this.data });

  @JsonKey(fromJson: base64ToBinaryData, toJson: binaryDataToBase64)
  Uint8List data;

  String get hash => sha256.convert(
      utf8.encode(
        binaryDataToBase64(data)
      )
    ).toString();

  factory ExportableBinaryData.fromJson(Map<String, dynamic> json) => _$ExportableBinaryDataFromJson(json);
  Map<String, dynamic> toJson() => _$ExportableBinaryDataToJson(this);
}

String binaryDataToBase64(Uint8List data) {
  return base64Encode(data);
}

Uint8List base64ToBinaryData(String data) {
  return base64Decode(data);
}