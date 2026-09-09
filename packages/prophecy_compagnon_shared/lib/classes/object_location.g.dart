// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObjectLocation _$ObjectLocationFromJson(Map<String, dynamic> json) =>
    ObjectLocation(
      type: $enumDecode(_$ObjectLocationTypeEnumMap, json['type']),
      collectionUri: json['collection_uri'] as String,
    );

Map<String, dynamic> _$ObjectLocationToJson(ObjectLocation instance) =>
    <String, dynamic>{
      'type': _$ObjectLocationTypeEnumMap[instance.type]!,
      'collection_uri': instance.collectionUri,
    };

const _$ObjectLocationTypeEnumMap = {
  ObjectLocationType.assets: 'assets',
  ObjectLocationType.memory: 'memory',
  ObjectLocationType.store: 'store',
};
