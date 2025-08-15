import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'combat.dart';
import 'encounter_entity_factory.dart';
import 'entity_base.dart';
import 'equipment.dart';
import 'exportable_binary_data.dart';
import 'object_location.dart';
import 'object_source.dart';
import 'weapon.dart';
import 'character/base.dart';
import 'character/injury.dart';
import 'character/skill.dart';
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
  static CreatureCategory animauxSauvages = CreatureCategory(title: "Animaux sauvages", isDefault: true);
  static CreatureCategory peuplesAnciens = CreatureCategory(title: "Peuples anciens", isDefault: true);
  static CreatureCategory creaturesDraconiques = CreatureCategory(title: "Créatures draconiques", isDefault: true);

  static CreatureCategory createNewCreatureCategory = CreatureCategory._create(title: "Créer cette catégorie", isDefault: true);

  static void _doStaticInit() {
    if(_staticInitDone) return;
    _staticInitDone = true;
    // ignore: unused_local_variable
    var ani = animauxSauvages;
    // ignore: unused_local_variable
    var peu = peuplesAnciens;
    // ignore: unused_local_variable
    var crea = creaturesDraconiques;
  }

  factory CreatureCategory({ required String title, bool isDefault = false }) {
    _doStaticInit();

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
    _doStaticInit();
    return _categories.values.toList();
  }

  static CreatureCategory byName(String name) {
    _doStaticInit();
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
  static bool _staticInitDone = false;
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
  final Map<WeaponRange, double> ranges;

  Map<String, dynamic> toJson() => _$NaturalWeaponModelToJson(this);
  factory NaturalWeaponModel.fromJson(Map<String, dynamic> json) => _$NaturalWeaponModelFromJson(json);
}

class NaturalArmor implements ProtectionProvider {
  NaturalArmor({ required this.value });

  final int value;

  @override
  int protection() => value;
}

class CreatureModelSummaryStore extends JsonStoreAdapter<CreatureModelSummary> {
  CreatureModelSummaryStore();

  @override
  String storeCategory() => 'creatureSummaries';

  @override
  String key(CreatureModelSummary object) => object.id;

  @override
  Future<CreatureModelSummary> fromJsonRepresentation(Map<String, dynamic> j) async {
    if(j.containsKey('icon') && j['icon'] is String) await restoreJsonBinaryData(j, 'icon');
    var summary = CreatureModelSummary.fromJson(j);
    summary.location = ObjectLocation(
      type: ObjectLocationType.store,
      collectionUri: '${getUriBase()}/${storeCategory()}',
    );
    return summary;
  }

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(CreatureModelSummary object) async {
    var j = object.toJson();
    if(object.icon != null) j['icon'] = object.icon!.hash;
    return j;
  }

  @override
  Future<void> willSave(CreatureModelSummary object) async {
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
  Future<void> willDelete(CreatureModelSummary object) async {
    if(object.icon != null) await BinaryDataStore().delete(object.icon!);
  }
}

class CreatureModelStore extends JsonStoreAdapter<CreatureModel> {
  CreatureModelStore();

  @override
  String storeCategory() => 'creatures';

  @override
  String key(CreatureModel object) => object.id;

  @override
  Future<CreatureModel> fromJsonRepresentation(Map<String, dynamic> j) async {
    if(j.containsKey('image') && j['image'] is String) await restoreJsonBinaryData(j, 'image');
    if(j.containsKey('icon') && j['icon'] is String) await restoreJsonBinaryData(j, 'icon');
    var model = CreatureModel.fromJson(j);
    model.location = ObjectLocation(
      type: ObjectLocationType.store,
      collectionUri: '${getUriBase()}/${storeCategory()}',
    );
    return model;
  }

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(CreatureModel object) async {
    var j = object.toJson();
    if(object.image != null) j['image'] = object.image!.hash;
    if(object.icon != null) j['icon'] = object.icon!.hash;
    return j;
  }

