import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import 'dart:convert';

import 'entity_base.dart';
import 'equipment.dart';
import 'character/base.dart';
import '../text_utils.dart';

enum ArmorType {
  light(title: "Armure légère"),
  medium(title: "Armure moyenne"),
  heavy(title: "Armure lourde");

  const ArmorType({ required this.title });

  final String title;
}

class ArmorModel {
  ArmorModel({
    required this.name,
    required this.id,
    required this.type,
    required this.requirements,
    required this.protection,
    required this.weight,
    required this.penalty,
  });

  final String name;
  final String id;
  final ArmorType type;
  final int weight;
  final List<(Ability,int)> requirements;
  final int protection;
  final int penalty;

  Armor instantiate() {
    return Armor.create(model: this);
  }

  static List<String> ids() {
    if(!_defaultAssetsLoaded) loadDefaultAssets();
    return _models.keys.toList();
  }
  static List<String> idsByType(ArmorType type) {
    if(!_defaultAssetsLoaded) loadDefaultAssets();
    var ret = <String>[];
    for(var am in _models.values) {
      if(am.type == type) ret.add(am.id);
    }
    return ret;
  }
  static ArmorModel? get(String id) {
    if(!_defaultAssetsLoaded) loadDefaultAssets();
    return _models[id];
  }
  static void register(ArmorModel model) {
    if(!_defaultAssetsLoaded) loadDefaultAssets();
    var id = sentenceToCamelCase(transliterateFrenchToAscii(model.name));
    if(!_models.containsKey(id)) _models[id] = model;
  }
  static Armor? _armorFactory(String id, String uuid) {
    var model = get(id);
    if(model == null) return null;
    return Armor(uuid, model: model);
  }

  static Future<void> loadDefaultAssets() async {
    if(_defaultAssetsLoaded) return;
    _defaultAssetsLoaded = true;

    EquipmentFactory.instance.registerFactory('armor', _armorFactory);

    var jsonStr = await rootBundle.loadString('assets/armor.json');
    var assets = json.decode(jsonStr);

    for(var model in assets) {
      var id = sentenceToCamelCase(transliterateFrenchToAscii(model['name']));

      var reqs = <(Ability,int)>[];
      for(var a in model['requirements'].keys) {
        reqs.add((Ability.values.byName(a),model['requirements'][a]));
      }

      _models[id] = ArmorModel(
          name: model['name'],
          id: id,
          type: ArmorType.values.byName(model['type']),
          requirements: reqs,
          protection: model['protection'],
          weight: model['weight'],
          penalty: model['penalty']
      );
    }
  }

  static bool _defaultAssetsLoaded = false;
  static final Map<String, ArmorModel> _models = <String, ArmorModel>{};
}

class Armor extends EquipableItem implements ProtectionProvider {
  Armor(this._uuid, { required this.model })
    : super(bodyPart: EquipableItemBodyPart.body, handiness: 0);

  Armor.create({ required this.model })
    : _uuid = const Uuid().v4().toString(),
      super(bodyPart: EquipableItemBodyPart.body, handiness: 0);

  final String _uuid;
  final ArmorModel model;

  @override
  String type() => 'armor:${model.id}';

  @override
  String uuid() => _uuid;

  @override
  String name() => model.name;

  @override
  double weight() => model.weight as double;

  @override
  List<(Ability, int)> equipRequirements() => model.requirements;

  @override
  void equiped(SupportsEquipableItem owner) {
    if(owner is EntityBase) {
      owner.addProtectionProvider(this);
    }
  }

  @override
  void unequiped(SupportsEquipableItem owner) {
    if(owner is EntityBase) {
      owner.removeProtectionProvider(this);
    }
  }

  @override
  int protection() => model.protection;
}