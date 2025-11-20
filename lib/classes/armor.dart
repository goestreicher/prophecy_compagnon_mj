import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'dart:convert';

import 'entity/abilities.dart';
import 'entity_base.dart';
import 'equipment.dart';
import '../text_utils.dart';

part 'armor.g.dart';

enum ArmorType {
  light(title: "Armure légère"),
  medium(title: "Armure moyenne"),
  heavy(title: "Armure lourde");

  const ArmorType({ required this.title });

  final String title;
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ArmorModel extends EquipmentModel {
  ArmorModel({
    required this.id,
    required super.name,
    required super.weight,
    required super.creationDifficulty,
    required super.creationTime,
    required super.villageAvailability,
    required super.cityAvailability,
    required this.type,
    required this.requirements,
    required this.protection,
    required this.penalty,
  });

  @override
  String get uuid => id;

  @JsonKey(includeToJson: false, readValue: _getIdFromJson)
  final String id;
  final ArmorType type;
  final Map<Ability,int> requirements;
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
      var id = _getIdFromJson(model, 'name') as String;
      _models[id] = ArmorModel.fromJson(model);
    }
  }

  static Object? _getIdFromJson(Map<dynamic, dynamic> json, _) =>
      sentenceToCamelCase(transliterateFrenchToAscii(json['name']));

  static bool _defaultAssetsLoaded = false;
  static final Map<String, ArmorModel> _models = <String, ArmorModel>{};

  factory ArmorModel.fromJson(Map<String, dynamic> json) =>
      _$ArmorModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ArmorModelToJson(this);
}

class Armor extends EquipableItem implements ProtectionProvider {
  Armor(this._uuid, { required this.model })
    : super(
        name: model.name,
        weight: model.weight,
        bodyPart: EquipableItemBodyPart.body,
        handiness: 0
      );

  Armor.create({ required this.model })
    : _uuid = const Uuid().v4().toString(),
      super(
        name: model.name,
        weight: model.weight,
        bodyPart: EquipableItemBodyPart.body,
        handiness: 0
      );

  final String _uuid;
  final ArmorModel model;

  @override
  String type() => 'armor:${model.id}';

  @override
  String uuid() => _uuid;

  @override
  Map<Ability, int> equipRequirements() => model.requirements;

  @override
  void equiped(SupportsEquipableItem owner, EquipableItemTarget target) {
    super.equiped(owner, target);

    if(owner is EntityBase) {
      owner.addProtectionProvider(this);
    }
  }

  @override
  void unequiped(SupportsEquipableItem owner) {
    super.unequiped(owner);

    if(owner is EntityBase) {
      owner.removeProtectionProvider(this);
    }
  }

  @override
  int protection() => model.protection;
}