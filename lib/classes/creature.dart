import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'combat.dart';
import 'entity/abilities.dart';
import 'entity/attributes.dart';
import 'entity/magic.dart';
import 'entity/skill.dart';
import 'entity/skills.dart';
import 'entity/specialized_skill.dart';
import 'entity/status.dart';
import 'entity_instance.dart';
import 'encounter_entity_factory.dart';
import 'entity_base.dart';
import 'equipment.dart';
import 'exportable_binary_data.dart';
import 'magic_user.dart';
import 'object_location.dart';
import 'object_source.dart';
import 'resource_memory_cache.dart';
import 'weapon.dart';
import 'character/base.dart';
import 'entity/injury.dart';
import 'storage/default_assets_store.dart';
import 'storage/storable.dart';
import '../text_utils.dart';

part 'creature.g.dart';

class CreatureCategoryJsonConverter extends JsonConverter<CreatureCategory, String> {
  const CreatureCategoryJsonConverter();

  @override
  CreatureCategory fromJson(String json) {
    var index = CreatureCategory.values.indexWhere((CreatureCategory c) => c.name == json);
    if(index != -1) {
      return CreatureCategory.values[index];
    }

    var name = sentenceToCamelCase(transliterateFrenchToAscii(json));
    index = CreatureCategory.values.indexWhere((CreatureCategory c) => c.name == name);
    if(index != -1) {
      return CreatureCategory.values[index];
    }

    return CreatureCategory(title: json);
  }

  @override
  String toJson(CreatureCategory object) => object.isDefault ? object.name : object.title;
}

class CreatureCategory {
  static CreatureCategory createNewCreatureCategory = CreatureCategory._create(title: "Créer cette catégorie", isDefault: true);

  static Future<void> loadDefaultAssets() async {
    if(_defaultAssetsLoaded) return;
    _defaultAssetsLoaded = true;

    var jsonStr = await rootBundle.loadString('assets/creature-categories.json');
    var categories = json.decode(jsonStr);
    for(var c in categories) {
      // ignore: unused_local_variable
      var category = CreatureCategory(title: c, isDefault: true);
    }
  }

  factory CreatureCategory({ required String title, bool isDefault = false }) {
    var name = sentenceToCamelCase(transliterateFrenchToAscii(title));
    if(!_categories.containsKey(name)) {
      var c = CreatureCategory._create(title: title, isDefault: isDefault);
      _categories[c.name] = c;
      return c;
    }
    else {
      return _categories[name]!;
    }
  }

  CreatureCategory._create({ required this.title, required this.isDefault });

  final String title;
  final bool isDefault;

  String get name => sentenceToCamelCase(transliterateFrenchToAscii(title));

  static List<CreatureCategory> get values {
    return _categories.values.toList();
  }

  static CreatureCategory byName(String name) {
    return _categories.values.firstWhere((CreatureCategory c) => c.name == name);
  }

  @override
  int get hashCode => title.hashCode;

  @override
  bool operator ==(Object other) {
    if(other is! CreatureCategory) return false;
    return title == other.title;
  }

