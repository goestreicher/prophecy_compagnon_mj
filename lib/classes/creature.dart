import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'encounter_entity_factory.dart';
import 'entity_base.dart';
import 'equipment.dart';
import 'combat.dart';
import 'weapon.dart';
import 'character/base.dart';
import 'character/injury.dart';
import 'character/skill.dart';
import 'storage/storable.dart';
import '../text_utils.dart';

part 'creature.g.dart';

enum CreatureCategory {
  animauxSauvages(title: "Animaux sauvages"),
  peuplesAnciens(title: "Peuples anciens"),
  creaturesDraconiques(title: "Créatures draconiques")
  ;

  const CreatureCategory({ required this.title });

  final String title;
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
  Future<CreatureModelSummary> fromJsonRepresentation(Map<String, dynamic> j) async =>
      CreatureModelSummary.fromJson(j);

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(CreatureModelSummary object) async =>
      object.toJson();
}

class CreatureModelStore extends JsonStoreAdapter<CreatureModel> {
  CreatureModelStore();

  @override
  String storeCategory() => 'creatures';

  @override
  String key(CreatureModel object) => object.id;

  @override
  Future<CreatureModel> fromJsonRepresentation(Map<String, dynamic> j) async => CreatureModel.fromJson(j);

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(CreatureModel object) async => object.toJson();
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CreatureModelSummary {
  CreatureModelSummary({
    required this.id,
    required this.name,
    required this.category,
    required this.source,
  });

  String id;
  String name;
  CreatureCategory category;
  String source;

  factory CreatureModelSummary.fromJson(Map<String, dynamic> j) => _$CreatureModelSummaryFromJson(j);
  Map<String, dynamic> toJson() => _$CreatureModelSummaryToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CreatureModel with EncounterEntityModel {
  CreatureModel(
      {
        required this.name,
        this.unique = false,
        required this.category,
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
      })
    : id = sentenceToCamelCase(transliterateFrenchToAscii(name)),
      mapSize = mapSize ?? 0.8,
      skills = skills ?? <SkillInstance>[],
      naturalWeapons = naturalWeapons ?? <NaturalWeaponModel>[],
      equipment = equipment ?? <String>[];

  @JsonKey(includeToJson: false, includeFromJson: false)
    String id;
  @JsonKey(includeToJson: false, includeFromJson: false)
    bool editable = false;
  final String name;
  bool unique;
  CreatureCategory category;
  String source;
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
      source: source,
    );

  @override
  String displayName() => name;

  @override
  bool isUnique() => unique;

  @override
  List<EntityBase> instantiate({ int count = 1 }) {
    var ret = <Creature>[];

    for(var idx = 0; idx < count; ++idx) {
      var creature = Creature.create(
        name: '$name #${idx+1}',
        initiative: initiative,
        injuryProvider: (EntityBase? e, InjuryManager? i) =>
            InjuryManager(
              levels: injuries,
            ),
        size: mapSize,
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

  static Future<List<String>> ids() async {
    if(!_defaultAssetsLoaded) await loadDefaultAssets();
    return _summaries.keys.toList();
  }

  static Future<CreatureModelSummary?> getSummary(String id) async {
    if(!_defaultAssetsLoaded) await loadDefaultAssets();
    return _summaries[id];
  }

  static Future<CreatureModel?> get(String id) async {
    if(!_defaultAssetsLoaded) await loadDefaultAssets();

    if(!_summaries.containsKey(id)) {
      return null;
    }

    if(!_models.containsKey(id)) {
      var model = await CreatureModelStore().get(id);
      if(model == null) {
        return null;
      }
      model.editable = true;
      _models[id] = model;
    }
    return _models[id];
  }

  static List<CreatureModelSummary> forCategory(CreatureCategory category) {
    var ret = <CreatureModelSummary>[];
    for(var summary in _summaries.values) {
      if(summary.category == category) ret.add(summary);
    }
    return ret;
  }

  static List<CreatureModelSummary> forSource(String source, CreatureCategory? category) {
    return _summaries.values
        .where((CreatureModelSummary c) => c.source == source && (category == null || c.category == category))
        .toList();
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

    var jsonStr = await rootBundle.loadString('assets/creature-ldb2e.json');
    var assets = json.decode(jsonStr);

    for(var model in assets) {
      var instance = CreatureModel.fromJson(model);
      _summaries[instance.id] = instance.summary;
      _models[instance.id] = instance;
    }

    for(var summary in await CreatureModelSummaryStore().getAll()) {
      _summaries[summary.id] = summary;
    }
  }

  static Future<void> saveLocalModel(CreatureModel model) async {
    await CreatureModelSummaryStore().save(model.summary);
    await CreatureModelStore().save(model);
    _summaries[model.id] = model.summary;
    _models[model.id] = model;
  }

  static Future<void> deleteLocalModel(String id) async {
    var model = await CreatureModelStore().get(id);
    if(model != null) {
      await CreatureModelSummaryStore().delete(model.summary);
      await CreatureModelStore().delete(model);
    }
    _summaries.remove(id);
    _models.remove(id);
  }

  static bool _defaultAssetsLoaded = false;
  static final Map<String, CreatureModelSummary> _summaries = <String, CreatureModelSummary>{};
  static final Map<String, CreatureModel> _models = <String, CreatureModel>{};
  static const String localCreatureSource = 'LOCAL_CREATED';

  factory CreatureModel.fromJson(Map<String, dynamic> json) => _$CreatureModelFromJson(json);
  Map<String, dynamic> toJson() => _$CreatureModelToJson(this);
}

class Creature extends EntityBase {
  Creature(
      super.uuid,
      {
        required super.name,
        super.initiative,
        super.injuryProvider,
        super.size,
      }
  );

  Creature.create(
      {
        required super.name,
        super.initiative,
        super.injuryProvider,
        super.size,
      })
    : super.create();
}