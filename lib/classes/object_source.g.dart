// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object_source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObjectSource _$ObjectSourceFromJson(Map<String, dynamic> json) => ObjectSource(
      type: $enumDecode(_$ObjectSourceTypeEnumMap, json['type']),
      name: json['name'] as String,
    );

Map<String, dynamic> _$ObjectSourceToJson(ObjectSource instance) =>
    <String, dynamic>{
      'type': _$ObjectSourceTypeEnumMap[instance.type]!,
      'name': instance.name,
    };

const _$ObjectSourceTypeEnumMap = {
  ObjectSourceType.original: 'original',
  ObjectSourceType.officiel: 'officiel',
  ObjectSourceType.scenario: 'scenario',
};
