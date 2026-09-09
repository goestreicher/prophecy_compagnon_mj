// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenericImage _$GenericImageFromJson(Map<String, dynamic> json) => GenericImage(
  sourceType: $enumDecode(_$GenericImageSourceTypeEnumMap, json['source_type']),
  source: json['source'] as String,
);

Map<String, dynamic> _$GenericImageToJson(GenericImage instance) =>
    <String, dynamic>{
      'source_type': _$GenericImageSourceTypeEnumMap[instance.sourceType]!,
      'source': instance.source,
    };

const _$GenericImageSourceTypeEnumMap = {
  GenericImageSourceType.asset: 'asset',
  GenericImageSourceType.local: 'local',
  GenericImageSourceType.memory: 'memory',
  GenericImageSourceType.url: 'url',
};
