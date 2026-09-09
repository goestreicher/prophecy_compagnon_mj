// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skills.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntitySkillFamily _$EntitySkillFamilyFromJson(Map<String, dynamic> json) =>
    EntitySkillFamily(
      all: (json['all'] as List<dynamic>)
          .map((e) => SkillInstance.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EntitySkillFamilyToJson(EntitySkillFamily instance) =>
    <String, dynamic>{'all': instance.all.map((e) => e.toJson()).toList()};

EntitySkills _$EntitySkillsFromJson(Map<String, dynamic> json) => EntitySkills(
  families: (json['families'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(
      $enumDecode(_$SkillFamilyEnumMap, k),
      EntitySkillFamily.fromJson(e as Map<String, dynamic>),
    ),
  ),
);

Map<String, dynamic> _$EntitySkillsToJson(EntitySkills instance) =>
    <String, dynamic>{
      'families': instance.families.map(
        (k, e) => MapEntry(_$SkillFamilyEnumMap[k]!, e.toJson()),
      ),
    };

const _$SkillFamilyEnumMap = {
  SkillFamily.combat: 'combat',
  SkillFamily.mouvement: 'mouvement',
  SkillFamily.theorie: 'theorie',
  SkillFamily.pratique: 'pratique',
  SkillFamily.technique: 'technique',
  SkillFamily.manipulation: 'manipulation',
  SkillFamily.communication: 'communication',
  SkillFamily.influence: 'influence',
};
