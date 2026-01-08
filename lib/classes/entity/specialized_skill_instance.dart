import 'package:json_annotation/json_annotation.dart';

import 'specialized_skill.dart';

part 'specialized_skill_instance.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class SpecializedSkillInstance {
  SpecializedSkillInstance({
    required this.skill,
    required this.value,
  });

  SpecializedSkill skill;
  int value;

  factory SpecializedSkillInstance.fromJson(Map<String, dynamic> json) =>
      _$SpecializedSkillInstanceFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SpecializedSkillInstanceToJson(this);
}