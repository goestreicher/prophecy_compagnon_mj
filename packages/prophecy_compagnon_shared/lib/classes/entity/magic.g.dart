// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'magic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntityMagic _$EntityMagicFromJson(Map<String, dynamic> json) => EntityMagic(
  skills: (json['skills'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry($enumDecode(_$MagicSkillEnumMap, k), (e as num).toInt()),
  ),
  spheres: (json['spheres'] as Map<String, dynamic>?)?.map(
    (k, e) =>
        MapEntry($enumDecode(_$MagicSphereEnumMap, k), (e as num).toInt()),
  ),
  pool: (json['pool'] as num?)?.toInt() ?? 0,
  pools: (json['pools'] as Map<String, dynamic>?)?.map(
    (k, e) =>
        MapEntry($enumDecode(_$MagicSphereEnumMap, k), (e as num).toInt()),
  ),
  spells: EntityMagicSpells.fromJson(json['spells'] as List),
);

Map<String, dynamic> _$EntityMagicToJson(
  EntityMagic instance,
) => <String, dynamic>{
  'skills': const EntityMagicSkillsJsonConverter().toJson(instance.skills),
  'spheres': const EntityMagicSpheresJsonConverter().toJson(instance.spheres),
  'pool': instance.pool,
  'pools': const EntityMagicSpheresJsonConverter().toJson(instance.pools),
  'spells': EntityMagicSpells.toJson(instance.spells),
};

const _$MagicSkillEnumMap = {
  MagicSkill.instinctive: 'instinctive',
  MagicSkill.invocatoire: 'invocatoire',
  MagicSkill.sorcellerie: 'sorcellerie',
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
