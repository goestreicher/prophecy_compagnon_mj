// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource_link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResourceLink _$ResourceLinkFromJson(Map<String, dynamic> json) =>
    ResourceLink(name: json['name'] as String, link: json['link'] as String)
      ..type = $enumDecode(_$ResourceLinkTypeEnumMap, json['type']);

Map<String, dynamic> _$ResourceLinkToJson(ResourceLink instance) =>
    <String, dynamic>{
      'name': instance.name,
      'link': instance.link,
      'type': _$ResourceLinkTypeEnumMap[instance.type]!,
    };

const _$ResourceLinkTypeEnumMap = {
  ResourceLinkType.npc: 'npc',
  ResourceLinkType.creature: 'creature',
  ResourceLinkType.place: 'place',
  ResourceLinkType.encounter: 'encounter',
  ResourceLinkType.map: 'map',
};
