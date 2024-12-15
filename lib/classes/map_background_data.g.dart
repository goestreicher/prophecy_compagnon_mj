// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_background_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapBackground _$MapBackgroundFromJson(Map<String, dynamic> json) =>
    MapBackground(
      uuid: json['uuid'] as String?,
      image:
          ExportableBinaryData.fromJson(json['image'] as Map<String, dynamic>),
      imageWidth: (json['image_width'] as num).toInt(),
      imageHeight: (json['image_height'] as num).toInt(),
      realWidth: (json['real_width'] as num).toDouble(),
      realHeight: (json['real_height'] as num).toDouble(),
    );

Map<String, dynamic> _$MapBackgroundToJson(MapBackground instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'image': instance.image.toJson(),
      'image_width': instance.imageWidth,
      'image_height': instance.imageHeight,
      'real_width': instance.realWidth,
      'real_height': instance.realHeight,
    };
