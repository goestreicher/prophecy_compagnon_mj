import 'package:json_annotation/json_annotation.dart';
import 'package:synchronized/synchronized.dart';
import 'package:uuid/uuid.dart';

import '../entity/abilities.dart';
import '../object_location.dart';
import '../object_source.dart';
import '../storage/default_assets_store.dart';
import '../storage/storable.dart';
import 'enums.dart';
import 'equipment.dart';

part 'cloth.g.dart';

class ClothModelStore extends JsonStoreAdapter<ClothModel> {
  @override
  String storeCategory() => 'clothModels';

  @override
  String key(ClothModel object) => object.id;

  @override
  Future<ClothModel> fromJsonRepresentation(Map<String, dynamic> j) async =>
      ClothModel.fromJson(j);

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(ClothModel object) async =>
      object.toJson();
}

class _ClothFactoryImplementation implements EquipmentFactoryImplementation {
  @override
  EquipmentModel? model(String id) {
    return ClothModel.get(id);
  }

  @override
  Equipment? forge(String id, Map<String, dynamic>? json) {
    var m = ClothModel.get(id);
    if(m == null) return null;

    if(json != null && json.containsKey('uuid')) {
      return Cloth(json['uuid'], model: m);
    }
    else {
      return Cloth.create(model: m);
    }
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ClothModel extends EquipableItemModel {
  factory ClothModel({
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
    required EquipableItemSlot slot,
    int handiness = 0,
    EquipableItemLayer layer = EquipableItemLayer.normal,
    bool supportsMetal = false,
    List<EquipmentSpecialCapability>? special,
  })
  {
    var cm = _cache[uuid]
        ?? ClothModel._create(
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
          supportsMetal: supportsMetal,
          special: special,
        );
    _cache[cm.id] = cm;
    return cm;
  }

  ClothModel._create({
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
    required super.slot,
    super.handiness = 0,
    super.layer,
    super.supportsMetal,
    super.special,
  });

  static Iterable<String> ids() => _cache.keys;
  
  static List<EquipableItemSlot> supportedBodyParts() => [
      EquipableItemSlot.head,
      EquipableItemSlot.body,
      EquipableItemSlot.upperBody,
      EquipableItemSlot.belt,
      EquipableItemSlot.hands,
      EquipableItemSlot.feet,
    ];

  static Iterable<String> idsByBodyPart(EquipableItemSlot bp) =>
    _cache.values
      .where((ClothModel m) => m.slot == bp)
      .map((ClothModel m) => m.id);

  static ClothModel? get(String id) => _cache[id];

  static Future<void> init() async {
    // ignore:unused_local_variable
    var c = _cache;
    await loadAll();
  }

  static Future<void> loadAll() async {
    EquipmentFactory.instance.registerFactory('cloth', _ClothFactoryImplementation());

    await _loadLock.synchronized(() async {
      var assetFiles = [
        'clothes.json',
      ];

      for (var f in assetFiles) {
        for (var model in await loadJSONAssetObjectList(f)) {
          try {
            // ignore:unused_local_variable
            var instance = ClothModel.fromJson(model);
            _cache[instance.id] = instance;
          } catch (e, stacktrace) {
            print('Error loading cloth ${model["name"]}: ${e.toString()}\n${stacktrace.toString()}');
          }
        }
      }

      for(var instance in (await ClothModelStore().getAll())) {
        _cache[instance.id] = instance;
      }
    });
  }

  static Future<void> saveLocalModel(ClothModel cloth) async {
    await ClothModelStore().save(cloth);
    _cache[cloth.id] = cloth;
  }

  static Future<void> deleteLocalModel(String id) async {
    var cloth = await ClothModelStore().get(id);
    if(cloth != null) await ClothModelStore().delete(cloth);
    _cache.remove(id);
  }

  static final Map<String, ClothModel> _cache = <String, ClothModel>{};
  static final _loadLock = Lock();

  static ClothModel fromJson(Map<String, dynamic> json) =>
      _$ClothModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ClothModelToJson(this);
}

class Cloth extends EquipableItem {
  Cloth(this._uuid, {
    required super.model,
    super.alias,
    super.quality,
    super.metal,
  });

  Cloth.create({
    required super.model,
    super.alias,
    super.quality,
    super.metal,
  })
    : _uuid = const Uuid().v4().toString();

  final String _uuid;

  @override
  String type() => 'cloth:${model.id}';

  @override
  String uuid() => _uuid;

  @override
  Map<Ability, int> equipRequirements() => <Ability, int>{};
}