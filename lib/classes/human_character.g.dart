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
  Disadvantage.dette: 'dette',
  Disadvantage.echec: 'echec',
  Disadvantage.emotif: 'emotif',
  Disadvantage.ennemi: 'ennemi',
  Disadvantage.faiblesse: 'faiblesse',
  Disadvantage.fragilite: 'fragilite',
  Disadvantage.interdit: 'interdit',
  Disadvantage.maladie: 'maladie',
  Disadvantage.malchance: 'malchance',
  Disadvantage.manie: 'manie',
  Disadvantage.obsession: 'obsession',
  Disadvantage.phobie: 'phobie',
  Disadvantage.serment: 'serment',
  Disadvantage.amnesie: 'amnesie',
  Disadvantage.appelDeLaBete: 'appelDeLaBete',
  Disadvantage.autocrate: 'autocrate',
  Disadvantage.blessure: 'blessure',
  Disadvantage.curiositeMageVents: 'curiositeMageVents',
  Disadvantage.dependance: 'dependance',
  Disadvantage.deviance: 'deviance',
  Disadvantage.echecRare: 'echecRare',
  Disadvantage.ennemiRare: 'ennemiRare',
  Disadvantage.incompetence: 'incompetence',
  Disadvantage.infirmite: 'infirmite',
  Disadvantage.instinctSuperieur: 'instinctSuperieur',
  Disadvantage.interditsDeBrorne: 'interditsDeBrorne',
  Disadvantage.maladresse: 'maladresse',
  Disadvantage.marqueDeNenya: 'marqueDeNenya',
  Disadvantage.maledictionDeKezyr: 'maledictionDeKezyr',
  Disadvantage.maledictionDeNenya: 'maledictionDeNenya',
  Disadvantage.mauvaiseReputation: 'mauvaiseReputation',
  Disadvantage.marqueAuFer: 'marqueAuFer',
  Disadvantage.mauvaisOeil: 'mauvaisOeil',
  Disadvantage.personneACharge: 'personneACharge',
  Disadvantage.phobieDesCites: 'phobieDesCites',
  Disadvantage.regardDesDragons: 'regardDesDragons',
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
  Advantage.anticipation: 'anticipation',
  Advantage.armeDuMaitre: 'armeDuMaitre',
  Advantage.augureFavorable: 'augureFavorable',
  Advantage.chance: 'chance',
  Advantage.charme: 'charme',
  Advantage.confidences: 'confidences',
  Advantage.convictionSuperieure: 'convictionSuperieure',
  Advantage.corpsAguerri: 'corpsAguerri',
  Advantage.droiture: 'droiture',
  Advantage.enigmatique: 'enigmatique',
  Advantage.fortunePersonnelle: 'fortunePersonnelle',
  Advantage.heritageDraconique: 'heritageDraconique',
  Advantage.illumine: 'illumine',
  Advantage.intellectualisation: 'intellectualisation',
  Advantage.magieNaturelle: 'magieNaturelle',
  Advantage.mentor: 'mentor',
  Advantage.present: 'present',
  Advantage.prestance: 'prestance',
  Advantage.pressentiment: 'pressentiment',
  Advantage.recuperation: 'recuperation',
  Advantage.resistanceALaMagie: 'resistanceALaMagie',
  Advantage.santeDeFer: 'santeDeFer',
  Advantage.sensAccru: 'sensAccru',
  Advantage.sensDeLOrientation: 'sensDeLOrientation',
  Advantage.sensEnAlerte: 'sensEnAlerte',
  Advantage.sommeilLeger: 'sommeilLeger',
  Advantage.statutSocial: 'statutSocial',
  Advantage.surprise: 'surprise',
  Advantage.chanceInouie: 'chanceInouie',
  Advantage.empathieNaturelle: 'empathieNaturelle',
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

TendencyAttribute _$TendencyAttributeFromJson(Map<String, dynamic> json) =>
    TendencyAttribute(
      value: (json['value'] as num).toInt(),
      circles: (json['circles'] as num).toInt(),
    );

