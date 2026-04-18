import '../../../classes/calendar.dart';
import '../../../classes/entity/abilities.dart';

enum AugurePlayerCharacterInfluencesType {
  character,
  motivation,
  quality,
  fault,
}

const augurePlayerCharacterInfluences = <Augure, Map<AugurePlayerCharacterInfluencesType,String>> {
  Augure.fataliste: {
    AugurePlayerCharacterInfluencesType.character: "Froid et méprisant",
    AugurePlayerCharacterInfluencesType.motivation: "Modifier",
    AugurePlayerCharacterInfluencesType.quality: "Prudent",
    AugurePlayerCharacterInfluencesType.fault: "Implacable",
  },
  Augure.volcan: {
    AugurePlayerCharacterInfluencesType.character: "Fougueux et passionné",
    AugurePlayerCharacterInfluencesType.motivation: "Réussir",
    AugurePlayerCharacterInfluencesType.quality: "Franc",
    AugurePlayerCharacterInfluencesType.fault: "Colérique",
  },
  Augure.metal: {
    AugurePlayerCharacterInfluencesType.character: "Méticuleux et taciturne",
    AugurePlayerCharacterInfluencesType.motivation: "Créer",
    AugurePlayerCharacterInfluencesType.quality: "Précis",
    AugurePlayerCharacterInfluencesType.fault: "Arrogant",
  },
  Augure.cite: {
    AugurePlayerCharacterInfluencesType.character: "Curieux et sociable",
    AugurePlayerCharacterInfluencesType.motivation: "Rencontrer",
    AugurePlayerCharacterInfluencesType.quality: "Sociable",
    AugurePlayerCharacterInfluencesType.fault: "Manipulateur",
  },
  Augure.vent: {
    AugurePlayerCharacterInfluencesType.character: "Impulsif et spontané",
    AugurePlayerCharacterInfluencesType.motivation: "Découvrir",
    AugurePlayerCharacterInfluencesType.quality: "Motivé",
    AugurePlayerCharacterInfluencesType.fault: "Inconstant",
  },
  Augure.ocean: {
    AugurePlayerCharacterInfluencesType.character: "Calme et pacifique",
    AugurePlayerCharacterInfluencesType.motivation: "Apprendre",
    AugurePlayerCharacterInfluencesType.quality: "Sage",
    AugurePlayerCharacterInfluencesType.fault: "Manipulateur",
  },
  Augure.chimere: {
    AugurePlayerCharacterInfluencesType.character: "Mystérieux et observateur",
    AugurePlayerCharacterInfluencesType.motivation: "Comprendre",
    AugurePlayerCharacterInfluencesType.quality: "Sensible",
    AugurePlayerCharacterInfluencesType.fault: "Énigmatique",
  },
  Augure.nature: {
    AugurePlayerCharacterInfluencesType.character: "Bienveillant et chaleureux",
    AugurePlayerCharacterInfluencesType.motivation: "Fonder",
    AugurePlayerCharacterInfluencesType.quality: "Convivial",
    AugurePlayerCharacterInfluencesType.fault: "Mystique",
  },
  Augure.pierre: {
    AugurePlayerCharacterInfluencesType.character: "Laconique et solitaire",
    AugurePlayerCharacterInfluencesType.motivation: "Survivre",
    AugurePlayerCharacterInfluencesType.quality: "Engagé",
    AugurePlayerCharacterInfluencesType.fault: "Borné",
  },
  Augure.homme: {
    AugurePlayerCharacterInfluencesType.character: "Inventif et visionnaire",
    AugurePlayerCharacterInfluencesType.motivation: "Inventer",
    AugurePlayerCharacterInfluencesType.quality: "Imaginatif",
    AugurePlayerCharacterInfluencesType.fault: "Matérialiste",
  },
};

enum PlayerCharacterWizardAge {
  enfant(
    title: 'Enfant (6-10 ans)',
    baseXP: 70,
    abilitiesModifiers: {
      Ability.force: -2,
      Ability.resistance: -2,
      Ability.intelligence: 0,
      Ability.volonte: 0,
      Ability.perception: 1,
      Ability.coordination: 0,
      Ability.empathie: 2,
      Ability.presence: 1,
    },
    attributesValues: {
      4: 3,
      3: 1,
    },
    baseLuck: 4,
    baseProficiency: 0,
    lpFreePoints: 3,
  ),
  adolescent(
    title: 'Adolescent (11-15 ans)',
    baseXP: 90,
    abilitiesModifiers: {
      Ability.force: -1,
      Ability.resistance: -1,
      Ability.intelligence: 0,
      Ability.volonte: 0,
      Ability.perception: 1,
      Ability.coordination: 0,
      Ability.empathie: 1,
      Ability.presence: 0,
    },
    attributesValues: {
      5: 1,
      4: 2,
      3: 1,
    },
    baseLuck: 2,
    baseProficiency: 0,
    lpFreePoints: 4,
  ),
  adulte(
    title: 'Adulte (16-40 ans)',
    baseXP: 110,
    abilitiesModifiers: {
      Ability.force: 0,
      Ability.resistance: 0,
      Ability.intelligence: 0,
      Ability.volonte: 0,
      Ability.perception: 0,
      Ability.coordination: 0,
      Ability.empathie: 0,
      Ability.presence: 0,
    },
    attributesValues: {
      5: 2,
      4: 1,
      3: 1,
    },
    baseLuck: 0,
    baseProficiency: 0,
    lpFreePoints: 6,
  ),
  ancien(
    title: 'Ancien (41-50 ans)',
    baseXP: 130,
    abilitiesModifiers: {
      Ability.force: -1,
      Ability.resistance: -1,
      Ability.intelligence: 1,
      Ability.volonte: 1,
      Ability.perception: -1,
      Ability.coordination: 0,
      Ability.empathie: 0,
      Ability.presence: 1,
    },
    attributesValues: {
      6: 1,
      5: 1,
      4: 1,
      3: 1,
    },
    baseLuck: 0,
    baseProficiency: 2,
    lpFreePoints: 4,
  ),
  venerable(
    title: 'Vénérable (51 ans et plus)',
    baseXP: 150,
    abilitiesModifiers: {
      Ability.force: -2,
      Ability.resistance: -1,
      Ability.intelligence: 1,
      Ability.volonte: 1,
      Ability.perception: -1,
      Ability.coordination: -1,
      Ability.empathie: 1,
      Ability.presence: 1,
    },
    attributesValues: {
      6: 2,
      4: 1,
      3: 1,
    },
    baseLuck: 0,
    baseProficiency: 4,
    lpFreePoints: 3,
  ),
  ;

  const PlayerCharacterWizardAge({
    required this.title,
    required this.baseXP,
    required this.abilitiesModifiers,
    required this.attributesValues,
    required this.baseLuck,
    required this.baseProficiency,
    required this.lpFreePoints,
  });

  final String title;
  final int baseXP;
  final Map<Ability, int> abilitiesModifiers;
  final Map<int, int> attributesValues;
  final int baseLuck;
  final int baseProficiency;
  final int lpFreePoints;
}

const experienceLevels = <int, String>{
  0: "Pas d'expérience supplémentaire",
  30: "Légèrement expérimenté",
  60: "Agguéri",
  90: "Vétéran",
};