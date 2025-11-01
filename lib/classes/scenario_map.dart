import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'place_map.dart';

part 'scenario_map.g.dart';

// class ScenarioMapStore extends JsonStoreAdapter<ScenarioMap> {
//   ScenarioMapStore();
//
//   @override
//   String storeCategory() => 'scenarioMaps';
//
//   @override
//   String key(ScenarioMap object) => object.uuid;
//
//   @override
//   Future<ScenarioMap> fromJsonRepresentation(Map<String, dynamic> j) async {
//     if(
//       j['place_map'].containsKey('exportable_binary_data')
//       && j['place_map']['exportable_binary_data'] != null
//     ) {
//       await restoreJsonBinaryData(j['place_map'], 'exportable_binary_data');
//     }
//     return ScenarioMap.fromJson(j);
//   }
//
//   @override
//   Future<Map<String, dynamic>> toJsonRepresentation(ScenarioMap object) async {
//     var j = object.toJson();
//
//     await object.placeMap.load();
//     if(object.placeMap.exportableBinaryData != null) {
//       j['place_map']['exportable_binary_data'] = object.placeMap.exportableBinaryData!.hash;
//     }
//
//     return j;
//   }
//
//   @override
//   Future<void> willSave(ScenarioMap object) async {
//     _deletePreviousData(object);
//     if(object.placeMap.exportableBinaryData != null) {
//       await BinaryDataStore().save(object.placeMap.exportableBinaryData!);
//     }
//   }
//
//   @override
//   Future<void> willDelete(ScenarioMap object) async {
//     _deletePreviousData(object);
//     if(object.placeMap.exportableBinaryData != null) {
//       await BinaryDataStore().delete(object.placeMap.exportableBinaryData!);
//     }
//   }
//
//   Future<void> _deletePreviousData(ScenarioMap object) async {
//     for(var h in object._previousMapsDataHashes) {
//       await BinaryDataStore().deleteByHash(h);
//     }
//   }
// }

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

  static void preImportFilter(Map<String, dynamic> j) {
    if(
        j['place_map'].containsKey('exportable_binary_data')
        && j['place_map']['exportable_binary_data'] != null
    ) {
      j['place_map']['exportable_binary_data'].remove('is_new');
    }
  }

  static Future<ScenarioMap?> fromStoreJsonRepresentation(Map<String, dynamic> json) async {
    if(!json.containsKey('place_map')) return null;

    var map = await PlaceMapStore().get(json['place_map']);
    if(map == null) return null;

    json['place_map'] = map.toJson();
    return ScenarioMap.fromJson(json);
  }

  Future<Map<String, dynamic>> toStoreJsonRepresentation() async {
    var j = toJson();
    j['place_map'] = placeMap.uuid;
    return j;
  }

  Future<void> willSave() async {
    await PlaceMapStore().save(placeMap);
  }

  Future<void> willDelete() async {
    await PlaceMapStore().delete(placeMap);
  }

  factory ScenarioMap.fromJson(Map<String, dynamic> json) =>
      _$ScenarioMapFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ScenarioMapToJson(this);
}