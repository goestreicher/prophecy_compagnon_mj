// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combat_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntityCombatStatusValue _$EntityCombatStatusValueFromJson(
  Map<String, dynamic> json,
) => EntityCombatStatusValue((json['bitfield'] as num).toInt());

Map<String, dynamic> _$EntityCombatStatusValueToJson(
  EntityCombatStatusValue instance,
) => <String, dynamic>{'bitfield': instance.bitfield};

EntityCombatStatus _$EntityCombatStatusFromJson(Map<String, dynamic> json) =>
    EntityCombatStatus(
      value: json['value'] == null
          ? EntityCombatStatusValue.empty()
          : EntityCombatStatusValue.fromJson(
              json['value'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$EntityCombatStatusToJson(EntityCombatStatus instance) =>
    <String, dynamic>{'value': instance.value.toJson()};
