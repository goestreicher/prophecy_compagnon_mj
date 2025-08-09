// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'magic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MagicSpell _$MagicSpellFromJson(Map<String, dynamic> json) => MagicSpell(
  name: json['name'] as String,
  sphere: $enumDecode(_$MagicSphereEnumMap, json['sphere']),
  level: (json['level'] as num).toInt(),
  skill: $enumDecode(_$MagicSkillEnumMap, json['skill']),
  complexity: (json['complexity'] as num).toInt(),
  cost: (json['cost'] as num).toInt(),
  difficulty: (json['difficulty'] as num).toInt(),
  castingDuration: (json['casting_duration'] as num).toInt(),
  castingDurationUnit: $enumDecode(
    _$CastingDurationUnitEnumMap,
    json['casting_duration_unit'],
  ),
  keys: (json['keys'] as List<dynamic>).map((e) => e as String).toList(),
  source: json['source'] as String,
  description: json['description'] as String,
);

Map<String, dynamic> _$MagicSpellToJson(MagicSpell instance) =>
    <String, dynamic>{
      'name': instance.name,
      'sphere': _$MagicSphereEnumMap[instance.sphere]!,
      'level': instance.level,
      'skill': _$MagicSkillEnumMap[instance.skill]!,
      'complexity': instance.complexity,
      'cost': instance.cost,
      'difficulty': instance.difficulty,
      'casting_duration': instance.castingDuration,
      'casting_duration_unit':
          _$CastingDurationUnitEnumMap[instance.castingDurationUnit]!,
      'keys': instance.keys,
      'source': instance.source,
      'description': instance.description,
    };

const _$MagicSphereEnumMap = {
  MagicSphere.pierre: 'pierre',
  MagicSphere.feu: 'feu',
  MagicSphere.oceans: 'oceans',
  MagicSphere.metal: 'metal',
  MagicSphere.nature: 'nature',
  MagicSphere.reves: 'reves',
  MagicSphere.cite: 'cite',
  MagicSphere.vents: 'vents',
  MagicSphere.ombre: 'ombre',
};

const _$MagicSkillEnumMap = {
  MagicSkill.instinctive: 'instinctive',
  MagicSkill.invocatoire: 'invocatoire',
  MagicSkill.sorcellerie: 'sorcellerie',
};

const _$CastingDurationUnitEnumMap = {
  CastingDurationUnit.action: 'action',
  CastingDurationUnit.turn: 'turn',
  CastingDurationUnit.minute: 'minute',
  CastingDurationUnit.hour: 'hour',
};
