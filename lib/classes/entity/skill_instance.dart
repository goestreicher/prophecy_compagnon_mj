import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'skill.dart';
import 'specialized_skill.dart';
import 'specialized_skill_instance.dart';

part 'skill_instance.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class SkillInstance with ChangeNotifier {
  SkillInstance({
    required this.skill,
    required this.value,
    List<SpecializedSkillInstance>? specializations,
  })
    : specializations = specializations ?? <SpecializedSkillInstance>[];

  final Skill skill;
  int value;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<SpecializedSkillInstance> specializations;

  SpecializedSkillInstance? specialization(SpecializedSkill s) {
    var idx = specializations.indexWhere((SpecializedSkillInstance i) => i.skill == s);
    return idx >= 0
        ? specializations[idx]
        : null;
  }

  SpecializedSkillInstance addSpecialization(SpecializedSkill s) {
    var i = specialization(s);
    if(i == null) {
      i = SpecializedSkillInstance(skill: s, value: 0);
      specializations.add(i);
      notifyListeners();
    }
    return i;
  }

  void delSpecialization(SpecializedSkill s) {
    specializations.removeWhere((SpecializedSkillInstance i) => i.skill == s);
    notifyListeners();
  }

  factory SkillInstance.fromJson(Map<String, dynamic> json) {
    var instance = _$SkillInstanceFromJson(json);
    if(json.containsKey('specializations') && json['specializations'] is List) {
      for(Map<String, dynamic> spec in json['specializations']) {
        var sp = SpecializedSkill.create(
          parent: instance.skill,
          name: spec['name'],
          reserved: spec['reserved'],
        );

        instance.specializations.add(
          SpecializedSkillInstance(skill: sp, value: spec['value'])
        );
      }
    }
    return instance;
  }

  Map<String, dynamic> toJson() {
    var ret = _$SkillInstanceToJson(this);
    if(specializations.isNotEmpty) {
      ret['specializations'] = <Map<String, dynamic>>[];
      for(var sp in specializations) {
        ret['specializations'].add(<String, dynamic>{
          'name': sp.skill.name,
          'reserved': sp.skill.reserved,
          'value': sp.value,
        });
      }
    }
    return ret;
  }
}