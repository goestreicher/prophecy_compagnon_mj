import 'package:flutter/foundation.dart';
import 'package:prophecy_compagnon_mj/classes/caste/character_caste.dart';

import '../../../classes/calendar.dart';
import '../../../classes/caste/base.dart';
import '../../../classes/caste/career.dart';
import '../../../classes/caste/interdicts.dart';
import '../../../classes/entity/abilities.dart';
import '../../../classes/entity/attributes.dart';
import '../../../classes/equipment/equipment.dart';
import '../../../classes/human_character.dart';
import '../../../classes/magic_spell.dart';
import '../../../classes/player_character.dart';
import 'enums.dart';
import 'utils.dart';

class PlayerCharacterWizardModel extends ChangeNotifier {
  String? concept;
  String? general;
  String? appearance;
  String? family;
  String? past;
  String? mentality;
  String? interests;
  String? passions;
  String? hate;
  String? ambitions;

  String get description {
    var full = "";

    full += "# Concept\n\n";
    full += (concept ?? "").isEmpty ? "Aucun\n\n" : "$concept!\n\n";
    full += "## Général\n\n${(general ?? "").isEmpty ? "Non renseigné\n\n" : "$general!\n\n"}";
    full += "## Général\n\n${(appearance ?? "").isEmpty ? "Non renseignée\n\n" : "$appearance!\n\n"}";
    full += "## Famille\n\n${(family ?? "").isEmpty ? "Non renseignée\n\n" : "$family!\n\n"}";
    full += "## Passé\n\n${(past ?? "").isEmpty ? "Non renseigné\n\n" : "$past!\n\n"}";
    full += "## Mentalité\n\n${(mentality ?? "").isEmpty ? "Non renseignée\n\n" : "$mentality!\n\n"}";
    full += "## Intérêts\n\n${(interests ?? "").isEmpty ? "Non renseignés\n\n" : "$interests!\n\n"}";
    full += "## Passions\n\n${(passions ?? "").isEmpty ? "Non renseignées\n\n" : "$passions!\n\n"}";
    full += "## Haines\n\n${(hate ?? "").isEmpty ? "Non renseignées\n\n" : "$hate!\n\n"}";
    full += "## Ambitions\n\n${(ambitions ?? "").isEmpty ? "Non renseignées\n\n" : "$ambitions!\n\n"}";

    full += "# Complément\n\n";

    full += "## Augure\n\n";
    full += "**Caractère** : ${augurePlayerCharacterInfluences[augure!]![AugurePlayerCharacterInfluencesType.character]!}\n\n";
    full += "**Motivation** : ${augurePlayerCharacterInfluences[augure!]![AugurePlayerCharacterInfluencesType.motivation]!}\n\n";
    full += "**Qualité** : ${augurePlayerCharacterInfluences[augure!]![AugurePlayerCharacterInfluencesType.quality]!}\n\n";
    full += "**Défaut** : ${augurePlayerCharacterInfluences[augure!]![AugurePlayerCharacterInfluencesType.fault]!}\n\n";

    if(career != null) {
      full += "## Carrière envisagée\n\n";
      full += "${career!.title}\n\n";
      full += "**Pré-requis**\n\n";
      for(var req in career!.requirements) {
        full += "* ${req.toDisplayString()}\n";
      }
    }

    full += "## Niveau d'expérience\n\n";
    full += "${experienceLevels[additionalBaseXP ?? 0]!}\n\n";

    return "$full\n\n";
  }

  Augure? augure;

  PlayerCharacterWizardAge? age;

  Caste? caste;
  CasteInterdict? interdict;
  Career? career;

  Map<Ability, int>? abilities;
  Ability? abilityTransferFrom;
  Ability? abilityTransferTo;

  Map<Attribute, int>? attributes;
  int? luck;
  int? proficiency;

  String? origin;
  int? tendencyDragon;
  int? tendencyHuman;
  int? tendencyFatality;

