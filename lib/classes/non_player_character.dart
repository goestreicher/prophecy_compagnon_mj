import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'character/base.dart';
import 'character/skill.dart';
import 'encounter_entity_factory.dart';
import 'entity_base.dart';
import 'equipment.dart';
import 'exportable_binary_data.dart';
import 'human_character.dart';
import 'magic.dart';
import 'object_location.dart';
import 'object_source.dart';
import 'place.dart';
import '../text_utils.dart';
import 'storage/default_assets_store.dart';
import 'storage/storable.dart';

part 'non_player_character.g.dart';

class NPCCategoryJsonConverter extends JsonConverter<NPCCategory, String> {
  const NPCCategoryJsonConverter();

  @override
  NPCCategory fromJson(String json) {
    var index = NPCCategory.values.indexWhere((NPCCategory c) => c.name == json);
    if(index != -1) {
      return NPCCategory.values[index];
    }

    var name = sentenceToCamelCase(transliterateFrenchToAscii(json));
    index = NPCCategory.values.indexWhere((NPCCategory c) => c.name == name);
    if(index != -1) {
      return NPCCategory.values[index];
    }

    return NPCCategory(title: json);
  }

  @override
  String toJson(NPCCategory object) => object.isDefault ? object.name : object.title;
}

class NPCCategory {
  static NPCCategory generique = NPCCategory(title: 'Générique', isDefault: true);

  static NPCCategory createNewCategory = NPCCategory._create(title: "Créer cette catégorie", isDefault: true);

  static void _doStaticInit() {
    if(_staticInitDone) return;
    _staticInitDone = true;
    // ignore: unused_local_variable
    var gen = generique;
  }

  factory NPCCategory({required String title, bool isDefault = false}) {
    _doStaticInit();

    var name = sentenceToCamelCase(transliterateFrenchToAscii(title));
    if(!_categories.containsKey(name)) {
      var c = NPCCategory._create(title: title, isDefault: isDefault);
      _categories[c.name] = c;
      return c;
    }
    else {
      return _categories[name]!;
    }
  }

  NPCCategory._create({ required this.title, required this.isDefault });

  final String title;
  final bool isDefault;

  String get name => sentenceToCamelCase(transliterateFrenchToAscii(title));

  static List<NPCCategory> get values {
    _doStaticInit();
    return _categories.values.toList();
  }

  static NPCCategory byName(String name) {
    _doStaticInit();
    return _categories.values.firstWhere((NPCCategory c) => c.name == name);
  }

  @override
  int get hashCode => title.hashCode;

  @override
  bool operator ==(Object other) {
    if(other is! NPCCategory) return false;
    return title == other.title;
  }

  static final Map<String, NPCCategory> _categories = <String, NPCCategory>{};
  static bool _staticInitDone = false;
}

class NPCSubcategoryJsonConverter extends JsonConverter<NPCSubCategory, Map<String, dynamic>> {
  const NPCSubcategoryJsonConverter();

  @override
  NPCSubCategory fromJson(Map<String, dynamic> json) {
    if(json.containsKey('name')) {
      return NPCSubCategory.byName(json['name']);
    }
    else {
      var name = sentenceToCamelCase(transliterateFrenchToAscii(json['title']));
      var index = NPCSubCategory.values.indexWhere((NPCSubCategory s) => s.name == name);
      if(index != -1) {
        return NPCSubCategory.values[index];
      }
      else {
        return _$NPCSubCategoryFromJson(json);
      }
    }
  }

