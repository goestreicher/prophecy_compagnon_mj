import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'skill.dart';
import 'skill_family.dart';
import 'skill_instance.dart';

part 'skills.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class EntitySkillFamily with ChangeNotifier {
  EntitySkillFamily({ required this.all });

  EntitySkillFamily.empty() : all = <SkillInstance>[];

  SkillInstance? skill(Skill s) {
    var idx = all.indexWhere((SkillInstance i) => i.skill == s);
    return idx >= 0
        ? all[idx]
        : null;
  }

  SkillInstance add(Skill s) {
    var i = skill(s);
    if(i == null) {
      i = SkillInstance(skill: s, value: 0);
      all.add(i);
      notifyListeners();
    }
    return i;
  }

  void del(Skill s) {
    all.removeWhere((SkillInstance i) => i.skill == s);
    notifyListeners();
  }

  List<SkillInstance> all;

  factory EntitySkillFamily.fromJson(Map<String, dynamic> json) =>
      _$EntitySkillFamilyFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EntitySkillFamilyToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class EntitySkills {
  EntitySkills({
    Map<SkillFamily, EntitySkillFamily>? families
  })
  {
    this.families = families ?? <SkillFamily, EntitySkillFamily>{};
    for(var f in SkillFamily.values) {
      if(!this.families.containsKey(f)) {
        this.families[f] = EntitySkillFamily.empty();
      }
    }
  }

  EntitySkills.empty()
  {
    families = Map.fromEntries(
        SkillFamily.values.map(
                (SkillFamily f) => MapEntry(f, EntitySkillFamily.empty())
        )
    );
  }

  EntitySkillFamily get combat => families[SkillFamily.combat]!;
  EntitySkillFamily get mouvement => families[SkillFamily.mouvement]!;
  EntitySkillFamily get theorie => families[SkillFamily.theorie]!;
  EntitySkillFamily get pratique => families[SkillFamily.pratique]!;
  EntitySkillFamily get technique => families[SkillFamily.technique]!;
  EntitySkillFamily get manipulation => families[SkillFamily.manipulation]!;
  EntitySkillFamily get communication => families[SkillFamily.communication]!;
  EntitySkillFamily get influence => families[SkillFamily.influence]!;

  List<SkillInstance> get all => [
    ...combat.all,
    ...mouvement.all,
    ...theorie.all,
    ...pratique.all,
    ...technique.all,
    ...manipulation.all,
    ...communication.all,
    ...influence.all,
  ];

  SkillInstance? skill(Skill s) => families[s.family]!.skill(s);

  SkillInstance add(Skill s) => families[s.family]!.add(s);

  void del(Skill s) => families[s.family]!.del(s);

  Iterable<SkillInstance> forFamily(SkillFamily family) =>
      families[family]!.all;

  late final Map<SkillFamily, EntitySkillFamily> families;

  factory EntitySkills.fromJson(Map<String, dynamic> json) =>
      _$EntitySkillsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EntitySkillsToJson(this);
}