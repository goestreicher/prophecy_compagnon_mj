import 'package:json_annotation/json_annotation.dart';

import 'map_background_data.dart';

part 'scenario_map.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ScenarioMap {
  ScenarioMap({
    required this.name,
    required this.data,
    bool? isDefault,
  })
      : isDefault = isDefault ?? false;

  String name;
  MapBackgroundData data;
  bool isDefault;

  factory ScenarioMap.fromJson(Map<String, dynamic> json) => _$ScenarioMapFromJson(json);
  Map<String, dynamic> toJson() => _$ScenarioMapToJson(this);
}