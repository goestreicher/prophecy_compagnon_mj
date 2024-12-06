// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scenario_encounter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EncounterEntity _$EncounterEntityFromJson(Map<String, dynamic> json) =>
    EncounterEntity(
      id: json['id'] as String,
      min: (json['min'] as num?)?.toInt() ?? 1,
      max: (json['max'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$EncounterEntityToJson(EncounterEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'min': instance.min,
      'max': instance.max,
    };

ScenarioEncounter _$ScenarioEncounterFromJson(Map<String, dynamic> json) =>
    ScenarioEncounter(
      name: json['name'] as String,
      entities: (json['entities'] as List<dynamic>?)
          ?.map((e) => EncounterEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ScenarioEncounterToJson(ScenarioEncounter instance) =>
    <String, dynamic>{
      'name': instance.name,
      'entities': instance.entities.map((e) => e.toJson()).toList(),
    };
