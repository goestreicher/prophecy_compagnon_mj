import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:json_annotation/json_annotation.dart';

import 'character/base.dart';
import 'character/skill.dart';
import 'entity_base.dart';
import 'equipment.dart';
import 'human_character.dart';
import 'magic.dart';
import '../text_utils.dart';

part 'non_player_character.g.dart';

enum NPCCategory {
  generique(title: 'Générique'),
  scenario(title: 'Scénario'),
  ;

  final String title;

  const NPCCategory({ required this.title });
}

enum NPCSubCategoryEnum {
  sansCaste(title: 'Sans caste', categories: [ NPCCategory.scenario, NPCCategory.generique ]),
  ;

  final String title;
  final List<NPCCategory> categories;

  const NPCSubCategoryEnum({ required this.title, required this.categories });
}

class NPCSubCategory {
  NPCSubCategory({
    String? title,
    List<NPCCategory>? categories,
    NPCSubCategoryEnum? subcategory,
  })
    : _title = title, _categories = categories, _subcat = subcategory
  {
    if(_subcat == null && (_title == null || _categories == null)) {
      throw ArgumentError('Either the subcategory or the title and the categories must be given');
    }
  }

  String get title => _subcat != null ? _subcat.title : _title!;
  List<NPCCategory> get categories => _subcat != null ? _subcat.categories : _categories!;
  NPCSubCategoryEnum? get subCategory => _subcat;

  static List<NPCSubCategory> subCategoriesForCategory(NPCCategory category) {
    var ret = <NPCSubCategory>[];

    if(category != NPCCategory.scenario) {
      ret.addAll(
        NPCSubCategoryEnum.values
          .where((NPCSubCategoryEnum s) => s.categories.contains(category))
          .map((NPCSubCategoryEnum s) => NPCSubCategory(subcategory: s))
      );
    }

    return ret;
  }

  @override
  int get hashCode => Object.hash(_title, _categories, _subcat);

  @override
  bool operator ==(Object other) {
    if(other is! NPCSubCategory) return false;

    if(_subcat != null) return _subcat == other._subcat;
    return _title == other._title;
  }

  final String? _title;
  final List<NPCCategory>? _categories;
  final NPCSubCategoryEnum? _subcat;
}

@JsonSerializable(fieldRename: FieldRename.snake, constructor: 'create')
class NonPlayerCharacter extends HumanCharacter {
  NonPlayerCharacter(
    super.uuid,
    {
      required super.name,
      required this.category,
      required this.subCategory,
      this.unique = false,
      this.editable = false,
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
    }
  )
    : id = sentenceToCamelCase(transliterateFrenchToAscii(name))
  {
    if(!subCategory.categories.contains(category)) {
      throw ArgumentError('La sous-catégorie "${subCategory.title}" ne peut pas être utilisée avec la catégorie "${category.title}"');
    }
  }

  NonPlayerCharacter.create({
    required super.name,
    required this.category,
    required this.subCategory,
    this.unique = false,
    this.editable = false,
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
  })
    : id = sentenceToCamelCase(transliterateFrenchToAscii(name)), super.create()
  {
    if(!subCategory.categories.contains(category)) {
      throw ArgumentError('La sous-catégorie "${subCategory.title}" ne peut pas être utilisée avec la catégorie "${category.title}"');
    }
  }

  static Map<String, dynamic> _subCategoryToJson(NPCSubCategory sub) {
    var ret = <String, dynamic>{};

    if(sub.subCategory == null) {
      ret['categories'] = sub.categories.map((NPCCategory c) => c.name).toList();
      ret['title'] = sub.title;
    }
    else {
      ret['subcategory'] = sub.subCategory!.name;
    }

    return ret;
  }

  static NPCSubCategory _subCategoryFromJson(Map<String, dynamic> json) {
    if(json.containsKey('subcategory')) {
      return NPCSubCategory(
        subcategory: NPCSubCategoryEnum.values.byName(json['subcategory']!),
      );
    }
    else {
      print(json['categories'].runtimeType);
      List<NPCCategory> categories = (json['categories'] as List<dynamic>)
          .map((dynamic name) => NPCCategory.values.byName(name as String))
          .toList();

      return NPCSubCategory(
        categories: categories,
        title: json['title'],
      );
    }
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
    final String id;
  NPCCategory category;
  @JsonKey(fromJson: _subCategoryFromJson, toJson: _subCategoryToJson)
    NPCSubCategory subCategory;
  bool unique;
  bool editable;
  bool useHumanInjuryManager;

  static bool _defaultAssetsLoaded = false;
  static final Map<String, NonPlayerCharacter> _instances = <String, NonPlayerCharacter>{};

  static NonPlayerCharacter? get(String id) {
    if(!_defaultAssetsLoaded) loadDefaultAssets();
    return _instances[id];
  }

  static List<NonPlayerCharacter> forCategory(NPCCategory category, NPCSubCategory? subCategory) {
    var ret = <NonPlayerCharacter>[];
    for(var instance in _instances.values) {
      if(instance.category == category && (subCategory == null || instance.subCategory == subCategory)) {
        ret.add(instance);
      }
    }
    return ret;
  }

  static Future<void> loadDefaultAssets() async {
    if(_defaultAssetsLoaded) return;
    _defaultAssetsLoaded = true;

    var jsonStr = await rootBundle.loadString('assets/npc-ldb2e.json');
    var assets = json.decode(jsonStr);

    for(var model in assets) {
      var instance = NonPlayerCharacter.fromJson(model);
      _instances[instance.id] = instance;
    }

    var box = await Hive.openLazyBox('npcsBox');
    for(var id in box.keys) {
      var jsonStr = await box.get(id);
      var npc = NonPlayerCharacter.fromJson(json.decode(jsonStr));
      npc.editable = true;
      _instances[npc.id] = npc;
    }
  }

  static Future<void> saveLocalModel(NonPlayerCharacter npc) async {
    var box = await Hive.openLazyBox('npcsBox');
    await box.put(npc.id, json.encode(npc.toJson()));
    _instances[npc.id] = npc;
  }

  static Future<void> deleteLocalModel(String id) async {
    var box = await Hive.openLazyBox('npcsBox');
    await box.delete(id);
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