  @override
  Map<String, dynamic> toJson(NPCSubCategory object) {
    if(object.isDefault) {
      return <String, dynamic>{'name': object.name};
    }
    else {
      return object.toJson();
    }
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
@NPCCategoryJsonConverter()
class NPCSubCategory {
  static NPCSubCategory sansCaste = NPCSubCategory(
    title: 'Sans Caste',
    categories: [NPCCategory.generique],
    isDefault: true,
  );

  static NPCSubCategory createNewSubCategory = NPCSubCategory._create(
    title: 'Créer une sous-catégorie',
    categories: [],
    isDefault: true,
  );

  static void _doStaticInit() {
    if(_staticInitDone) return;
    _staticInitDone = true;
    // ignore: unused_local_variable
    var san = sansCaste;
    return;
  }

  factory NPCSubCategory({
    required String title,
    required List<NPCCategory> categories,
    bool isDefault = false,
  }) {
    _doStaticInit();

    var name = sentenceToCamelCase(transliterateFrenchToAscii(title));
    if(_subCategories.containsKey(name)) {
      return _subCategories[name]!;
    }
    else {
      var s = NPCSubCategory._create(title: title, categories: categories, isDefault: isDefault);
      _subCategories[s.name] = s;
      return s;
    }
  }

  NPCSubCategory._create({ required this.title, required this.categories, this.isDefault = false });

  static List<NPCSubCategory> subCategoriesForCategory(NPCCategory category) {
    _doStaticInit();
    return _subCategories.values
        .where((NPCSubCategory s) => s.categories.contains(category))
        .toList();
  }

  static List<NPCSubCategory> get values {
    _doStaticInit();
    return _subCategories.values.toList();
  }

  static NPCSubCategory byName(String name) {
    _doStaticInit();
    return _subCategories[name]!;
  }

  static NPCSubCategory? byTitle(String title) {
    _doStaticInit();
    String? key;
    _subCategories.forEach((k, v) {
      if (v.title == title) key = k;
    });
    return key == null ? null : _subCategories[key]!;
  }

  final String title;
  final List<NPCCategory> categories;
  @JsonKey(includeFromJson: false, includeToJson: false)
    final bool isDefault;

  String get name => sentenceToCamelCase(transliterateFrenchToAscii(title));

  @override
  int get hashCode => Object.hash(title, categories);

  @override
  bool operator ==(Object other) {
    if(other is! NPCSubCategory) return false;
    return title == other.title;
  }

  static final Map<String, NPCSubCategory> _subCategories = <String, NPCSubCategory>{};
  static bool _staticInitDone = false;

  factory NPCSubCategory.fromJson(Map<String, dynamic> j) => _$NPCSubCategoryFromJson(j);
  Map<String, dynamic> toJson() => _$NPCSubCategoryToJson(this);
}

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
      collectionUri: '${getUriBase()}/${storeCategory()}',
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
      collectionUri: '${getUriBase()}/${storeCategory()}',
    );
  }

  @override
  Future<void> willDelete(NonPlayerCharacterSummary object) async {
    if(object.icon != null) await BinaryDataStore().delete(object.icon!);
  }
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
      collectionUri: '${getUriBase()}/${storeCategory()}',
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
      collectionUri: '${getUriBase()}/${storeCategory()}',
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
class NonPlayerCharacterSummary {
  NonPlayerCharacterSummary({
    required this.id,
    required this.name,
    required this.category,
    required this.subCategory,
    this.location = ObjectLocation.memory,
    required this.source,
    this.icon,
  });

  final String id;
  final String name;
  final NPCCategory category;
  final NPCSubCategory subCategory;
  @JsonKey(includeFromJson: true, includeToJson: false)
    ObjectLocation location;
  final ObjectSource source;
  final ExportableBinaryData? icon;

  static bool exists(String id) => _summaries.containsKey(id);

  static List<NonPlayerCharacterSummary> getAll({String? nameFilter}) {
    return _summaries.values
        .where((NonPlayerCharacterSummary s) => nameFilter == null || s.name.toLowerCase().contains(nameFilter.toLowerCase()))
        .toList();
  }
  
  static List<NonPlayerCharacterSummary> forLocationType(ObjectLocationType type, NPCCategory? category, NPCSubCategory? subCategory, {String? nameFilter}) {
    return _summaries.values
        .where((NonPlayerCharacterSummary s) => s.location.type == type && (category == null || _matchesCategory(s, category, subCategory)))
        .where((NonPlayerCharacterSummary s) => nameFilter == null || s.name.toLowerCase().contains(nameFilter.toLowerCase()))
        .toList();
  }

  static List<NonPlayerCharacterSummary> forCategory(NPCCategory category, NPCSubCategory? subCategory, {String? nameFilter}) {
    return _summaries.values
        .where((NonPlayerCharacterSummary s) => _matchesCategory(s, category, subCategory))
        .where((NonPlayerCharacterSummary s) => nameFilter == null || s.name.toLowerCase().contains(nameFilter.toLowerCase()))
        .toList();
  }

  static List<NonPlayerCharacterSummary> forSourceType(ObjectSourceType type, NPCCategory? category, NPCSubCategory? subCategory, {String? nameFilter}) {
    return _summaries.values
        .where((NonPlayerCharacterSummary s) => s.source.type == type && (category == null || _matchesCategory(s, category, subCategory)))
        .where((NonPlayerCharacterSummary s) => nameFilter == null || s.name.toLowerCase().contains(nameFilter.toLowerCase()))
        .toList();
  }

