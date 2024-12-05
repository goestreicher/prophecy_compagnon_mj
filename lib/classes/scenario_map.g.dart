// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scenario_map.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScenarioMap _$ScenarioMapFromJson(Map<String, dynamic> json) => ScenarioMap(
      name: json['name'] as String,
      data: MapBackgroundData.fromJson(json['data'] as Map<String, dynamic>),
      isDefault: json['is_default'] as bool?,
    );

Map<String, dynamic> _$ScenarioMapToJson(ScenarioMap instance) =>
    <String, dynamic>{
      'name': instance.name,
      'data': instance.data.toJson(),
      'is_default': instance.isDefault,
    };
