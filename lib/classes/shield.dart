import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import 'dart:convert';

import 'entity/base.dart';
import 'combat.dart';
import 'entity/abilities.dart';
import 'equipment.dart';
import 'entity_base.dart';
import '../text_utils.dart';

class ShieldModel {
  ShieldModel({
    required this.id,
    required this.name,
    required this.weight,
    required this.requirements,
    required this.protection,
    required this.penalty,
    required this.damage,
  });

  final String id;
  final String name;
  final double weight;
  final List<(Ability,int)> requirements;
  final int protection;
  final int penalty;
  final AttributeBasedCalculator damage;

  Shield instantiate() {
    return Shield.create(model: this);
  }

  static List<String> ids() {
    if(!_defaultAssetsLoaded) loadDefaultAssets();
    return _models.keys.toList();
  }

  static ShieldModel? get(String id) {
    if(!_defaultAssetsLoaded) loadDefaultAssets();
    return _models[id];
  }

  static void register(ShieldModel model) {
    if(!_defaultAssetsLoaded) loadDefaultAssets();
    var id = sentenceToCamelCase(transliterateFrenchToAscii(model.name));
    if(!_models.containsKey(id)) _models[id] = model;
  }

  static Shield? _shieldFactory(String id, String uuid) {
    var model = get(id);
    if(model == null) return null;
    return Shield(uuid, model: model);
  }

  static Future<void> loadDefaultAssets() async {
    if(_defaultAssetsLoaded) return;
    _defaultAssetsLoaded = true;

    EquipmentFactory.instance.registerFactory('shield', _shieldFactory);

    var jsonStr = await rootBundle.loadString('assets/shield.json');
    var assets = json.decode(jsonStr);

    for(var model in assets) {
      var id = sentenceToCamelCase(transliterateFrenchToAscii(model['name']));

      var reqs = <(Ability,int)>[];
      for(var a in model['requirements'].keys) {
        reqs.add((Ability.values.byName(a),model['requirements'][a]));
      }

      AttributeBasedCalculator dmg = AttributeBasedCalculator.fromJson(model['damage']);

      _models[id] = ShieldModel(
        name: model['name'],
        id: id,
        weight: model['weight'],
        requirements: reqs,
        protection: model['protection'],
        penalty: model['penalty'],
        damage: dmg,
      );
    }
  }

  static bool _defaultAssetsLoaded = false;
  static final Map<String, ShieldModel> _models = <String, ShieldModel>{};
}

class Shield extends EquipableItem implements ProtectionProvider, DamageProvider {
  Shield(this._uuid, { required this.model })
    : super(bodyPart: EquipableItemBodyPart.hand, handiness: 1);

  Shield.create({ required this.model })
    : _uuid = const Uuid().v4().toString(),
      super(bodyPart: EquipableItemBodyPart.hand, handiness: 1);

  final String _uuid;
  final ShieldModel model;

  @override
  String type() => 'shield:${model.id}';

  @override
  String uuid() => _uuid;

  @override
  String name() => model.name;

  @override
  double weight() => model.weight;

  @override
  List<(Ability, int)> equipRequirements() => model.requirements;

  @override
  void equiped(SupportsEquipableItem owner, EquipableItemTarget target) {
    super.equiped(owner, target);

    if(owner is EntityBase) {
      owner.addProtectionProvider(this);
      owner.addDamageProvider(WeaponRange.contact, this);
      owner.addDamageProvider(WeaponRange.melee, this);
    }
  }

  @override
  void unequiped(SupportsEquipableItem owner) {
    super.unequiped(owner);

    if(owner is EntityBase) {
      owner.removeProtectionProvider(this);
      owner.removeDamageProvider(this);
    }
  }

  @override
  int protection() => model.protection;

  @override
  int damage(EntityBase owner, {List<int>? throws }) =>
      model.damage.calculate(
        model.damage.ability != null
            ? owner.abilities.ability(model.damage.ability!)
            : 0,
        throws: throws
      ).toInt();
}
