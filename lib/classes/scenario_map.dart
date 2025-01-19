import 'package:json_annotation/json_annotation.dart';
import 'package:prophecy_compagnon_mj/classes/exportable_binary_data.dart';
import 'package:uuid/uuid.dart';

import 'place.dart';
import 'storage/storable.dart';

part 'scenario_map.g.dart';

class ScenarioMapStore extends JsonStoreAdapter<ScenarioMap> {
  ScenarioMapStore();

  @override
  String storeCategory() => 'maps';

  @override
  String key(ScenarioMap object) => object.uuid;

  @override
  Future<ScenarioMap> fromJsonRepresentation(Map<String, dynamic> j) async =>
      ScenarioMap.fromJson(j);

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(ScenarioMap object) async =>
      object.toJson();

  @override
  Future<void> willSave(ScenarioMap object) async {
    if(object.placeMap.exportableBinaryData != null) {
      await BinaryDataStore().save(object.placeMap.exportableBinaryData!);
    }
  }

  @override
  Future<void> willDelete(ScenarioMap object) async {
    if(object.placeMap.exportableBinaryData != null) {
      await BinaryDataStore().delete(object.placeMap.exportableBinaryData!);
    }
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ScenarioMap {
  ScenarioMap({
    String? uuid,
    required this.name,
    required this.placeMap,
    bool? isDefault,
  })
    : uuid = uuid ?? const Uuid().v4().toString(),
      isDefault = isDefault ?? false;

  String uuid;
  String name;
  PlaceMap placeMap;
  bool isDefault;

  factory ScenarioMap.fromJson(Map<String, dynamic> json) => _$ScenarioMapFromJson(json);
  Map<String, dynamic> toJson() => _$ScenarioMapToJson(this);
}