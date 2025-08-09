// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KorDate _$KorDateFromJson(Map<String, dynamic> json) => KorDate(
  age: $enumDecodeNullable(_$KorAgeEnumMap, json['age']) ?? KorAge.empires,
  year: (json['year'] as num).toInt(),
  cycle: $enumDecode(_$KorCycleEnumMap, json['cycle']),
  week: (json['week'] as num).toInt(),
  day: $enumDecode(_$WeekDayEnumMap, json['day']),
);

Map<String, dynamic> _$KorDateToJson(KorDate instance) => <String, dynamic>{
  'age': _$KorAgeEnumMap[instance.age]!,
  'year': instance.year,
  'cycle': _$KorCycleEnumMap[instance.cycle]!,
  'week': instance.week,
  'day': _$WeekDayEnumMap[instance.day]!,
};

const _$KorAgeEnumMap = {
  KorAge.fondations: 'fondations',
  KorAge.conquetes: 'conquetes',
  KorAge.empires: 'empires',
};

const _$KorCycleEnumMap = {
  KorCycle.blanc: 'blanc',
  KorCycle.moryargon: 'moryargon',
  KorCycle.soleil: 'soleil',
  KorCycle.silence: 'silence',
};

const _$WeekDayEnumMap = {
  WeekDay.roc: 'roc',
  WeekDay.volcan: 'volcan',
  WeekDay.ecume: 'ecume',
  WeekDay.metal: 'metal',
  WeekDay.arbre: 'arbre',
  WeekDay.songes: 'songes',
  WeekDay.foyer: 'foyer',
  WeekDay.vents: 'vents',
  WeekDay.serpent: 'serpent',
};
