import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';

import '../text_utils.dart';
import 'storage/default_assets_store.dart';
import 'storage/storable.dart';

part 'npc_category.g.dart';

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

class NPCCategoryStore extends ObjectStoreAdapter<NPCCategory> {
  @override
  String storeCategory() => 'npcCategories';

  @override
  String key(NPCCategory object) => object.name;

  @override
  Future<NPCCategory> fromStoreRepresentation(String r) async =>
      NPCCategoryJsonConverter().fromJson(r);

  @override
  Future<String> toStoreRepresentation(NPCCategory object) async =>
      NPCCategoryJsonConverter().toJson(object);
}

class NPCCategory {
  static NPCCategory createNewCategory = NPCCategory._create(title: "Créer cette catégorie", isDefault: true);

  factory NPCCategory({required String title, bool isDefault = false}) {
    var name = sentenceToCamelCase(transliterateFrenchToAscii(title));
    if(!_categories.containsKey(name)) {
      var c = NPCCategory._create(title: title, isDefault: isDefault);
      _categories[c.name] = c;
      if(!isDefault) NPCCategoryStore().save(c);
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
    return _categories.values.toList();
  }

  static NPCCategory byName(String name) {
    return _categories.values.firstWhere((NPCCategory c) => c.name == name);
  }

  @override
  int get hashCode => title.hashCode;

  @override
  bool operator ==(Object other) {
    if(other is! NPCCategory) return false;
    return title == other.title;
  }

  static Future<void> init() async {
    await _loadDefaultAssets();
    await NPCCategoryStore().getAll();
  }

  static Future<void> _loadDefaultAssets() async {
    if(_defaultAssetsLoaded) return;
    _defaultAssetsLoaded = true;

    var jsonStr = await rootBundle.loadString('assets/npc-categories.json');
    var categories = json.decode(jsonStr);
    for(var c in categories) {
      // ignore: unused_local_variable
      var category = NPCCategory(title: c, isDefault: true);
    }
  }

  static final Map<String, NPCCategory> _categories = <String, NPCCategory>{};
  static bool _defaultAssetsLoaded = false;
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

class NPCSubCategoryStore extends JsonStoreAdapter<NPCSubCategory> {
  @override
  String storeCategory() => 'npcSubCategories';

  @override
  String key(NPCSubCategory object) => object.name;

  @override
  Future<NPCSubCategory> fromJsonRepresentation(Map<String, dynamic> j) async =>
      NPCSubcategoryJsonConverter().fromJson(j);

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(NPCSubCategory object) async =>
      NPCSubcategoryJsonConverter().toJson(object);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
@NPCCategoryJsonConverter()
class NPCSubCategory {
  static NPCSubCategory createNewSubCategory = NPCSubCategory._create(
    title: 'Créer une sous-catégorie',
    categories: [],
    isDefault: true,
  );

  factory NPCSubCategory({
    required String title,
    required List<NPCCategory> categories,
    bool isDefault = false,
  }) {
    var name = sentenceToCamelCase(transliterateFrenchToAscii(title));
    if(_subCategories.containsKey(name)) {
      var sub = _subCategories[name]!;
      var updated = false;
      for(var c in categories) {
        if(!sub.categories.contains(c)) {
          sub.categories.add(c);
          updated = true;
        }
      }
      if(updated && !isDefault) NPCSubCategoryStore().save(sub);
      return sub;
    }
    else {
      var s = NPCSubCategory._create(title: title, categories: categories, isDefault: isDefault);
      _subCategories[s.name] = s;
      if(!isDefault) NPCSubCategoryStore().save(s);
      return s;
    }
  }

  NPCSubCategory._create({ required this.title, required this.categories, this.isDefault = false });

  static List<NPCSubCategory> subCategoriesForCategory(NPCCategory category) {
    return _subCategories.values
        .where((NPCSubCategory s) => s.categories.contains(category))
        .toList();
  }

  static List<NPCSubCategory> get values {
    return _subCategories.values.toList();
  }

  static NPCSubCategory byName(String name) {
    return _subCategories[name]!;
  }

  static NPCSubCategory? byTitle(String title) {
    String? key;
    _subCategories.forEach((k, v) {
      if (v.title == title) key = k;
    });
    return key == null ? null : _subCategories[key]!;
  }

  final String title;
  final List<NPCCategory> categories;
  @JsonKey(includeFromJson: true, includeToJson: false)
  final bool isDefault;

  String get name => sentenceToCamelCase(transliterateFrenchToAscii(title));

  @override
  int get hashCode => Object.hash(title, categories);

  @override
  bool operator ==(Object other) {
    if(other is! NPCSubCategory) return false;
    return title == other.title;
  }

  static Future<void> init() async {
    await _loadDefaultAssets();
    await NPCSubCategoryStore().getAll();
  }

  static Future<void> _loadDefaultAssets() async {
    if(_defaultAssetsLoaded) return;
    _defaultAssetsLoaded = true;

    for (var sc in await loadJSONAssetObjectList('npc-subcategories.json')) {
      // ignore: unused_local_variable
      var subCategory = NPCSubCategory.fromJson(sc);
    }
  }

  static final Map<String, NPCSubCategory> _subCategories = <String, NPCSubCategory>{};
  static bool _defaultAssetsLoaded = false;

  factory NPCSubCategory.fromJson(Map<String, dynamic> j) => _$NPCSubCategoryFromJson(j);
  Map<String, dynamic> toJson() => _$NPCSubCategoryToJson(this);
}