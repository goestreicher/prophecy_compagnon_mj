// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'non_player_character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NPCSubCategory _$NPCSubCategoryFromJson(Map<String, dynamic> json) =>
    NPCSubCategory(
      title: json['title'] as String,
      categories: (json['categories'] as List<dynamic>)
          .map((e) => const NPCCategoryJsonConverter().fromJson(e as String))
          .toList(),
      isDefault: json['is_default'] as bool? ?? false,
    );

Map<String, dynamic> _$NPCSubCategoryToJson(NPCSubCategory instance) =>
    <String, dynamic>{
      'title': instance.title,
      'categories': instance.categories
          .map(const NPCCategoryJsonConverter().toJson)
          .toList(),
    };

NonPlayerCharacterSummary _$NonPlayerCharacterSummaryFromJson(
  Map<String, dynamic> json,
) => NonPlayerCharacterSummary(
  id: json['id'] as String,
  name: json['name'] as String,
  category: const NPCCategoryJsonConverter().fromJson(
    json['category'] as String,
  ),
  subCategory: const NPCSubcategoryJsonConverter().fromJson(
    json['sub_category'] as Map<String, dynamic>,
  ),
  location: json['location'] == null
      ? ObjectLocation.memory
      : ObjectLocation.fromJson(json['location'] as Map<String, dynamic>),
  source: ObjectSource.fromJson(json['source'] as Map<String, dynamic>),
  icon: json['icon'] == null
      ? null
      : ExportableBinaryData.fromJson(json['icon'] as Map<String, dynamic>),
);

Map<String, dynamic> _$NonPlayerCharacterSummaryToJson(
  NonPlayerCharacterSummary instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'category': const NPCCategoryJsonConverter().toJson(instance.category),
  'sub_category': const NPCSubcategoryJsonConverter().toJson(
    instance.subCategory,
  ),
  'source': instance.source.toJson(),
  'icon': instance.icon?.toJson(),
};

