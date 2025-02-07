import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:prophecy_compagnon_mj/classes/storage/storable.dart';

import 'character/base.dart';
import 'character/skill.dart';
import 'encounter_entity_factory.dart';
import 'entity_base.dart';
import 'equipment.dart';
import 'exportable_binary_data.dart';
import 'human_character.dart';
import 'magic.dart';
import 'object_source.dart';
import 'place.dart';
import '../text_utils.dart';

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
    j['editable'] = true;
    return NonPlayerCharacterSummary.fromJson(j);
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
    j['editable'] = true;
    return NonPlayerCharacter.fromJson(j);
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

    var summary = await NonPlayerCharacterSummaryStore().get(object.id);
    if(summary != null) await NonPlayerCharacterSummaryStore().delete(summary);

    await NonPlayerCharacterSummaryStore().save(object.summary);
  }

  @override
  Future<void> willDelete(NonPlayerCharacter object) async {
    if(object.icon != null) await BinaryDataStore().delete(object.icon!);
    if(object.image != null) await BinaryDataStore().delete(object.image!);

    var summary = await NonPlayerCharacterSummaryStore().get(object.id);
    if(summary != null) await NonPlayerCharacterSummaryStore().delete(summary);
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
@NPCCategoryJsonConverter()
@NPCSubcategoryJsonConverter()
class NonPlayerCharacterSummary {
  NonPlayerCharacterSummary({
    required this.id,
    required this.isDefault,
    required this.name,
    required this.category,
    required this.subCategory,
    required this.source,
    this.icon,
    this.editable = false,
  });

  final String id;
  final bool isDefault;
  final String name;
  final NPCCategory category;
  final NPCSubCategory subCategory;
  final ObjectSource source;
  final ExportableBinaryData? icon;
  @JsonKey(includeToJson: false, includeFromJson: true)
    final bool editable;

  factory NonPlayerCharacterSummary.fromJson(Map<String, dynamic> j) => _$NonPlayerCharacterSummaryFromJson(j);
  Map<String, dynamic> toJson() => _$NonPlayerCharacterSummaryToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
@NPCCategoryJsonConverter()
@NPCSubcategoryJsonConverter()
class NonPlayerCharacter extends HumanCharacter with EncounterEntityModel {
  NonPlayerCharacter(
    {
      super.uuid,
      super.isDefault,
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
      this.editable = false,
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
  @JsonKey(includeToJson: false, includeFromJson: true)
    bool editable;
  bool useHumanInjuryManager;

  NonPlayerCharacterSummary get summary => NonPlayerCharacterSummary(
      id: id,
      isDefault: isDefault,
      name: name,
      category: category,
      subCategory: subCategory,
      source: source,
      icon: icon?.clone(),
      editable: editable,
    );

  static bool _defaultAssetsLoaded = false;
  static final Map<String, NonPlayerCharacterSummary> _summaries = <String, NonPlayerCharacterSummary>{};
  static final Map<String, NonPlayerCharacter> _instances = <String, NonPlayerCharacter>{};

  static Future<NonPlayerCharacter?> get(String id) async {
    if(!_defaultAssetsLoaded) await loadDefaultAssets();

    if(!_summaries.containsKey(id)) {
      return null;
    }

    if(!_instances.containsKey(id)) {
      var model = await NonPlayerCharacterStore().get(id);
      if(model == null) {
        return null;
      }
      model.editable = true;
      _instances[id] = model;
    }

    return _instances[id];
  }

  static bool _matchesCategory(NonPlayerCharacterSummary summary, NPCCategory category, NPCSubCategory? subCategory) {
    return summary.category == category
        && (subCategory == null || summary.subCategory == subCategory);
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

  @override
  String displayName() => name;

  @override
  bool isUnique() => unique;

  @override
  List<EntityBase> instantiate({ int count = 1 }) {
    var ret = <NonPlayerCharacter>[];

    for(var i=0; i<count; ++i) {
      var j = toJson();
      j['name'] = '$name #${i+1}';
      ret.add(NonPlayerCharacter.fromJson(j));
    }

    return ret;
  }

  static EncounterEntityModel? _modelFactory(String id) {
    return _instances[id];
  }

  static List<EntityBase> _npcFactory(String id, int count) {
    if(!_instances.containsKey(id)) return <EntityBase>[];
    return _instances[id]!.instantiate(count: count);
  }

  static Future<void> loadDefaultAssets() async {
    if(_defaultAssetsLoaded) return;
    _defaultAssetsLoaded = true;

    EncounterEntityFactory.instance.registerFactory(
        'npc',
        _modelFactory,
        _npcFactory);

    var jsonStr = await rootBundle.loadString('assets/npc-ldb2e.json');
    var assets = json.decode(jsonStr);

    for(var model in assets) {
      model['is_default'] = true;
      var instance = NonPlayerCharacter.fromJson(model);
      _summaries[instance.id] = instance.summary;
      _instances[instance.id] = instance;
    }

    for(var npc in await NonPlayerCharacterSummaryStore().getAll()) {
      _summaries[npc.id] = npc;
    }
  }

  static Future<void> saveLocalModel(NonPlayerCharacter npc) async {
    await NonPlayerCharacterStore().save(npc);
    _summaries[npc.id] = npc.summary;
    _instances[npc.id] = npc;
  }

  static Future<void> deleteLocalModel(String id) async {
    var npc = await NonPlayerCharacterStore().get(id);
    if(npc != null) {
      await NonPlayerCharacterStore().delete(npc);
    }
    _summaries.remove(id);
    _instances.remove(id);
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