  static final Map<String, CreatureCategory> _categories = <String, CreatureCategory>{};
  static bool _defaultAssetsLoaded = false;
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class NaturalWeaponModelRangeSpecification {
  NaturalWeaponModelRangeSpecification({
    required this.initiative,
    required this.effectiveDistance,
    this.maximumDistance,
  });

  int initiative;
  double effectiveDistance;
  double? maximumDistance;

  factory NaturalWeaponModelRangeSpecification.fromJson(Map<String, dynamic> json)
    => _$NaturalWeaponModelRangeSpecificationFromJson(json);
  Map<String, dynamic> toJson() => _$NaturalWeaponModelRangeSpecificationToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class NaturalWeaponModel {
  NaturalWeaponModel({
    required this.name,
    required this.skill,
    required this.damage,
    required this.ranges,
  }) : id = sentenceToCamelCase(transliterateFrenchToAscii(name));

  @JsonKey(includeToJson: false, includeFromJson: false)
    late String id;
  String name;
  int skill;
  int damage;
  final Map<WeaponRange, NaturalWeaponModelRangeSpecification> ranges;

  Map<String, dynamic> toJson() => _$NaturalWeaponModelToJson(this);
  factory NaturalWeaponModel.fromJson(Map<String, dynamic> json)
    => _$NaturalWeaponModelFromJson(json);
}

class NaturalArmor implements ProtectionProvider {
  NaturalArmor({ required this.value });

  final int value;

  @override
  int protection() => value;
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CreatureSpecialCapability {
  CreatureSpecialCapability({ required this.name, required this.description });

  String name;
  String description;

  factory CreatureSpecialCapability.fromJson(Map<String, dynamic> json)
      => _$CreatureSpecialCapabilityFromJson(json);
  Map<String, dynamic> toJson()
      => _$CreatureSpecialCapabilityToJson(this);
}

class CreatureSummaryStore extends JsonStoreAdapter<CreatureSummary> {
  CreatureSummaryStore();

  @override
  String storeCategory() => 'creatureSummaries';

  @override
  String key(CreatureSummary object) => object.id;

  @override
  Future<CreatureSummary> fromJsonRepresentation(Map<String, dynamic> j) async {
    if(j.containsKey('icon') && j['icon'] is String) await restoreJsonBinaryData(j, 'icon');
    var summary = CreatureSummary.fromJson(j);
    summary.location = ObjectLocation(
      type: ObjectLocationType.store,
      collectionUri: '${getUriBase()}/${storeCategory()}',
    );
    return summary;
  }

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(CreatureSummary object) async {
    var j = object.toJson();
    if(object.icon != null) j['icon'] = object.icon!.hash;
    return j;
  }

  @override
  Future<void> willSave(CreatureSummary object) async {
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
  Future<void> willDelete(CreatureSummary object) async {
    if(object.icon != null) await BinaryDataStore().delete(object.icon!);
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
@CreatureCategoryJsonConverter()
class CreatureSummary {
  factory CreatureSummary({
    required String id,
    required String name,
    required CreatureCategory category,
    ObjectLocation location = ObjectLocation.memory,
    required ObjectSource source,
    ExportableBinaryData? icon,
  })
  {
    var summ = _cache.entry(id)
        ?? CreatureSummary._create(
          id: id,
          name: name,
          category: category,
          location: location,
          source: source,
          icon: icon,
        );
    _cache.add(id, summ);
    return summ;
  }

  CreatureSummary._create({
    required this.id,
    required this.name,
    required this.category,
    this.location = ObjectLocation.memory,
    required this.source,
    this.icon,
  });

  final String id;
  final String name;
  final CreatureCategory category;
  @JsonKey(includeFromJson: true, includeToJson: false)
  ObjectLocation location;
  final ObjectSource source;
  final ExportableBinaryData? icon;

  static Future<Iterable<String>> ids() async {
    await loadAll();
    return _cache.keys;
  }

  static Future<bool> exists(String id) async {
    await loadAll();
    return _cache.contains(id);
  }

  static Future<CreatureSummary?> get(String id) async {
    await loadAll();
    return _cache.entry(id);
  }

  static Future<Iterable<CreatureSummary>> getAll({String? nameFilter}) async {
    await loadAll();
    return _cache.values
        .where(
            (CreatureSummary c) =>
                nameFilter == null
                || c.name.toLowerCase().contains(nameFilter.toLowerCase())
        );
  }

  static Future<Iterable<CreatureSummary>> forLocationType(
    ObjectLocationType type,
    CreatureCategory? category,
    {String? nameFilter}
  ) async {
    await loadAll();
    return _cache.values
        .where(
            (CreatureSummary c) =>
                c.location.type == type
                && (category == null || c.category == category)
        )
        .where(
            (CreatureSummary c) =>
                nameFilter == null
                || c.name.toLowerCase().contains(nameFilter.toLowerCase())
        );
  }

  static Future<Iterable<CreatureSummary>> forCategory(
    CreatureCategory category,
    {String? nameFilter}
  ) async {
    await loadAll();
    return _cache.values
        .where((CreatureSummary c) => c.category == category)
        .where(
            (CreatureSummary c) =>
                nameFilter == null
                || c.name.toLowerCase().contains(nameFilter.toLowerCase())
        );
  }

  static Future<Iterable<CreatureSummary>> forSourceType(
    ObjectSourceType type,
    CreatureCategory? category,
    {String? nameFilter}
  ) async {
    await loadAll();
    return _cache.values
        .where(
            (CreatureSummary c) =>
                c.source.type == type
                && (category == null || c.category == category)
        )
        .where(
            (CreatureSummary c) =>
                nameFilter == null
                || c.name.toLowerCase().contains(nameFilter.toLowerCase())
        );
  }

  static Future<Iterable<CreatureSummary>> forSource(
    ObjectSource source,
    CreatureCategory? category,
    {String? nameFilter}
  ) async {
    await loadAll();
    return _cache.values
        .where(
            (CreatureSummary c) =>
                c.source == source
                && (category == null || c.category == category)
        )
        .where(
            (CreatureSummary c) =>
                nameFilter == null
                || c.name.toLowerCase().contains(nameFilter.toLowerCase())
        );
  }

  static Future<void> init() async {
    // ignore:unused_local_variable
    var c = _cache;
  }

  static Future<void> loadAll() async {
    if(_cache.isEmpty || _cache.purged) {
      var assetFiles = [
        'creatures-ldb2e.json',
        'creatures-ecran2e.json',
        'creatures-les-ecailles-de-brorne.json',
        'creatures-les-enfants-de-heyra.json',
        'creatures-les-foudres-de-kroryn.json',
      ];

      for (var f in assetFiles) {
        for (var model in await loadJSONAssetObjectList(f)) {
          try {
            // ignore:unused_local_variable
            var instance = CreatureSummary.fromJson(model);
          } catch (e, stacktrace) {
            print('Error loading creature ${model["name"]}: ${e.toString()}\n${stacktrace.toString()}');
          }
        }
      }

      await CreatureSummaryStore().getAll();

      _cache.purged = false;
    }
  }

  static Future<void> _reloadFromStore(String id) async {
    _removeFromCache(id);
    var summary = await CreatureSummaryStore().get(id);
    if(summary != null) {
      _cache.add(summary.id, summary);
    }
  }

  static void _removeFromCache(String id) =>
      _cache.del(id);

  static Future<void> _saveLocalModel(CreatureSummary summary) async {
    await CreatureSummaryStore().save(summary);
    _cache.add(summary.id, summary);
  }

  static Future<void> _deleteLocalModel(String id) async {
    var summary = await CreatureSummaryStore().get(id);
    if(summary != null) {
      CreatureSummaryStore().delete(summary);
    }
    _cache.del(id);
  }

  static final _cache = ResourceMemoryCache<CreatureSummary>();

  factory CreatureSummary.fromJson(Map<String, dynamic> j) {
    if(!j.containsKey('id')) {
      if (j.containsKey('uuid')) {
        j['id'] = j['uuid'];
      }
      else {
        j['id'] = Creature._getId(j['name']);
      }
    }
    return _$CreatureSummaryFromJson(j);
  }

  Map<String, dynamic> toJson() =>
      _$CreatureSummaryToJson(this);
}

class CreatureStore extends JsonStoreAdapter<Creature> {
  CreatureStore();

  @override
  String storeCategory() => 'creatures';

  @override
  String key(Creature object) => object.id;

  @override
  Future<Creature> fromJsonRepresentation(Map<String, dynamic> j) async {
    if(j.containsKey('image') && j['image'] is String) await restoreJsonBinaryData(j, 'image');
    if(j.containsKey('icon') && j['icon'] is String) await restoreJsonBinaryData(j, 'icon');
    var model = Creature.fromJson(j);
    model.location = ObjectLocation(
      type: ObjectLocationType.store,
      collectionUri: '${getUriBase()}/${storeCategory()}',
    );
    return model;
  }

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(Creature object) async {
    var j = object.toJson();
    if(object.image != null) j['image'] = object.image!.hash;
    if(object.icon != null) j['icon'] = object.icon!.hash;
    return j;
  }

  @override
  Future<void> willSave(Creature object) async {
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
  Future<void> willDelete(Creature object) async {
    if(object.icon != null) await BinaryDataStore().delete(object.icon!);
    if(object.image != null) await BinaryDataStore().delete(object.image!);
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
@CreatureCategoryJsonConverter()
class Creature extends EntityBase with EncounterEntityModel, MagicUser {
  factory Creature({
    String? uuid,
    ObjectLocation location = ObjectLocation.memory,
    required ObjectSource source,
    required String name,
    required int initiative,
    InjuryManager Function(EntityBase?, InjuryManager?) injuryProvider = entityBaseDefaultInjuries,
    required double size,
    String? description,
    ExportableBinaryData? image,
    ExportableBinaryData? icon,
    bool unique = false,
    required CreatureCategory category,
    required String biome,
    required String realSize,
    required String weight,
    required int naturalArmor,
    String naturalArmorDescription = '',
    List<NaturalWeaponModel>? naturalWeapons,
    List<CreatureSpecialCapability>? specialCapabilities,
    EntityStatus? status,
    EntityEquipment? equipment,
    EntityMagic? magic,
  }) {
    bool isDefault = (location.type == ObjectLocationType.assets);
    String id = uuid ?? (isDefault ? _getId(name) : Uuid().v4().toString());
    var model = _cache.entry(id)
        ?? Creature._create(
            uuid: uuid,
            location: location,
            source: source,
            name: name,
            initiative: initiative,
            injuryProvider: injuryProvider,
            size: size,
            weight: weight,
            description: description,
            image: image,
            icon: icon,
            unique: unique,
            category: category,
            biome: biome,
            realSize: realSize,
            naturalArmor: naturalArmor,
            naturalArmorDescription: naturalArmorDescription,
            naturalWeapons: naturalWeapons,
            specialCapabilities: specialCapabilities,
            status: status,
            equipment: equipment,
            magic: magic,
          );
    _cache.add(id, model);
    // Force insertion in CreatureSummary cache
    // ignore:unused_local_variable
    var s = model.summary;
    return model;
  }

  Creature._create(
      {
        super.uuid,
        super.location = ObjectLocation.memory,
        required super.name,
        super.initiative,
        super.injuryProvider = entityBaseDefaultInjuries,
        super.size,
        super.description,
        super.image,
        super.icon,
        this.unique = false,
        required this.category,
        required this.source,
        required this.biome,
        required this.realSize,
        required this.weight,
        required this.naturalArmor,
        this.naturalArmorDescription = '',
        List<NaturalWeaponModel>? naturalWeapons,
        List<CreatureSpecialCapability>? specialCapabilities,
        super.status,
        super.equipment,
        super.magic,
      })
    : naturalWeapons = naturalWeapons ?? <NaturalWeaponModel>[],
      specialCapabilities = specialCapabilities ?? <CreatureSpecialCapability>[];

  bool unique;
  CreatureCategory category;
  ObjectSource source;
  String biome;
  String realSize;
  String weight;
  int naturalArmor;
  String naturalArmorDescription;
  List<NaturalWeaponModel> naturalWeapons;
  List<CreatureSpecialCapability> specialCapabilities;

  CreatureSummary get summary => CreatureSummary(
      id: id,
      name: name,
      category: category,
      location: location,
      source: source,
      icon: icon?.clone(),
    );

  @override
  String displayName() => name;

  @override
  bool isUnique() => unique;

  @override
  List<EntityBase> instantiate({ int count = 1 }) {
    var ret = <EntityInstance>[];

    var modelSpecification = 'creature:$id';

    for(var idx = 0; idx < count; ++idx) {
      var instance = EntityInstance.prepareInstantiation(
        entity: this,
        name: '$name #${idx+1}',
        modelSpecification: modelSpecification,
      );

      instance.addProtectionProvider(NaturalArmor(value: naturalArmor));

      var contactRange = AttributeBasedCalculator(
          static: 0.5,
          multiply: 0,
          add: 0,
          dice: 0);

      for(var weapon in naturalWeapons) {
        var spSkill = SpecializedSkill.create(
          parent: Skill.creatureNaturalWeapon,
          name: weapon.name,
          reserved: true,
          reservedPrefix: 'creature:$id:specialized:combat:',
        );
        var skill = instance.skills.add(Skill.creatureNaturalWeapon);
        skill.addSpecialization(spSkill).value = weapon.skill;

        AttributeBasedCalculator? effective;
        AttributeBasedCalculator? max;

        if(weapon.ranges.containsKey(WeaponRange.contact)) {
          effective = AttributeBasedCalculator(
              static: weapon.ranges[WeaponRange.contact]!.effectiveDistance,
              multiply: 0,
              add: 0,
              dice: 0);
          max = effective;
        }
        else if(weapon.ranges.containsKey(WeaponRange.melee)) {
          effective = AttributeBasedCalculator(
              static: weapon.ranges[WeaponRange.melee]!.effectiveDistance,
              multiply: 0,
              add: 0,
              dice: 0);
          max = effective;
        }
        else if(weapon.ranges.containsKey(WeaponRange.distance)) {
          effective = AttributeBasedCalculator(
              static: weapon.ranges[WeaponRange.distance]!.effectiveDistance,
              multiply: 0,
              add: 0,
              dice: 0);
          max = effective;
        }
        else if(weapon.ranges.containsKey(WeaponRange.ranged)) {
          effective = AttributeBasedCalculator(
              static: weapon.ranges[WeaponRange.ranged]!.effectiveDistance,
              multiply: 0,
              add: 0,
              dice: 0);
          max = AttributeBasedCalculator(
              static: weapon.ranges[WeaponRange.ranged]!.maximumDistance == null
                  ? weapon.ranges[WeaponRange.ranged]!.effectiveDistance * 2
                  : weapon.ranges[WeaponRange.ranged]!.maximumDistance!,
              multiply: 0,
              add: 0,
              dice: 0);
        }

        var wm = WeaponModel(
            name: 'creature:$id:specialized:weapon:${weapon.id}',
            id: 'creature:$id:specialized:weapon:${weapon.id}',
            skill: spSkill,
            weight: 0.0,
            bodyPart: EquipableItemBodyPart.hand,
            hands: 0,
            requirements: [],
            initiative: Map<WeaponRange, int>.fromEntries(
              weapon.ranges.keys.map( (WeaponRange r) => MapEntry(r, 0) )
            ),
            damage: AttributeBasedCalculator(
                static: weapon.damage.toDouble(),
                multiply: 1,
                add: 0,
                dice: 1
            ),
            rangeEffective: effective ?? contactRange,
            rangeMax: max ?? contactRange);

        var weaponInstance = wm.instantiate();
        for(var range in weapon.ranges.keys) {
          instance.addNaturalWeapon(range, weaponInstance);
        }
      }

      ret.add(instance);
    }

    return ret;
  }

  Creature clone(String newName) {
    var j = toJson();
    j.remove('uuid');
    j['location'] = ObjectLocation.memory.toJson();
    j['name'] = newName;
    return Creature.fromJson(j);
  }

  static Future<Creature?> get(String id) async {
    Creature? ret = _cache.entry(id);
    if(ret != null) return ret;

    CreatureSummary? summ = await CreatureSummary.get(id);
    if(summ == null) return null;

    if(summ.location.type == ObjectLocationType.assets) {
      ret = await loadFromAssets(summ.location.collectionUri, id);
    }
    else if(summ.location.type == ObjectLocationType.store) {
      ret = await CreatureStore().get(id);
    }

    return ret;
  }

  static Future<Creature?> loadFromAssets(String file, String id) async {
    for(var a in await loadJSONAssetObjectList(file)) {
      bool match = false;
      var m = a as Map<String, dynamic>;

      if(m.containsKey('uuid') && m['uuid'] == id) {
        match = true;
      }
      else {
        match = (id == _getId(m['name']));
      }

      if(match) return Creature.fromJson(m);
    }
    return null;
  }

  static Future<void> reloadFromStore(String id) async {
    _cache.del(id);
    await CreatureSummary._reloadFromStore(id);
  }

  static void removeFromCache(String id) {
    _cache.del(id);
    CreatureSummary._removeFromCache(id);
  }

  static Future<void> saveLocalModel(Creature model) async {
    await CreatureStore().save(model);
    await CreatureSummary._saveLocalModel(model.summary);
    _cache.add(model.id, model);
  }

  static Future<void> deleteLocalModel(String id) async {
    var model = await CreatureStore().get(id);
    if(model != null) {
      await CreatureStore().delete(model);
      await CreatureSummary._deleteLocalModel(id);
    }
    _cache.del(id);
  }

  static Future<void> init() async {
    // ignore:unused_local_variable
    var c = _cache;

    EntityInstanceModelRetriever.instance.registerRetriever(
      'creature',
      Creature.get,
    );

    EncounterEntityFactory.instance.registerFactory(
        'creature',
        _modelFactory,
        _creatureFactory
    );

    await CreatureSummary.init();
  }

  static void preImportFilter(Map<String, dynamic> json) {
    json.remove('uuid');
    json.remove('source');

    if(json.containsKey('unique') && json['unique'] && json.containsKey('equipment') && json['equipment'] is List) {
      for(Map<String, dynamic> e in json['equipment']) {
        e.remove('uuid');
      }
    }
  }

  static Future<Creature> import(Map<String, dynamic> json) async {
    preImportFilter(json);
    json['source'] = ObjectSource.local.toJson();

    /*
        Trying to find if this creature shadows one of the default creatures
     */
    var defaultId = sentenceToCamelCase(transliterateFrenchToAscii(json['name']));
    if(await CreatureSummary.exists(defaultId)) {
      throw(CreatureExistsException(id: defaultId));
    }

    var model = Creature.fromJson(json);
    await Creature.saveLocalModel(model);
    return model;
  }

  static String _getId(String name) =>
      sentenceToCamelCase(transliterateFrenchToAscii(name));

  static Future<EncounterEntityModel?> _modelFactory(String id) async {
    return get(id);
  }

  static Future<Iterable<EntityBase>> _creatureFactory(String id, int count) async {
    var m = await get(id);
    if(m == null) return <EntityBase>[];
    return m.instantiate(count: count);
  }

  static final _cache = ResourceMemoryCache<Creature>();

  factory Creature.fromJson(Map<String, dynamic> json) {
    Creature c = _$CreatureFromJson(json);
    c.loadNonRestorableJson(json);
    return c;
  }

  @override
  Map<String, dynamic> toJson() {
    var j = _$CreatureToJson(this);

    saveNonExportableJson(j);

    if(j.containsKey('unique') && j['unique'] && j.containsKey('equipment') && j['equipment'] is List) {
      for(Map<String, dynamic> e in j['equipment']) {
        e.remove('uuid');
      }
    }

    return j;
  }
}

class CreatureExistsException implements Exception {
  const CreatureExistsException({ required this.id });

  final String id;

  @override
  String toString() {
    return 'Une créature avec ce nom (ou un nom similaire existe déjà), ID: $id';
  }
}