// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_background_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapBackgroundData _$MapBackgroundDataFromJson(Map<String, dynamic> json) =>
    MapBackgroundData(
      imageData: base64ToImageData(json['image_data'] as String),
      imageWidth: (json['image_width'] as num).toInt(),
      imageHeight: (json['image_height'] as num).toInt(),
      realWidth: (json['real_width'] as num).toDouble(),
      realHeight: (json['real_height'] as num).toDouble(),
    );

Map<String, dynamic> _$MapBackgroundDataToJson(MapBackgroundData instance) =>
    <String, dynamic>{
      'image_data': imageDataToBase64(instance.imageData),
      'image_width': instance.imageWidth,
      'image_height': instance.imageHeight,
      'real_width': instance.realWidth,
      'real_height': instance.realHeight,
    };
