import '../caste/base.dart';
import '../caste/character_caste.dart';
import '../caste/interdicts.dart';
import '../caste/privileges.dart';
import '../character/advantages.dart';
import '../character/tendencies.dart';
import '../draconic_link.dart';
import '../entity_base.dart';
import '../equipment/weapon.dart';
import '../human_character.dart';
import '../magic.dart';
import '../magic_user.dart';
import 'abilities.dart';
import 'attributes.dart';
import 'skill.dart';
import 'skill_family.dart';
import 'skill_instance.dart';
import 'specialized_skill_instance.dart';

abstract class EntityRequirement {
  const EntityRequirement();

  String toDisplayString();
  bool meetsRequirements(EntityBase entity);
}

class SimpleDescriptionRequirement extends EntityRequirement {
  const SimpleDescriptionRequirement(this.description);

  final String description;

  @override
  String toDisplayString() => description;

  @override
  bool meetsRequirements(EntityBase entity) => true;
}

class OneOfRequirements extends EntityRequirement {
  const OneOfRequirements({ required this.requirements });

  final List<EntityRequirement> requirements;

  @override
  String toDisplayString() =>
      requirements
        .map<String>((EntityRequirement r) => r.toDisplayString())
        .join(" OU ");

  @override
  bool meetsRequirements(EntityBase entity) =>
      requirements.any((EntityRequirement r) => r.meetsRequirements(entity));
}

class AllOfRequirements extends EntityRequirement {
  const AllOfRequirements({ required this.requirements });

  final List<EntityRequirement> requirements;

  @override
  String toDisplayString() =>
      requirements
        .map<String>((EntityRequirement r) => r.toDisplayString())
        .join(" ET ");

  @override
  bool meetsRequirements(EntityBase entity) =>
      requirements.every((EntityRequirement r) => r.meetsRequirements(entity));
}

class AbilityMinRequirement extends EntityRequirement {
  const AbilityMinRequirement({ required this.ability, required this.min });

  final Ability ability;
  final int min;

  @override
  String toDisplayString() => "${ability.title} à $min";

  @override
  bool meetsRequirements(EntityBase entity) =>
      (entity.abilities.all[ability] ?? 0) >= min;
}

class AbilityMaxRequirement extends EntityRequirement {
  const AbilityMaxRequirement({ required this.ability, required this.max });

  final Ability ability;
  final int max;

  @override
  String toDisplayString() => "${ability.title} inférieure ou égale à $max";

  @override
  bool meetsRequirements(EntityBase entity) =>
      (entity.abilities.all[ability] ?? 99) <= max;
}

class AttributeMinRequirement extends EntityRequirement {
  const AttributeMinRequirement({ required this.attribute, required this.min });

  final Attribute attribute;
  final int min;

  @override
  String toDisplayString() => "${attribute.title} à $min";

  @override
  bool meetsRequirements(EntityBase entity) =>
      (entity.attributes.all[attribute] ?? 0) >= min;
}

class LuckMinRequirement extends EntityRequirement {
  const LuckMinRequirement({ required this.min });

  final int min;

  @override
  String toDisplayString() => "Chance à $min";

  @override
  bool meetsRequirements(EntityBase entity) =>
      entity is HumanCharacter
      && entity.luck >= min;
}

class ProficiencyMinRequirement extends EntityRequirement {
  const ProficiencyMinRequirement({ required this.min });

  final int min;

  @override
  String toDisplayString() => "Maîtrise à $min";

  @override
  bool meetsRequirements(EntityBase entity) =>
      entity is HumanCharacter
      && entity.proficiency >= min;
}

class RenownMinRequirement extends EntityRequirement {
  const RenownMinRequirement({ required this.min });

  final int min;

  @override
  String toDisplayString() => "Renommée à $min";

  @override
  bool meetsRequirements(EntityBase entity) =>
      entity is HumanCharacter
      && entity.renown >= min;
}

class TendencyMinRequirement extends EntityRequirement {
  const TendencyMinRequirement({ required this.tendency, required this.min });

  final Tendency tendency;
  final int min;

  @override
  String toDisplayString() => "Tendance ${tendency.title} à $min";

  @override
  bool meetsRequirements(EntityBase entity) =>
      entity is HumanCharacter
      && entity.tendencies[tendency].value >= min;
}

class TendencyMaxRequirement extends EntityRequirement {
  const TendencyMaxRequirement({ required this.tendency, required this.max });

