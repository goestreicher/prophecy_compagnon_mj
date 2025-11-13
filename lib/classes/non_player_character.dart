import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'caste/character_caste.dart';
import 'draconic_favor.dart';
import 'entity/injury.dart';
import 'character/tendencies.dart';
import 'entity/abilities.dart';
import 'entity/attributes.dart';
import 'entity/magic.dart';
import 'entity/skills.dart';
import 'entity/status.dart';
import 'draconic_link.dart';
import 'encounter_entity_factory.dart';
import 'entity_base.dart';
import 'entity_instance.dart';
import 'equipment.dart';
import 'exportable_binary_data.dart';
import 'human_character.dart';
import 'npc_category.dart';
import 'object_location.dart';
import 'object_source.dart';
import '../text_utils.dart';
import 'resource_base_class.dart';
import 'resource_memory_cache.dart';
import 'storage/default_assets_store.dart';
import 'storage/storable.dart';

part 'non_player_character.g.dart';

class NonPlayerCharacterSummaryStore extends JsonStoreAdapter<NonPlayerCharacterSummary> {
  NonPlayerCharacterSummaryStore();

  @override
  String storeCategory() => 'npcSummaries';

  @override
  String key(NonPlayerCharacterSummary object) => object.id;

  @override
  Future<NonPlayerCharacterSummary> fromJsonRepresentation(Map<String, dynamic> j) async {
    if(j.containsKey('icon') && j['icon'] is String) await restoreJsonBinaryData(j, 'icon');
    var summary = NonPlayerCharacterSummary.fromJson(j);
    summary.location = ObjectLocation(
      type: ObjectLocationType.store,
      collectionUri: getCollectionUri(),
    );
    return summary;
  }

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(NonPlayerCharacterSummary object) async {
    var j = object.toJson();
    if(object.icon != null) j['icon'] = object.icon!.hash;
    return j;
  }

  @override
  Future<void> willSave(NonPlayerCharacterSummary object) async {
    if(object.icon != null) await BinaryDataStore().save(object.icon!);

    // Force-set the location here in case the object is used after being saved,
    // even if the location is not saved in the store (excluded from the
    // JSON representation).
    object.location = ObjectLocation(
      type: ObjectLocationType.store,
      collectionUri: getCollectionUri(),
    );
  }

