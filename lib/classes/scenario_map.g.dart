// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scenario_map.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScenarioMap _$ScenarioMapFromJson(Map<String, dynamic> json) => ScenarioMap(
      uuid: json['uuid'] as String?,
      name: json['name'] as String,
      background:
          MapBackground.fromJson(json['background'] as Map<String, dynamic>),
      isDefault: json['is_default'] as bool?,
    );

Map<String, dynamic> _$ScenarioMapToJson(ScenarioMap instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'background': instance.background.toJson(),
      'is_default': instance.isDefault,
    };
