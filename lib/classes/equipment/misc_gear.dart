import 'package:json_annotation/json_annotation.dart';
import 'package:synchronized/synchronized.dart';
import 'package:uuid/uuid.dart';

import '../object_location.dart';
import '../object_source.dart';
import '../storage/default_assets_store.dart';
import '../storage/storable.dart';
import 'equipment.dart';

part 'misc_gear.g.dart';

class MiscGearModelStore extends JsonStoreAdapter<MiscGearModel> {
  @override
  String storeCategory() => 'miscGearModels';

  @override
  String key(MiscGearModel object) => object.id;

  @override
  Future<MiscGearModel> fromJsonRepresentation(Map<String, dynamic> j) async =>
      MiscGearModel.fromJson(j);

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(MiscGearModel object) async =>
      object.toJson();
}

class _MiscGearFactoryImplementation implements EquipmentFactoryImplementation {
  @override
  EquipmentModel? model(String id) {
    return MiscGearModel.get(id);
  }

  @override
  Equipment? forge(String id, Map<String, dynamic>? json) {
    var m = MiscGearModel.get(id);
    if(m == null) return null;

    if(json != null && json.containsKey('uuid')) {
      return MiscGear(json['uuid'], model: m);
    }
    else {
      return MiscGear.create(model: m);
    }
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MiscGearModel extends EquipmentModel {
  factory MiscGearModel({
    required String uuid,
    required String name,
    bool unique = false,
    required ObjectSource source,
    ObjectLocation location = ObjectLocation.memory,
    required double weight,
    required int creationDifficulty,
    required int creationTime,
    required EquipmentAvailability villageAvailability,
    required EquipmentAvailability cityAvailability,
    bool supportsMetal = false,
    List<EquipmentSpecialCapability>? special,
  })
  {
    var gm = _cache[uuid]
        ?? MiscGearModel._create(
          uuid: uuid,
          name: name,
          unique: unique,
          source: source,
          location: location,
          weight: weight,
          creationDifficulty: creationDifficulty,
          creationTime: creationTime,
          villageAvailability: villageAvailability,
          cityAvailability: cityAvailability,
          supportsMetal: supportsMetal,
          special: special,
        );
    _cache[gm.id] = gm;
    return gm;
  }

  MiscGearModel._create({
    required super.uuid,
    required super.name,
    super.unique,
    required super.source,
    super.location,
    required super.weight,
    required super.creationDifficulty,
    required super.creationTime,
    required super.villageAvailability,
    required super.cityAvailability,
    super.supportsMetal,
    List<EquipmentSpecialCapability>? special,
  });

  static Iterable<String> ids() => _cache.keys;

  static MiscGearModel? get(String id) => _cache[id];

  static Future<void> init() async {
    // ignore:unused_local_variable
    var c = _cache;
    await loadAll();
  }

  static Future<void> loadAll() async {
    EquipmentFactory.instance.registerFactory('misc-gear', _MiscGearFactoryImplementation());

    await _loadLock.synchronized(() async {
      var assetFiles = [
        'misc-gear.json',
      ];

      for (var f in assetFiles) {
        for (var model in await loadJSONAssetObjectList(f)) {
          try {
            // ignore:unused_local_variable
            var instance = MiscGearModel.fromJson(model);
            _cache[instance.id] = instance;
          } catch (e, stacktrace) {
            print('Error loading misc gear ${model["name"]}: ${e.toString()}\n${stacktrace.toString()}');
          }
        }
      }

      for(var instance in (await MiscGearModelStore().getAll())) {
        _cache[instance.id] = instance;
      }
    });
  }

  static Future<void> saveLocalModel(MiscGearModel gear) async {
    await MiscGearModelStore().save(gear);
    _cache[gear.id] = gear;
  }

  static Future<void> deleteLocalModel(String id) async {
    var gear = await MiscGearModelStore().get(id);
    if(gear != null) await MiscGearModelStore().delete(gear);
    _cache.remove(id);
  }

  static final Map<String, MiscGearModel> _cache = <String, MiscGearModel>{};
  static final _loadLock = Lock();

  static MiscGearModel fromJson(Map<String, dynamic> json) =>
      _$MiscGearModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MiscGearModelToJson(this);
}

class MiscGear extends Equipment {
  MiscGear(this._uuid, {
    required super.model,
    super.quality,
    super.metal,
  });

  MiscGear.create({
    required super.model,
    super.quality,
    super.metal,
  })
    : _uuid = const Uuid().v4().toString();

  final String _uuid;

  @override
  String type() => 'misc-gear:${model.id}';

  @override
  String uuid() => _uuid;
}