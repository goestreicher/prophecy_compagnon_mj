// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'human_character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterDisadvantage _$CharacterDisadvantageFromJson(
  Map<String, dynamic> json,
) => CharacterDisadvantage(
  disadvantage: $enumDecode(_$DisadvantageEnumMap, json['disadvantage']),
  cost: (json['cost'] as num).toInt(),
  details: json['details'] as String,
);

Map<String, dynamic> _$CharacterDisadvantageToJson(
  CharacterDisadvantage instance,
) => <String, dynamic>{
  'disadvantage': _$DisadvantageEnumMap[instance.disadvantage]!,
  'cost': instance.cost,
  'details': instance.details,
};

const _$DisadvantageEnumMap = {
  Disadvantage.anomalie: 'anomalie',
  Disadvantage.complexeDInferiorite: 'complexeDInferiorite',
  Disadvantage.curiositeMageVents: 'curiositeMageVents',
  Disadvantage.dette: 'dette',
  Disadvantage.echec: 'echec',
  Disadvantage.emotif: 'emotif',
  Disadvantage.ennemi: 'ennemi',
  Disadvantage.faiblesse: 'faiblesse',
  Disadvantage.fragilite: 'fragilite',
  Disadvantage.instinctSuperieur: 'instinctSuperieur',
  Disadvantage.interdit: 'interdit',
  Disadvantage.interditsDeBrorne: 'interditsDeBrorne',
  Disadvantage.maladie: 'maladie',
  Disadvantage.malchance: 'malchance',
  Disadvantage.maledictionDeKezyr: 'maledictionDeKezyr',
  Disadvantage.maledictionDeNenya: 'maledictionDeNenya',
  Disadvantage.manie: 'manie',
  Disadvantage.marqueDeNenya: 'marqueDeNenya',
  Disadvantage.mauvaiseReputation: 'mauvaiseReputation',
  Disadvantage.obsession: 'obsession',
  Disadvantage.phobie: 'phobie',
  Disadvantage.phobieDesCites: 'phobieDesCites',
  Disadvantage.serment: 'serment',
  Disadvantage.amnesie: 'amnesie',
  Disadvantage.appelDeLaBete: 'appelDeLaBete',
  Disadvantage.autocrate: 'autocrate',
  Disadvantage.blessure: 'blessure',
  Disadvantage.dependance: 'dependance',
  Disadvantage.deviance: 'deviance',
  Disadvantage.echecRare: 'echecRare',
  Disadvantage.ennemiRare: 'ennemiRare',
  Disadvantage.harmonieNaturelle: 'harmonieNaturelle',
  Disadvantage.incompetence: 'incompetence',
  Disadvantage.infirmite: 'infirmite',
  Disadvantage.maladresse: 'maladresse',
  Disadvantage.marqueAuFer: 'marqueAuFer',
  Disadvantage.mauvaisOeil: 'mauvaisOeil',
  Disadvantage.personneACharge: 'personneACharge',
  Disadvantage.regardDesDragons: 'regardDesDragons',
  Disadvantage.traumatismeMental: 'traumatismeMental',
  Disadvantage.troubleMental: 'troubleMental',
  Disadvantage.chetif: 'chetif',
  Disadvantage.curiosite: 'curiosite',
  Disadvantage.illusions: 'illusions',
  Disadvantage.insignifiant: 'insignifiant',
  Disadvantage.lassitude: 'lassitude',
  Disadvantage.mensongesInfantiles: 'mensongesInfantiles',
  Disadvantage.naivete: 'naivete',
  Disadvantage.revolte: 'revolte',
  Disadvantage.transfert: 'transfert',
  Disadvantage.versatilite: 'versatilite',
  Disadvantage.cardiaque: 'cardiaque',
  Disadvantage.edente: 'edente',
  Disadvantage.grincheux: 'grincheux',
  Disadvantage.impotent: 'impotent',
  Disadvantage.maladeImaginaire: 'maladeImaginaire',
  Disadvantage.nostalgieObsessionnelle: 'nostalgieObsessionnelle',
  Disadvantage.rhumatismes: 'rhumatismes',
  Disadvantage.senile: 'senile',
  Disadvantage.surdite: 'surdite',
  Disadvantage.vueDefaillante: 'vueDefaillante',
};

