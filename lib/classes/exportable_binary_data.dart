import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:prophecy_compagnon_mj/classes/storage/exceptions.dart';
import 'package:prophecy_compagnon_mj/classes/storage/storage.dart';

import 'storage/storable.dart';

part 'exportable_binary_data.g.dart';

class BinaryDataStore extends JsonStoreAdapter<ExportableBinaryData> {
  BinaryDataStore();

  @override
  String storeCategory() => 'binaries';

  @override
  String key(ExportableBinaryData object) => object.hash;

  @override
  Future<void> save(ExportableBinaryData object) async {
    if(!object.isNew) return;
    object.isNew = false;

    var refCategory = 'binariesRefCount';
    try {
      var refCount = int.tryParse(await DataStorage.instance.get(refCategory, object.hash));
      if(refCount == null) {
        // Consider this as a non-existing key, and initialize a new
        // ref counter in the block below
        throw KeyNotFoundException(refCategory, object.hash);
      }
      else {
        await DataStorage.instance.save(refCategory, object.hash, (refCount+1).toString());
      }
    }
    on KeyNotFoundException {
      // This is the first reference to this hash, initialize a ref counter
      await DataStorage.instance.save(refCategory, object.hash, 1.toString());
      await super.save(object);
    }
  }

  @override
  Future<void> delete(ExportableBinaryData object) async {
    if(object.isNew) return;

    var refCategory = 'binariesRefCount';
    try {
      var refCount = int.tryParse(await DataStorage.instance.get(refCategory, object.hash));
      if(refCount == null) {
        // If the ref counter cannot be parsed, just delete the object
        await super.delete(object);
      }
      else {
        if(refCount <= 1) {
          await DataStorage.instance.delete(refCategory, object.hash);
          await super.delete(object);
        }
        else {
          await DataStorage.instance.save(refCategory, object.hash, (refCount-1).toString());
        }
      }
    }
    on KeyNotFoundException {
      await super.delete(object);
    }
  }

  @override
  Future<ExportableBinaryData> fromJsonRepresentation(Map<String, dynamic> j) async => ExportableBinaryData.fromJson(j);

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(ExportableBinaryData object) async => object.toJson();
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ExportableBinaryData {
  ExportableBinaryData({ required this.data, this.isNew = true });

  @JsonKey(fromJson: base64ToBinaryData, toJson: binaryDataToBase64)
  final Uint8List data;
  bool isNew;

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