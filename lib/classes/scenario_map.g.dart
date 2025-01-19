// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scenario_map.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScenarioMap _$ScenarioMapFromJson(Map<String, dynamic> json) => ScenarioMap(
      uuid: json['uuid'] as String?,
      name: json['name'] as String,
      placeMap: PlaceMap.fromJson(json['place_map'] as Map<String, dynamic>),
      isDefault: json['is_default'] as bool?,
    );

Map<String, dynamic> _$ScenarioMapToJson(ScenarioMap instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'place_map': instance.placeMap.toJson(),
      'is_default': instance.isDefault,
    };
