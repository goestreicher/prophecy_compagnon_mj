import 'package:json_annotation/json_annotation.dart';
import 'package:synchronized/synchronized.dart';
import 'package:uuid/uuid.dart';

import 'entity/base.dart';
import 'combat.dart';
import 'entity/abilities.dart';
import 'equipment.dart';
import 'entity_base.dart';
import 'object_location.dart';
import 'object_source.dart';
import 'storage/default_assets_store.dart';
import 'storage/storable.dart';

part 'shield.g.dart';

class ShieldStore extends JsonStoreAdapter<ShieldModel> {
  @override
  String storeCategory() => 'shields';

  @override
  String key(ShieldModel object) => object.id;

  @override
  Future<ShieldModel> fromJsonRepresentation(Map<String, dynamic> j) async =>
      ShieldModel.fromJson(j);

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(ShieldModel object) async =>
      object.toJson();
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ShieldModel extends EquipmentModel {
  factory ShieldModel({
    required String uuid,
    required String name,
    required ObjectSource source,
    ObjectLocation location = ObjectLocation.memory,
    required double weight,
    required int creationDifficulty,
    required int creationTime,
    required EquipmentAvailability villageAvailability,
    required EquipmentAvailability cityAvailability,
    required Map<Ability, int> requirements,
    required int protection,
    required int penalty,
    required AttributeBasedCalculator damage,
    List<EquipmentSpecialCapability>? special,
  })
  {
    var sm = _cache[uuid]
        ?? ShieldModel._create(
            uuid: uuid,
            name: name,
            source: source,
            location: location,
            weight: weight,
            creationDifficulty: creationDifficulty,
            creationTime: creationTime,
            villageAvailability: villageAvailability,
            cityAvailability: cityAvailability,
            requirements: requirements,
            protection: protection,
            penalty: penalty,
            damage: damage,
            special: special,
        );
    _cache[sm.id] = sm;
    return sm;
  }

  ShieldModel._create({
    required super.uuid,
    required super.name,
    required super.source,
    super.location,
    required super.weight,
    required super.creationDifficulty,
    required super.creationTime,
    required super.villageAvailability,
    required super.cityAvailability,
    required this.requirements,
    required this.protection,
    required this.penalty,
    required this.damage,
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

  static Shield? _shieldFactory(String id, String uuid) {
    var model = get(id);
    if(model == null) return null;
    return Shield(uuid, model: model);
  }

  static Future<void> init() async {
    // ignore:unused_local_variable
    var c = _cache;
    await loadAll();
  }

  static Future<void> loadAll() async {
    EquipmentFactory.instance.registerFactory('shield', _shieldFactory);

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

      for(var instance in (await ShieldStore().getAll())) {
        _cache[instance.id] = instance;
      }
    });
  }

  static Future<void> saveLocalModel(ShieldModel shield) async {
    await ShieldStore().save(shield);
    _cache[shield.id] = shield;
  }

  static Future<void> deleteLocalModel(String id) async {
    var shield = await ShieldStore().get(id);
    if(shield != null) await ShieldStore().delete(shield);
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
