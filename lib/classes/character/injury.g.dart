// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injury.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InjuryLevel _$InjuryLevelFromJson(Map<String, dynamic> json) => InjuryLevel(
      rank: (json['rank'] as num).toInt(),
      title: json['title'] as String,
      start: (json['start'] as num).toInt(),
      end: (json['end'] as num).toInt(),
      malus: (json['malus'] as num).toInt(),
      capacity: (json['capacity'] as num).toInt(),
    );

Map<String, dynamic> _$InjuryLevelToJson(InjuryLevel instance) =>
    <String, dynamic>{
      'rank': instance.rank,
      'title': instance.title,
      'start': instance.start,
      'end': instance.end,
      'malus': instance.malus,
      'capacity': instance.capacity,
    };
