// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntityHealthStatusValue _$EntityHealthStatusValueFromJson(
  Map<String, dynamic> json,
) => EntityHealthStatusValue((json['bitfield'] as num).toInt());

Map<String, dynamic> _$EntityHealthStatusValueToJson(
  EntityHealthStatusValue instance,
) => <String, dynamic>{'bitfield': instance.bitfield};

EntityHealthStatus _$EntityHealthStatusFromJson(Map<String, dynamic> json) =>
    EntityHealthStatus(
      value: json['value'] == null
          ? EntityHealthStatusValue.empty()
          : EntityHealthStatusValue.fromJson(
              json['value'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$EntityHealthStatusToJson(EntityHealthStatus instance) =>
    <String, dynamic>{'value': instance.value.toJson()};