  @override
  Future<void> willSave(CreatureModel object) async {
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
  Future<void> willDelete(CreatureModel object) async {
    if(object.icon != null) await BinaryDataStore().delete(object.icon!);
    if(object.image != null) await BinaryDataStore().delete(object.image!);
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
@CreatureCategoryJsonConverter()
class CreatureModelSummary {
  CreatureModelSummary({
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

  static Future<List<String>> ids() async {
    return _summaries.keys.toList();
  }

  static bool exists(String id) => _summaries.containsKey(id);

  static Future<CreatureModelSummary?> get(String id) async {
    return _summaries[id];
  }

  static List<CreatureModelSummary> forCategory(CreatureCategory category, {String? nameFilter}) {
    return _summaries.values
        .where((CreatureModelSummary c) => c.category == category)
        .where((CreatureModelSummary c) => nameFilter == null || c.name.toLowerCase().contains(nameFilter.toLowerCase()))
        .toList();
  }

  static List<CreatureModelSummary> forSourceType(ObjectSourceType type, CreatureCategory? category, {String? nameFilter}) {
    return _summaries.values
        .where((CreatureModelSummary c) => c.source.type == type && (category == null || c.category == category))
        .where((CreatureModelSummary c) => nameFilter == null || c.name.toLowerCase().contains(nameFilter.toLowerCase()))
        .toList();
  }

  static List<CreatureModelSummary> forSource(ObjectSource source, CreatureCategory? category, {String? nameFilter}) {
    return _summaries.values
        .where((CreatureModelSummary c) => c.source == source && (category == null || c.category == category))
        .where((CreatureModelSummary c) => nameFilter == null || c.name.toLowerCase().contains(nameFilter.toLowerCase()))
        .toList();
  }

  static void _defaultAssetLoaded(CreatureModelSummary summary) {
    _summaries[summary.id] = summary;
  }

  static Future<void> _loadStoreAssets() async {
    for(var summary in await CreatureModelSummaryStore().getAll()) {
      _summaries[summary.id] = summary;
    }
  }

  static Future<void> _saveLocalModel(CreatureModelSummary summary) async {
    await CreatureModelSummaryStore().save(summary);
    _summaries[summary.id] = summary;
  }

  static Future<void> _deleteLocalModel(String id) async {
    var summary = await CreatureModelSummaryStore().get(id);
    if(summary != null) {
      CreatureModelSummaryStore().delete(summary);
    }
    _summaries.remove(id);
  }

  static final Map<String, CreatureModelSummary> _summaries = <String, CreatureModelSummary>{};

  factory CreatureModelSummary.fromJson(Map<String, dynamic> j) => _$CreatureModelSummaryFromJson(j);
  Map<String, dynamic> toJson() => _$CreatureModelSummaryToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
@CreatureCategoryJsonConverter()
class CreatureModel with EncounterEntityModel {
  CreatureModel(
      {
        String? uuid,
        required this.name,
        this.unique = false,
        required this.category,
        this.location = ObjectLocation.memory,
        required this.source,
        this.description = '',
        required this.biome,
        required this.size,
        required this.weight,
        double? mapSize,
        required this.abilities,
        required this.attributes,
        required this.initiative,
        required this.injuries,
        required this.naturalArmor,
        this.naturalArmorDescription = '',
        List<SkillInstance>? skills,
        List<NaturalWeaponModel>? naturalWeapons,
        List<String>? equipment,
        this.specialCapability = '',
        ExportableBinaryData? image,
        ExportableBinaryData? icon,
      })
    : uuid = uuid ?? (!location.type.canWrite ? null : Uuid().v4().toString()),
      mapSize = mapSize ?? 0.8,
      skills = skills ?? <SkillInstance>[],
      naturalWeapons = naturalWeapons ?? <NaturalWeaponModel>[],
      equipment = equipment ?? <String>[],
      _image = image,
      _icon = icon;

  String get id => uuid ?? sentenceToCamelCase(transliterateFrenchToAscii(name));
  @JsonKey(includeIfNull: false)
    final String? uuid;
  final String name;
  bool unique;
  CreatureCategory category;
  @JsonKey(includeFromJson: true, includeToJson: false)
    ObjectLocation location;
  ObjectSource source;
  String description;
  String biome;
  String size;
  String weight;
  double mapSize;
  final Map<Ability, int> abilities;
  final Map<Attribute, int> attributes;
  int initiative;
  final List<InjuryLevel> injuries;
  int naturalArmor;
  String naturalArmorDescription;
  final List<SkillInstance> skills;
  List<NaturalWeaponModel> naturalWeapons;
  List<String> equipment = <String>[];
  String specialCapability;

  CreatureModelSummary get summary => CreatureModelSummary(
      id: id,
      name: name,
      category: category,
      location: location,
      source: source,
      icon: icon?.clone(),
    );

  ExportableBinaryData? get image => _image;
  set image(ExportableBinaryData? i) {
    if(_image != null && (i == null || _image!.hash != i.hash)) BinaryDataStore().delete(_image!);
    _image = i;
  }
  ExportableBinaryData? _image;

  ExportableBinaryData? get icon => _icon;
  set icon(ExportableBinaryData? i) {
    if(_icon != null && (i == null || _icon!.hash != i.hash)) BinaryDataStore().delete(_icon!);
    _icon = i;
  }
  ExportableBinaryData? _icon;

  @override
  String displayName() => name;

  @override
  bool isUnique() => unique;

  @override
  List<EntityBase> instantiate({ int count = 1 }) {
    var ret = <Creature>[];

    for(var idx = 0; idx < count; ++idx) {
      var creature = Creature(
        location: location,
        name: '$name #${idx+1}',
        initiative: initiative,
        injuryProvider: (EntityBase? e, InjuryManager? i) =>
            InjuryManager(
              levels: injuries,
            ),
        size: mapSize,
        image: image,
        icon: icon,
      );

      creature.addProtectionProvider(NaturalArmor(value: naturalArmor));

      for(var a in abilities.keys) {
        creature.setAbility(a, abilities[a]!);
      }
      for(var a in attributes.keys) {
        creature.setAttribute(a, attributes[a]!);
      }
      for(var s in skills) {
        creature.setSkill(s.skill, s.value);

        for(var sp in s.specializations.keys) {
          creature.setSpecializedSkill(sp, s.specializations[sp]!);
        }
      }

      var contactRange = AttributeBasedCalculator(
          static: 0.5,
          multiply: 0,
          add: 0,
          dice: 0);

      for(var weapon in naturalWeapons) {
        var spSkillId = 'creature:$id:specialized:combat:${weapon.id}';
        var spSkill = SpecializedSkill.create(spSkillId, Skill.creatureNaturalWeapon, title: weapon.name, reserved: true);
        creature.setSpecializedSkill(spSkill, weapon.skill);

        AttributeBasedCalculator? effective;
        AttributeBasedCalculator? max;

        if(weapon.ranges.containsKey(WeaponRange.contact)) {
          effective = AttributeBasedCalculator(
              static: weapon.ranges[WeaponRange.contact]!,
              multiply: 0,
              add: 0,
              dice: 0);
          max = effective;
        }
        else if(weapon.ranges.containsKey(WeaponRange.melee)) {
          effective = AttributeBasedCalculator(
              static: weapon.ranges[WeaponRange.melee]!,
              multiply: 0,
              add: 0,
              dice: 0);
          max = effective;
        }
        else if(weapon.ranges.containsKey(WeaponRange.distance)) {
          effective = AttributeBasedCalculator(
              static: weapon.ranges[WeaponRange.distance]!,
              multiply: 0,
              add: 0,
              dice: 0);
          max = effective;
        }
        else if(weapon.ranges.containsKey(WeaponRange.ranged)) {
          effective = AttributeBasedCalculator(
              static: weapon.ranges[WeaponRange.ranged]!,
              multiply: 0,
              add: 0,
              dice: 0);
          max = AttributeBasedCalculator(
              static: weapon.ranges[WeaponRange.ranged]! * 2,
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

        var instance = wm.instantiate();
        for(var range in weapon.ranges.keys) {
          creature.addNaturalWeapon(range, instance);
        }
      }

      for(var e in equipment) {
        var ids = e.split(':');
        if (ids.length < 2) continue;
        var factory = EquipmentFactory.instance.getFactory(ids[0]);
        if (factory == null) continue;

        var eq = factory(ids[1], const Uuid().v4().toString());
        if (eq != null) {
          creature.addEquipment(eq);
        }
      }

      ret.add(creature);
    }

    return ret;
  }

  static Future<CreatureModel?> get(String id) async {
    if(!_defaultAssetsLoaded) await loadDefaultAssets();

    if(CreatureModelSummary.exists(id) == false) {
      return null;
    }

    if(!_models.containsKey(id)) {
      var model = await CreatureModelStore().get(id);
      if(model == null) {
        return null;
      }
      _models[id] = model;
    }
    return _models[id];
  }

  static EncounterEntityModel? _modelFactory(String id) {
    return _models[id];
  }

  static List<EntityBase> _creatureFactory(String id, int count) {
    if(!_models.containsKey(id)) return <EntityBase>[];
    return _models[id]!.instantiate(count: count);
  }

  static Future<void> loadDefaultAssets() async {
    if(_defaultAssetsLoaded) return;
    _defaultAssetsLoaded = true;

    EncounterEntityFactory.instance.registerFactory(
        'creature',
        _modelFactory,
        _creatureFactory);

    for(var model in await loadJSONAssetObjectList('creature-ldb2e.json')) {
      var instance = CreatureModel.fromJson(model);
      CreatureModelSummary._defaultAssetLoaded(instance.summary);
      _models[instance.id] = instance;
    }
  }

  static Future<void> loadStoreAssets() async {
    await CreatureModelSummary._loadStoreAssets();
  }

  static Future<void> saveLocalModel(CreatureModel model) async {
    await CreatureModelStore().save(model);
    await CreatureModelSummary._saveLocalModel(model.summary);
    _models[model.id] = model;
  }

  static Future<void> deleteLocalModel(String id) async {
    var model = await CreatureModelStore().get(id);
    if(model != null) {
      await CreatureModelStore().delete(model);
      await CreatureModelSummary._deleteLocalModel(id);
    }
    _models.remove(id);
  }

  static bool _defaultAssetsLoaded = false;
  static final Map<String, CreatureModel> _models = <String, CreatureModel>{};

  CreatureModel clone(String newName) {
    var j = toJson();
    j['location'] = ObjectLocation.memory.toJson();
    j['name'] = newName;
    return CreatureModel.fromJson(j);
  }

  factory CreatureModel.fromJson(Map<String, dynamic> json) => _$CreatureModelFromJson(json);
  Map<String, dynamic> toJson() => _$CreatureModelToJson(this);
}

class Creature extends EntityBase {
  Creature(
      {
        super.uuid,
        super.location = ObjectLocation.memory,
        required super.name,
        super.initiative,
        super.injuryProvider,
        super.size,
        super.image,
        super.icon,
      }
  );
}