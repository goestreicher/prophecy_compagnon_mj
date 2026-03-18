import 'package:json_annotation/json_annotation.dart';
import 'package:synchronized/synchronized.dart';
import 'package:uuid/uuid.dart';

import '../entity/abilities.dart';
import '../object_location.dart';
import '../object_source.dart';
import '../storage/default_assets_store.dart';
import '../storage/storable.dart';
import 'equipment.dart';

part 'jewel.g.dart';

class JewelModelStore extends JsonStoreAdapter<JewelModel> {
  @override
  String storeCategory() => 'jewelModels';

  @override
  String key(JewelModel object) => object.id;

  @override
  Future<JewelModel> fromJsonRepresentation(Map<String, dynamic> j) async =>
      JewelModel.fromJson(j);

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(JewelModel object) async =>
      object.toJson();
}

class _JewelFactoryImplementation implements EquipmentFactoryImplementation {
  @override
  EquipmentModel? model(String id) {
    return JewelModel.get(id);
  }

  @override
  Equipment? forge(String id, Map<String, dynamic>? json) {
    var m = JewelModel.get(id);
    if(m == null) return null;

    if(json != null && json.containsKey('uuid')) {
      return Jewel(json['uuid'], model: m);
    }
    else {
      return Jewel.create(model: m);
    }
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class JewelModel extends EquipableItemModel {
  factory JewelModel({
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
    var jm = _cache[uuid]
        ?? JewelModel._create(
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
    _cache[jm.id] = jm;
    return jm;
  }

  JewelModel._create({
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
    EquipableItemSlot.forehead,
    EquipableItemSlot.neck,
    EquipableItemSlot.ears,
    EquipableItemSlot.chest,
    EquipableItemSlot.upperArm,
    EquipableItemSlot.forearm,
    EquipableItemSlot.finger,
  ];

  static Iterable<String> idsByBodyPart(EquipableItemSlot bp) =>
    _cache.values
      .where((JewelModel m) => m.slot == bp)
      .map((JewelModel m) => m.id);

  static JewelModel? get(String id) => _cache[id];

  static Future<void> init() async {
    // ignore:unused_local_variable
    var c = _cache;
    await loadAll();
  }

  static Future<void> loadAll() async {
    EquipmentFactory.instance.registerFactory('jewel', _JewelFactoryImplementation());

    await _loadLock.synchronized(() async {
      var assetFiles = [
        'jewel.json',
      ];

      for (var f in assetFiles) {
        for (var model in await loadJSONAssetObjectList(f)) {
          try {
            // ignore:unused_local_variable
            var instance = JewelModel.fromJson(model);
            _cache[instance.id] = instance;
          } catch (e, stacktrace) {
            print('Error loading jewel ${model["name"]}: ${e.toString()}\n${stacktrace.toString()}');
          }
        }
      }

      for(var instance in (await JewelModelStore().getAll())) {
        _cache[instance.id] = instance;
      }
    });
  }

  static Future<void> saveLocalModel(JewelModel jewel) async {
    await JewelModelStore().save(jewel);
    _cache[jewel.id] = jewel;
  }

  static Future<void> deleteLocalModel(String id) async {
    var jewel = await JewelModelStore().get(id);
    if(jewel != null) await JewelModelStore().delete(jewel);
    _cache.remove(id);
  }

  static final Map<String, JewelModel> _cache = <String, JewelModel>{};
  static final _loadLock = Lock();

  static JewelModel fromJson(Map<String, dynamic> json) =>
      _$JewelModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$JewelModelToJson(this);
}

class Jewel extends EquipableItem {
  Jewel(this._uuid, {
    required super.model,
    super.alias,
    super.quality,
    super.metal,
  });

  Jewel.create({
    required super.model,
    super.alias,
    super.quality,
    super.metal,
  })
    : _uuid = const Uuid().v4().toString();

  final String _uuid;

  @override
  String type() => 'jewel:${model.id}';

  @override
  String uuid() => _uuid;

  @override
  Map<Ability, int> equipRequirements() => <Ability, int>{};
}