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
  Future<ScenarioMap> fromJsonRepresentation(Map<String, dynamic> j) async {
    if(
      j['place_map'].containsKey('exportable_binary_data')
      && j['place_map']['exportable_binary_data'] != null
    ) {
      await restoreJsonBinaryData(j['place_map'], 'exportable_binary_data');
    }
    return ScenarioMap.fromJson(j);
  }

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(ScenarioMap object) async {
    var j = object.toJson();

    await object.placeMap.load();
    if(object.placeMap.exportableBinaryData != null) {
      j['place_map']['exportable_binary_data'] = object.placeMap.exportableBinaryData!.hash;
    }

    return j;
  }

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
  // TODO: create a replaceMap function to keep track of previous data objects, as in Place
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

  factory ScenarioMap.fromJson(Map<String, dynamic> json) => _$ScenarioMapFromJson(json);
  Map<String, dynamic> toJson() => _$ScenarioMapToJson(this);
}