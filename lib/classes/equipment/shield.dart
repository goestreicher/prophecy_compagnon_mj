import 'package:json_annotation/json_annotation.dart';
import 'package:synchronized/synchronized.dart';
import 'package:uuid/uuid.dart';

import '../entity/base.dart';
import '../combat.dart';
import '../entity/abilities.dart';
import 'equipment.dart';
import '../entity_base.dart';
import '../object_location.dart';
import '../object_source.dart';
import '../storage/default_assets_store.dart';
import '../storage/storable.dart';

part 'shield.g.dart';

class ShieldModelStore extends JsonStoreAdapter<ShieldModel> {
  @override
  String storeCategory() => 'shieldModels';

  @override
  String key(ShieldModel object) => object.id;

  @override
  Future<ShieldModel> fromJsonRepresentation(Map<String, dynamic> j) async =>
      ShieldModel.fromJson(j);

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(ShieldModel object) async =>
      object.toJson();
}

class _ShieldFactoryImplementation implements EquipmentFactoryImplementation {
  @override
  EquipmentModel? model(String id) {
    return ShieldModel.get(id);
  }

  @override
  Equipment? forge(String id, Map<String, dynamic>? json) {
    var m = ShieldModel.get(id);
    if(m == null) return null;

    if(json != null && json.containsKey('uuid')) {
      return Shield(json['uuid'], model: m);
    }
    else {
      return Shield.create(model: m);
    }
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ShieldModel extends EquipableItemModel {
  factory ShieldModel({
    required String uuid,
    required String name,
    bool unique = false,
    required ObjectSource source,
    ObjectLocation location = ObjectLocation.memory,
    String description = '',
    required double weight,
    required int creationDifficulty,
    required int creationTime,
    required EquipmentAvailability villageAvailability,
    required EquipmentAvailability cityAvailability,
    EquipableItemSlot slot = EquipableItemSlot.hands,
    int handiness = 1,
    EquipableItemLayer layer = EquipableItemLayer.normal,
    required Map<Ability, int> requirements,
    required int protection,
    required int penalty,
    required AttributeBasedCalculator damage,
    bool supportsMetal = false,
    List<EquipmentSpecialCapability>? special,
  })
  {
    var sm = _cache[uuid]
        ?? ShieldModel._create(
            uuid: uuid,
            name: name,
            unique: unique,
            source: source,
            location: location,
            description: description,
            weight: weight,
            creationDifficulty: creationDifficulty,
            creationTime: creationTime,
            villageAvailability: villageAvailability,
            cityAvailability: cityAvailability,
            slot: slot,
            handiness: handiness,
            layer: layer,
            requirements: requirements,
            protection: protection,
            penalty: penalty,
            damage: damage,
            supportsMetal: supportsMetal,
            special: special,
        );
    _cache[sm.id] = sm;
    return sm;
  }

  ShieldModel._create({
    required super.uuid,
    required super.name,
    super.unique,
    required super.source,
    super.location,
    super.description,
    required super.weight,
    required super.creationDifficulty,
    required super.creationTime,
    required super.villageAvailability,
    required super.cityAvailability,
    super.slot = EquipableItemSlot.hands,
    super.handiness = 1,
    super.layer,
    required this.requirements,
    required this.protection,
    required this.penalty,
    required this.damage,
    super.supportsMetal,
    super.special,
  });

  Map<Ability, int> requirements;
  int protection;
  int penalty;
  AttributeBasedCalculator damage;

  Shield instantiate() {
    return Shield.create(model: this);
  }

  static Iterable<String> ids() => _cache.keys;

  static ShieldModel? get(String id) => _cache[id];

  static Future<void> init() async {
    // ignore:unused_local_variable
    var c = _cache;
    await loadAll();
  }

  static Future<void> loadAll() async {
    EquipmentFactory.instance.registerFactory('shield', _ShieldFactoryImplementation());

    await _loadLock.synchronized(() async {
      var assetFiles = [
        'shield.json',
      ];

      for (var f in assetFiles) {
        for (var model in await loadJSONAssetObjectList(f)) {
          try {
            // ignore:unused_local_variable
            var instance = ShieldModel.fromJson(model);
            _cache[instance.id] = instance;
          } catch (e, stacktrace) {
            print('Error loading shield ${model["name"]}: ${e.toString()}\n${stacktrace.toString()}');
          }
        }
      }

      for(var instance in (await ShieldModelStore().getAll())) {
        _cache[instance.id] = instance;
      }
    });
  }

  static Future<void> saveLocalModel(ShieldModel shield) async {
    await ShieldModelStore().save(shield);
    _cache[shield.id] = shield;
  }

  static Future<void> deleteLocalModel(String id) async {
    var shield = await ShieldModelStore().get(id);
    if(shield != null) await ShieldModelStore().delete(shield);
    _cache.remove(id);
  }

  static final Map<String, ShieldModel> _cache = <String, ShieldModel>{};
  static final _loadLock = Lock();

  factory ShieldModel.fromJson(Map<String, dynamic> json) =>
      _$ShieldModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ShieldModelToJson(this);
}

class Shield extends EquipableItem implements ProtectionProvider, DamageProvider {
  Shield(this._uuid, {
    required super.model,
    super.alias,
    super.quality,
    super.metal,
  });

  Shield.create({
    required super.model,
    super.alias,
    super.quality,
    super.metal,
  })
    : _uuid = const Uuid().v4().toString();

  final String _uuid;

  @override
  String type() => 'shield:${model.id}';

  @override
  String uuid() => _uuid;

  @override
  Map<Ability, int> equipRequirements() => (model as ShieldModel).requirements;

  @override
  void equiped(SupportsEquipableItem owner, EquipableItemSlot target) {
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
  int protection() => (model as ShieldModel).protection;

  @override
  int damage(EntityBase owner, {List<int>? throws }) =>
      (model as ShieldModel).damage.calculate(
          (model as ShieldModel).damage.ability != null
            ? owner.abilities.ability((model as ShieldModel).damage.ability!)
            : 0,
        throws: throws
      ).toInt();
}
