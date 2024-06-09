import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
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

@JsonSerializable(fieldRename: FieldRename.snake)
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

@JsonSerializable(fieldRename: FieldRename.snake)
class CreatureModel extends EncounterEntityModel {
  CreatureModel(
      {
        required this.name,
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

  @override
  String displayName() => name;

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

  static List<String> ids() {
    if(!_defaultAssetsLoaded) loadDefaultAssets();
    return _models.keys.toList();
  }
  static CreatureModel? get(String id) {
    if(!_defaultAssetsLoaded) loadDefaultAssets();
    return _models[id];
  }

  static List<CreatureModel> forCategory(CreatureCategory category) {
    var ret = <CreatureModel>[];
    for(var model in _models.values) {
      if(model.category == category) ret.add(model);
    }
    return ret;
  }

  static List<CreatureModel> forSource(String source, CreatureCategory? category) {
    return _models.values
        .where((CreatureModel c) => c.source == source && (category == null || c.category == category!))
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
      _models[instance.id] = instance;
    }

    var box = await Hive.openLazyBox('creaturesBox');
    for(var id in box.keys) {
      var model = await box.get(id);
      var instance = CreatureModel.fromJson(json.decode(model));
      instance.editable = true;
      _models[instance.id] = instance;
    }
  }

  static Future<void> saveLocalModel(CreatureModel model) async {
    var box = await Hive.openLazyBox('creaturesBox');
    await box.put(model.id, json.encode(model.toJson()));
    _models[model.id] = model;
  }

  static Future<void> deleteLocalModel(String id) async {
    var box = await Hive.openLazyBox('creaturesBox');
    await box.delete(id);
    _models.remove(id);
  }

  static bool _defaultAssetsLoaded = false;
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