import 'package:json_annotation/json_annotation.dart';
import 'package:synchronized/synchronized.dart';
import 'package:uuid/uuid.dart';

import 'entity/abilities.dart';
import 'entity_base.dart';
import 'equipment.dart';
import 'object_location.dart';
import 'object_source.dart';
import 'storage/default_assets_store.dart';
import 'storage/storable.dart';

part 'armor.g.dart';

enum ArmorType {
  light(title: "Armure légère"),
  medium(title: "Armure moyenne"),
  heavy(title: "Armure lourde");

  const ArmorType({ required this.title });

  final String title;
}

class ArmorModelStore extends JsonStoreAdapter<ArmorModel> {
  @override
  String storeCategory() => 'armorModels';

  @override
  String key(ArmorModel object) => object.id;

  @override
  Future<ArmorModel> fromJsonRepresentation(Map<String, dynamic> j) async =>
      ArmorModel.fromJson(j);

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(ArmorModel object) async =>
      object.toJson();
}

class _ArmorFactoryImplementation implements EquipmentFactoryImplementation {
  @override
  EquipmentModel? model(String id) {
    return ArmorModel.get(id);
  }

  @override
  Equipment? forge(String id, Map<String, dynamic>? json) {
    var m = ArmorModel.get(id);
    if(m == null) return null;

    if(json != null && json.containsKey('uuid')) {
      return Armor(json['uuid'], model: m);
    }
    else {
      return Armor.create(model: m);
    }
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ArmorModel extends EquipmentModel {
  factory ArmorModel({
    required String uuid,
    required String name,
    required ObjectSource source,
    ObjectLocation location = ObjectLocation.memory,
    required double weight,
    required int creationDifficulty,
    required int creationTime,
    required EquipmentAvailability villageAvailability,
    required EquipmentAvailability cityAvailability,
    required ArmorType type,
    required Map<Ability, int> requirements,
    required int protection,
    required int penalty,
    List<EquipmentSpecialCapability>? special,
  })
  {
    var am = _cache[uuid]
        ?? ArmorModel._create(
          uuid: uuid,
          name: name,
          source: source,
          location: location,
          weight: weight,
          creationDifficulty: creationDifficulty,
          creationTime: creationTime,
          villageAvailability: villageAvailability,
          cityAvailability: cityAvailability,
          type: type,
          requirements: requirements,
          protection: protection,
          penalty: penalty,
          special: special,
        );
    _cache[am.id] = am;
    return am;
  }

  ArmorModel._create({
    required super.uuid,
    required super.name,
    required super.source,
    super.location,
    required super.weight,
    required super.creationDifficulty,
    required super.creationTime,
    required super.villageAvailability,
    required super.cityAvailability,
    required this.type,
    required this.requirements,
    required this.protection,
    required this.penalty,
    super.special,
  });

  ArmorType type;
  Map<Ability,int> requirements;
  int protection;
  int penalty;

  Armor instantiate() {
    return Armor.create(model: this);
  }

  static Iterable<String> ids() => _cache.keys;

  static Iterable<String> idsByType(ArmorType type) =>
    _cache.values
      .where(
          (ArmorModel am) => am.type == type
        )
      .map(
          (ArmorModel am) => am.id
      );

  static ArmorModel? get(String id) => _cache[id];

  static Future<void> init() async {
    // ignore:unused_local_variable
    var c = _cache;
    await loadAll();
  }

  static Future<void> loadAll() async {
    EquipmentFactory.instance.registerFactory('armor', _ArmorFactoryImplementation());

    await _loadLock.synchronized(() async {
      var assetFiles = [
        'armor.json',
      ];

      for (var f in assetFiles) {
        for (var model in await loadJSONAssetObjectList(f)) {
          try {
            // ignore:unused_local_variable
            var instance = ArmorModel.fromJson(model);
            _cache[instance.id] = instance;
          } catch (e, stacktrace) {
            print('Error loading armor ${model["name"]}: ${e.toString()}\n${stacktrace.toString()}');
          }
        }
      }

      for(var instance in (await ArmorModelStore().getAll())) {
        _cache[instance.id] = instance;
      }
    });
  }

  static Future<void> saveLocalModel(ArmorModel armor) async {
    await ArmorModelStore().save(armor);
    _cache[armor.id] = armor;
  }

  static Future<void> deleteLocalModel(String id) async {
    var armor = await ArmorModelStore().get(id);
    if(armor != null) await ArmorModelStore().delete(armor);
    _cache.remove(id);
  }

  static final Map<String, ArmorModel> _cache = <String, ArmorModel>{};
  static final _loadLock = Lock();

  factory ArmorModel.fromJson(Map<String, dynamic> json) =>
      _$ArmorModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ArmorModelToJson(this);
}

class Armor extends EquipableItem implements ProtectionProvider {
  Armor(this._uuid, { required ArmorModel model })
    : super(
        model: model,
        bodyPart: EquipableItemBodyPart.body,
        handiness: 0
      );

  Armor.create({ required ArmorModel model })
    : _uuid = const Uuid().v4().toString(),
      super(
        model: model,
        bodyPart: EquipableItemBodyPart.body,
        handiness: 0
      );

  final String _uuid;

  @override
  String type() => 'armor:${model.id}';

  @override
  String uuid() => _uuid;

  @override
  Map<Ability, int> equipRequirements() => (model as ArmorModel).requirements;

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
  int protection() => (model as ArmorModel).protection;
}