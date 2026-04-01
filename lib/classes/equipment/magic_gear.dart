import 'package:json_annotation/json_annotation.dart';
import 'package:synchronized/synchronized.dart';
import 'package:uuid/uuid.dart';

import '../object_location.dart';
import '../object_source.dart';
import '../storage/default_assets_store.dart';
import '../storage/storable.dart';
import 'enums.dart';
import 'equipment.dart';

part 'magic_gear.g.dart';

class MagicGearModelStore extends JsonStoreAdapter<MagicGearModel> {
  @override
  String storeCategory() => 'magicGearModels';

  @override
  String key(MagicGearModel object) => object.uuid;

  @override
  Future<MagicGearModel> fromJsonRepresentation(Map<String, dynamic> j) async =>
      MagicGearModel.fromJson(j);

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(MagicGearModel object) async =>
      object.toJson();
}

class _MagicGearFactoryImplementation implements EquipmentFactoryImplementation {
  @override
  EquipmentModel? fromJson(Map<String, dynamic> json) =>
      MagicGearModel.fromJson(json);

  @override
  EquipmentModel? model(String id) {
    return MagicGearModel.get(id);
  }

  @override
  Equipment? forge(String id, Map<String, dynamic>? json) {
    var m = MagicGearModel.get(id);
    if(m == null) return null;

    if(json != null && json.containsKey('uuid')) {
      return MagicGear(json['uuid'], model: m);
    }
    else {
      return MagicGear.create(model: m);
    }
  }

  @override
  Future<void> saveLocalModel(EquipmentModel model) async {
    if(model is! MagicGearModel) return;
    await MagicGearModel.saveLocalModel(model);
  }

  @override
  Future<void> deleteLocalModel(EquipmentModel model) async {
    if(model is! MagicGearModel) return;
    await MagicGearModel.deleteLocalModel(model.uuid);
  }

  @override
  Future<void> reloadFromStore(String uuid) async {
    await MagicGearModel.reloadFromStore(uuid);
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MagicGearModel extends EquipmentModel {
  factory MagicGearModel({
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
    bool supportsMetal = false,
    EquipmentQuality? intrinsicResistance,
    List<EquipmentSpecialCapability>? special,
  })
  {
    var gm = _cache[uuid]
        ?? MagicGearModel._create(
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
          supportsMetal: supportsMetal,
          intrinsicResistance: intrinsicResistance,
          special: special,
        );
    _cache[gm.uuid] = gm;
    return gm;
  }

  MagicGearModel._create({
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
    super.supportsMetal,
    super.intrinsicResistance,
    super.special,
  });

  @JsonKey(includeToJson: true)
  @override
  String get factory => 'magic-gear';

  static Iterable<String> ids() => _cache.keys;

  static MagicGearModel? get(String id) => _cache[id];

  static Future<void> init() async {
    // ignore:unused_local_variable
    var c = _cache;
    await loadAll();
  }

  static Future<void> loadAll() async {
    EquipmentFactory.instance.registerFactory('magic-gear', _MagicGearFactoryImplementation());

    await _loadLock.synchronized(() async {
      var assetFiles = [
        'magic-gear.json',
      ];

      for (var f in assetFiles) {
        for (var model in await loadJSONAssetObjectList(f)) {
          try {
            // ignore:unused_local_variable
            var instance = MagicGearModel.fromJson(model);
            _cache[instance.uuid] = instance;
          } catch (e, stacktrace) {
            print('Error loading magic gear ${model["name"]}: ${e.toString()}\n${stacktrace.toString()}');
          }
        }
      }

      for(var instance in (await MagicGearModelStore().getAll())) {
        _cache[instance.uuid] = instance;
      }
    });
  }

  static Future<void> saveLocalModel(MagicGearModel gear) async {
    await MagicGearModelStore().save(gear);
    _cache[gear.uuid] = gear;
  }

  static Future<void> deleteLocalModel(String id) async {
    var gear = await MagicGearModelStore().get(id);
    if(gear != null) await MagicGearModelStore().delete(gear);
    _cache.remove(id);
  }

  static Future<void> reloadFromStore(String id) async {
    var m = await MagicGearModelStore().get(id);
    if(m != null) _cache[id] = m;
  }

  static final Map<String, MagicGearModel> _cache = <String, MagicGearModel>{};
  static final _loadLock = Lock();

  static MagicGearModel fromJson(Map<String, dynamic> json) =>
      _$MagicGearModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$MagicGearModelToJson(this);
}

class MagicGear extends Equipment {
  MagicGear(this._uuid, {
    required super.model,
    super.alias,
    super.quality,
    super.metal,
  });

  MagicGear.create({
    required super.model,
    super.alias,
    super.quality,
    super.metal,
  })
      : _uuid = const Uuid().v4().toString();

  final String _uuid;

  @override
  String uuid() => _uuid;
}