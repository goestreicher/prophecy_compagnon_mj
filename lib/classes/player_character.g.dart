// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerCharacterSummary _$PlayerCharacterSummaryFromJson(
  Map<String, dynamic> json,
) => PlayerCharacterSummary(
  id: json['id'] as String,
  name: json['name'] as String,
  player: json['player'] as String,
  caste: $enumDecode(_$CasteEnumMap, json['caste']),
  casteStatus: $enumDecode(_$CasteStatusEnumMap, json['caste_status']),
  icon: json['icon'] == null
      ? null
      : ExportableBinaryData.fromJson(json['icon'] as Map<String, dynamic>),
  location: json['location'] == null
      ? ObjectLocation.memory
      : ObjectLocation.fromJson(json['location'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PlayerCharacterSummaryToJson(
  PlayerCharacterSummary instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'player': instance.player,
  'caste': _$CasteEnumMap[instance.caste]!,
  'caste_status': _$CasteStatusEnumMap[instance.casteStatus]!,
  'icon': instance.icon?.toJson(),
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

PlayerCharacter _$PlayerCharacterFromJson(Map<String, dynamic> json) =>
    PlayerCharacter(
        uuid: json['uuid'] as String?,
        location: json['location'] == null
            ? ObjectLocation.memory
            : ObjectLocation.fromJson(json['location'] as Map<String, dynamic>),
        player: json['player'] as String,
        augure: $enumDecode(_$AugureEnumMap, json['augure']),
        name: json['name'] as String,
        caste:
            $enumDecodeNullable(_$CasteEnumMap, json['caste']) ??
            Caste.sansCaste,
        casteStatus:
            $enumDecodeNullable(_$CasteStatusEnumMap, json['caste_status']) ??
            CasteStatus.none,
        initiative: (json['initiative'] as num?)?.toInt() ?? 1,
        luck: (json['luck'] as num?)?.toInt() ?? 0,
        proficiency: (json['proficiency'] as num?)?.toInt() ?? 0,
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
      )
      ..description = json['description'] as String
      ..status = json['status'] == null
          ? EntityStatus.empty()
          : EntityStatus.fromJson(json['status'] as Map<String, dynamic>)
      ..size = (json['size'] as num).toDouble()
      ..weight = (json['weight'] as num).toDouble()
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
      ..extraMagicPool = (json['extra_magic_pool'] as num?)?.toInt() ?? 0
      ..career = $enumDecodeNullable(_$CareerEnumMap, json['career'])
      ..age = (json['age'] as num).toInt()
      ..height = (json['height'] as num).toDouble()
      ..origin = Place.fromJson(json['origin'] as Map<String, dynamic>)
      ..renown = (json['renown'] as num).toInt()
      ..interdicts =
          (json['interdicts'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$InterdictEnumMap, e))
              .toList() ??
          []
      ..castePrivileges =
          (json['caste_privileges'] as List<dynamic>?)
              ?.map(
                (e) =>
                    CharacterCastePrivilege.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          []
      ..disadvantages = (json['disadvantages'] as List<dynamic>)
          .map((e) => CharacterDisadvantage.fromJson(e as Map<String, dynamic>))
          .toList()
      ..advantages = (json['advantages'] as List<dynamic>)
          .map((e) => CharacterAdvantage.fromJson(e as Map<String, dynamic>))
          .toList()
      ..tendencies = CharacterTendencies.fromJson(
        json['tendencies'] as Map<String, dynamic>,
      );

Map<String, dynamic> _$PlayerCharacterToJson(
  PlayerCharacter instance,
) => <String, dynamic>{
  'equiped': equipedToJson(instance.equiped),
  'uuid': ?instance.uuid,
  'name': instance.name,
  'description': instance.description,
  'image': instance.image?.toJson(),
  'icon': instance.icon?.toJson(),
  'status': instance.status.toJson(),
  'size': instance.size,
  'weight': instance.weight,
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
  'origin': instance.origin.toJson(),
  'luck': instance.luck,
  'proficiency': instance.proficiency,
  'renown': instance.renown,
  'interdicts': instance.interdicts.map((e) => _$InterdictEnumMap[e]!).toList(),
  'caste_privileges': instance.castePrivileges.map((e) => e.toJson()).toList(),
  'disadvantages': instance.disadvantages.map((e) => e.toJson()).toList(),
  'advantages': instance.advantages.map((e) => e.toJson()).toList(),
  'tendencies': instance.tendencies.toJson(),
  'player': instance.player,
  'augure': _$AugureEnumMap[instance.augure]!,
};

const _$AugureEnumMap = {
  Augure.pierre: 'pierre',
  Augure.fataliste: 'fataliste',
  Augure.chimere: 'chimere',
  Augure.nature: 'nature',
  Augure.ocean: 'ocean',
  Augure.metal: 'metal',
  Augure.volcan: 'volcan',
  Augure.vent: 'vent',
  Augure.homme: 'homme',
  Augure.cite: 'cite',
  Augure.none: 'none',
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