NonPlayerCharacter _$NonPlayerCharacterFromJson(Map<String, dynamic> json) =>
    NonPlayerCharacter(
        uuid: json['uuid'] as String?,
        location: json['location'] == null
            ? ObjectLocation.memory
            : ObjectLocation.fromJson(json['location'] as Map<String, dynamic>),
        source: ObjectSource.fromJson(json['source'] as Map<String, dynamic>),
        name: json['name'] as String,
        category: const NPCCategoryJsonConverter().fromJson(
          json['category'] as String,
        ),
        subCategory: const NPCSubcategoryJsonConverter().fromJson(
          json['sub_category'] as Map<String, dynamic>,
        ),
        unique: json['unique'] as bool? ?? false,
        useHumanInjuryManager:
            json['use_human_injury_manager'] as bool? ?? false,
        initiative: (json['initiative'] as num?)?.toInt() ?? 1,
        caste:
            $enumDecodeNullable(_$CasteEnumMap, json['caste']) ??
            Caste.sansCaste,
        casteStatus:
            $enumDecodeNullable(_$CasteStatusEnumMap, json['caste_status']) ??
            CasteStatus.none,
        age: (json['age'] as num?)?.toInt() ?? 25,
        height: (json['height'] as num?)?.toDouble() ?? 1.7,
        size: (json['size'] as num?)?.toDouble(),
        weight: (json['weight'] as num?)?.toDouble() ?? 60.0,
        luck: (json['luck'] as num?)?.toInt() ?? 0,
        proficiency: (json['proficiency'] as num?)?.toInt() ?? 0,
        renown: (json['renown'] as num?)?.toInt() ?? 0,
        origin: json['origin'] == null
            ? null
            : Place.fromJson(json['origin'] as Map<String, dynamic>),
        interdicts:
            (json['interdicts'] as List<dynamic>?)
                ?.map((e) => $enumDecode(_$CasteInterdictEnumMap, e))
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
      ..extraMagicPool = (json['extra_magic_pool'] as num?)?.toInt() ?? 0
      ..career = $enumDecodeNullable(_$CareerEnumMap, json['career'])
      ..draconicLink = json['draconic_link'] == null
          ? null
          : DraconicLink.fromJson(
              json['draconic_link'] as Map<String, dynamic>,
            );

Map<String, dynamic> _$NonPlayerCharacterToJson(
  NonPlayerCharacter instance,
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
  'interdicts': instance.interdicts
      .map((e) => _$CasteInterdictEnumMap[e]!)
      .toList(),
  'caste_privileges': instance.castePrivileges.map((e) => e.toJson()).toList(),
  'disadvantages': instance.disadvantages.map((e) => e.toJson()).toList(),
  'advantages': instance.advantages.map((e) => e.toJson()).toList(),
  'tendencies': instance.tendencies.toJson(),
  'draconic_link': instance.draconicLink?.toJson(),
  'category': const NPCCategoryJsonConverter().toJson(instance.category),
  'sub_category': const NPCSubcategoryJsonConverter().toJson(
    instance.subCategory,
  ),
  'source': instance.source.toJson(),
  'unique': instance.unique,
  'use_human_injury_manager': instance.useHumanInjuryManager,
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

const _$CasteInterdictEnumMap = {
  CasteInterdict.loiDuCompagnon: 'loiDuCompagnon',
  CasteInterdict.loiDeLaPerfection: 'loiDeLaPerfection',
  CasteInterdict.loiDuRespect: 'loiDuRespect',
  CasteInterdict.loiDeLArme: 'loiDeLArme',
  CasteInterdict.loiDeLHonneur: 'loiDeLHonneur',
  CasteInterdict.loiDuSangCombattant: 'loiDuSangCombattant',
  CasteInterdict.loiDuCoeur: 'loiDuCoeur',
  CasteInterdict.loiDeLOrdre: 'loiDeLOrdre',
  CasteInterdict.loiDuProgres: 'loiDuProgres',
  CasteInterdict.loiDuSavoir: 'loiDuSavoir',
  CasteInterdict.loiDuCollege: 'loiDuCollege',
  CasteInterdict.loiDuSecret: 'loiDuSecret',
  CasteInterdict.loiDuPacte: 'loiDuPacte',
  CasteInterdict.loiDuPartage: 'loiDuPartage',
  CasteInterdict.loiDeLaPrudence: 'loiDeLaPrudence',
  CasteInterdict.loiDeLaMeditation: 'loiDeLaMeditation',
  CasteInterdict.loiDeLaNature: 'loiDeLaNature',
  CasteInterdict.loiDuSangProdige: 'loiDuSangProdige',
  CasteInterdict.loiDuLien: 'loiDuLien',
  CasteInterdict.loiDuSacrifice: 'loiDuSacrifice',
  CasteInterdict.loiDuSangProtecteur: 'loiDuSangProtecteur',
  CasteInterdict.loiDeLAmitie: 'loiDeLAmitie',
  CasteInterdict.loiDeLaDecouverte: 'loiDeLaDecouverte',
  CasteInterdict.loiDeLaLiberte: 'loiDeLaLiberte',
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
  Career.alchimiste: 'alchimiste',
  Career.architecte: 'architecte',
  Career.artisanElementaire: 'artisanElementaire',
  Career.forgeron: 'forgeron',
  Career.mecaniste: 'mecaniste',
  Career.mineur: 'mineur',
  Career.orfevre: 'orfevre',
  Career.tisserand: 'tisserand',
  Career.aventurier: 'aventurier',
  Career.chevalier: 'chevalier',
  Career.duelliste: 'duelliste',
  Career.gladiateur: 'gladiateur',
  Career.guerrier: 'guerrier',
  Career.lutteur: 'lutteur',
  Career.maitreDArmes: 'maitreDArmes',
  Career.mercenaire: 'mercenaire',
  Career.paladin: 'paladin',
  Career.strategeCombattant: 'strategeCombattant',
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
  Career.conteurs: 'conteurs',
  Career.erudits: 'erudits',
  Career.herboristes: 'herboristes',
  Career.historiens: 'historiens',
  Career.medecins: 'medecins',
  Career.navigateurs: 'navigateurs',
  Career.scientifiques: 'scientifiques',
  Career.conjurateur: 'conjurateur',
  Career.enchanteur: 'enchanteur',
  Career.fideleDeChimere: 'fideleDeChimere',
  Career.gardienMage: 'gardienMage',
  Career.generaliste: 'generaliste',
  Career.guerisseurMage: 'guerisseurMage',
  Career.invocateur: 'invocateur',
  Career.mageDeCombat: 'mageDeCombat',
  Career.questeurBlanc: 'questeurBlanc',
  Career.reveur: 'reveur',
  Career.specialisteDesRituels: 'specialisteDesRituels',
  Career.specialisteElementaire: 'specialisteElementaire',
  Career.gardienProdige: 'gardienProdige',
  Career.fervent: 'fervent',
  Career.guerisseurProdige: 'guerisseurProdige',
  Career.mediateur: 'mediateur',
  Career.missionnaire: 'missionnaire',
  Career.poeteDeLaNature: 'poeteDeLaNature',
  Career.prodigeAnimal: 'prodigeAnimal',
  Career.prophete: 'prophete',
  Career.sage: 'sage',
  Career.tuteur: 'tuteur',
  Career.gardeDuCorps: 'gardeDuCorps',
  Career.ingenieurMilitaire: 'ingenieurMilitaire',
  Career.inquisiteur: 'inquisiteur',
  Career.instructeur: 'instructeur',
  Career.legionnaire: 'legionnaire',
  Career.milicien: 'milicien',
  Career.protecteurItinerant: 'protecteurItinerant',
  Career.soldat: 'soldat',
  Career.strategeProtecteur: 'strategeProtecteur',
  Career.chasseurs: 'chasseurs',
  Career.eclaireurs: 'eclaireurs',
  Career.errants: 'errants',
  Career.explorateurs: 'explorateurs',
  Career.menestrels: 'menestrels',
  Career.messagers: 'messagers',
  Career.missionnaires: 'missionnaires',
};
