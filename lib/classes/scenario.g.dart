// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scenario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScenarioEvent _$ScenarioEventFromJson(Map<String, dynamic> json) =>
    ScenarioEvent(
      day: (json['day'] as num).toInt(),
      description: json['description'] as String,
    );

Map<String, dynamic> _$ScenarioEventToJson(ScenarioEvent instance) =>
    <String, dynamic>{
      'day': instance.day,
      'description': instance.description,
    };

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
      encounters: (json['encounters'] as List<dynamic>?)
          ?.map((e) => ScenarioEncounter.fromJson(e as Map<String, dynamic>))
          .toList(),
      pcEvents: (json['pc_events'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            int.parse(k),
            (e as List<dynamic>)
                .map((e) => ScenarioEvent.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
      worldEvents: (json['world_events'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            int.parse(k),
            (e as List<dynamic>)
                .map((e) => ScenarioEvent.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
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
      'encounters': instance.encounters.map((e) => e.toJson()).toList(),
      'pc_events': instance.pcEvents.map(
          (k, e) => MapEntry(k.toString(), e.map((e) => e.toJson()).toList())),
      'world_events': instance.worldEvents.map(
          (k, e) => MapEntry(k.toString(), e.map((e) => e.toJson()).toList())),
    };