  List<CharacterDisadvantage>? mandatoryDisadvantages;
  List<CharacterDisadvantage>? additionalDisadvantages;

  List<CharacterAdvantage>? advantages;

  List<WizardSkillInstance?>? baseSkills;
  WizardSkillInstance? starterSpecialization;
  List<WizardSkillInstance?>? advantageAugureBaseSkills;
  WizardSkillInstance? advantageNaturalMagicSkill;
  WizardSkillInstance? advantageIntuitiveMagicSkill;
  List<WizardSkillInstance?>? advantageMentorBaseSkills;

  int get baseXP {
    switch(age!) {
      case PlayerCharacterWizardAge.enfant:
        return 70;
      case PlayerCharacterWizardAge.adolescent:
        return 90;
      case PlayerCharacterWizardAge.adulte:
        return 110;
      case PlayerCharacterWizardAge.ancien:
        return 130;
      case PlayerCharacterWizardAge.venerable:
        return 150;
    }
  }

  int? additionalBaseXP;

  int get maxXP {
    if(age == null) return 0;
    var ret = additionalBaseXP ?? 0;
    return ret + baseXP;
  }

  int get usedXP => _usedXP;
  set usedXP(int v) {
    _usedXP = v;
    notifyListeners();
  }
  int _usedXP = 0;

  int get remainingXP => maxXP - usedXP;

  List<CharacterCastePrivilege>? privileges;
  List<WizardSkillInstance>? augmentationSkills;
  WizardSkillInstance? augmentationStarterSpecialization;
  List<WizardSkillInstance>? augmentationMagicSkills;
  List<WizardSkillInstance>? augmentationMagicSpheres;
  int additionalMagicPool = 0;
  List<MagicSpell>? spells;
  MagicSpell? advantageSpell;
  int renown = 0;

  List<Equipment>? equipment;
  int? money;

  String? characterName;
  String? playerName;
  PlayerCharacterPrivilegedExperience? privilegedExperience;
  int characterAge = 25;
  double characterHeight = 1.7;
  double characterWeight = 60.0;

  int? abilityComputedValue(Ability a) {
    int? ret;

    if(!(abilities?.containsKey(a) ?? false)) return ret;

    ret = abilities![a]!;
    if((age?.abilitiesModifiers[a]) != null) {
      ret += age!.abilitiesModifiers[a]!;
    }

    if(abilityTransferFrom == a) {
      ret -= 1;
    }
    if(abilityTransferTo == a) {
      ret += 1;
    }

    return ret;
  }

  Map<Ability, int> computedAbilities() =>
    Map<Ability, int>.fromEntries(
      Ability.values
        .map((Ability a) =>
          MapEntry<Ability, int>(a, abilityComputedValue(a) ?? 0))
    );

  int get initiative {
    var a = computedAbilities();

    var sum = a[Ability.coordination]! + a[Ability.perception]!;
    var init = 0;

    switch(sum) {
      case >= 2 && <= 5:
        init = 1;
      case >= 6 && <= 9:
        init = 2;
      case >= 10 && <= 13:
        init = 3;
      case >= 14 && <= 16:
        init = 4;
      case >= 17:
        init = 5;
    }

    return init;
  }

  int? attributeComputedValue(Attribute attribute) {
    int? ret;

    if(!(attributes?.containsKey(attribute) ?? false)) return ret;

    ret = attributes![attribute]!;

    var mod = EntityAttributes.attributeModifier(attribute, computedAbilities());
    if(mod != null) {
      ret += mod;
    }

    return ret;
  }

  Map<Attribute, int> computedAttributes() =>
      Map<Attribute, int>.fromEntries(
        Attribute.values
          .map((Attribute a) =>
            MapEntry<Attribute, int>(a, attributeComputedValue(a) ?? 0))
      );

  int? effectiveBaseSkill(String title) {
    // TODO: improve this with a pre-calculated cache of effective values
    var skills = Map.fromEntries(
      effectiveBaseSkills
        .map((WizardSkillInstance i) => MapEntry<String, int>(
          i.title,
          i.value
        ))
    );

    return skills[title];
  }

