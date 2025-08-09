// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exportable_binary_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExportableBinaryData _$ExportableBinaryDataFromJson(
  Map<String, dynamic> json,
) => ExportableBinaryData(
  data: base64ToBinaryData(json['data'] as String),
  isNew: json['is_new'] as bool? ?? true,
);

Map<String, dynamic> _$ExportableBinaryDataToJson(
  ExportableBinaryData instance,
) => <String, dynamic>{
  'data': binaryDataToBase64(instance.data),
  'is_new': instance.isNew,
};
