import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import 'combat.dart';
import 'equipment.dart';
import 'entity_base.dart';
import 'character/base.dart';
import 'character/skill.dart';
import '../text_utils.dart';

class WeaponModel {
  WeaponModel({
    required this.name,
    required this.id,
    required this.skill,
    required this.weight,
    required this.bodyPart,
    required this.hands,
    required this.requirements,
    required this.initiative,
    required this.damage,
    required this.rangeEffective,
    required this.rangeMax,
  });

  final String name;
  final String id;
  final SpecializedSkill skill;
  final double weight;
  final EquipableItemBodyPart bodyPart;
  final int hands;
  final List<(Ability,int)> requirements;
  final Map<WeaponRange, int> initiative;
  final AttributeBasedCalculator damage;
  final AttributeBasedCalculator rangeEffective;
  final AttributeBasedCalculator rangeMax;

  WeaponRange get range {
    return initiative.keys.reduce((value, element) => element.index > value.index ? element : value);
  }

  Weapon instantiate() {
    return Weapon.create(model: this);
  }

  static List<String> ids() {
    if(!_defaultAssetsLoaded) loadDefaultAssets();
    return _models.keys.toList();
  }

  static List<String> idsBySkill(Skill skill) {
    if(!_defaultAssetsLoaded) loadDefaultAssets();
    var ret = <String>[];
    for(var wm in _models.values) {
      if(wm.skill.parent == skill) ret.add(wm.id);
    }
    return ret;
  }

  static WeaponModel? get(String id) {
    if(!_defaultAssetsLoaded) loadDefaultAssets();
    return _models[id];
  }

  static void register(WeaponModel model) {
    if(!_defaultAssetsLoaded) loadDefaultAssets();
    var id = sentenceToCamelCase(transliterateFrenchToAscii(model.name));
    if(!_models.containsKey(id)) _models[id] = model;
  }

  static Weapon? _weaponFactory(String id, String uuid) {
    var model = get(id);
    if(model == null) return null;
    return Weapon(uuid, model: model);
  }

  static Future<void> loadDefaultAssets() async {
    if(_defaultAssetsLoaded) return;
    _defaultAssetsLoaded = true;

    EquipmentFactory.instance.registerFactory('weapon', _weaponFactory);

    var jsonStr = await rootBundle.loadString('assets/weapon.json');
    var assets = json.decode(jsonStr);

    for(var model in assets) {
      var id = sentenceToCamelCase(transliterateFrenchToAscii(model['name']));
      var skill = Skill.values.byName(model['skill']);
      var sp = SpecializedSkill.create('${skill.name}:$id', skill, title: model['name']);

      var reqs = <(Ability,int)>[];
      for(var a in model['requirements'].keys) {
        reqs.add((Ability.values.byName(a),model['requirements'][a]));
      }

      var init = <WeaponRange, int>{};
      for(var i in model['initiative'].keys) {
        var r = WeaponRange.values.byName(i);
        init[r] = model['initiative'][i];
      }

      AttributeBasedCalculator dmg = AttributeBasedCalculator(
          static: (model['damage']['static'] as num).toDouble(),
          multiply: model['damage']['multiply'],
          add: model['damage']['add'],
          dice: model['damage']['dice']);

      AttributeBasedCalculator rEff = AttributeBasedCalculator(
          static: (model['range']['eff']['static'] as num).toDouble(),
          multiply: model['range']['eff']['multiply'],
          add: model['range']['eff']['add'],
          dice: model['range']['eff']['dice']);
      AttributeBasedCalculator rMax = AttributeBasedCalculator(
          static: (model['range']['max']['static'] as num).toDouble(),
          multiply: model['range']['max']['multiply'],
          add: model['range']['max']['add'],
          dice: model['range']['max']['dice']);

      _models[id] = WeaponModel(
          name: model['name'],
          id: id,
          skill: sp,
          weight: model['weight'],
          bodyPart: EquipableItemBodyPart.values.byName(model['body_part']),
          hands: model['hands'],
          requirements: reqs,
          initiative: init,
          damage: dmg,
          rangeEffective: rEff,
          rangeMax: rMax,
      );
    }
  }

  static bool _defaultAssetsLoaded = false;
  static final Map<String, WeaponModel> _models = <String, WeaponModel>{};
}

class Weapon extends EquipableItem implements DamageProvider, InitiativeProvider {
  Weapon(this._uuid, { required this.model })
    : super(bodyPart: model.bodyPart, handiness: model.hands);

  Weapon.create({ required this.model })
    : _uuid = const Uuid().v4().toString(),
      super(bodyPart: EquipableItemBodyPart.hand, handiness: model.hands);

  final String _uuid;
  final WeaponModel model;

  @override
  String type() => 'weapon:${model.id}';

  @override
  String uuid() => _uuid;

  @override
  String name() => model.name;

  @override
  double weight() => model.weight;

  @override
  List<(Ability, int)> equipRequirements() => model.requirements;

  @override
  void equiped(SupportsEquipableItem owner) {
    if(owner is EntityBase) {
      for (var range in model.initiative.keys) {
        owner.addDamageProvider(range, this);
      }
    }
  }

  @override
  void unequiped(SupportsEquipableItem owner) {
    if(owner is EntityBase) {
      owner.removeDamageProvider(this);
    }
  }

  @override
  int damage(EntityBase owner, {List<int>? throws })
    => model.damage.calculate(owner.ability(Ability.force), throws: throws).toInt();

  @override
  int initiativeForRange(WeaponRange range) {
    int ret = 0;
    WeaponRange selected = WeaponRange.contact;
    for(var r in model.initiative.keys) {
      if(r.index >= selected.index && r.index <= range.index) {
        selected = r;
        ret = model.initiative[r]!;
      }
    }
    return ret;
  }
}