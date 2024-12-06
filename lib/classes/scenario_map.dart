import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'map_background_data.dart';
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
    var background = await MapBackgroundStore().get(j['background']);
    if(background != null) {
      j['background'] = background.toJson();
    }
    else {
      // TODO: improve error handling in case the background is not found (ctor will fail)
    }

    return ScenarioMap.fromJson(j);
  }

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(ScenarioMap object) async {
    var j = object.toJson();
    j['background'] = object.background.hash;
    return j;
  }

  @override
  Future<void> willSave(ScenarioMap object) async {
    MapBackgroundStore().save(object.background);
  }

  @override
  Future<void> willDelete(ScenarioMap object) async {
    MapBackgroundStore().delete(object.background);
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ScenarioMap {
  ScenarioMap({
    String? uuid,
    required this.name,
    required this.background,
    bool? isDefault,
  })
    : uuid = uuid ?? const Uuid().v4().toString(),
      isDefault = isDefault ?? false;

  String uuid;
  String name;
  MapBackground background;
  bool isDefault;

  factory ScenarioMap.fromJson(Map<String, dynamic> json) => _$ScenarioMapFromJson(json);
  Map<String, dynamic> toJson() => _$ScenarioMapToJson(this);
}