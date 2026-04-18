import 'package:prophecy_compagnon_mj/classes/caste/base.dart';
import 'package:prophecy_compagnon_mj/classes/character/advantages.dart';
import 'package:prophecy_compagnon_mj/classes/entity/specialized_skill.dart';
import 'package:prophecy_compagnon_mj/ui/table/pc_wizard/utils.dart';

import '../../../classes/calendar.dart';
import '../../../classes/caste/character_caste.dart';
import '../../../classes/character/tendencies.dart';
import '../../../classes/entity/abilities.dart';
import '../../../classes/entity/attributes.dart';
import '../../../classes/entity/injury.dart';
import '../../../classes/entity/magic.dart';
import '../../../classes/entity/skill_family.dart';
import '../../../classes/entity/skill_instance.dart';
import '../../../classes/entity/skills.dart';
import '../../../classes/entity/specialized_skill_instance.dart';
import '../../../classes/equipment/equipment.dart';
import '../../../classes/human_character.dart';
import '../../../classes/magic.dart';
import '../../../classes/magic_spell.dart';
import '../../../classes/money.dart';
import '../../../classes/player_character.dart';
import 'model.dart';

String? validateFinalize(PlayerCharacterWizardModel model) {
  try {
    var _ = playerCharacterWizardFinalize(model);
  }
  catch(e, s) {
    return '${e.toString()}\n${s.toString()}';
  }
  return null;
}

PlayerCharacter playerCharacterWizardFinalize(PlayerCharacterWizardModel model) {
  var abilities = EntityAbilities(abilities: model.computedAbilities());
  var attributes = EntityAttributes(attributes: model.computedAttributes());
  var injuriesManager = InjuryManager.getInjuryManagerForAbilities(
    resistance: abilities.resistance,
    volonte: abilities.volonte,
  );

  var skills = <SkillFamily, List<SkillInstance>>{};
  for(var f in SkillFamily.values) {
    skills[f] = <SkillInstance>[];
  }
  var wizardSpecialization = model.starterSpecialization!;
  var specializedSkill = SpecializedSkill.create(
    parent: (wizardSpecialization.skill as WizardStandardSkillWrapper).skill,
    parentImplementation: wizardSpecialization.implementation,
    name: wizardSpecialization.specialization!,
  );
  var specialization = SpecializedSkillInstance(
    skill: specializedSkill,
    value: wizardSpecialization.value,
  );
  for(var i in model.effectiveSkills) {
    if(i.skill is! WizardStandardSkillWrapper) continue;
    var w = i.skill as WizardStandardSkillWrapper;

    var si = SkillInstance(
      skill: w.skill,
      implementation: i.implementation,
      value: i.value,
      specializations: specialization.skill.parent == w.skill && i.implementation == wizardSpecialization.implementation
        ? [specialization]
        : null,
    );
    skills[w.skill.family]!.add(si);
  }
  var entitySkills = EntitySkills(
    families: Map<SkillFamily, EntitySkillFamily>.fromEntries(
      skills.entries.map(
        (MapEntry<SkillFamily, List<SkillInstance>> e) => MapEntry(
          e.key,
          EntitySkillFamily(all: e.value),
        )
      )
    )
  );

  var magicSkills = <MagicSkill, int>{};
  var magicSpheres = <MagicSphere, int>{};
  for(var i in model.effectiveSkills) {
    if(i.skill is WizardMagicSkillSkillWrapper) {
      for(var s in MagicSkill.values) {
        if(i.implementation == s.title) {
          magicSkills[s] = i.value;
        }
      }
    }
    else if (i.skill is WizardMagicSphereSkillWrapper) {
      for(var s in MagicSphere.values) {
        if(i.implementation == s.title) {
          magicSpheres[s] = i.value;
        }
      }
    }
  }
  var magicSpells = <MagicSpell>[];
  if(model.spells != null) magicSpells.addAll(model.spells!);
  if(model.advantageSpell != null) magicSpells.add(model.advantageSpell!);

  List<CharacterDisadvantage> disadvantages = List.from(model.mandatoryDisadvantages!);
  if(model.additionalDisadvantages != null) {
    disadvantages.addAll(model.additionalDisadvantages!);
  }

  var circlesDragon = 0;
  var circlesHuman = 0;
  var circlesFatality = 0;
  var hasAdvantageAugure = (model.advantages ?? <CharacterAdvantage>[])
      .any((CharacterAdvantage a) => a.advantage == Advantage.augureFavorable);
  if(hasAdvantageAugure) {
    switch(model.augure!) {
      case Augure.none:
        ; // no-op
      case Augure.fataliste:
        circlesFatality += 5;
      case Augure.volcan:
        circlesDragon += 4;
        circlesFatality += 1;
      case Augure.metal:
        circlesDragon += 3;
        circlesHuman += 2;
      case Augure.cite:
        circlesDragon += 1;
        circlesHuman += 4;
      case Augure.vent:
        circlesDragon += 4;
        circlesHuman += 1;
      case Augure.ocean:
        circlesDragon += 5;
      case Augure.chimere:
        circlesDragon += 3;
        circlesHuman += 1;
        circlesFatality += 1;
      case Augure.nature:
        circlesDragon += 4;
        circlesFatality += 1;
      case Augure.pierre:
        circlesDragon += 5;
      case Augure.homme:
        circlesHuman += 0;
    }
  }
  var tendencies = CharacterTendencies(
    dragon: TendencyAttribute(
        value: model.tendencyDragon!,
        circles: circlesDragon,
      ),
    human: TendencyAttribute(
        value: model.tendencyHuman!,
        circles: circlesHuman
      ),
    fatality: TendencyAttribute(
        value: model.tendencyFatality!,
        circles: circlesFatality,
      ),
  );

  return PlayerCharacter(
    player: model.playerName!,
    augure: model.augure!,
    name: model.characterName!,
    privilegedExperience: model.privilegedExperience!,
    abilities: abilities,
    attributes: attributes,
    initiative: model.initiative,
    injuries: EntityInjuries(manager: injuriesManager),
    skills: entitySkills,
    equipment: EntityEquipment(model.equipment!),
    money: MoneyWallet(bronze: (model.money ?? 0)),
    magic: EntityMagic(
        skills: magicSkills,
        spheres: magicSpheres,
        pool: model.additionalMagicPool,
        spells: magicSpells,
      ),
    caste: CharacterCaste(
        caste: model.caste!,
        status: CasteStatus.apprenti,
        interdicts: [model.interdict!],
        privileges: model.privileges,
      ),
    age: model.characterAge,
    height: model.characterHeight,
    weight: model.characterWeight,
    luck: model.luck ?? 0,
    proficiency: model.proficiency ?? 0,
    renown: model.renown,
    origin: CharacterOrigin(uuid: model.origin!),
    disadvantages: CharacterDisadvantages(disadvantages),
    advantages: CharacterAdvantages(model.advantages),
    tendencies: tendencies,
    description: model.description,
  );
}