  @override
  Future<void> willDelete(NonPlayerCharacterSummary object) async {
    if(object.icon != null) await BinaryDataStore().delete(object.icon!);
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
@NPCCategoryJsonConverter()
@NPCSubcategoryJsonConverter()
class NonPlayerCharacterSummary extends ResourceBaseClass {
  factory NonPlayerCharacterSummary({
    required String id,
    required String name,
    required NPCCategory category,
    required NPCSubCategory subCategory,
    ObjectLocation location = ObjectLocation.memory,
    required ObjectSource source,
    ExportableBinaryData? icon,
  })
  {
    var summ = _cache.entry(id)
        ?? NonPlayerCharacterSummary._create(
          id: id,
          name: name,
          category: category,
          subCategory: subCategory,
          location: location,
          source: source,
          icon: icon,
        );
    _cache.add(id, summ);
    return summ;
  }

  NonPlayerCharacterSummary._create({
    required this.id,
    required super.name,
    required super.source,
    super.location,
    required this.category,
    required this.subCategory,
    this.icon,
  });

  @override
  final String id;
  final NPCCategory category;
  final NPCSubCategory subCategory;
  final ExportableBinaryData? icon;

  static Future<Iterable<String>> ids() async {
    await loadAll();
    return _cache.keys;
  }

  static Future<bool> exists(String id) async {
    await loadAll();
    return _cache.contains(id);
  }

  static Future<NonPlayerCharacterSummary?> get(String id) async {
    await loadAll();
    return _cache.entry(id);
  }

  static Future<Iterable<NonPlayerCharacterSummary>> getAll(
    {String? nameFilter}
  ) async {
    await loadAll();
    return _cache.values
        .where(
            (NonPlayerCharacterSummary s) =>
                nameFilter == null
                || s.name.toLowerCase().contains(nameFilter.toLowerCase())
        );
  }

  static Future<Iterable<NonPlayerCharacterSummary>> forLocationType(
    ObjectLocationType type,
    NPCCategory? category,
    NPCSubCategory? subCategory,
    {String? nameFilter}
  ) async {
    await loadAll();
    return _cache.values
        .where(
            (NonPlayerCharacterSummary s) =>
                s.location.type == type
                && (
                    category == null
                    || _matchesCategory(s, category, subCategory)
                )
        )
        .where(
            (NonPlayerCharacterSummary s) =>
                nameFilter == null
                || s.name.toLowerCase().contains(nameFilter.toLowerCase())
        );
  }

  static Future<Iterable<NonPlayerCharacterSummary>> forCategory(
    NPCCategory category,
    NPCSubCategory? subCategory,
    {String? nameFilter}
  ) async {
    await loadAll();
    return _cache.values
        .where(
            (NonPlayerCharacterSummary s) =>
                _matchesCategory(s, category, subCategory)
        )
        .where(
            (NonPlayerCharacterSummary s) =>
                nameFilter == null
                || s.name.toLowerCase().contains(nameFilter.toLowerCase())
        );
  }

  static Future<Iterable<NonPlayerCharacterSummary>> forSourceType(
    ObjectSourceType type,
    NPCCategory? category,
    NPCSubCategory? subCategory,
    {String? nameFilter}
  ) async {
    await loadAll();
    return _cache.values
        .where(
            (NonPlayerCharacterSummary s) =>
                s.source.type == type
                && (
                    category == null
                    || _matchesCategory(s, category, subCategory)
                )
        )
        .where(
            (NonPlayerCharacterSummary s) =>
                nameFilter == null
                || s.name.toLowerCase().contains(nameFilter.toLowerCase())
        );
  }

  static Future<Iterable<NonPlayerCharacterSummary>> forSource(
    ObjectSource source,
    NPCCategory? category,
    NPCSubCategory? subCategory,
    {String? nameFilter}
  ) async {
    await loadAll();
    return _cache.values
        .where(
            (NonPlayerCharacterSummary s) =>
                s.source == source
                && (
                    category == null
                    || _matchesCategory(s, category, subCategory)
                )
        )
        .where(
            (NonPlayerCharacterSummary s) =>
                nameFilter == null
                || s.name.toLowerCase().contains(nameFilter.toLowerCase())
        );
  }

  static bool _matchesCategory(
    NonPlayerCharacterSummary summary,
    NPCCategory category,
    NPCSubCategory? subCategory
  ) {
    return
        summary.category == category
        && (
            subCategory == null
            || summary.subCategory == subCategory
        );
  }

  static Future<void> init() async {
    // ignore:unused_local_variable
    var c = _cache;
  }

  static Future<void> loadAll() async {
    var assetFiles = [
      'npcs-ldb2e.json',
      'npcs-les-compagnons-de-khy.json',
      'npcs-les-ecailles-de-brorne.json',
      'npcs-les-enfants-de-heyra.json',
      'npcs-les-forges-de-kezyr.json',
      'npcs-les-foudres-de-kroryn.json',
      'npcs-les-orphelins-de-szyl.json',
      'npcs-les-versets-d-ozyr.json',
      'npcs-les-voiles-de-nenya.json',
      'npcs-les-grands-dragons.json',
    ];

    for (var f in assetFiles) {
      if(!_cache.containsCollection(f)) {
        _cache.addCollection(f);

        for (var model in await loadJSONAssetObjectList(f)) {
          try {
            // ignore:unused_local_variable
            var instance = NonPlayerCharacterSummary.fromJson(model);
          } catch (e, stacktrace) {
            print('Error loading NPC ${model["name"]}: ${e.toString()}\n${stacktrace.toString()}');
          }
        }
      }
    }

    if(!_cache.containsCollection(NonPlayerCharacterSummaryStore().getCollectionUri())) {
      _cache.addCollection(NonPlayerCharacterSummaryStore().getCollectionUri());
      await NonPlayerCharacterSummaryStore().getAll();
    }
  }

  static Future<void> _reloadFromStore(String id) async {
    _removeFromCache(id);
    var summary = await NonPlayerCharacterSummaryStore().get(id);
    if(summary != null) {
      _cache.add(id, summary);
    }
  }

  static void _removeFromCache(String id) =>
      _cache.del(id);

  static Future<void> _saveLocalModel(NonPlayerCharacterSummary summary) async {
    await NonPlayerCharacterSummaryStore().save(summary);
    _cache.add(summary.id, summary);
  }

  static Future<void> _deleteLocalModel(String id) async {
    var summary = await NonPlayerCharacterSummaryStore().get(id);
    if(summary != null) {
      await NonPlayerCharacterSummaryStore().delete(summary);
    }
    _cache.del(id);
  }

  static final _cache = ResourceMemoryCache<NonPlayerCharacterSummary>();

  factory NonPlayerCharacterSummary.fromJson(Map<String, dynamic> j){
    if(!j.containsKey('id')) {
      if (j.containsKey('uuid')) {
        j['id'] = j['uuid'];
      }
      else {
        j['id'] = NonPlayerCharacter._getId(j['name']);
      }
    }
    return _$NonPlayerCharacterSummaryFromJson(j);
  }

  Map<String, dynamic> toJson() =>
      _$NonPlayerCharacterSummaryToJson(this);
}

class NonPlayerCharacterStore extends JsonStoreAdapter<NonPlayerCharacter> {
  NonPlayerCharacterStore();

  @override
  String storeCategory() => 'npcs';

  @override
  String key(NonPlayerCharacter object) => object.id;

  @override
  Future<NonPlayerCharacter> fromJsonRepresentation(Map<String, dynamic> j) async {
    if(j.containsKey('image') && j['image'] is String) await restoreJsonBinaryData(j, 'image');
    if(j.containsKey('icon') && j['icon'] is String) await restoreJsonBinaryData(j, 'icon');
    var npc = NonPlayerCharacter.fromJson(j);
    npc.location = ObjectLocation(
      type: ObjectLocationType.store,
      collectionUri: getCollectionUri(),
    );
    return npc;
  }

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(NonPlayerCharacter object) async {
    var j = object.toJson();
    if(object.image != null) j['image'] = object.image!.hash;
    if(object.icon != null) j['icon'] = object.icon!.hash;
    return j;
  }

  @override
  Future<void> willSave(NonPlayerCharacter object) async {
    if(object.image != null) await BinaryDataStore().save(object.image!);
    if(object.icon != null) await BinaryDataStore().save(object.icon!);

    // Force-set the location here in case the object is used after being saved,
    // even if the location is not saved in the store (excluded from the
    // JSON representation).
    object.location = ObjectLocation(
      type: ObjectLocationType.store,
      collectionUri: getCollectionUri(),
    );
  }

  @override
  Future<void> willDelete(NonPlayerCharacter object) async {
    if(object.icon != null) await BinaryDataStore().delete(object.icon!);
    if(object.image != null) await BinaryDataStore().delete(object.image!);
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
@NPCCategoryJsonConverter()
@NPCSubcategoryJsonConverter()
class NonPlayerCharacter extends HumanCharacter with EncounterEntityModel {
  factory NonPlayerCharacter({
    String? uuid,
    ObjectLocation location = ObjectLocation.memory,
    required ObjectSource source,
    required String name,
    required NPCCategory category,
    required NPCSubCategory subCategory,
    bool unique = false,
    EntityAbilities? abilities,
    EntityAttributes? attributes,
    bool useHumanInjuryManager = false,
    EntityInjuries? injuries,
    InjuryProvider injuryProvider = humanCharacterDefaultInjuries,
    int initiative = 1,
    EntitySkills? skills,
    EntityStatus? status,
    EntityEquipment? equipment,
    EntityMagic? magic,
    int age = 25,
    double height = 1.7,
    double? size,
    double weight = 60.0,
    int luck = 0,
    int proficiency = 0,
    int renown = 0,
    CharacterOrigin? origin,
    CharacterCaste? caste,
    CharacterDisadvantages? disadvantages,
    CharacterAdvantages? advantages,
    CharacterTendencies? tendencies,
    String? description,
    EntityDraconicFavors? favors,
    ExportableBinaryData? image,
    ExportableBinaryData? icon,
  }) {
    bool isDefault = (location.type == ObjectLocationType.assets);
    String id = uuid ?? (isDefault ? _getId(name) : Uuid().v4().toString());
    var npc = _cache.entry(id)
        ?? NonPlayerCharacter._create(
            uuid: uuid,
            location: location,
            source: source,
            name: name,
            category: category,
            subCategory: subCategory,
            unique: unique,
            abilities: abilities,
            attributes: attributes,
            useHumanInjuryManager: useHumanInjuryManager,
            injuries: injuries,
            injuryProvider: injuryProvider,
            initiative: initiative,
            skills: skills,
            status: status,
            equipment: equipment,
            magic: magic,
            caste: caste,
            age: age,
            height: height,
            size: size,
            weight: weight,
            luck: luck,
            proficiency: proficiency,
            renown: renown,
            origin: origin,
            disadvantages: disadvantages,
            advantages: advantages,
            tendencies: tendencies,
            description: description,
            favors: favors,
            image: image,
            icon: icon,
          );
    _cache.add(id, npc);
    // Force insertion in CreatureSummary cache
    // ignore:unused_local_variable
    var s = npc.summary;
    return npc;
  }

  NonPlayerCharacter._create({
    super.uuid,
    required super.name,
    required super.source,
    super.location = ObjectLocation.memory,
    required this.category,
    required this.subCategory,
    bool unique = false,
    super.abilities,
    super.attributes,
    bool useHumanInjuryManager = false,
    super.injuries,
    super.injuryProvider,
    super.initiative,
    super.skills,
    super.status,
    super.equipment,
    super.magic,
    super.caste,
    super.age,
    super.height,
    super.size,
    super.weight,
    super.luck,
    super.proficiency,
    super.renown,
    super.origin,
    super.disadvantages,
    super.advantages,
    super.tendencies,
    super.description,
    super.favors,
    super.image,
    super.icon,
  })
    : uniqueNotifier = ValueNotifier<bool>(unique),
      useHumanInjuryManagerNotifier = ValueNotifier<bool>(useHumanInjuryManager)
  {
    if(!subCategory.categories.contains(category)) {
      throw ArgumentError('La sous-catégorie "${subCategory.title}" ne peut pas être utilisée avec la catégorie "${category.title}"');
    }
  }

  NPCCategory category;
  NPCSubCategory subCategory;

  bool get unique => uniqueNotifier.value;
  set unique(bool b) => uniqueNotifier.value = b;
  @JsonKey(includeFromJson: false, includeToJson: false)
  ValueNotifier<bool> uniqueNotifier;

  bool get useHumanInjuryManager => useHumanInjuryManagerNotifier.value;
  set useHumanInjuryManager(bool b) => useHumanInjuryManagerNotifier.value = b;
  @JsonKey(includeFromJson: false, includeToJson: false)
  ValueNotifier<bool> useHumanInjuryManagerNotifier;

  NonPlayerCharacterSummary get summary => NonPlayerCharacterSummary(
      id: id,
      name: name,
      category: category,
      subCategory: subCategory,
      source: source,
      icon: icon?.clone(),
      location: location,
    );

  @override
  String displayName() => name;

  @override
  bool isUnique() => unique;

  @override
  List<EntityBase> instantiate({ int count = 1 }) {
    var ret = <EntityBase>[];

    var modelSpecification = 'npc:$id';

    for(var idx=0; idx<count; ++idx) {
      var instance = EntityInstance.prepareInstantiation(
        entity: this,
        name: '$name #${idx+1}',
        modelSpecification: modelSpecification,
      );

      ret.add(instance);
    }

    return ret;
  }

  NonPlayerCharacter clone(String newName, { ObjectSource? source }) {
    var j = toJson();
    j.remove('uuid');
    j['location'] = ObjectLocation.memory.toJson();
    j['source'] = source?.toJson() ?? ObjectSource.local.toJson();
    j['name'] = newName;
    return NonPlayerCharacter.fromJson(j);
  }

  static Future<NonPlayerCharacter?> get(String id) async {
    NonPlayerCharacter? ret = _cache.entry(id);
    if(ret != null) return ret;

    NonPlayerCharacterSummary? summ = await NonPlayerCharacterSummary.get(id);
    if(summ == null) return null;

    if(summ.location.type == ObjectLocationType.assets) {
      ret = await loadFromAssets(summ.location.collectionUri, id);
    }
    else if(summ.location.type == ObjectLocationType.store) {
      ret = await NonPlayerCharacterStore().get(id);
    }

    return ret;
  }

  static Future<NonPlayerCharacter?> loadFromAssets(String file, String id) async {
    for(var a in await loadJSONAssetObjectList(file)) {
      bool match = false;
      var m = a as Map<String, dynamic>;

      if(m.containsKey('uuid') && m['uuid'] == id) {
        match = true;
      }
      else {
        match = (id == _getId(m['name']));
      }

      if(match) return NonPlayerCharacter.fromJson(m);
    }
    return null;
  }

  static Future<void> reloadFromStore(String id) async {
    _cache.del(id);
    await NonPlayerCharacterSummary._reloadFromStore(id);
  }

  static void removeFromCache(String id) {
    _cache.del(id);
    NonPlayerCharacterSummary._removeFromCache(id);
  }

  static Future<void> saveLocalModel(NonPlayerCharacter npc) async {
    await NonPlayerCharacterStore().save(npc);
    await NonPlayerCharacterSummary._saveLocalModel(npc.summary);
    _cache.add(npc.id, npc);
  }

  static Future<void> deleteLocalModel(String id) async {
    var npc = await NonPlayerCharacterStore().get(id);
    if(npc != null) {
      await NonPlayerCharacterStore().delete(npc);
      await NonPlayerCharacterSummary._deleteLocalModel(id);
    }
    _cache.del(id);
  }

  static String _getId(String name) =>
      sentenceToCamelCase(transliterateFrenchToAscii(name));

  static Future<EncounterEntityModel?> _modelFactory(String id) async {
    return get(id);
  }

  static Future<Iterable<EntityBase>> _npcFactory(String id, int count) async {
    var m = await get(id);
    if(m == null) return <EntityBase>[];
    return m.instantiate(count: count);
  }

  static Future<void> init() async {
    // ignore:unused_local_variable
    var c = _cache;

    EntityInstanceModelRetriever.instance.registerRetriever(
      'npc',
      NonPlayerCharacter.get,
    );

    EncounterEntityFactory.instance.registerFactory(
        'npc',
        _modelFactory,
        _npcFactory
    );

    await NonPlayerCharacterSummary.init();
  }

  static void preImportFilter(Map<String, dynamic> json) {
    json.remove('uuid');
    json.remove('source');

    if(json.containsKey('unique') && !json['unique'] && json.containsKey('equipment') && json['equipment'] is List) {
      for(Map<String, dynamic> e in json['equipment']) {
        e.remove('uuid');
      }
    }
  }

  static Future<NonPlayerCharacter> import(Map<String, dynamic> json) async {
    preImportFilter(json);
    json['source'] = ObjectSource.local.toJson();

    /*
        Trying to find if this NPC shadows a default one
     */
    var defaultId = sentenceToCamelCase(transliterateFrenchToAscii(json['name']));
    if(await NonPlayerCharacterSummary.exists(defaultId)) {
      throw(NonPlayerCharacterExistsException(id: defaultId));
    }

    var model = NonPlayerCharacter.fromJson(json);
    await NonPlayerCharacter.saveLocalModel(model);
    return model;
  }

  static final _cache = ResourceMemoryCache<NonPlayerCharacter>();

  factory NonPlayerCharacter.fromJson(Map<String, dynamic> json) {
    NonPlayerCharacter npc = _$NonPlayerCharacterFromJson(json);
    npc.loadNonRestorableJson(json);
    return npc;
  }

  @override
  Map<String, dynamic> toJson() {
    var j = _$NonPlayerCharacterToJson(this);

    saveNonExportableJson(j);

    if((!j.containsKey('unique') || !j['unique']) && j.containsKey('equipment') && j['equipment'] is List) {
      for(var e in j['equipment']) {
        (e as Map<String, dynamic>).remove('uuid');
      }
    }

    return j;
  }
}

class NonPlayerCharacterExistsException implements Exception {
  const NonPlayerCharacterExistsException({ required this.id });

  final String id;

  @override
  String toString() {
    return 'Un PNJ avec ce nom (ou un nom similaire existe déjà), ID: $id';
  }
}