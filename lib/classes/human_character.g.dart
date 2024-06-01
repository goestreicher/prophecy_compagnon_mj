// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'human_character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterDisadvantage _$CharacterDisadvantageFromJson(
        Map<String, dynamic> json) =>
    CharacterDisadvantage(
      disadvantage: $enumDecode(_$DisadvantageEnumMap, json['disadvantage']),
      cost: (json['cost'] as num).toInt(),
      details: json['details'] as String,
    );

Map<String, dynamic> _$CharacterDisadvantageToJson(
        CharacterDisadvantage instance) =>
    <String, dynamic>{
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
  Disadvantage.blessure: 'blessure',
  Disadvantage.dependance: 'dependance',
  Disadvantage.deviance: 'deviance',
  Disadvantage.echecRare: 'echecRare',
  Disadvantage.ennemiRare: 'ennemiRare',
  Disadvantage.incompetence: 'incompetence',
  Disadvantage.infirmite: 'infirmite',
  Disadvantage.maladresse: 'maladresse',
  Disadvantage.marqueAuFer: 'marqueAuFer',
  Disadvantage.mauvaisOeil: 'mauvaisOeil',
  Disadvantage.personneACharge: 'personneACharge',
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
  Advantage.armeDuMaitre: 'armeDuMaitre',
  Advantage.augureFavorable: 'augureFavorable',
  Advantage.chance: 'chance',
  Advantage.charme: 'charme',
  Advantage.confidences: 'confidences',
  Advantage.corpsAguerri: 'corpsAguerri',
  Advantage.droiture: 'droiture',
  Advantage.fortunePersonnelle: 'fortunePersonnelle',
  Advantage.heritageDraconique: 'heritageDraconique',
  Advantage.magieNaturelle: 'magieNaturelle',
  Advantage.mentor: 'mentor',
  Advantage.prestance: 'prestance',
  Advantage.pressentiment: 'pressentiment',
  Advantage.resistanceALaMagie: 'resistanceALaMagie',
  Advantage.santeDeFer: 'santeDeFer',
  Advantage.sensAccru: 'sensAccru',
  Advantage.sensDeLOrientation: 'sensDeLOrientation',
  Advantage.sensEnAlerte: 'sensEnAlerte',
  Advantage.statutSocial: 'statutSocial',
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
    <String, dynamic>{
      'value': instance.value,
      'circles': instance.circles,
    };

CharacterTendencies _$CharacterTendenciesFromJson(Map<String, dynamic> json) =>
    CharacterTendencies(
      dragon:
          TendencyAttribute.fromJson(json['dragon'] as Map<String, dynamic>),
      human: TendencyAttribute.fromJson(json['human'] as Map<String, dynamic>),
      fatality:
          TendencyAttribute.fromJson(json['fatality'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CharacterTendenciesToJson(
        CharacterTendencies instance) =>
    <String, dynamic>{
      'dragon': instance.dragon,
      'human': instance.human,
      'fatality': instance.fatality,
    };

HumanCharacter _$HumanCharacterFromJson(Map<String, dynamic> json) =>
    HumanCharacter(
      json['uuid'] as String,
      name: json['name'] as String,
      initiative: (json['initiative'] as num?)?.toInt() ?? 1,
      caste:
          $enumDecodeNullable(_$CasteEnumMap, json['caste']) ?? Caste.sansCaste,
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
      origin: $enumDecodeNullable(_$OriginCountryEnumMap, json['origin']) ??
          OriginCountry.empireDeSolyr,
      interdicts: (json['interdicts'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$InterdictEnumMap, e))
              .toList() ??
          [],
      castePrivileges: (json['caste_privileges'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$CastePrivilegeEnumMap, e))
              .toList() ??
          [],
      disadvantages: (json['disadvantages'] as List<dynamic>?)
          ?.map(
              (e) => CharacterDisadvantage.fromJson(e as Map<String, dynamic>))
          .toList(),
      advantages: (json['advantages'] as List<dynamic>?)
          ?.map((e) => CharacterAdvantage.fromJson(e as Map<String, dynamic>))
          .toList(),
      tendencies: json['tendencies'] == null
          ? null
          : CharacterTendencies.fromJson(
              json['tendencies'] as Map<String, dynamic>),
    )
      ..magicSpells = (json['magic_spells'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$MagicSphereEnumMap, k),
            (e as List<dynamic>).map((e) => e as String).toList()),
      )
      ..magicPool = (json['magic_pool'] as num).toInt()
      ..description = json['description'] as String
      ..size = (json['size'] as num).toDouble()
      ..skills = (json['skills'] as List<dynamic>)
          .map((e) => SkillInstance.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$HumanCharacterToJson(HumanCharacter instance) =>
    <String, dynamic>{
      'magic_spells': instance.magicSpells
          .map((k, e) => MapEntry(_$MagicSphereEnumMap[k]!, e)),
      'magic_pool': instance.magicPool,
      'equiped': equipedToJson(instance.equiped),
      'uuid': instance.uuid,
      'name': instance.name,
      'description': instance.description,
      'size': instance.size,
      'weight': instance.weight,
      'initiative': instance.initiative,
      'abilities': enumKeyedMapToJson(instance.abilities),
      'attributes': enumKeyedMapToJson(instance.attributes),
      'skills': instance.skills,
      'equipment': equipmentToJson(instance.equipment),
      'caste': _$CasteEnumMap[instance.caste]!,
      'caste_status': _$CasteStatusEnumMap[instance.casteStatus]!,
      'career': _$CareerEnumMap[instance.career],
      'age': instance.age,
      'height': instance.height,
      'origin': _$OriginCountryEnumMap[instance.origin]!,
      'luck': instance.luck,
      'proficiency': instance.proficiency,
      'renown': instance.renown,
      'interdicts':
          instance.interdicts.map((e) => _$InterdictEnumMap[e]!).toList(),
      'caste_privileges': instance.castePrivileges
          .map((e) => _$CastePrivilegeEnumMap[e]!)
          .toList(),
      'disadvantages': instance.disadvantages,
      'advantages': instance.advantages,
      'tendencies': instance.tendencies,
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

const _$OriginCountryEnumMap = {
  OriginCountry.archipelDePyr: 'archipelDePyr',
  OriginCountry.citeDeGriff: 'citeDeGriff',
  OriginCountry.empireDeSolyr: 'empireDeSolyr',
  OriginCountry.empireNesora: 'empireNesora',
  OriginCountry.empireZul: 'empireZul',
  OriginCountry.foretDeSolor: 'foretDeSolor',
  OriginCountry.foretMere: 'foretMere',
  OriginCountry.jaspor: 'jaspor',
  OriginCountry.kali: 'kali',
  OriginCountry.kar: 'kar',
  OriginCountry.kern: 'kern',
  OriginCountry.lacsSanglants: 'lacsSanglants',
  OriginCountry.marchesAlyzees: 'marchesAlyzees',
  OriginCountry.pomyrie: 'pomyrie',
  OriginCountry.principauteDeMarne: 'principauteDeMarne',
  OriginCountry.royaumeDesFleurs: 'royaumeDesFleurs',
  OriginCountry.terresGalyrs: 'terresGalyrs',
  OriginCountry.ysmir: 'ysmir',
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

const _$CastePrivilegeEnumMap = {
  CastePrivilege.apprenti: 'apprenti',
  CastePrivilege.autorisation: 'autorisation',
  CastePrivilege.charteDAtelier: 'charteDAtelier',
  CastePrivilege.familier: 'familier',
  CastePrivilege.notable: 'notable',
  CastePrivilege.outils: 'outils',
  CastePrivilege.psychometrie: 'psychometrie',
  CastePrivilege.reparationDeRoutine: 'reparationDeRoutine',
  CastePrivilege.expertiseArtisan: 'expertiseArtisan',
  CastePrivilege.faveurPolitiqueArtisan: 'faveurPolitiqueArtisan',
  CastePrivilege.tuteurArtisan: 'tuteurArtisan',
  CastePrivilege.adaptation: 'adaptation',
  CastePrivilege.argotCombattant: 'argotCombattant',
  CastePrivilege.botteSecrete: 'botteSecrete',
  CastePrivilege.doubleAttaque: 'doubleAttaque',
  CastePrivilege.engagement: 'engagement',
  CastePrivilege.feinte: 'feinte',
  CastePrivilege.riposte: 'riposte',
  CastePrivilege.vigilance: 'vigilance',
  CastePrivilege.alliesMercenairesCombattant: 'alliesMercenairesCombattant',
  CastePrivilege.compagnonsDeBatailleCombattant:
      'compagnonsDeBatailleCombattant',
  CastePrivilege.maitriseDArmureCombattant: 'maitriseDArmureCombattant',
  CastePrivilege.bonneFortune: 'bonneFortune',
  CastePrivilege.expertise: 'expertise',
  CastePrivilege.faveurPolitique: 'faveurPolitique',
  CastePrivilege.fournisseurDePoisons: 'fournisseurDePoisons',
  CastePrivilege.notorieteCommercant: 'notorieteCommercant',
  CastePrivilege.psychologie: 'psychologie',
  CastePrivilege.reflexesDeFuite: 'reflexesDeFuite',
  CastePrivilege.ressources: 'ressources',
  CastePrivilege.connaissanceDuMondeCommercant: 'connaissanceDuMondeCommercant',
  CastePrivilege.messagerCommercant: 'messagerCommercant',
  CastePrivilege.relationsDAffairesCommercant: 'relationsDAffairesCommercant',
  CastePrivilege.ambassade: 'ambassade',
  CastePrivilege.aplomb: 'aplomb',
  CastePrivilege.avalDraconique: 'avalDraconique',
  CastePrivilege.calligraphieOfficielle: 'calligraphieOfficielle',
  CastePrivilege.linguistique: 'linguistique',
  CastePrivilege.memoire: 'memoire',
  CastePrivilege.notorieteErudit: 'notorieteErudit',
  CastePrivilege.faveurPolitiqueErudit: 'faveurPolitiqueErudit',
  CastePrivilege.messagerErudit: 'messagerErudit',
  CastePrivilege.psychologieErudit: 'psychologieErudit',
  CastePrivilege.anonymat: 'anonymat',
  CastePrivilege.laboratoire: 'laboratoire',
  CastePrivilege.leurre: 'leurre',
  CastePrivilege.messager: 'messager',
  CastePrivilege.prevoyance: 'prevoyance',
  CastePrivilege.sortilegeFetiche: 'sortilegeFetiche',
  CastePrivilege.style: 'style',
  CastePrivilege.tuteur: 'tuteur',
  CastePrivilege.apprentiMage: 'apprentiMage',
  CastePrivilege.engagementMage: 'engagementMage',
  CastePrivilege.memoireMage: 'memoireMage',
  CastePrivilege.donDeBrorne: 'donDeBrorne',
  CastePrivilege.donDeHeyra: 'donDeHeyra',
  CastePrivilege.donDeKalimsshar: 'donDeKalimsshar',
  CastePrivilege.donDeKezyr: 'donDeKezyr',
  CastePrivilege.donDeKhy: 'donDeKhy',
  CastePrivilege.donDeKroryn: 'donDeKroryn',
  CastePrivilege.donDeNenya: 'donDeNenya',
  CastePrivilege.donDOzyr: 'donDOzyr',
  CastePrivilege.donDeSzyl: 'donDeSzyl',
  CastePrivilege.aplombProdige: 'aplombProdige',
  CastePrivilege.engagementProdige: 'engagementProdige',
  CastePrivilege.reflexesDeDegagement: 'reflexesDeDegagement',
  CastePrivilege.adopte: 'adopte',
  CastePrivilege.autorite: 'autorite',
  CastePrivilege.cuirasse: 'cuirasse',
  CastePrivilege.defense: 'defense',
  CastePrivilege.influences: 'influences',
  CastePrivilege.porteParole: 'porteParole',
  CastePrivilege.requisition: 'requisition',
  CastePrivilege.signesDeBatailleProtecteur: 'signesDeBatailleProtecteur',
  CastePrivilege.engagementProtecteur: 'engagementProtecteur',
  CastePrivilege.notorieteProtecteur: 'notorieteProtecteur',
  CastePrivilege.archer: 'archer',
  CastePrivilege.compagnons: 'compagnons',
  CastePrivilege.connaissanceDuMonde: 'connaissanceDuMonde',
  CastePrivilege.filsDeLaTerre: 'filsDeLaTerre',
  CastePrivilege.logistique: 'logistique',
  CastePrivilege.maitriseDArmure: 'maitriseDArmure',
  CastePrivilege.rancune: 'rancune',
  CastePrivilege.solitaire: 'solitaire',
  CastePrivilege.ambassadeVoyageur: 'ambassadeVoyageur',
  CastePrivilege.familierVoyageur: 'familierVoyageur',
  CastePrivilege.linguistiqueVoyageur: 'linguistiqueVoyageur',
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
