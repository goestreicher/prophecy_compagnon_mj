// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injury.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InjuryLevel _$InjuryLevelFromJson(Map<String, dynamic> json) => InjuryLevel(
  type: $enumDecode(_$InjuryEnumMap, json['type']),
  start: (json['start'] as num).toInt(),
  end: (json['end'] as num).toInt(),
  capacity: (json['capacity'] as num).toInt(),
);

Map<String, dynamic> _$InjuryLevelToJson(InjuryLevel instance) =>
    <String, dynamic>{
      'type': _$InjuryEnumMap[instance.type]!,
      'start': instance.start,
      'end': instance.end,
      'capacity': instance.capacity,
    };

const _$InjuryEnumMap = {
  Injury.ignore: 'ignore',
  Injury.scratch: 'scratch',
  Injury.injured: 'injured',
  Injury.light: 'light',
  Injury.grave: 'grave',
  Injury.fatal: 'fatal',
  Injury.death: 'death',
};

EntityInjuries _$EntityInjuriesFromJson(Map<String, dynamic> json) =>
    EntityInjuries(
      manager: InjuryManager.fromJson(json['manager'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EntityInjuriesToJson(EntityInjuries instance) =>
    <String, dynamic>{'manager': instance.manager.toJson()};
