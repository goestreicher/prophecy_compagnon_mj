import 'package:json_annotation/json_annotation.dart';
import 'package:synchronized/synchronized.dart';
import 'package:uuid/uuid.dart';

import 'character_role.dart';
import 'exportable_binary_data.dart';
import 'object_location.dart';
import 'object_source.dart';
import 'place_map.dart';
import 'resource_base_class.dart';
import 'resource_memory_cache.dart';
import 'storage/default_assets_store.dart';
import 'storage/storable.dart';

part 'place.g.dart';

enum PlaceType {
  monde(title: 'Monde', sort: -1),
  continent(title: 'Continent', sort: 0),
  nation(title: 'Nation', sort: 1),
  region(title: 'Région', sort: 2),
  lieuUnique(title: 'Lieu unique', sort: 4),
  citeEtat(title: 'Cité-État', sort: 5),
  capitale(title: 'Capitale', sort: 6),
  archiduche(title: 'Archiduché', sort: 10),
  principaute(title: 'Principauté', sort: 15),
  duche(title: 'Duché', sort: 20),
  marche(title: 'Marche', sort: 25),
  comte(title: 'Comté', sort: 30),
  baronnie(title: 'Baronnie', sort: 35),
  citeLibre(title: 'Cité Libre', sort: 40),
  cite(title: 'Cité', sort: 45),
  ville(title: 'Ville', sort: 50),
  village(title: 'Village', sort: 55),
  quartier(title: 'Quartier', sort: 60),
  batiment(title: 'Bâtiment', sort: 65),
  ;

  final String title;
  final int sort;

  const PlaceType({ required this.title, required this.sort });
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PlaceDescription {
  PlaceDescription({
    required this.general,
    this.history,
    this.ethnology,
    this.society,
    this.politics,
    this.judicial,
    this.economy,
    this.military,
  });

  String general;
  String? history;
  String? ethnology;
  String? society;
  String? politics;
  String? judicial;
  String? economy;
  String? military;

  factory PlaceDescription.fromJson(Map<String, dynamic> j) => _$PlaceDescriptionFromJson(j);
  Map<String, dynamic> toJson() => _$PlaceDescriptionToJson(this);
}

class PlaceSummaryStore extends JsonStoreAdapter<PlaceSummary> {
  @override
  String storeCategory() => 'placeSummaries';

  @override
  String key(PlaceSummary object) => object.id;

  @override
  Future<PlaceSummary> fromJsonRepresentation(Map<String, dynamic> j) async {
    j['location'] = ObjectLocation(
      type: ObjectLocationType.store,
      collectionUri: getCollectionUri(),
    ).toJson();
    var place = PlaceSummary.fromJson(j);
    return place;
  }

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(PlaceSummary object) async
      => _$PlaceSummaryToJson(object);