  static List<NonPlayerCharacterSummary> forSource(ObjectSource source, NPCCategory? category, NPCSubCategory? subCategory, {String? nameFilter}) {
    return _summaries.values
        .where((NonPlayerCharacterSummary s) => s.source == source && (category == null || _matchesCategory(s, category, subCategory)))
        .where((NonPlayerCharacterSummary s) => nameFilter == null || s.name.toLowerCase().contains(nameFilter.toLowerCase()))
        .toList();
  }

  static bool _matchesCategory(NonPlayerCharacterSummary summary, NPCCategory category, NPCSubCategory? subCategory) {
    return summary.category == category
        && (subCategory == null || summary.subCategory == subCategory);
  }

  static Future<void> _reloadFromStore(String id) async {
    _removeFromCache(id);
    var summary = await NonPlayerCharacterSummaryStore().get(id);
    if(summary != null) {
      _summaries[id] = summary;
    }
  }

  static void _removeFromCache(String id) => _summaries.remove(id);

  static void _defaultAssetLoaded(NonPlayerCharacterSummary summary) {
    _summaries[summary.id] = summary;
  }

  static Future<void> _loadStoreAssets() async {
    for(var npc in await NonPlayerCharacterSummaryStore().getAll()) {
      _summaries[npc.id] = npc;
    }
  }

  static Future<void> _saveLocalModel(NonPlayerCharacterSummary summary) async {
    await NonPlayerCharacterSummaryStore().save(summary);
    _summaries[summary.id] = summary;
  }

  static Future<void> _deleteLocalModel(String id) async {
    var summary = await NonPlayerCharacterSummaryStore().get(id);
    if(summary != null) {
      await NonPlayerCharacterSummaryStore().delete(summary);
    }
    _summaries.remove(id);
  }

  static final Map<String, NonPlayerCharacterSummary> _summaries = <String, NonPlayerCharacterSummary>{};

