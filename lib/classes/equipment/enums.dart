enum EquipableItemSlot {
  body(title: 'Corps'),
  fullBody(title: 'Corps & Tête'),
  upperBody(title: 'Haut du corps'),
  head(title: 'Tête'),
  forehead(title: 'Front'),
  ears(title: 'Oreilles'),
  neck(title: 'Cou'),
  torso(title: 'Torse'),
  chest(title: 'Poitrine'),
  arms(title: 'Bras'),
  upperArm(title: 'Haut de bras', slots: 2),
  forearm(title: 'Avant-bras', slots: 2),
  hands(title: 'Mains'),
  dominantHand(title: 'Main dominante'),
  weakHand(title: 'Main faible'),
  finger(title: 'Doigt', slots: 10),
  belt(title: 'Ceinture'),
  legs(title: 'Jambes'),
  feet(title: 'Pieds'),
  ;

  final String title;
  final int slots;

  const EquipableItemSlot({ required this.title, this.slots = 1 });

  static List<EquipableItemSlot> slotsFor(EquipableItemSlot bp) {
    if(bp == body) {
      return [
        torso,
        arms,
        legs,
      ];
    }
    else if(bp == fullBody) {
      return [
        head,
        neck,
        torso,
        arms,
        legs,
      ];
    }
    else if(bp == upperBody) {
      return [
        torso,
        arms,
      ];
    }
    else {
      return [bp];
    }
  }
}

enum EquipableItemLayer {
  under(title: 'Sous-couche'),
  normal(title: 'Défaut'),
  over(title: 'Sur-couche'),
  ;

  final String title;

  const EquipableItemLayer({ required this.title });
}

enum EquipmentScarcity {
  tresCommun(title: 'Très commun', short: 'tc'),
  commun(title: 'Commun', short: 'c'),
  peuCommun(title: 'Peu commun', short: 'pc'),
  rare(title: 'Rare', short: 'r'),
  tresRare(title: 'Très rare', short: 'tr'),
  introuvable(title: 'Introuvable', short: 'int'),
  nonApplicable(title: 'Non applicable', short: 'NA'),
  ;

  final String title;
  final String short;

  const EquipmentScarcity({ required this.title, required this.short });
}

enum EquipmentQuality {
  inferior(title: 'Inférieure', priceMultiplier: 0.9),
  normal(title: 'Normale', priceMultiplier: 1.0),
  good(title: 'Bonne', priceMultiplier: 1.2),
  veryGood(title: 'Très bonne', priceMultiplier: 1.5),
  superior(title: 'Supérieure', priceMultiplier: 2.0),
  exceptional(title: 'Exceptionnelle', priceMultiplier: 3.0),
  incredible(title: 'Incroyable', priceMultiplier: 5.0),
  legendary(title: 'Légendaire', priceMultiplier: 10.0),
  ;

  final String title;
  final double priceMultiplier;

  const EquipmentQuality({ required this.title, required this.priceMultiplier });
}

enum EquipmentMetal {
  none(
    title: 'None',
    weightModifier: 1.0,
    damageModifier: 0,
    protectionModifier: 0,
  ),
  iron(
    title: 'Fer',
    weightModifier: 1.0,
    damageModifier: 0,
    protectionModifier: 0,
  ),
  steel(
    title: 'Acier',
    weightModifier: 1.3,
    damageModifier: 2,
    protectionModifier: 2,
    priceModifier: 5,
    intrinsicResistance: EquipmentQuality.superior
  ),
  silver(
    title: 'Argent',
    weightModifier: 2.0,
    damageModifier: 0,
    protectionModifier: 0,
    priceModifier: 25000,
    intrinsicResistance: EquipmentQuality.good
  ),
  bronze(
    title: 'Bronze',
    weightModifier: 0.9,
    damageModifier: -5,
    protectionModifier: -5,
    priceModifier: 6,
    intrinsicResistance: EquipmentQuality.inferior
  ),
  copper(
    title: 'Cuivre',
    weightModifier: 1.15,
    damageModifier: -2,
    protectionModifier: -2,
    priceModifier: 2
  ),
  gold(
    title: 'Or',
    weightModifier: 3.6,
    damageModifier: 0,
    protectionModifier: 0,
    priceModifier: 33000
  ),
  platinum(
    title: 'Platine',
    weightModifier: 3.5,
    damageModifier: 0,
    protectionModifier: 0,
    priceModifier: 30000,
    intrinsicResistance: EquipmentQuality.good
  ),
  stone(
    title: 'Pierre',
    weightModifier: 1.2,
    damageModifier: -5,
    protectionModifier: null,
    intrinsicResistance: EquipmentQuality.inferior
  ),
  bloodOfKezyr(
    title: 'Sang de Kezyr',
    weightModifier: 1.5,
    damageModifier: 5,
    protectionModifier: 10,
    intrinsicResistance: EquipmentQuality.legendary
  ),
  darkSteel(
    title: 'Sombracier',
    weightModifier: 0.75,
    damageModifier: 8,
    protectionModifier: 5,
    intrinsicResistance: EquipmentQuality.incredible
  ),
  ;

  final String title;
  final double weightModifier;
  final int damageModifier;
  final int? protectionModifier;
  final double? priceModifier;
  final EquipmentQuality intrinsicResistance;

  const EquipmentMetal({
    required this.title,
    required this.weightModifier,
    required this.damageModifier,
    this.protectionModifier,
    this.priceModifier,
    this.intrinsicResistance = EquipmentQuality.normal,
  });
}

enum EquipmentAvailabilityZone {
  village,
  city,
}