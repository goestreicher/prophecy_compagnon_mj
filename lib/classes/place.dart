import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'exportable_binary_data.dart';
import 'object_source.dart';
import 'storage/storable.dart';
import '../../text_utils.dart';

part 'place.g.dart';

enum PlaceType {
  monde(title: 'Monde', sort: -1),
  continent(title: 'Continent', sort: 0),
  nation(title: 'Nation', sort: 5),
  citeEtat(title: 'Cité-État', sort: 5),
  archiduche(title: 'Archiduché', sort: 10),
  principaute(title: 'Principauté', sort: 15),
  duche(title: 'Duché', sort: 20),
  marche(title: 'Marche', sort: 25),
  comte(title: 'Comté', sort: 30),
  baronnie(title: 'Baronnie', sort: 35),
  citeLibre(title: 'Cité Libre', sort: 40),
  capitale(title: 'Capitale', sort: 40),
  cite(title: 'Cité', sort: 45),
  ville(title: 'Ville', sort: 50),
  village(title: 'Village', sort: 55),
  quartier(title: 'Quartier', sort: 60),
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
  Future<Place> fromJsonRepresentation(Map<String, dynamic> j) async =>
      Place.fromJson(j);

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(Place object) async =>
      object.toJson();

  @override
  Future<void> willSave(Place object) async {
    if(object.map?.exportableBinaryData != null) {
      await BinaryDataStore().save(object.map!.exportableBinaryData!);
    }
  }

  @override
  Future<void> willDelete(Place object) async {
    if(object.map?.exportableBinaryData != null) {
      await BinaryDataStore().delete(object.map!.exportableBinaryData!);
    }
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PlaceMap {
  PlaceMap({
    required this.sourceType,
    required this.source,
  });

  PlaceMapSourceType sourceType;
  String source;
  @JsonKey(includeFromJson: false, includeToJson: false)
    Uint8List? imageData;
  @JsonKey(includeFromJson: false, includeToJson: false)
    ExportableBinaryData? exportableBinaryData;

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
class Place {
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
    bool isDefault = false,
    required ObjectSource source,
    PlaceMap? map,
  }) {
    String id = uuid ?? (isDefault ? sentenceToCamelCase(transliterateFrenchToAscii(name)) : Uuid().v4().toString());
    if(!_instances.containsKey(id)) {
      var place = Place._create(
        uuid: isDefault ? null : id,
        parentId: parentId,
        type: type,
        name: name,
        government: government,
        leader: leader,
        motto: motto,
        climate: climate,
        description: description,
        isDefault: isDefault,
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
    required this.name,
    this.government,
    this.leader,
    this.motto,
    this.climate,
    required this.description,
    this.isDefault = false,
    required this.source,
    this.map,
  }) : uuid = uuid ?? (isDefault ? null : Uuid().v4().toString());

  String get id => uuid ?? sentenceToCamelCase(transliterateFrenchToAscii(name));
  @JsonKey(includeIfNull: false)
    final String? uuid;
  final String? parentId;
  PlaceType type;
  String name;
  String? government;
  String? leader;
  String? motto;
  String? climate;
  PlaceDescription description;
  final bool isDefault;
  final ObjectSource source;
  PlaceMap? map;

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

    var jsonStr = await rootBundle.loadString('assets/places-ldb2e.json');
    var assets = json.decode(jsonStr);

    for(var a in assets) {
      a['is_default'] = true;
      // ignore:unused_local_variable
      var p = Place.fromJson(a);
    }

    PlaceStore().getAll();
  }

  factory Place.fromJson(Map<String, dynamic> json) {
   if(json.containsKey('id') && _instances.containsKey(json['id']!) && _instances[json['id']]!.isDefault) {
     return _instances[json['id']]!;
   } else {
     return _$PlaceFromJson(json);
   }
 }

 Map<String, dynamic> toJson() {
   if(isDefault) {
     return {'id': id};
   }
   else {
     return _$PlaceToJson(this);
   }
 }
}