  final Tendency tendency;
  final int max;

  @override
  String toDisplayString() => "Tendance ${tendency.title} inférieure ou égale à $max";

  @override
  bool meetsRequirements(EntityBase entity) =>
      entity is HumanCharacter
      && entity.tendencies[tendency].value <= max;
}

class TendencyCirclesMinRequirement extends EntityRequirement {
  const TendencyCirclesMinRequirement({ required this.tendency, required this.min });

  final Tendency tendency;
  final int min;

  @override
  String toDisplayString() => "$min cercles en Tendance ${tendency.title}";

  @override
  bool meetsRequirements(EntityBase entity) =>
      entity is HumanCharacter
        && (
          entity.tendencies[tendency].value >= 1
          || entity.tendencies[tendency].circles >= min
        );
}

class TendencyCirclesMaxRequirement extends EntityRequirement {
  const TendencyCirclesMaxRequirement({ required this.tendency, required this.max });

  final Tendency tendency;
  final int max;

  @override
  String toDisplayString() => "Moins de $max cercles en Tendance ${tendency.title}";

  @override
  bool meetsRequirements(EntityBase entity) =>
      entity is HumanCharacter
      && entity.tendencies[tendency].value == 0
      && entity.tendencies[tendency].circles <= max;
}

class HasInterdictRequirement extends EntityRequirement {
  const HasInterdictRequirement({ required this.interdict });

  final CasteInterdict interdict;

  @override
  String toDisplayString() => "Interdit ${interdict.title}";

  @override
  bool meetsRequirements(EntityBase entity) =>
      entity is HumanCharacter
      && entity.caste.interdicts.contains(interdict);
}

class InterdictCountMinRequirement extends EntityRequirement {
  const InterdictCountMinRequirement({ required this.caste, required this.min });

  final Caste caste;
  final int min;

  @override
  String toDisplayString() => "$min Interdits de la caste (${caste.title})";

  @override
  bool meetsRequirements(EntityBase entity) =>
      entity is HumanCharacter
      && entity.caste.interdicts.length >= min;
}

class HasPrivilegeRequirement extends EntityRequirement {
  const HasPrivilegeRequirement({ required this.privilege });

  final CastePrivilege privilege;

  @override
  String toDisplayString() => "Privilège ${privilege.title}";

  @override
  bool meetsRequirements(EntityBase entity) =>
      entity is HumanCharacter
      && entity.caste.privileges.any(
        (CharacterCastePrivilege p) => p.privilege == privilege
      );
}

class PrivilegeCountMinRequirement extends EntityRequirement {
  const PrivilegeCountMinRequirement({ required this.min });

  final int min;

  @override
  String toDisplayString() => "$min Privilèges";

  @override
  bool meetsRequirements(EntityBase entity) =>
      entity is HumanCharacter
      && entity.caste.privileges.length >= min;
}

class HasAdvantageRequirement extends EntityRequirement {
  const HasAdvantageRequirement({ required this.advantage });

  final Advantage advantage;

  @override
  String toDisplayString() => "Avantage ${advantage.title}";

  @override
  bool meetsRequirements(EntityBase entity) =>
      entity is HumanCharacter
      && entity.advantages.any((CharacterAdvantage a) => a.advantage == advantage);
}

class HasSphereDraconicLinkRequirement extends EntityRequirement {
  const HasSphereDraconicLinkRequirement({ required this.sphere });

  final MagicSphere sphere;

  @override
  String toDisplayString() => "Lien de la Sphère ${sphere.title}";

  @override
  bool meetsRequirements(EntityBase entity) =>
      entity is HumanCharacter
      && entity.draconicLink.progress.index > DraconicLinkProgress.aucunLien.index
      && entity.draconicLink.sphere == sphere;
}

class HasNoDraconicLinkRequirement extends EntityRequirement {
  const HasNoDraconicLinkRequirement();

  @override
  String toDisplayString() => "Aucun Lien";

  @override
  bool meetsRequirements(EntityBase entity) =>
      entity is HumanCharacter
      && entity.draconicLink.progress == DraconicLinkProgress.aucunLien;
}

class SingleSkillMinRequirement extends EntityRequirement {
  const SingleSkillMinRequirement({ required this.skill, required this.min });

  final Skill skill;
  final int min;

  @override
  String toDisplayString() => "Compétence ${skill.title} à $min";

  @override
  bool meetsRequirements(EntityBase entity) =>
      (entity.skills.skill(skill)?.value ?? 0) >= min;
}