CharacterAdvantage _$CharacterAdvantageFromJson(Map<String, dynamic> json) =>
    CharacterAdvantage(
      advantage: $enumDecode(_$AdvantageEnumMap, json['advantage']),
      cost: (json['cost'] as num).toInt(),
      details: json['details'] as String,
    );

Map<String, dynamic> _$CharacterAdvantageToJson(CharacterAdvantage instance) =>
    <String, dynamic>{
      'advantage': _$AdvantageEnumMap[instance.advantage]!,
      'cost': instance.cost,
      'details': instance.details,
    };

const _$AdvantageEnumMap = {
  Advantage.agilite: 'agilite',
  Advantage.allie: 'allie',
  Advantage.ambidextre: 'ambidextre',
  Advantage.armeDuMaitre: 'armeDuMaitre',
  Advantage.augureFavorable: 'augureFavorable',
  Advantage.chance: 'chance',
  Advantage.charme: 'charme',
  Advantage.confidences: 'confidences',
  Advantage.corpsAguerri: 'corpsAguerri',
  Advantage.droiture: 'droiture',
  Advantage.fortunePersonnelle: 'fortunePersonnelle',
  Advantage.heritageDraconique: 'heritageDraconique',
  Advantage.humaniste: 'humaniste',
  Advantage.magieIntuitive: 'magieIntuitive',
  Advantage.magieNaturelle: 'magieNaturelle',
  Advantage.mentor: 'mentor',
  Advantage.present: 'present',
  Advantage.prestance: 'prestance',
  Advantage.pressentiment: 'pressentiment',
  Advantage.resistanceALaMagie: 'resistanceALaMagie',
  Advantage.santeDeFer: 'santeDeFer',
  Advantage.sensAccru: 'sensAccru',
  Advantage.sensDeLOrientation: 'sensDeLOrientation',
  Advantage.sensEnAlerte: 'sensEnAlerte',
  Advantage.statutSocial: 'statutSocial',
  Advantage.surprise: 'surprise',
  Advantage.chanceInouie: 'chanceInouie',
  Advantage.empathieNaturelle: 'empathieNaturelle',
  Advantage.faeGardienne: 'faeGardienne',
  Advantage.fetiche: 'fetiche',
  Advantage.instinctProtecteur: 'instinctProtecteur',
  Advantage.precoce: 'precoce',
  Advantage.artInterdit: 'artInterdit',
  Advantage.conviction: 'conviction',
  Advantage.culture: 'culture',
  Advantage.habileteReconnue: 'habileteReconnue',
  Advantage.objetDePredilection: 'objetDePredilection',
  Advantage.techniquePersonnelle: 'techniquePersonnelle',
};

