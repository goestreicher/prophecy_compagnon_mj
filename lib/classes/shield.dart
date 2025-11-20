import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'dart:convert';

import 'entity/base.dart';
import 'combat.dart';
import 'entity/abilities.dart';
import 'equipment.dart';
import 'entity_base.dart';
import '../text_utils.dart';

part 'shield.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ShieldModel extends EquipmentModel {
  ShieldModel({
    required this.id,
    required super.name,
    required super.weight,
    required super.creationDifficulty,
    required super.creationTime,
    required super.villageAvailability,
    required super.cityAvailability,
    required this.requirements,
    required this.protection,
    required this.penalty,
    required this.damage,
  });

  @override
  String get uuid => id;

  @JsonKey(includeToJson: false, readValue: _getIdFromJson)
  final String id;
  final Map<Ability, int> requirements;
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
      var id = _getIdFromJson(model, 'name') as String;
      _models[id] = ShieldModel.fromJson(model);
    }
  }

  static Object? _getIdFromJson(Map<dynamic, dynamic> json, _) =>
      sentenceToCamelCase(transliterateFrenchToAscii(json['name']));

  static bool _defaultAssetsLoaded = false;
  static final Map<String, ShieldModel> _models = <String, ShieldModel>{};

  factory ShieldModel.fromJson(Map<String, dynamic> json) =>
      _$ShieldModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ShieldModelToJson(this);
}

class Shield extends EquipableItem implements ProtectionProvider, DamageProvider {
  Shield(this._uuid, { required this.model })
    : super(
        name: model.name,
        weight: model.weight,
        bodyPart: EquipableItemBodyPart.hand,
        handiness: 1
      );

  Shield.create({ required this.model })
    : _uuid = const Uuid().v4().toString(),
      super(
        name: model.name,
        weight: model.weight,
        bodyPart: EquipableItemBodyPart.hand,
        handiness: 1
      );

  final String _uuid;
  final ShieldModel model;

  @override
  String type() => 'shield:${model.id}';

  @override
  String uuid() => _uuid;

  @override
  Map<Ability, int> equipRequirements() => model.requirements;

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