class MultipleSkillsMinRequirement extends EntityRequirement {
  const MultipleSkillsMinRequirement({ required this.skills, required this.min, required this.count });

  final List<Skill> skills;
  final int min;
  final int count;

  @override
  String toDisplayString() => "$count de ces compétences à $min : ${(skills.map((Skill s) => s.title)).join(", ")}";

  @override
  bool meetsRequirements(EntityBase entity) {
    var total = 0;

    for(var s in skills) {
      if((entity.skills.skill(s)?.value ?? 0) >= min) {
        total += 1;
      }
    }

    return total >= count;
  }
}

class SingleSkillImplementationMinRequirement extends EntityRequirement {
  const SingleSkillImplementationMinRequirement({ required this.skill, required this.implementation, required this.min });

  final Skill skill;
  final String implementation;
  final int min;

  @override
  String toDisplayString() => "Compétence ${skill.title} ($implementation) à $min";

  @override
  bool meetsRequirements(EntityBase entity) =>
      (entity.skills.skill(skill, implementation: implementation)?.value ?? 0) > min;
}

class SingleSkillAnyImplementationMinRequirement extends EntityRequirement {
  const SingleSkillAnyImplementationMinRequirement({ required this.skill, required this.min, this.count = 1, this.comment });

  final Skill skill;
  final int min;
  final int count;
  final String? comment;

  @override
  String toDisplayString() => "$count Compétences de ${skill.title} à $min${comment != null ? " ($comment)" : ""}";

  @override
  bool meetsRequirements(EntityBase entity) {
    var instances = entity.skills.all.where(
      (SkillInstance i) => i.skill == skill && i.value >= min
    );
    return instances.length >= count;
  }
}

class SkillSpecializationCountMinRequirement extends EntityRequirement {
  const SkillSpecializationCountMinRequirement({ required this.skill, required this.min });

  final Skill skill;
  final int min;

  @override
  String toDisplayString() => "$min Spécialisation(s) en ${skill.title}";

  @override
  bool meetsRequirements(EntityBase entity) =>
      (entity.skills.skill(skill)?.specializations.length ?? 0) >= min;
}

class SkillSpecializationMinRequirement extends EntityRequirement {
  const SkillSpecializationMinRequirement({ required this.skill, required this.specialization, required this.min });

  final Skill skill;
  final String specialization;
  final int min;

  @override
  String toDisplayString() => "${skill.title} ($specialization) à $min";

  @override
  bool meetsRequirements(EntityBase entity) {
    if((entity.skills.skill(skill)?.specializations ?? <SpecializedSkillInstance>[]).isEmpty) {
      return false;
    }

    for(var sp in entity.skills.skill(skill)!.specializations) {
      if(sp.skill.name == specialization && sp.value >= min) {
        return true;
      }
    }

    return false;
  }
}

class MultipleSkillsInFamilyMinRequirement extends EntityRequirement {
  const MultipleSkillsInFamilyMinRequirement({
    required this.family,
    required this.count,
    required this.min,
  });

  final SkillFamily family;
  final int count;
  final int min;

  @override
  String toDisplayString() => "$count Compétences de ${family.title} à $min";

  @override
  bool meetsRequirements(EntityBase entity) {
    if((entity.skills.families[family]?.all ?? <SkillInstance>[]).isEmpty) {
      return false;
    }

    int total = 0;

    for(var instance in entity.skills.families[family]!.all) {
      if(instance.value >= min) {
        total += 1;
      }
    }

    return total >= count;
  }
}

class SkillAttributeTotalPointsRequirement extends EntityRequirement {
  const SkillAttributeTotalPointsRequirement({ required this.attribute, required this.min });

  final Attribute attribute;
  final int min;

  @override
  String toDisplayString() => "$min points dans des Compétences liées à ${attribute.title}";

  @override
  bool meetsRequirements(EntityBase entity) {
    int total = 0;

    for(var family in SkillFamily.values) {
      if(family.defaultAttribute != attribute) {
        continue;
      }
      if((entity.skills.families[family]?.all ?? <SkillInstance>[]).isEmpty) {
        continue;
      }

      total += (
        entity.skills.families[family]!.all
          .map<int>((SkillInstance i) => i.value)
          .reduce((int value, int element) => value + element)
      );
    }

    return total >= min;
  }
}

class SkillFamilyTotalPointsRequirement extends EntityRequirement {
  const SkillFamilyTotalPointsRequirement({ required this.family, required this.min });

