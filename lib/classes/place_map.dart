import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'exportable_binary_data.dart';
import 'storage/storable.dart';

part 'place_map.g.dart';

enum PlaceMapSourceType {
  asset,
  local,
}

class PlaceMapStore extends JsonStoreAdapter<PlaceMap> {
  PlaceMapStore();

  @override
  String storeCategory() => 'placeMaps';

  @override
  String key(PlaceMap object) => object.uuid;

  @override
  Future<PlaceMap> fromJsonRepresentation(Map<String, dynamic> j) async {
    if(
        j.containsKey('exportable_binary_data')
        && j['exportable_binary_data'] != null
    ) {
      await restoreJsonBinaryData(j, 'exportable_binary_data');
    }
    return PlaceMap.fromJson(j);
  }

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(PlaceMap object) async {
    var j = object.toJson();

    await object.load();
    if(object.exportableBinaryData != null) {
      j['exportable_binary_data'] = object.exportableBinaryData!.hash;
    }

    return j;
  }

  @override
  Future<void> willSave(PlaceMap object) async {
    _deletePreviousData(object);
    if(object.exportableBinaryData != null) {
      await BinaryDataStore().save(object.exportableBinaryData!);
    }
  }

  @override
  Future<void> willDelete(PlaceMap object) async {
    _deletePreviousData(object);
    if(object.exportableBinaryData != null) {
      await BinaryDataStore().delete(object.exportableBinaryData!);
    }
  }

  Future<void> _deletePreviousData(PlaceMap object) async {
    for(var h in object._previousMapsDataHashes) {
      await BinaryDataStore().deleteByHash(h);
    }
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PlaceMap {
  PlaceMap({
    String? uuid,
    required this.sourceType,
    required this.source,
    required this.imageWidth,
    required this.imageHeight,
    required this.realWidth,
    required this.realHeight,
  }) : uuid = uuid ?? const Uuid().v4().toString();

  String uuid;
  PlaceMapSourceType sourceType;
  String source;
  final int imageWidth;
  final int imageHeight;
  double realWidth;
  double realHeight;
  @JsonKey(includeFromJson: false, includeToJson: false)
  Uint8List? imageData;
  ExportableBinaryData? exportableBinaryData;

  final List<String> _previousMapsDataHashes = <String>[];

  double get pixelsPerMeter => imageWidth / realWidth;

  Uint8List? get image {
    Uint8List? ret;

    if(sourceType == PlaceMapSourceType.asset) {
      ret = imageData;
    }
    else if(sourceType == PlaceMapSourceType.local) {
      ret = exportableBinaryData?.data;
    }

    return ret;
  }

  Future<void> load() async {
    if(sourceType == PlaceMapSourceType.asset) {
      if(imageData != null) return;
      var data = await rootBundle.load(source);
      imageData = data.buffer.asUint8List();
    }
    else if(sourceType == PlaceMapSourceType.local) {
      if(exportableBinaryData != null) return;
      exportableBinaryData = await BinaryDataStore().get(source);
    }
  }

  void replaceMapData(ExportableBinaryData newData) {
    if(exportableBinaryData != null) {
      _previousMapsDataHashes.add(exportableBinaryData!.hash);
    }
    exportableBinaryData = newData;
  }

  factory PlaceMap.fromJson(Map<String, dynamic> j) => _$PlaceMapFromJson(j);

  Map<String, dynamic> toJson() => _$PlaceMapToJson(this);
}