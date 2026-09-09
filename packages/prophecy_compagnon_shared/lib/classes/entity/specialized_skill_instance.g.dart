// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specialized_skill_instance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpecializedSkillInstance _$SpecializedSkillInstanceFromJson(
  Map<String, dynamic> json,
) => SpecializedSkillInstance(
  skill: SpecializedSkill.fromJson(json['skill'] as Map<String, dynamic>),
  value: (json['value'] as num).toInt(),
);

Map<String, dynamic> _$SpecializedSkillInstanceToJson(
  SpecializedSkillInstance instance,
) => <String, dynamic>{
  'skill': instance.skill.toJson(),
  'value': instance.value,
};