  final SkillFamily family;
  final int min;

  @override
  String toDisplayString() => "$min points dans des Compétences de ${family.title}";

  @override
  bool meetsRequirements(EntityBase entity) =>
      (entity.skills.families[family]?.all ?? <SkillInstance>[]).isNotEmpty
      && (entity.skills.families[family]!.all
            .map<int>((SkillInstance i) => i.value)
            .reduce((int value, int element) => value + element)) >= min;
}

class WeaponSkillsMinRequirement extends EntityRequirement {
  const WeaponSkillsMinRequirement({ required this.min, this.count = 1 });

  final int min;
  final int count;

  @override
  String toDisplayString() => "$count Compétences d'arme à $min";

  @override
  bool meetsRequirements(EntityBase entity) {
    var total = 0;

    for(var s in WeaponModel.weaponSkills()) {
      if((entity.skills.skill(s)?.value ?? 0) >= min) {
        total += 1;
      }
    }

    return total >= count;
  }
}

class MagicSphereMinRequirement extends EntityRequirement {
  const MagicSphereMinRequirement({ required this.sphere, required this.min });

  final MagicSphere sphere;
  final int min;

  @override
  String toDisplayString() => "Sphère ${sphere.title} à $min";

  @override
  bool meetsRequirements(EntityBase entity) =>
      entity is MagicUser
      && entity.magic.spheres.get(sphere) >= min;
}

class MagicSphereAnyMinRequirement extends EntityRequirement {
  const MagicSphereAnyMinRequirement({ required this.min, this.count = 1 });

  final int min;
  final int count;

  @override
  String toDisplayString() => "$count Sphères à $min";

  @override
  bool meetsRequirements(EntityBase entity) {
    if(entity is! MagicUser) return false;

    var total = 0;

    for(var s in MagicSphere.values) {
      if(entity.magic.spheres.get(s) >= min) {
        total += 1;
      }
    }

    return total >= count;
  }
}

class MagicSkillMinRequirement extends EntityRequirement {
  const MagicSkillMinRequirement({ required this.skill, required this.min });

  final MagicSkill skill;
  final int min;

  @override
  String toDisplayString() => "Compétence ${skill.title} à $min";

  @override
  bool meetsRequirements(EntityBase entity) =>
      entity is MagicUser
      && entity.magic.skills.get(skill) >= min;
}

class MagicSkillAnyMinRequirement extends EntityRequirement {
  const MagicSkillAnyMinRequirement({ required this.min, this.count = 1 });

  final int min;
  final int count;

  @override
  String toDisplayString() => "$count Compétences magiques à $min";

  @override
  bool meetsRequirements(EntityBase entity) {
    if(entity is! MagicUser) return false;

    var total = 0;

    for(var s in MagicSkill.values) {
      if(entity.magic.skills.get(s) >= min) {
        total += 1;
      }
    }

    return total >= count;
  }
}

class MagicSpellCountMinRequirement extends EntityRequirement {
  const MagicSpellCountMinRequirement({ required this.min, this.spheres = 1 });

  final int min;
  final int spheres;

  @override
  String toDisplayString() => "$min Sorts dans $spheres Sphère(s)";

  @override
  bool meetsRequirements(EntityBase entity) {
    if(entity is! MagicUser) return false;

    Map<MagicSphere, int> total = <MagicSphere, int>{};

    for(var s in MagicSphere.values) {
      total[s] = entity.magic.spells.forSphere(s).length;
    }

    return total.keys.length >= spheres
        && total.values.every((int n) => n >= min);
  }
}

class MagicPoolMinRequirement extends EntityRequirement {
  const MagicPoolMinRequirement({ required this.min });

  final int min;

  @override
  String toDisplayString() => "$min points dans la Réserve Personnelle";

  @override
  bool meetsRequirements(EntityBase entity) =>
      entity is MagicUser
      && entity.magic.pool >= 10;
}

class CasteMemberRequirement extends EntityRequirement {
  const CasteMemberRequirement({ required this.caste, this.status = CasteStatus.apprenti });

  final Caste caste;
  final CasteStatus status;

  @override
  String toDisplayString() => "Membre de la Caste ${caste.title} de ${status.index}° Statut";

  @override
  bool meetsRequirements(EntityBase entity) =>
      entity is HumanCharacter
      && entity.caste.caste == caste
      && entity.caste.status.index >= status.index;
}