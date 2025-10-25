import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'object_location.dart';
import 'object_source.dart';
import 'resource_base_class.dart';
import 'resource_link.dart';
import 'resource_memory_cache.dart';
import 'storage/default_assets_store.dart';
import 'storage/storable.dart';

part 'faction.g.dart';

class FactionSummaryStore extends JsonStoreAdapter<FactionSummary> {
  @override
  String storeCategory() => 'factionSummaries';

  @override
  String key(FactionSummary object) => object.id;

  @override
  Future<FactionSummary> fromJsonRepresentation(Map<String, dynamic> j) async {
    var faction = FactionSummary.fromJson(j);
    faction.location = ObjectLocation(
      type: ObjectLocationType.store,
      collectionUri: '${getUriBase()}/${storeCategory()}',
    );
    return faction;
  }

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(FactionSummary object) async
      => _$FactionSummaryToJson(object);

  @override
  Future<void> willSave(FactionSummary object) async {
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
class FactionSummary extends ResourceBaseClass {
  factory FactionSummary({
    required String uuid,
    required ObjectSource source,
    ObjectLocation location = ObjectLocation.memory,
    required String name,
    String? parentId,
    bool displayOnly = false,
  })
  {
    var f = _cache.entry(uuid)
      ?? FactionSummary._create(
          uuid: uuid,
          source: source,
          location: location,
          name: name,
          parentId: parentId,
          displayOnly: displayOnly,
        );
    _cache.add(f.id, f);
    return f;
  }

  FactionSummary._create({
    required this.uuid,
    required super.source,
    super.location,
    required super.name,
    this.parentId,
    this.displayOnly = false,
  });

  final String uuid;
  final String? parentId;
  bool displayOnly;

  @override
  String get id => uuid;

  static int sortComparator(FactionSummary a, FactionSummary b)
      => a.name.toLowerCase().compareTo(b.name.toLowerCase());

  static Future<FactionSummary?> byId(String id) async {
    await loadAll();
    return _cache.entry(id);
  }

  static Future<Iterable<FactionSummary>> withParent(String? parentId) async {
    await loadAll();
    return _cache.values
      .where((FactionSummary f) => f.parentId == parentId);
  }

  static Future<void> init() async {
    // ignore:unused_local_variable
    var c = _cache;
  }

  static Future<void> loadAll() async {
    if(_cache.isEmpty || _cache.purged) {
      var assetFiles = [
        'factions-castes.json',
        'factions-secretes.json',
        'factions-les-voiles-de-nenya.json',
      ];
      for(var f in assetFiles) {
        for(var a in await loadJSONAssetObjectList(f)) {
          // ignore:unused_local_variable
          var f = FactionSummary.fromJson(a);
        }
      }

      await FactionSummaryStore().getAll();

      _cache.purged = false;
    }
  }

  static final _cache = ResourceMemoryCache<FactionSummary>();

  static void _factionDeleted(String id) => _cache.del(id);

  factory FactionSummary.fromJson(Map<String, dynamic> json)
      => _$FactionSummaryFromJson(json);

  Map<String, dynamic> toJson()
      => _$FactionSummaryToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class FactionMember {
  FactionMember({
    this.name,
    this.link,
    required this.title,
  })
  {
    if(name == null && link == null) {
      throw ArgumentError('Either name or link must be provided to create a faction member');
    }
  }

  String? name;
  ResourceLink? link;
  String title;

  factory FactionMember.fromJson(Map<String, dynamic> j) => _$FactionMemberFromJson(j);
  Map<String, dynamic> toJson() => _$FactionMemberToJson(this);
}

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
    // Ensure that the summary is saved too
    await FactionSummaryStore().save(object.summary);

    // Force-set the location here in case the object is used after being saved,
    // even if the location is not saved in the store (excluded from the
    // JSON representation).
    object.location = ObjectLocation(
      type: ObjectLocationType.store,
      collectionUri: '${getUriBase()}/${storeCategory()}',
    );
  }

  @override
  Future<void> willDelete(Faction object) async {
    await FactionSummaryStore().delete(object.summary);
  }
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
    var f = _cache.entry(id)
        ?? Faction._create(
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
    _cache.add(f.id, f);
    // Force insertion of the summary in FactionSummary's cache
    // ignore:unused_local_variable
    var s = f.summary;
    return f;
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

  FactionSummary get summary => FactionSummary(
    uuid: uuid,
    source: source,
    location: location,
    name: name,
    parentId: parentId,
    displayOnly: displayOnly,
  );

  static int sortComparator(Faction a, Faction b)
      => a.name.toLowerCase().compareTo(b.name.toLowerCase());

  static Future<Iterable<Faction>> withParent(String? parentId) async {
    var ret = <Faction>[];
    for(var summ in await FactionSummary.withParent(parentId)) {
      ret.add((await byId(summ.id))!);
    }
    return ret;
  }

  static Future<Faction?> byId(String id) async {
    Faction? ret = _cache.entry(id);
    if(ret != null) return ret;

    FactionSummary? summ = await FactionSummary.byId(id);
    if(summ == null) return null;

    if(summ.location.type == ObjectLocationType.assets) {
      ret = await loadFromAssets(summ.location.collectionUri, id);
    }
    else if(summ.location.type == ObjectLocationType.store) {
      ret = await FactionStore().get(id);
    }

    return ret;
  }

  static Future<Faction?> loadFromAssets(String file, String id) async {
    for(var a in await loadJSONAssetObjectList(file)) {
      if((a as Map<String, dynamic>)['uuid'] == id) {
        return Faction.fromJson(a);
      }
    }
    return null;
  }

  static Future<void> reloadFromStore(Faction f) async {
    FactionSummary._factionDeleted(f.id);
    _cache.del(f.id);
    // ignore:unused_local_variable
    var prev = await FactionStore().get(f.id);
  }

  static void removeFromCache(Faction f) {
    FactionSummary._factionDeleted(f.id);
    _cache.del(f.id);
  }

  static Future<void> delete(Faction f) async {
    for(var child in (await withParent(f.id)).toList()) {
      await delete(child);
    }
    await FactionStore().delete(f);
    FactionSummary._factionDeleted(f.id);
    _cache.del(f.id);
  }

  static Future<void> init() async {
    // ignore:unused_local_variable
    var c = _cache;
    await FactionSummary.init();
  }

  static Future<void> import(List<dynamic> j) async {
    for(Map<String, dynamic> factionJson in j) {
      Faction f = Faction.fromJson(factionJson);
      await FactionStore().save(f);
    }
  }

  static final _cache = ResourceMemoryCache<Faction>();

  factory Faction.fromJson(Map<String, dynamic> json) {
    Faction? cached;
    if(json.containsKey('id')) {
      cached = _cache.entry(json['id']);
    }
    else if(json.containsKey('uuid')) {
      cached = _cache.entry(json['uuid']);
    }
    return cached ?? _$FactionFromJson(json);
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