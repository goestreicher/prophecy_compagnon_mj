import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'exportable_binary_data.dart';
import 'storage/storable.dart';

part 'map_background_data.g.dart';

class MapBackgroundStore extends JsonStoreAdapter<MapBackground> {
  MapBackgroundStore();

  @override
  String storeCategory() => 'mapBackgrounds';

  @override
  String key(MapBackground object) => object.uuid;

  @override
  Future<MapBackground> fromJsonRepresentation(Map<String, dynamic> j) async {
    var bin = await BinaryDataStore().get(j['image']);
    if(bin != null) {
      j['image'] = bin.toJson();
    }
    else {
      // TODO: improve this, because as it is, decoding will fail
      j['image'] = '';
    }

    return MapBackground.fromJson(j);
  }

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(MapBackground object) async {
    var j = object.toJson();
    j['image'] = object.image.hash;
    return j;
  }

  @override
  Future<void> willSave(MapBackground object) async {
    await BinaryDataStore().save(object.image);
  }

  @override
  Future<void> willDelete(MapBackground object) async {
    await BinaryDataStore().delete(object.image);
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MapBackground {
  MapBackground({
    String? uuid,
    required this.image,
    required this.imageWidth,
    required this.imageHeight,
    required this.realWidth,
    required this.realHeight,
  })
    : uuid = uuid ?? const Uuid().v4().toString();

  double get pixelsPerMeter => imageWidth / realWidth;

  final String uuid;
  final ExportableBinaryData image;
  final int imageWidth;
  final int imageHeight;
  double realWidth;
  double realHeight;

  factory MapBackground.fromJson(Map<String, dynamic> json) => _$MapBackgroundFromJson(json);
  Map<String, dynamic> toJson() => _$MapBackgroundToJson(this);
}