  @override
  Future<void> willSave(PlaceSummary object) async {
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
class PlaceSummary extends ResourceBaseClass {
  factory PlaceSummary({
    required String uuid,
    required ObjectSource source,
    ObjectLocation location = ObjectLocation.memory,
    required String name,
    required PlaceType type,
    String? parentId,
    bool canCache = true,
  })
  {
    var p = _cache.entry(uuid)
      ?? PlaceSummary._create(
        uuid: uuid,
        source: source,
        location: location,
        name: name,
        type: type,
        parentId: parentId,
        canCache: canCache,
      );
    if(canCache) _cache.add(p.id, p);
    return p;
  }

  PlaceSummary._create({
    required this.uuid,
    required super.source,
    super.location = ObjectLocation.memory,
    required super.name,
    required this.type,
    this.parentId,
    this.canCache = true,
  });

  String uuid;
  PlaceType type;
  String? parentId;
  bool canCache;

  @override
  String get id => uuid;

  static int sortComparator(PlaceSummary a, PlaceSummary b)
      => a.type.sort != b.type.sort
          ? a.type.sort - b.type.sort
          : a.name.compareTo(b.name);

  static Future<PlaceSummary?> get(String id) async {
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

  static Future<Iterable<PlaceSummary>> withParent(String? parentId) async {
    await loadAll();
    return _cache.values
        .where((PlaceSummary p) => p.parentId == parentId);
  }

  static Future<Iterable<PlaceSummary>> forLocationType(ObjectLocationType type) async {
    await loadAll();
    return _cache.values
        .where((PlaceSummary p) => p.location.type == type);
  }

  static Future<Iterable<PlaceSummary>> forSource(ObjectSource source) async {
    await loadAll();
    return _cache.values
        .where((PlaceSummary p) => p.source == source);
  }

  static Future<void> init() async {
    // ignore:unused_local_variable
    var c = _cache;
  }

  static Future<void> loadAll() async {
    await _loadLock.synchronized(() async {
      var assetFiles = [
        'places-ldb2e.json',
        'places-la-colere-des-dragons.json',
        'places-les-compagnons-de-khy.json',
        'places-les-ecailles-de-brorne.json',
        'places-les-enfants-de-heyra.json',
        'places-les-forges-de-kezyr.json',
        'places-les-foudres-de-kroryn.json',
        'places-les-orphelins-de-szyl.json',
        'places-les-secrets-de-kalimsshar.json',
        'places-les-versets-d-ozyr.json',
        'places-les-voiles-de-nenya.json',
        'places-yris-flambeau-de-l-humanite.json',
      ];

      for (var f in assetFiles) {
        if (!_cache.containsCollection(f)) {
          _cache.addCollection(f);

          for (var a in await loadJSONAssetObjectList(f)) {
            // ignore:unused_local_variable
            var p = PlaceSummary.fromJson(a);
          }
        }
      }

      if (!_cache.containsCollection(PlaceSummaryStore().getCollectionUri())) {
        _cache.addCollection(PlaceSummaryStore().getCollectionUri());
        await PlaceSummaryStore().getAll();
      }
    });
  }

  static final _cache = ResourceMemoryCache<PlaceSummary, PlaceSummaryStore>(
    jsonConverter: PlaceSummary.fromJson,
    store: () => PlaceSummaryStore(),
  );
  static final _loadLock = Lock();

  static void _placeDeleted(String id) => _cache.del(id);

  static Future<void> _saveLocalModel(PlaceSummary summary) async {
    await PlaceSummaryStore().save(summary);
    _cache.add(summary.id, summary);
  }

  static Future<void> _deleteLocalModel(String id) async {
    var summary = await PlaceSummaryStore().get(id);
    if(summary != null) {
      await PlaceSummaryStore().delete(summary);
    }
    _cache.del(id);
  }

  factory PlaceSummary.fromJson(Map<String, dynamic> json)
      => _$PlaceSummaryFromJson(json);

  Map<String, dynamic> toJson()
      => _$PlaceSummaryToJson(this);
}

class PlaceStore extends JsonStoreAdapter<Place> {
  @override
  String storeCategory() => 'places';

  @override
  String key(Place object) => object.id;

  @override
  Future<Place> fromJsonRepresentation(Map<String, dynamic> j) async {
    if(
        j.containsKey('map')
        && j['map'] != null
        && j['map'].containsKey('exportable_binary_data')
        && j['map']['exportable_binary_data'] != null
    ) {
      await restoreJsonBinaryData(j['map'], 'exportable_binary_data');
    }

    j['location'] = ObjectLocation(
      type: ObjectLocationType.store,
      collectionUri: getCollectionUri(),
    ).toJson();
    var place = Place.fromJson(j);
    return place;
  }

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(Place object) async {
    var j = object.toJson();
    if(object.map != null) {
      object.map!.load();
      if(object.map!.exportableBinaryData != null) {
        j['map']['exportable_binary_data'] = object.map!.exportableBinaryData!.hash;
      }
    }
    return j;
  }

  @override
  Future<void> willSave(Place object) async {
    _deletePreviousData(object);
    if(object.map?.exportableBinaryData != null) {
      await BinaryDataStore().save(object.map!.exportableBinaryData!);
    }

    // Force-set the location here in case the object is used after being saved,
    // even if the location is not saved in the store (excluded from the
    // JSON representation).
    object.location = ObjectLocation(
      type: ObjectLocationType.store,
      collectionUri: getCollectionUri(),
    );
  }

  @override
  Future<void> willDelete(Place object) async {
    _deletePreviousData(object);
    if(object.map?.exportableBinaryData != null) {
      await BinaryDataStore().delete(object.map!.exportableBinaryData!);
    }
  }

  Future<void> _deletePreviousData(Place object) async {
    for(var h in object._previousMapsDataHashes) {
      await BinaryDataStore().deleteByHash(h);
    }
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Place extends ResourceBaseClass {
  factory Place({
    String? uuid,
    String? parentId,
    required PlaceType type,
    required String name,
    List<CharacterRole>? leaders,
    String? government,
    String? leader,
    String? motto,
    String? climate,
    required PlaceDescription description,
    ObjectLocation location = ObjectLocation.memory,
    required ObjectSource source,
    PlaceMap? map,
    bool canCache = true,
  }) {
    String id = uuid ?? Uuid().v4().toString();
    var p = _cache.entry(id)
        ??  Place._create(
              uuid: id,
              parentId: parentId,
              type: type,
              name: name,
              leaders: leaders,
              government: government,
              motto: motto,
              climate: climate,
              description: description,
              location: location,
              source: source,
              map: map,
              canCache: canCache,
            );
    if(canCache) _cache.add(p.id, p);
    // Force insertion of the summary in PlaceSummary's cache
    // ignore:unused_local_variable
    var s = p.summary;
    return p;
  }
  
  Place._create({
    required this.uuid,
    this.parentId,
    required this.type,
    required super.name,
    List<CharacterRole>? leaders,
    this.government,
    this.motto,
    this.climate,
    required this.description,
    super.location,
    required super.source,
    this.map,
    this.canCache = true,
  })
    : leaders = leaders ?? <CharacterRole>[];

  @override
  String get id => uuid;
  final String uuid;
  final String? parentId;
  PlaceType type;
  List<CharacterRole> leaders;
  String? government;
  String? motto;
  String? climate;
  PlaceDescription description;
  PlaceMap? map;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool canCache;

  static Place unknown = Place._create(
    uuid: 'unknown',
    type: PlaceType.monde,
    name: 'Inconnu',
    description: PlaceDescription(general: 'Lieu inconnu'),
    source: ObjectSource.local,
    location: ObjectLocation(
      type: ObjectLocationType.assets,
      collectionUri: 'in-memory',
    ),
    canCache: false,
  );

  PlaceSummary get summary => PlaceSummary(
    uuid: uuid,
    source: source,
    location: location,
    name: name,
    type: type,
    parentId: parentId,
    canCache: canCache,
  );

  final List<String> _previousMapsDataHashes = <String>[];

  void replaceMap(PlaceMap? newMap) {
    if(map != null && map!.exportableBinaryData != null) {
      _previousMapsDataHashes.add(map!.exportableBinaryData!.hash);
    }
    map = newMap;
  }

  static Future<List<Place>> withParent(String id) async {
    var ret = <Place>[];
    for(var summ in await PlaceSummary.withParent(id)) {
      ret.add((await get(summ.id))!);
    }
    return ret;
  }

  static Future<Place?> get(String id) async {
    Place? ret = _cache.entry(id);
    if(ret != null) return ret;

    PlaceSummary? summ = await PlaceSummary.get(id);
    if(summ == null) return null;

    if(summ.location.type == ObjectLocationType.assets) {
      ret = await loadFromAssets(summ.location.collectionUri, id);
    }
    else if(summ.location.type == ObjectLocationType.store) {
      ret = await PlaceStore().get(id);
    }

    return ret;
  }

  static Future<Place?> loadFromAssets(String file, String id) async {
    for(var a in await loadJSONAssetObjectList(file)) {
      if((a as Map<String, dynamic>)['uuid'] == id) {
        return Place.fromJson(a);
      }
    }
    return null;
  }

  @Deprecated('Use PlaceSummary.forLocationType')
  static Future<List<Place>> forLocationType(ObjectLocationType type) async {
    var ret = <Place>[];
    for(var summ in await PlaceSummary.forLocationType(type)) {
      ret.add((await get(summ.id))!);
    }
    return ret;
  }

  @Deprecated('Use PlaceSummary.forSource')
  static Future<List<Place>> forSource(ObjectSource source) async {
    var ret = <Place>[];
    for(var summ in await PlaceSummary.forSource(source)) {
      ret.add((await get(summ.id))!);
    }
    return ret;
  }

  static Future<void> reloadFromStore(Place p) async {
    PlaceSummary._placeDeleted(p.id);
    _cache.del(p.id);
    // ignore:unused_local_variable
    var prev = await PlaceStore().get(p.id);
  }

  static void removeFromCache(Place p) {
    PlaceSummary._placeDeleted(p.id);
    _cache.del(p.id);
  }

  static Future<void> saveLocalModel(Place p) async {
    await PlaceStore().save(p);
    await PlaceSummary._saveLocalModel(p.summary);
    _cache.add(p.id, p);
  }

  static Future<void> delete(Place p) async {
    for(var child in await withParent(p.id)) {
      await delete(child);
    }
    await PlaceStore().delete(p);
    await PlaceSummary._deleteLocalModel(p.id);
    _cache.del(p.id);
  }

  static Future<void> init() async {
    // ignore:unused_local_variable
    var c = _cache;
    await PlaceSummary.init();
  }

  static void preImportFilter(Map<String, dynamic> j) {
    if(
        j.containsKey('map')
        && j['map'] != null
        && j['map'].containsKey('exportable_binary_data')
        && j['map']['exportable_binary_data'] != null
    ) {
      j['map']['exportable_binary_data'].remove('is_new');
    }

    j.remove('source');
  }

  static Future<void> import(List<dynamic> j) async {
    for(Map<String, dynamic> placeJson in j) {
      preImportFilter(placeJson);
      placeJson['source'] = ObjectSource.local.toJson();
      Place p = Place.fromJson(placeJson);
      await Place.saveLocalModel(p);
    }
  }

  static final _cache = ResourceMemoryCache<Place, PlaceStore>(
    jsonConverter: Place.fromJson,
    store: () => PlaceStore(),
  );

  factory Place.fromJson(Map<String, dynamic> json) {
    Place? cached;
    if(json.containsKey('id')) {
      if(json['id'] == 'unknown') {
        cached = Place.unknown;
      }
      else {
        cached = _cache.entry(json['id']);
      }
    }
    else if(json.containsKey('uuid')) {
      cached = _cache.entry(json['uuid']);
    }
    return cached ?? _$PlaceFromJson(json);
  }

   Map<String, dynamic> toJson() {
     if(location.type == ObjectLocationType.assets) {
       return {'id': id};
     }
     else {
       return _$PlaceToJson(this);
     }
   }
}
