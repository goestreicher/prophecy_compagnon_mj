import 'package:json_annotation/json_annotation.dart';
import 'package:synchronized/synchronized.dart';
import 'package:uuid/uuid.dart';

import 'character_role.dart';
import 'object_location.dart';
import 'object_source.dart';
import 'resource_base_class.dart';
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
    j['location'] = ObjectLocation(
      type: ObjectLocationType.store,
      collectionUri: getCollectionUri(),
    ).toJson();
    var faction = FactionSummary.fromJson(j);
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
      collectionUri: getCollectionUri(),
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

  static Future<FactionSummary?> get(String id) async {
    if(!_cache.contains(id)) {
      var loc = _cache.entryLocation(id);
      if(loc == null) {
        await loadAll();
      }
      else {
        return _cache.tryLoad(
            loc,
            id,
            (Map<String, dynamic> j) => j['uuid']!
        );
      }
    }

    return _cache.entry(id);
  }

  static Future<Iterable<FactionSummary>> withParent(String? parentId) async {
    await loadAll();
    return _cache.values
      .where((FactionSummary f) => f.parentId == parentId);
  }

  static Future<Iterable<FactionSummary>> forLocationType(ObjectLocationType type) async {
    await loadAll();
    return _cache.values
      .where((FactionSummary p) => p.location.type == type);
  }

  static Future<void> init() async {
    // ignore:unused_local_variable
    var c = _cache;
  }

  static Future<void> loadAll() async {
    await _loadLock.synchronized(() async {
      var assetFiles = [
        'factions-castes.json',
        'factions-secretes.json',
        'factions-les-voiles-de-nenya.json',
        'factions-yris-flambeau-de-l-humanite.json',
      ];

      for(var f in assetFiles) {
        if(!_cache.containsCollection(f)) {
          _cache.addCollection(f);

          for(var a in await loadJSONAssetObjectList(f)) {
            // ignore:unused_local_variable
            var f = FactionSummary.fromJson(a);
          }
        }
      }

      if(!_cache.containsCollection(FactionSummaryStore().getCollectionUri())) {
        _cache.addCollection(FactionSummaryStore().getCollectionUri());
        await FactionSummaryStore().getAll();
      }
    });
  }

  static final _cache = ResourceMemoryCache<FactionSummary, FactionSummaryStore>(
    jsonConverter: FactionSummary.fromJson,
    store: () => FactionSummaryStore(),
  );
  static final _loadLock = Lock();

  static void _factionDeleted(String id) => _cache.del(id);

  static Future<void> _saveLocalModel(FactionSummary summary) async {
    await FactionSummaryStore().save(summary);
    _cache.add(summary.id, summary);
  }

  static Future<void> _deleteLocalModel(String id) async {
    var summary = await FactionSummaryStore().get(id);
    if(summary != null) {
      await FactionSummaryStore().delete(summary);
    }
    _cache.del(id);
  }

  factory FactionSummary.fromJson(Map<String, dynamic> json)
      => _$FactionSummaryFromJson(json);

  Map<String, dynamic> toJson()
      => _$FactionSummaryToJson(this);
}

class FactionStore extends JsonStoreAdapter<Faction> {
  @override
  String storeCategory() => 'factions';

  @override
  String key(Faction object) => object.id;

  @override
  Future<Faction> fromJsonRepresentation(Map<String, dynamic> j) async {
    j['location'] = ObjectLocation(
      type: ObjectLocationType.store,
      collectionUri: getCollectionUri(),
    ).toJson();
    var faction = Faction.fromJson(j);
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
      collectionUri: getCollectionUri(),
    );
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Faction extends ResourceBaseClass {
  factory Faction({
    String? uuid,
    String? parentId,
    bool displayOnly = false,
    required String name,
    List<CharacterRole> leaders = const <CharacterRole>[],
    List<CharacterRole> members = const <CharacterRole>[],
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
    this.leaders = const <CharacterRole>[],
    this.members = const <CharacterRole>[],
    required this.description,
    super.location,
    required super.source,
  });

  @override
  String get id => uuid;
  String uuid;
  String? parentId;
  bool displayOnly;
  List<CharacterRole> leaders;
  List<CharacterRole> members;
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
      ret.add((await get(summ.id))!);
    }
    return ret;
  }

  static Future<Faction?> get(String id) async {
    Faction? ret = _cache.entry(id);
    if(ret != null) return ret;

    FactionSummary? summ = await FactionSummary.get(id);
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

  static Future<void> saveLocalModel(Faction f) async {
    await FactionStore().save(f);
    await FactionSummary._saveLocalModel(f.summary);
    _cache.add(f.id, f);
  }

  static Future<void> delete(Faction f) async {
    for(var child in (await withParent(f.id)).toList()) {
      await delete(child);
    }
    await FactionStore().delete(f);
    await FactionSummary._deleteLocalModel(f.id);
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
      await Faction.saveLocalModel(f);
    }
  }

  static final _cache = ResourceMemoryCache<Faction, FactionStore>(
    jsonConverter: Faction.fromJson,
    store: () => FactionStore(),
  );

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