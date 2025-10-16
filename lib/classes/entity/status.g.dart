// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntityStatusValue _$EntityStatusValueFromJson(Map<String, dynamic> json) =>
    EntityStatusValue((json['bitfield'] as num).toInt());

Map<String, dynamic> _$EntityStatusValueToJson(EntityStatusValue instance) =>
    <String, dynamic>{'bitfield': instance.bitfield};

EntityStatus _$EntityStatusFromJson(Map<String, dynamic> json) => EntityStatus(
  value: json['value'] == null
      ? EntityStatusValue.empty()
      : EntityStatusValue.fromJson(json['value'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EntityStatusToJson(EntityStatus instance) =>
    <String, dynamic>{'value': instance.value.toJson()};