Map<String, dynamic> _$TendencyAttributeToJson(TendencyAttribute instance) =>
    <String, dynamic>{'value': instance.value, 'circles': instance.circles};

CharacterTendencies _$CharacterTendenciesFromJson(Map<String, dynamic> json) =>
    CharacterTendencies(
      dragon: TendencyAttribute.fromJson(
        json['dragon'] as Map<String, dynamic>,
      ),
      human: TendencyAttribute.fromJson(json['human'] as Map<String, dynamic>),
      fatality: TendencyAttribute.fromJson(
        json['fatality'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$CharacterTendenciesToJson(
  CharacterTendencies instance,
) => <String, dynamic>{
  'dragon': instance.dragon.toJson(),
  'human': instance.human.toJson(),
  'fatality': instance.fatality.toJson(),
};

HumanCharacter _$HumanCharacterFromJson(Map<String, dynamic> json) =>
    HumanCharacter(
        uuid: json['uuid'] as String?,
        location: json['location'] == null
            ? ObjectLocation.memory
            : ObjectLocation.fromJson(json['location'] as Map<String, dynamic>),
        name: json['name'] as String,
        initiative: (json['initiative'] as num?)?.toInt() ?? 1,
        size: (json['size'] as num?)?.toDouble(),
        description: json['description'] as String?,
        image: json['image'] == null
            ? null
            : ExportableBinaryData.fromJson(
                json['image'] as Map<String, dynamic>,
              ),
        icon: json['icon'] == null
            ? null
            : ExportableBinaryData.fromJson(
                json['icon'] as Map<String, dynamic>,
              ),
        caste:
            $enumDecodeNullable(_$CasteEnumMap, json['caste']) ??
            Caste.sansCaste,
        casteStatus:
            $enumDecodeNullable(_$CasteStatusEnumMap, json['caste_status']) ??
            CasteStatus.none,
        career: $enumDecodeNullable(_$CareerEnumMap, json['career']),
        luck: (json['luck'] as num?)?.toInt() ?? 0,
        proficiency: (json['proficiency'] as num?)?.toInt() ?? 0,
        renown: (json['renown'] as num?)?.toInt() ?? 0,
        age: (json['age'] as num?)?.toInt() ?? 25,
        height: (json['height'] as num?)?.toDouble() ?? 1.7,
        weight: (json['weight'] as num?)?.toDouble() ?? 60.0,
        origin: json['origin'] == null
            ? null
            : Place.fromJson(json['origin'] as Map<String, dynamic>),
        interdicts:
            (json['interdicts'] as List<dynamic>?)
                ?.map((e) => $enumDecode(_$InterdictEnumMap, e))
                .toList() ??
            [],
        castePrivileges:
            (json['caste_privileges'] as List<dynamic>?)
                ?.map(
                  (e) => CharacterCastePrivilege.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList() ??
            [],
        disadvantages: (json['disadvantages'] as List<dynamic>?)
            ?.map(
              (e) => CharacterDisadvantage.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        advantages: (json['advantages'] as List<dynamic>?)
            ?.map((e) => CharacterAdvantage.fromJson(e as Map<String, dynamic>))
            .toList(),
        tendencies: json['tendencies'] == null
            ? null
            : CharacterTendencies.fromJson(
                json['tendencies'] as Map<String, dynamic>,
              ),
      )
      ..status = json['status'] == null
          ? EntityStatus.empty()
          : EntityStatus.fromJson(json['status'] as Map<String, dynamic>)
      ..skills = (json['skills'] as List<dynamic>)
          .map((e) => SkillInstance.fromJson(e as Map<String, dynamic>))
          .toList()
      ..magicSpells =
          (json['magic_spells'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              $enumDecode(_$MagicSphereEnumMap, k),
              (e as List<dynamic>).map((e) => e as String).toList(),
            ),
          ) ??
          {}
      ..extraMagicPool = (json['extra_magic_pool'] as num?)?.toInt() ?? 0;

Map<String, dynamic> _$HumanCharacterToJson(
  HumanCharacter instance,
) => <String, dynamic>{
  'equiped': equipedToJson(instance.equiped),
  'uuid': ?instance.uuid,
  'name': instance.name,
  'description': instance.description,
  'image': instance.image?.toJson(),
  'icon': instance.icon?.toJson(),
  'status': instance.status.toJson(),
  'size': instance.size,
  'initiative': instance.initiative,
  'abilities': enumKeyedMapToJson(instance.abilities),
  'attributes': enumKeyedMapToJson(instance.attributes),
  'skills': instance.skills.map((e) => e.toJson()).toList(),
  'equipment': equipmentToJson(instance.equipment),
  'magic_spells': instance.magicSpells.map(
    (k, e) => MapEntry(_$MagicSphereEnumMap[k]!, e),
  ),
  'extra_magic_pool': instance.extraMagicPool,
  'caste': _$CasteEnumMap[instance.caste]!,
  'caste_status': _$CasteStatusEnumMap[instance.casteStatus]!,
  'career': _$CareerEnumMap[instance.career],
  'age': instance.age,
  'height': instance.height,
  'weight': instance.weight,
  'origin': instance.origin.toJson(),
  'luck': instance.luck,
  'proficiency': instance.proficiency,
  'renown': instance.renown,
  'interdicts': instance.interdicts.map((e) => _$InterdictEnumMap[e]!).toList(),
  'caste_privileges': instance.castePrivileges.map((e) => e.toJson()).toList(),
  'disadvantages': instance.disadvantages.map((e) => e.toJson()).toList(),
  'advantages': instance.advantages.map((e) => e.toJson()).toList(),
  'tendencies': instance.tendencies.toJson(),
};

const _$CasteEnumMap = {
  Caste.sansCaste: 'sansCaste',
  Caste.artisan: 'artisan',
  Caste.combattant: 'combattant',
  Caste.commercant: 'commercant',
  Caste.erudit: 'erudit',
  Caste.mage: 'mage',
  Caste.prodige: 'prodige',
  Caste.protecteur: 'protecteur',
  Caste.voyageur: 'voyageur',
};

const _$CasteStatusEnumMap = {
  CasteStatus.none: 'none',
  CasteStatus.apprenti: 'apprenti',
  CasteStatus.initie: 'initie',
  CasteStatus.expert: 'expert',
  CasteStatus.maitre: 'maitre',
  CasteStatus.grandMaitre: 'grandMaitre',
};

const _$CareerEnumMap = {
  Career.forgeron: 'forgeron',
  Career.architecte: 'architecte',
  Career.orfevre: 'orfevre',
  Career.alchimiste: 'alchimiste',
  Career.tisserand: 'tisserand',
  Career.mineur: 'mineur',
  Career.artisanElementaire: 'artisanElementaire',
  Career.mecaniste: 'mecaniste',
  Career.aventurier: 'aventurier',
  Career.guerrier: 'guerrier',
  Career.duelliste: 'duelliste',
  Career.mercenaire: 'mercenaire',
  Career.maitreDArmes: 'maitreDArmes',
  Career.strategeCombattant: 'strategeCombattant',
  Career.chevalier: 'chevalier',
  Career.gladiateur: 'gladiateur',
  Career.paladin: 'paladin',
  Career.lutteur: 'lutteur',
  Career.courtisane: 'courtisane',
  Career.diplomate: 'diplomate',
  Career.espion: 'espion',
  Career.joueur: 'joueur',
  Career.marchand: 'marchand',
  Career.marchandItinerant: 'marchandItinerant',
  Career.mendiant: 'mendiant',
  Career.tenancier: 'tenancier',
  Career.voleur: 'voleur',
  Career.architectes: 'architectes',
  Career.astronomes: 'astronomes',
  Career.cartographes: 'cartographes',
  Career.erudits: 'erudits',
  Career.herboristes: 'herboristes',
  Career.historiens: 'historiens',
  Career.medecins: 'medecins',
  Career.navigateurs: 'navigateurs',
  Career.scientifiques: 'scientifiques',
  Career.generaliste: 'generaliste',
  Career.specialisteElementaire: 'specialisteElementaire',
  Career.invocateur: 'invocateur',
  Career.specialisteDesRituels: 'specialisteDesRituels',
  Career.enchanteur: 'enchanteur',
  Career.mageDeCombat: 'mageDeCombat',
  Career.guerisseurMage: 'guerisseurMage',
  Career.ingenieur: 'ingenieur',
  Career.reveur: 'reveur',
  Career.fideleDeChimere: 'fideleDeChimere',
  Career.gardien: 'gardien',
  Career.tuteur: 'tuteur',
  Career.prophete: 'prophete',
  Career.fervent: 'fervent',
  Career.guerisseurProdige: 'guerisseurProdige',
  Career.sage: 'sage',
  Career.mediateur: 'mediateur',
  Career.missionnaire: 'missionnaire',
  Career.prodigeAnimal: 'prodigeAnimal',
  Career.poeteDeLaNature: 'poeteDeLaNature',
  Career.soldat: 'soldat',
  Career.legionnaire: 'legionnaire',
  Career.gardeDuCorps: 'gardeDuCorps',
  Career.milicien: 'milicien',
  Career.inquisiteur: 'inquisiteur',
  Career.instructeur: 'instructeur',
  Career.strategeProtecteur: 'strategeProtecteur',
  Career.ingenieurMilitaire: 'ingenieurMilitaire',
  Career.protecteurItinerant: 'protecteurItinerant',
  Career.chasseurs: 'chasseurs',
  Career.eclaireurs: 'eclaireurs',
  Career.errants: 'errants',
  Career.explorateurs: 'explorateurs',
  Career.menestrels: 'menestrels',
  Career.messagers: 'messagers',
  Career.missionnaires: 'missionnaires',
};

const _$InterdictEnumMap = {
  Interdict.loiDuCompagnon: 'loiDuCompagnon',
  Interdict.loiDeLaPerfection: 'loiDeLaPerfection',
  Interdict.loiDuRespect: 'loiDuRespect',
  Interdict.loiDeLArme: 'loiDeLArme',
  Interdict.loiDeLHonneur: 'loiDeLHonneur',
  Interdict.loiDuSangCombattant: 'loiDuSangCombattant',
  Interdict.loiDuCoeur: 'loiDuCoeur',
  Interdict.loiDeLOrdre: 'loiDeLOrdre',
  Interdict.loiDuProgres: 'loiDuProgres',
  Interdict.loiDuSavoir: 'loiDuSavoir',
  Interdict.loiDuCollege: 'loiDuCollege',
  Interdict.loiDuSecret: 'loiDuSecret',
  Interdict.loiDuPacte: 'loiDuPacte',
  Interdict.loiDuPartage: 'loiDuPartage',
  Interdict.loiDeLaPrudence: 'loiDeLaPrudence',
  Interdict.loiDeLaMeditation: 'loiDeLaMeditation',
  Interdict.loiDeLaNature: 'loiDeLaNature',
  Interdict.loiDuSangProdige: 'loiDuSangProdige',
  Interdict.loiDuLien: 'loiDuLien',
  Interdict.loiDuSacrifice: 'loiDuSacrifice',
  Interdict.loiDuSangProtecteur: 'loiDuSangProtecteur',
  Interdict.loiDeLAmitie: 'loiDeLAmitie',
  Interdict.loiDeLaDecouverte: 'loiDeLaDecouverte',
  Interdict.loiDeLaLiberte: 'loiDeLaLiberte',
};

const _$MagicSphereEnumMap = {
  MagicSphere.pierre: 'pierre',
  MagicSphere.feu: 'feu',
  MagicSphere.oceans: 'oceans',
  MagicSphere.metal: 'metal',
  MagicSphere.nature: 'nature',
  MagicSphere.reves: 'reves',
  MagicSphere.cite: 'cite',
  MagicSphere.vents: 'vents',
  MagicSphere.ombre: 'ombre',
};
