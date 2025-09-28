import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'exportable_binary_data.dart';
import 'object_location.dart';
import 'object_source.dart';
import 'resource_base_class.dart';
import 'storage/default_assets_store.dart';
import 'storage/storable.dart';
import '../../text_utils.dart';

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

enum PlaceMapSourceType {
  asset,
  local,
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

    var place = Place.fromJson(j);
    place.location = ObjectLocation(
      type: ObjectLocationType.store,
      collectionUri: '${getUriBase()}/${storeCategory()}',
    );
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
      collectionUri: '${getUriBase()}/${storeCategory()}',
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
class PlaceMap {
  PlaceMap({
    required this.sourceType,
    required this.source,
    required this.imageWidth,
    required this.imageHeight,
    required this.realWidth,
    required this.realHeight,
  });

  PlaceMapSourceType sourceType;
  String source;
  final int imageWidth;
  final int imageHeight;
  double realWidth;
  double realHeight;
  @JsonKey(includeFromJson: false, includeToJson: false)
    Uint8List? imageData;
  ExportableBinaryData? exportableBinaryData;

  double get pixelsPerMeter => imageWidth / realWidth;

  Uint8List? get image {
    Uint8List? ret;

    if(sourceType == PlaceMapSourceType.asset) {
      ret = imageData;
    }
    else if(sourceType == PlaceMapSourceType.local) {
      ret = exportableBinaryData?.data;
    }

    return ret;
  }

  Future<void> load() async {
    if(sourceType == PlaceMapSourceType.asset) {
      if(imageData != null) return;
      var data = await rootBundle.load(source);
      imageData = data.buffer.asUint8List();
    }
    else if(sourceType == PlaceMapSourceType.local) {
      if(exportableBinaryData != null) return;
      exportableBinaryData = await BinaryDataStore().get(source);
    }
  }

  factory PlaceMap.fromJson(Map<String, dynamic> j) => _$PlaceMapFromJson(j);
  Map<String, dynamic> toJson() => _$PlaceMapToJson(this);
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

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Place extends ResourceBaseClass {
  factory Place({
    String? uuid,
    String? parentId,
    required PlaceType type,
    required String name,
    String? government,
    String? leader,
    String? motto,
    String? climate,
    required PlaceDescription description,
    ObjectLocation location = ObjectLocation.memory,
    required ObjectSource source,
    PlaceMap? map,
  }) {
    bool isDefault = (location.type == ObjectLocationType.assets);
    String id = uuid ?? (isDefault ? sentenceToCamelCase(transliterateFrenchToAscii(name)) : Uuid().v4().toString());
    if(!_instances.containsKey(id)) {
      var place = Place._create(
        uuid: uuid,
        parentId: parentId,
        type: type,
        name: name,
        government: government,
        leader: leader,
        motto: motto,
        climate: climate,
        description: description,
        location: location,
        source: source,
        map: map,
      );
      _instances[id] = place;
    }
    return _instances[id]!;
  }
  
  Place._create({
    String? uuid,
    this.parentId,
    required this.type,
    required super.name,
    this.government,
    this.leader,
    this.motto,
    this.climate,
    required this.description,
    super.location,
    required super.source,
    this.map,
  }) : uuid = uuid ?? (!location.type.canWrite ? null : Uuid().v4().toString());

  @override
  String get id => uuid ?? sentenceToCamelCase(transliterateFrenchToAscii(name));
  @JsonKey(includeIfNull: false)
    final String? uuid;
  final String? parentId;
  PlaceType type;
  String? government;
  String? leader;
  String? motto;
  String? climate;
  PlaceDescription description;
  PlaceMap? map;

  final List<String> _previousMapsDataHashes = <String>[];

  void replaceMap(PlaceMap? newMap) {
    if(map != null && map!.exportableBinaryData != null) {
      _previousMapsDataHashes.add(map!.exportableBinaryData!.hash);
    }
    map = newMap;
  }

  static int sortComparator(Place a, Place b) =>
      a.type.sort != b.type.sort
        ? a.type.sort - b.type.sort
        : a.name.compareTo(b.name);

  static List<Place> values() {
    loadDefaultAssets();
    return _instances.values.toList();
  }

  static List<Place> withParent(String id) => _instances.values
      .where((Place p) => p.parentId == id)
      .toList();

  static Place? byId(String id) {
    loadDefaultAssets();
    return _instances[id];
  }

  static List<Place> byType(PlaceType type) {
    loadDefaultAssets();
    return _instances.values
        .where((Place p) => p.type == type)
        .toList();
  }

  static List<Place> forLocationType(ObjectLocationType type) {
    loadDefaultAssets();
    return _instances.values
        .where((Place p) => p.location.type == type)
        .toList();
  }

  static List<Place> forSource(ObjectSource source) {
    loadDefaultAssets();
    return _instances.values
        .where((Place p) => p.source == source)
        .toList();
  }

  static Future<void> reloadFromStore(Place p) async {
    _instances.remove(p.id);
    // ignore:unused_local_variable
    var prev = await PlaceStore().get(p.id);
  }

  static Place? removeFromCache(Place p) => _instances.remove(p.id);

  static Future<void> delete(Place p) async {
    for(var child in withParent(p.id)) {
      await delete(child);
    }
    _instances.remove(p.id);
    await PlaceStore().delete(p);
  }

  static final Map<String, Place> _instances = <String, Place>{};
  static bool _defaultAssetsLoaded = false;

  static Future<void> loadDefaultAssets() async {
    if(_defaultAssetsLoaded) return;
    _defaultAssetsLoaded = true;

    var assetFiles = [
      'places-ldb2e.json',
      'places-les-ecailles-de-brorne.json',
      'places-les-enfants-de-heyra.json',
      'places-les-forges-de-kezyr.json',
      'places-les-foudres-de-kroryn.json',
    ];

    for(var f in assetFiles) {
      for (var a in await loadJSONAssetObjectList(f)) {
        // ignore:unused_local_variable
        var p = Place.fromJson(a);
      }
    }
  }

  static Future<void> loadStoreAssets() async {
    await PlaceStore().getAll();
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
      await PlaceStore().save(p);
    }
  }

  factory Place.fromJson(Map<String, dynamic> json) {
   if(json.containsKey('id') && _instances.containsKey(json['id']!) && _instances[json['id']]!.location.type == ObjectLocationType.assets) {
     return _instances[json['id']]!;
   } else if(json.containsKey('uuid') && _instances.containsKey(json['uuid'])) {
     return _instances[json['uuid']]!;
   } else {
     return _$PlaceFromJson(json);
   }
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
