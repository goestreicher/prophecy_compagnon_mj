// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FactionSummary _$FactionSummaryFromJson(Map<String, dynamic> json) =>
    FactionSummary(
      uuid: json['uuid'] as String,
      source: ObjectSource.fromJson(json['source'] as Map<String, dynamic>),
      location: json['location'] == null
          ? ObjectLocation.memory
          : ObjectLocation.fromJson(json['location'] as Map<String, dynamic>),
      name: json['name'] as String,
      parentId: json['parent_id'] as String?,
      displayOnly: json['display_only'] as bool? ?? false,
    );

Map<String, dynamic> _$FactionSummaryToJson(FactionSummary instance) =>
    <String, dynamic>{
      'source': instance.source.toJson(),
      'name': instance.name,
      'uuid': instance.uuid,
      'parent_id': instance.parentId,
      'display_only': instance.displayOnly,
    };

Faction _$FactionFromJson(Map<String, dynamic> json) => Faction(
  uuid: json['uuid'] as String?,
  parentId: json['parent_id'] as String?,
  displayOnly: json['display_only'] as bool? ?? false,
  name: json['name'] as String,
  leaders:
      (json['leaders'] as List<dynamic>?)
          ?.map((e) => CharacterRole.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <CharacterRole>[],
  members:
      (json['members'] as List<dynamic>?)
          ?.map((e) => CharacterRole.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <CharacterRole>[],
  description: json['description'] as String,
  location: json['location'] == null
      ? ObjectLocation.memory
      : ObjectLocation.fromJson(json['location'] as Map<String, dynamic>),
  source: ObjectSource.fromJson(json['source'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FactionToJson(Faction instance) => <String, dynamic>{
  'source': instance.source.toJson(),
  'name': instance.name,
  'uuid': instance.uuid,
  'parent_id': instance.parentId,
  'display_only': instance.displayOnly,
  'leaders': instance.leaders.map((e) => e.toJson()).toList(),
  'members': instance.members.map((e) => e.toJson()).toList(),
  'description': instance.description,
};
