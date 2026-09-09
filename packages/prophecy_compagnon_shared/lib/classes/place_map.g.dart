// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_map.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceMap _$PlaceMapFromJson(Map<String, dynamic> json) =>
    PlaceMap(
        uuid: json['uuid'] as String?,
        sourceType: $enumDecode(
          _$PlaceMapSourceTypeEnumMap,
          json['source_type'],
        ),
        source: json['source'] as String,
        imageWidth: (json['image_width'] as num).toInt(),
        imageHeight: (json['image_height'] as num).toInt(),
        realWidth: (json['real_width'] as num).toDouble(),
        realHeight: (json['real_height'] as num).toDouble(),
      )
      ..exportableBinaryData = json['exportable_binary_data'] == null
          ? null
          : ExportableBinaryData.fromJson(
              json['exportable_binary_data'] as Map<String, dynamic>,
            );

Map<String, dynamic> _$PlaceMapToJson(PlaceMap instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'source_type': _$PlaceMapSourceTypeEnumMap[instance.sourceType]!,
  'source': instance.source,
  'image_width': instance.imageWidth,
  'image_height': instance.imageHeight,
  'real_width': instance.realWidth,
  'real_height': instance.realHeight,
  'exportable_binary_data': instance.exportableBinaryData?.toJson(),
};

const _$PlaceMapSourceTypeEnumMap = {
  PlaceMapSourceType.asset: 'asset',
  PlaceMapSourceType.local: 'local',
};
