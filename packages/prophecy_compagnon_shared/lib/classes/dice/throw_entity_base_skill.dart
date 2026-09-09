import 'package:prophecy_compagnon_shared/classes/dice/throw_entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/entity/abilities.dart';
import 'package:prophecy_compagnon_shared/classes/entity/skill.dart';
import 'package:prophecy_compagnon_shared/classes/entity/skill_instance.dart';
import 'package:prophecy_compagnon_shared/classes/entity/specialized_skill.dart';
import 'package:prophecy_compagnon_shared/classes/entity/specialized_skill_instance.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';

class DiceThrowEntityBaseSkill extends DiceThrowEntityBase {
  DiceThrowEntityBaseSkill({
    required super.attribute,
    this.skill,
    this.specialization,
    this.implementation,
    this.ability,
    this.additionalDifficultyOnAbility = true,
  })
  {
    if(skill == null && specialization == null) {
      throw(ArgumentError('Une compétence ou une spécialisation doivent être fournies pour un lancer'));
    }
  }

  final Skill? skill;
  final SpecializedSkill? specialization;
  final String? implementation;
  final Ability? ability;
  final bool additionalDifficultyOnAbility;

  @override
  bool canThrow(EntityBase entity) {
    if(_entitySpecialization(entity) != null) return true;
    if(_entitySkill(entity) != null) return true;
    if(ability != null) return true;
    return false;
  }

  @override
  String componentLabel(EntityBase entity) {
    String? skillLabel;

    if(_entitySpecialization(entity) != null) {
      skillLabel = specialization!.parent.title;
      if(implementation != null) {
        skillLabel += ' ($implementation)';
      }
      skillLabel += ' / ${specialization!.name}';
    }
    else if(_entitySkill(entity) != null) {
      skillLabel = skill!.title;
      if(implementation != null) {
        skillLabel += ' ($implementation)';
      }
    }
    else {
      skillLabel = ability!.title;
    }

    return skillLabel;
  }

  @override
  int componentValue(EntityBase entity) {
    int? skillValue;

    // TODO: manage bonuses
    skillValue = _entitySpecialization(entity)?.value;
    skillValue ??= _entitySkill(entity)?.value;
    skillValue ??= entity.abilities[ability!];

    return skillValue;
  }

  @override
  String get label {
    var ret = '${attribute.title} + ${(specialization?.parent ?? skill!).title}';

    if(implementation != null) {
      ret += ' ($implementation)';
    }

    if(specialization != null) {
      ret += ' / ${specialization!.name}';
    }

    return ret;
  }

  @override
  int value(EntityBase entity) =>
      entity.attributes[attribute] + componentValue(entity);

  @override
  int difficultyModifier(EntityBase entity) =>
      (_entitySpecialization(entity) ?? _entitySkill(entity)) == null && additionalDifficultyOnAbility
        ? 5
        : 0;

  SkillInstance? _entitySkill(EntityBase entity) => entity.skills
      .skill(
        specialization?.parent ?? skill!,
        implementation: implementation,
      );

  SpecializedSkillInstance? _entitySpecialization(EntityBase entity) =>
      specialization == null
        ? null
        : entity.skills
            .skill(
              specialization!.parent,
              implementation: implementation,
            )
            ?.specialization(specialization!);
}