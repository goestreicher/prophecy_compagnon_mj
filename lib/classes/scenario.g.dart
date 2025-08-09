// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scenario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScenarioSummary _$ScenarioSummaryFromJson(Map<String, dynamic> json) =>
    ScenarioSummary(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      subtitle: json['subtitle'] as String? ?? '',
    );

Map<String, dynamic> _$ScenarioSummaryToJson(ScenarioSummary instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'subtitle': instance.subtitle,
    };

Scenario _$ScenarioFromJson(Map<String, dynamic> json) => Scenario(
  uuid: json['uuid'] as String?,
  name: json['name'] as String,
  subtitle: json['subtitle'] as String? ?? '',
  danger: (json['danger'] as num?)?.toInt() ?? 0,
  discovery: (json['discovery'] as num?)?.toInt() ?? 0,
  magic: (json['magic'] as num?)?.toInt() ?? 0,
  implication: (json['implication'] as num?)?.toInt() ?? 0,
  synopsys: json['synopsys'] as String? ?? '',
  maps: (json['maps'] as List<dynamic>?)
      ?.map((e) => ScenarioMap.fromJson(e as Map<String, dynamic>))
      .toList(),
  npcs: (json['npcs'] as List<dynamic>?)
      ?.map((e) => NonPlayerCharacter.fromJson(e as Map<String, dynamic>))
      .toList(),
  creatures: (json['creatures'] as List<dynamic>?)
      ?.map((e) => CreatureModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  encounters: (json['encounters'] as List<dynamic>?)
      ?.map((e) => ScenarioEncounter.fromJson(e as Map<String, dynamic>))
      .toList(),
  places: (json['places'] as List<dynamic>?)
      ?.map((e) => Place.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ScenarioToJson(Scenario instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'name': instance.name,
  'subtitle': instance.subtitle,
  'danger': instance.danger,
  'discovery': instance.discovery,
  'magic': instance.magic,
  'implication': instance.implication,
  'synopsys': instance.synopsys,
  'maps': instance.maps.map((e) => e.toJson()).toList(),
  'npcs': instance.npcs.map((e) => e.toJson()).toList(),
  'creatures': instance.creatures.map((e) => e.toJson()).toList(),
  'encounters': instance.encounters.map((e) => e.toJson()).toList(),
  'places': instance.places.map((e) => e.toJson()).toList(),
};