  factory NonPlayerCharacterSummary.fromJson(Map<String, dynamic> j) => _$NonPlayerCharacterSummaryFromJson(j);
  Map<String, dynamic> toJson() => _$NonPlayerCharacterSummaryToJson(this);
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
    bool useHumanInjuryManager = false,
    int initiative = 1,
    Caste caste = Caste.sansCaste,
    CasteStatus casteStatus = CasteStatus.none,
    int age = 25,
    double height = 1.7,
    double? size,
    double weight = 60.0,
    int luck = 0,
    int proficiency = 0,
    int renown = 0,
    Place? origin,
    List<Interdict>? interdicts,
    List<CharacterCastePrivilege>? castePrivileges,
    List<CharacterDisadvantage>? disadvantages,
    List<CharacterAdvantage>? advantages,
    CharacterTendencies? tendencies,
    String? description,
    ExportableBinaryData? image,
    ExportableBinaryData? icon,
  }) {
    bool isDefault = (location.type == ObjectLocationType.assets);
    String id = uuid ?? (isDefault ? sentenceToCamelCase(transliterateFrenchToAscii(name)) : Uuid().v4().toString());
    if(!_models.containsKey(id)) {
      var npc = NonPlayerCharacter._create(
        uuid: uuid,
        location: location,
        source: source,
        name: name,
        category: category,
        subCategory: subCategory,
        unique: unique,
        useHumanInjuryManager: useHumanInjuryManager,
        initiative: initiative,
        caste: caste,
        casteStatus: casteStatus,
        age: age,
        height: height,
        size: size,
        weight: weight,
        luck: luck,
        proficiency: proficiency,
        renown: renown,
        origin: origin,
        interdicts: interdicts,
        castePrivileges: castePrivileges,
        disadvantages: disadvantages,
        advantages: advantages,
        tendencies: tendencies,
        description: description,
        image: image,
        icon: icon,
      );
      _models[id] = npc;
    }
    return _models[id]!;
  }

  NonPlayerCharacter._create(
    {
      super.uuid,
      super.location = ObjectLocation.memory,
      required super.name,
      required this.category,
      required this.subCategory,
      required this.source,
      this.unique = false,
      this.useHumanInjuryManager = false,
      super.initiative,
      super.caste,
      super.casteStatus,
      super.age,
      super.height,
      super.size,
      super.weight,
      super.luck,
      super.proficiency,
      super.renown,
      super.origin,
      super.interdicts,
      super.castePrivileges,
      super.disadvantages,
      super.advantages,
      super.tendencies,
      super.description,
      super.image,
      super.icon,
    }
  ) {
    if(!subCategory.categories.contains(category)) {
      throw ArgumentError('La sous-catégorie "${subCategory.title}" ne peut pas être utilisée avec la catégorie "${category.title}"');
    }
  }

  NPCCategory category;
  NPCSubCategory subCategory;
  ObjectSource source;
  bool unique;
  bool useHumanInjuryManager;

  NonPlayerCharacterSummary get summary => NonPlayerCharacterSummary(
      id: id,
      name: name,
      category: category,
      subCategory: subCategory,
      source: source,
      icon: icon?.clone(),
      location: location,
    );

  NonPlayerCharacter clone(String newName) {
    var j = toJson();
    j.remove('uuid');
    j['name'] = newName;
    var cloned = NonPlayerCharacter.fromJson(j);
    cloned.location = ObjectLocation.memory;
    return cloned;
  }

  static bool _defaultAssetsLoaded = false;
  static final Map<String, NonPlayerCharacter> _models = <String, NonPlayerCharacter>{};

  static Future<NonPlayerCharacter?> get(String id) async {
    if(!_defaultAssetsLoaded) await loadDefaultAssets();

    if(!NonPlayerCharacterSummary.exists(id)) {
      return null;
    }

    if(!_models.containsKey(id)) {
      var model = await NonPlayerCharacterStore().get(id);
      if(model == null) {
        return null;
      }
      _models[id] = model;
    }

    return _models[id];
  }

  @override
  String displayName() => name;

  @override
  bool isUnique() => unique;

  @override
  List<EntityBase> instantiate({ int count = 1 }) {
    // TODO: rework this at it will create duplicates in _instances
    var ret = <NonPlayerCharacter>[];

    for(var i=0; i<count; ++i) {
      var j = toJson();
      j['name'] = '$name #${i+1}';
      ret.add(NonPlayerCharacter.fromJson(j));
    }

    return ret;
  }

  static EncounterEntityModel? _modelFactory(String id) {
    return _models[id];
  }

  static List<EntityBase> _npcFactory(String id, int count) {
    if(!_models.containsKey(id)) return <EntityBase>[];
    return _models[id]!.instantiate(count: count);
  }

  static Future<void> reloadFromStore(String id) async {
    _models.remove(id);
    await NonPlayerCharacterSummary._reloadFromStore(id);
  }

  static void removeFromCache(String id) {
    _models.remove(id);
    NonPlayerCharacterSummary._removeFromCache(id);
  }

  static Future<void> loadDefaultAssets() async {
    if(_defaultAssetsLoaded) return;
    _defaultAssetsLoaded = true;

    EncounterEntityFactory.instance.registerFactory(
        'npc',
        _modelFactory,
        _npcFactory);

    for(var model in await loadJSONAssetObjectList('npc-ldb2e.json')) {
      var instance = NonPlayerCharacter.fromJson(model);
      NonPlayerCharacterSummary._defaultAssetLoaded(instance.summary);
      _models[instance.id] = instance;
    }
  }

  static Future<void> loadStoreAssets() async {
    await NonPlayerCharacterSummary._loadStoreAssets();
  }

  static Future<void> saveLocalModel(NonPlayerCharacter npc) async {
    await NonPlayerCharacterStore().save(npc);
    await NonPlayerCharacterSummary._saveLocalModel(npc.summary);
    _models[npc.id] = npc;
  }

  static Future<void> deleteLocalModel(String id) async {
    var npc = await NonPlayerCharacterStore().get(id);
    if(npc != null) {
      await NonPlayerCharacterStore().delete(npc);
      await NonPlayerCharacterSummary._deleteLocalModel(id);
    }
    _models.remove(id);
  }

  static void preImportFilter(Map<String, dynamic> json) {
    json.remove('source');

    if(json.containsKey('unique') && json['unique'] && json.containsKey('equipment') && json['equipment'] is List) {
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
    if(NonPlayerCharacterSummary.exists(defaultId)) {
      throw(NonPlayerCharacterExistsException(id: defaultId));
    }

    var model = NonPlayerCharacter.fromJson(json);
    await NonPlayerCharacter.saveLocalModel(model);
    return model;
  }

  factory NonPlayerCharacter.fromJson(Map<String, dynamic> json) {
    NonPlayerCharacter npc = _$NonPlayerCharacterFromJson(json);
    npc.loadNonRestorableJson(json);
    return npc;
  }

  @override
  Map<String, dynamic> toJson() {
    var j = _$NonPlayerCharacterToJson(this);
    saveNonExportableJson(j);
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