import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:prophecy_compagnon_mj/classes/storage/storable.dart';

import 'character/base.dart';
import 'character/skill.dart';
import 'encounter_entity_factory.dart';
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
  sansCaste(title: 'Sans caste', categories: [ NPCCategory.generique ]),
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

    if(
        _subcat == null &&
        _title != null &&
        _categories != null &&
        _categories.contains(NPCCategory.scenario) &&
        -1 == _scenarioNames.indexWhere((NPCSubCategory s) => s.title == _title)
    ) {
      _scenarioNames.add(this);
    }
  }

  String get title => _subcat != null ? _subcat.title : _title!;
  List<NPCCategory> get categories => _subcat != null ? _subcat.categories : _categories!;
  NPCSubCategoryEnum? get subCategory => _subcat;

  static List<NPCSubCategory> subCategoriesForCategory(NPCCategory category) {
    var ret = <NPCSubCategory>[];

    if(category == NPCCategory.scenario) {
      ret.addAll(_scenarioNames);
    }
    else {
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

  static final List<NPCSubCategory> _scenarioNames = <NPCSubCategory>[];

  final String? _title;
  final List<NPCCategory>? _categories;
  final NPCSubCategoryEnum? _subcat;
}

Map<String, dynamic> _subCategoryToJson(NPCSubCategory sub) {
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

NPCSubCategory _subCategoryFromJson(Map<String, dynamic> json) {
  if(json.containsKey('subcategory')) {
    return NPCSubCategory(
      subcategory: NPCSubCategoryEnum.values.byName(json['subcategory']!),
    );
  }
  else {
    List<NPCCategory> categories = (json['categories'] as List<dynamic>)
        .map((dynamic name) => NPCCategory.values.byName(name as String))
        .toList();

    return NPCSubCategory(
      categories: categories,
      title: json['title'],
    );
  }
}

class NonPlayerCharacterSummaryStore extends JsonStoreAdapter<NonPlayerCharacterSummary> {
  NonPlayerCharacterSummaryStore();

  @override
  String storeCategory() => 'npcSummaries';

  @override
  String key(NonPlayerCharacterSummary object) => object.id;

  @override
  Future<NonPlayerCharacterSummary> fromJsonRepresentation(Map<String, dynamic> j) async =>
      NonPlayerCharacterSummary.fromJson(j);

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(NonPlayerCharacterSummary object) async => object.toJson();
}

class NonPlayerCharacterStore extends JsonStoreAdapter<NonPlayerCharacter> {
  NonPlayerCharacterStore();

  @override
  String storeCategory() => 'npcs';

  @override
  String key(NonPlayerCharacter object) => object.id;

  @override
  Future<NonPlayerCharacter> fromJsonRepresentation(Map<String, dynamic> j) async => NonPlayerCharacter.fromJson(j);

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(NonPlayerCharacter object) async => object.toJson();
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class NonPlayerCharacterSummary {
  NonPlayerCharacterSummary({
    required this.id,
    required this.name,
    required this.category,
    required this.subCategory,
  });

  String id;
  String name;
  NPCCategory category;
  @JsonKey(fromJson: _subCategoryFromJson, toJson: _subCategoryToJson)
    NPCSubCategory subCategory;

  factory NonPlayerCharacterSummary.fromJson(Map<String, dynamic> j) => _$NonPlayerCharacterSummaryFromJson(j);
  Map<String, dynamic> toJson() => _$NonPlayerCharacterSummaryToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, constructor: 'create')
class NonPlayerCharacter extends HumanCharacter with EncounterEntityModel {
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

  @JsonKey(includeFromJson: false, includeToJson: false)
    final String id;
  NPCCategory category;
  @JsonKey(fromJson: _subCategoryFromJson, toJson: _subCategoryToJson)
    NPCSubCategory subCategory;
  bool unique;
  bool editable;
  bool useHumanInjuryManager;

  NonPlayerCharacterSummary get summary => NonPlayerCharacterSummary(
      id: id,
      name: name,
      category: category,
      subCategory: subCategory,
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

  static List<NonPlayerCharacterSummary> forCategory(NPCCategory category, NPCSubCategory? subCategory) {
    var ret = <NonPlayerCharacterSummary>[];
    for(var summary in _summaries.values) {
      if(summary.category == category && (subCategory == null || summary.subCategory == subCategory)) {
        ret.add(summary);
      }
    }
    return ret;
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
      var instance = NonPlayerCharacter.fromJson(model);
      _summaries[instance.id] = instance.summary;
      _instances[instance.id] = instance;
    }

    for(var npc in await NonPlayerCharacterSummaryStore().getAll()) {
      _summaries[npc.id] = npc;
    }
  }

  static Future<void> saveLocalModel(NonPlayerCharacter npc) async {
    await NonPlayerCharacterSummaryStore().save(npc.summary);
    await NonPlayerCharacterStore().save(npc);
    _summaries[npc.id] = npc.summary;
    _instances[npc.id] = npc;
  }

  static Future<void> deleteLocalModel(String id) async {
    var npc = await NonPlayerCharacterStore().get(id);
    if(npc != null) {
      await NonPlayerCharacterSummaryStore().delete(npc.summary);
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