CharacterOrigin _$CharacterOriginFromJson(Map<String, dynamic> json) =>
    CharacterOrigin(
      uuid: json['uuid'] as String?,
      place: json['place'] == null
          ? null
          : Place.fromJson(json['place'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CharacterOriginToJson(CharacterOrigin instance) =>
    <String, dynamic>{'uuid': instance.uuid};

HumanCharacter _$HumanCharacterFromJson(
  Map<String, dynamic> json,
) => HumanCharacter(
  uuid: json['uuid'] as String?,
  name: json['name'] as String,
  source: ObjectSource.fromJson(json['source'] as Map<String, dynamic>),
  location: json['location'] == null
      ? ObjectLocation.memory
      : ObjectLocation.fromJson(json['location'] as Map<String, dynamic>),
  abilities: json['abilities'] == null
      ? null
      : EntityAbilities.fromJson(json['abilities'] as Map<String, dynamic>),
  attributes: json['attributes'] == null
      ? null
      : EntityAttributes.fromJson(json['attributes'] as Map<String, dynamic>),
  initiative: (json['initiative'] as num?)?.toInt() ?? 1,
  injuries: json['injuries'] == null
      ? null
      : EntityInjuries.fromJson(json['injuries'] as Map<String, dynamic>),
  size: (json['size'] as num?)?.toDouble(),
  description: json['description'] as String?,
  skills: json['skills'] == null
      ? null
      : EntitySkills.fromJson(json['skills'] as Map<String, dynamic>),
  status: json['status'] == null
      ? null
      : EntityStatus.fromJson(json['status'] as Map<String, dynamic>),
  equipment: EntityEquipment.fromJson(json['equipment'] as List),
  magic: json['magic'] == null
      ? null
      : EntityMagic.fromJson(json['magic'] as Map<String, dynamic>),
  favors: EntityDraconicFavors.fromJson(
    EntityDraconicFavors.readFavorsFromJson(json, 'favors') as List,
  ),
  fervor: json['fervor'] == null
      ? null
      : EntityFervor.fromJson(json['fervor'] as Map<String, dynamic>),
  image: json['image'] == null
      ? null
      : ExportableBinaryData.fromJson(json['image'] as Map<String, dynamic>),
  icon: json['icon'] == null
      ? null
      : ExportableBinaryData.fromJson(json['icon'] as Map<String, dynamic>),
  caste: json['caste'] == null
      ? null
      : CharacterCaste.fromJson(json['caste'] as Map<String, dynamic>),
  honoraryCaste: json['honorary_caste'] == null
      ? null
      : CharacterCaste.fromJson(json['honorary_caste'] as Map<String, dynamic>),
  luck: (json['luck'] as num?)?.toInt() ?? 0,
  proficiency: (json['proficiency'] as num?)?.toInt() ?? 0,
  renown: (json['renown'] as num?)?.toInt() ?? 0,
  age: (json['age'] as num?)?.toInt() ?? 25,
  height: (json['height'] as num?)?.toDouble() ?? 1.7,
  weight: (json['weight'] as num?)?.toDouble() ?? 60.0,
  origin: json['origin'] == null
      ? null
      : CharacterOrigin.fromJson(json['origin'] as Map<String, dynamic>),
  disadvantages: CharacterDisadvantages.fromJson(
    json['disadvantages'] as List?,
  ),
  advantages: CharacterAdvantages.fromJson(json['advantages'] as List?),
  tendencies: json['tendencies'] == null
      ? null
      : CharacterTendencies.fromJson(
          json['tendencies'] as Map<String, dynamic>,
        ),
  draconicLink: json['draconic_link'] == null
      ? null
      : DraconicLink.fromJson(json['draconic_link'] as Map<String, dynamic>),
);

Map<String, dynamic> _$HumanCharacterToJson(HumanCharacter instance) =>
    <String, dynamic>{
      'source': instance.source.toJson(),
      'name': instance.name,
      'uuid': ?instance.uuid,
      'description': instance.description,
      'image': instance.image?.toJson(),
      'icon': instance.icon?.toJson(),
      'abilities': instance.abilities.toJson(),
      'attributes': instance.attributes.toJson(),
      'initiative': instance.initiative,
      'injuries': instance.injuries.toJson(),
      'size': instance.size,
      'skills': instance.skills.toJson(),
      'status': instance.status.toJson(),
      'equipment': EntityEquipment.toJson(instance.equipment),
      'magic': instance.magic.toJson(),
      'favors': EntityDraconicFavors.toJson(instance.favors),
      'fervor': instance.fervor.toJson(),
      'caste': instance.caste.toJson(),
      'honorary_caste': instance.honoraryCaste?.toJson(),
      'age': instance.age,
      'height': instance.height,
      'weight': instance.weight,
      'origin': instance.origin.toJson(),
      'luck': instance.luck,
      'proficiency': instance.proficiency,
      'renown': instance.renown,
      'disadvantages': CharacterDisadvantages.toJson(instance.disadvantages),
      'advantages': CharacterAdvantages.toJson(instance.advantages),
      'tendencies': instance.tendencies.toJson(),
      'draconic_link': instance.draconicLink.toJson(),
    };
