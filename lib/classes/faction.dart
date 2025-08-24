import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'object_location.dart';
import 'object_source.dart';
import 'resource_base_class.dart';
import 'storage/default_assets_store.dart';
import 'storage/storable.dart';

part 'faction.g.dart';

class FactionStore extends JsonStoreAdapter<Faction> {
  @override
  String storeCategory() => 'factions';

  @override
  String key(Faction object) => object.id;

  @override
  Future<Faction> fromJsonRepresentation(Map<String, dynamic> j) async {
    var faction = Faction.fromJson(j);
    faction.location = ObjectLocation(
      type: ObjectLocationType.store,
      collectionUri: '${getUriBase()}/${storeCategory()}',
    );
    return faction;
  }

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(Faction object) async => _$FactionToJson(object);

  @override
  Future<void> willSave(Faction object) async {
    // Force-set the location here in case the object is used after being saved,
    // even if the location is not saved in the store (excluded from the
    // JSON representation).
    object.location = ObjectLocation(
      type: ObjectLocationType.store,
      collectionUri: '${getUriBase()}/${storeCategory()}',
    );
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class FactionMember {
  FactionMember({
    required this.name,
    required this.title,
  });

  String name;
  String title;

  factory FactionMember.fromJson(Map<String, dynamic> j) => _$FactionMemberFromJson(j);
  Map<String, dynamic> toJson() => _$FactionMemberToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Faction extends ResourceBaseClass {
  factory Faction({
    String? uuid,
    String? parentId,
    bool displayOnly = false,
    required String name,
    List<FactionMember> leaders = const <FactionMember>[],
    List<FactionMember> members = const <FactionMember>[],
    required String description,
    ObjectLocation location = ObjectLocation.memory,
    required ObjectSource source,
  }) {
    var id = uuid ?? Uuid().v4().toString();
    if(!_instances.containsKey(id)) {
      var faction = Faction._create(
        uuid: id,
        parentId: parentId,
        displayOnly: displayOnly,
        name: name,
        leaders: leaders,
        members: members,
        description: description,
        location: location,
        source: source,
      );
      _instances[id] = faction;
    }
    return _instances[id]!;
  }

  Faction._create({
    required this.uuid,
    this.parentId,
    this.displayOnly = false,
    required super.name,
    this.leaders = const <FactionMember>[],
    this.members = const <FactionMember>[],
    required this.description,
    super.location,
    required super.source,
  });

  @override
  String get id => uuid;
  String uuid;
  String? parentId;
  bool displayOnly;
  List<FactionMember> leaders;
  List<FactionMember> members;
  String description;

  static final Map<String, Faction> _instances = <String, Faction>{};
  static bool _defaultAssetsLoaded = false;

  static int sortComparator(Faction a, Faction b) => a.name.toLowerCase().compareTo(b.name.toLowerCase());

  static Iterable<Faction> withParent(String? parentId) => _instances.values
      .where((Faction f) => f.parentId == parentId);

  static Faction? byId(String id) => _instances[id];

  static Future<void> reloadFromStore(Faction f) async {
    _instances.remove(f.id);
    // ignore:unused_local_variable
    var prev = await FactionStore().get(f.id);
  }

  static Faction? removeFromCache(Faction f) => _instances.remove(f.id);

  static Future<void> delete(Faction f) async {
    for(var child in withParent(f.id).toList()) {
      await delete(child);
    }
    _instances.remove(f.id);
    await FactionStore().delete(f);
  }

  static Future<void> loadDefaultAssets() async {
    if(_defaultAssetsLoaded) return;
    _defaultAssetsLoaded = true;

    var assetFiles = [
      'factions-castes.json',
      'factions-secretes.json',
    ];

    for(var f in assetFiles) {
      for(var a in await loadJSONAssetObjectList(f)) {
        // ignore:unused_local_variable
        var f = Faction.fromJson(a);
      }
    }
  }

  static Future<void> loadStoreAssets() async {
    await FactionStore().getAll();
  }

  static Future<void> import(List<dynamic> j) async {
    for(Map<String, dynamic> factionJson in j) {
      Faction f = Faction.fromJson(factionJson);
      await FactionStore().save(f);
    }
  }

  factory Faction.fromJson(Map<String, dynamic> json) {
    if(json.containsKey('id') && _instances.containsKey(json['id']!) && _instances[json['id']]!.location.type == ObjectLocationType.assets) {
      return _instances[json['id']]!;
    } else if(json.containsKey('uuid') && _instances.containsKey(json['uuid'])) {
      return _instances[json['uuid']]!;
    } else {
      return _$FactionFromJson(json);
    }
  }

  Map<String, dynamic> toJson() {
    if(location.type == ObjectLocationType.assets) {
      return {'id': id};
    }
    else {
      return _$FactionToJson(this);
    }
  }
}