  List<WizardSkillInstance> get effectiveBaseSkills {
    var skills = Map<String, WizardSkillInstance>.fromEntries(
        (baseSkills ?? <WizardSkillInstance>[])
            .where((WizardSkillInstance? i) => i != null)
            .map((WizardSkillInstance? i) => MapEntry(
              i!.title,
              WizardSkillInstance(
                skill: i.skill,
                implementation: i.implementation,
                value: i.value,
              )
            ))
    );

    for(var i in (advantageAugureBaseSkills ?? <WizardSkillInstance?>[])) {
      if(i == null) continue;
      if(skills.containsKey(i.title)) {
        skills[i.title]!.value += i.value;
      }
      else {
        skills[i.title] = WizardSkillInstance(
            skill: i.skill,
            implementation: i.implementation,
            value: i.value,
        );
      }
    }

    if(advantageNaturalMagicSkill != null) {
      if(skills.containsKey(advantageNaturalMagicSkill!.title)) {
        skills[advantageNaturalMagicSkill!.title]!.value +=
            advantageNaturalMagicSkill!.value;
      }
      else {
        skills[advantageNaturalMagicSkill!.title] = WizardSkillInstance(
          skill: advantageNaturalMagicSkill!.skill,
          implementation: advantageNaturalMagicSkill!.implementation,
          value: advantageNaturalMagicSkill!.value,
        );
      }
    }

    if(advantageIntuitiveMagicSkill != null) {
      if(skills.containsKey(advantageIntuitiveMagicSkill!.title)) {
        skills[advantageIntuitiveMagicSkill!.title]!.value +=
            advantageIntuitiveMagicSkill!.value;
      }
      else {
        skills[advantageIntuitiveMagicSkill!.title] = WizardSkillInstance(
          skill: advantageIntuitiveMagicSkill!.skill,
          implementation: advantageIntuitiveMagicSkill!.implementation,
          value: advantageIntuitiveMagicSkill!.value,
        );
      }
    }

    for(var i in (advantageMentorBaseSkills ?? <WizardSkillInstance?>[])) {
      if(i == null) continue;
      if(skills.containsKey(i.title)) {
        skills[i.title]!.value += i.value;
      }
      else {
        skills[i.title] = i;
      }
    }

    return skills.values.toList();
  }

  int get effectiveStarterSpecialization =>
      effectiveBaseSkill(starterSpecialization!.title)!;

  List<WizardSkillInstance> get effectiveSkills {
    var skills = Map<String, WizardSkillInstance>.fromEntries(
        effectiveBaseSkills
              .map((WizardSkillInstance i) => MapEntry(
              i.title,
              WizardSkillInstance(
                skill: i.skill,
                implementation: i.implementation,
                value: i.value,
              )
        ))
    );

    for(var i in (augmentationSkills ?? <WizardSkillInstance>[])) {
      if(skills.containsKey(i.title)) {
        skills[i.title]!.value += i.value;
      }
      else {
        skills[i.title] = WizardSkillInstance(
          skill: i.skill,
          implementation: i.implementation,
          value: i.value,
        );
      }
    }

    for(var i in (augmentationMagicSkills ?? <WizardSkillInstance>[])) {
      if(skills.containsKey(i.title)) {
        skills[i.title]!.value += i.value;
      }
      else {
        skills[i.title] = WizardSkillInstance(
          skill: i.skill,
          implementation: i.implementation,
          value: i.value,
        );
      }
    }

    for(var i in (augmentationMagicSpheres ?? <WizardSkillInstance>[])) {
      if(skills.containsKey(i.title)) {
        skills[i.title]!.value += i.value;
      }
      else {
        skills[i.title] = WizardSkillInstance(
          skill: i.skill,
          implementation: i.implementation,
          value: i.value,
        );
      }
    }

    return skills.values.toList();
  }
}