import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

import '../text_utils.dart';
import 'object_location.dart';
import 'object_source.dart';
import 'resource_base_class.dart';
import 'resource_memory_cache.dart';
import 'star_company.dart';
import 'star_motivations.dart';
import 'star_powers.dart';
import 'storage/default_assets_store.dart';
import 'storage/storable.dart';

part 'star.g.dart';

enum StarReach {
  level0(title: 'Aucun autre inspiré'),
  level1(title: '1 ou 2 autres inspirés'),
  level2(title: 'de 3 à 5 autres inspirés'),
  level3(title: 'de 6 à 10 autres inspirés'),
  level4(title: 'de 11 à 20 autres inspirés'),
  level5(title: 'de 21 à 50 autres inspirés'),
  level6(title: 'de 51 à 100 autres inspirés'),
  level7(title: 'de 101 à 200 autres inspirés'),
  level8(title: 'de 201 à 500 autres inspirés'),
  level9(title: 'plus de 500 autres inspirés'),
  ;

  final String title;

  const StarReach({ required this.title });
}

class StarStore extends JsonStoreAdapter<Star> {
  @override
  String storeCategory() => 'stars';

  @override
  String key(Star object) => object.id;

  @override
  Future<Star> fromJsonRepresentation(Map<String, dynamic> json) async {
    json['location'] = ObjectLocation(
      type: ObjectLocationType.store,
      collectionUri: getCollectionUri(),
    ).toJson();
    return Star.fromJson(json);
  }

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(Star object) async =>
      object.toJson();

  @override
  Future<void> willSave(Star object) async {
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
class Star extends ResourceBaseClass {
  factory Star({
    required String name,
    required ObjectSource source,
    ObjectLocation location = ObjectLocation.memory,
    String description = '',
    required StarReach envergure,
    required StarMotivations motivations,
    Map<int, StarPower>? powers,
    List<StarCompany>? companies,
  }) {
    var s = _cache.entry(_getId(name))
      ?? Star._create(
            name: name,
            source: source,
            location: location,
            description: description,
            envergure: envergure,
            motivations: motivations,
            powers: powers,
            companies: companies,
        );
    _cache.add(s.id, s);
    return s;
  }

  Star._create({
    required super.name,
    required super.source,
    super.location,
    this.description = '',
    required this.envergure,
    required this.motivations,
    Map<int, StarPower>? powers,
    List<StarCompany>? companies
  })
    : powers = powers ?? <int, StarPower>{},
      companies = companies ?? <StarCompany>[];

  String description;
  StarReach envergure;
  StarMotivations motivations;
  Map<int, StarPower> powers;
  List<StarCompany> companies;

  @override
  String get id => sentenceToCamelCase(transliterateFrenchToAscii(name));

  int get eclat => [
      motivations.getValue(MotivationType.vertu),
      motivations.getValue(MotivationType.penchant),
      motivations.getValue(MotivationType.ideal),
      motivations.getValue(MotivationType.interdit),
      motivations.getValue(MotivationType.epreuve),
      motivations.getValue(MotivationType.destinee)
    ].reduce(min);

  static Future<Star?> get(String id) async {
    if(!_cache.contains(id)) {
      var loc = _cache.entryLocation(id);
      if(loc == null) {
        await loadAll();
      }
      else {
        return _cache.tryLoad(
            loc,
            id,
            (Map<String, dynamic> j) => _getId(j['name']!)
        );
      }
    }

    return _cache.entry(id);
  }

  static Future<Iterable<Star>> getAll({ String? nameFilter }) async {
    await loadAll();
    return _cache.values
        .where((Star s) =>
            nameFilter == null
            || s.name.toLowerCase().contains(nameFilter.toLowerCase()));
  }

  static Future<Iterable<Star>> forLocationType(
    ObjectLocationType type,
    { String? nameFilter }
  ) async {
    await loadAll();
    return _cache.values
        .where((Star s) => s.location.type == type)
        .where(
            (Star s) =>
                nameFilter == null
                || s.name.toLowerCase().contains(nameFilter.toLowerCase())
    );
  }

  static Future<Iterable<Star>> forSourceType(
    ObjectSourceType type,
    {String? nameFilter}
  ) async {
    await loadAll();
    return _cache.values
        .where((Star s) => s.source.type == type)
        .where(
            (Star s) =>
                nameFilter == null
                || s.name.toLowerCase().contains(nameFilter.toLowerCase())
        );
  }

  static Future<Iterable<Star>> forSource(
      ObjectSource source,
      {String? nameFilter}
  ) async {
    await loadAll();
    return _cache.values
        .where((Star s) => s.source == source)
        .where(
            (Star s) =>
                nameFilter == null
                || s.name.toLowerCase().contains(nameFilter.toLowerCase())
        );
  }

  static Future<void> saveLocalModel(Star s) async {
    await StarStore().save(s);
    _cache.add(s.id, s);
  }

  static Future<void> deleteLocalModel(String id) async {
    var model = await StarStore().get(id);
    if(model != null) {
      await StarStore().delete(model);
    }
    _cache.del(id);
  }

  static void removeFromCache(String id) => _cache.del(id);

  static Future<void> reloadFromStore(String id) async {
    removeFromCache(id);
    var s = await StarStore().get(id);
    if(s != null) {
      _cache.add(s.id, s);
    }
  }

  static Future<void> init() async {
    // ignore:unused_local_variable
    var c = _cache;
  }

  static Future<void> loadAll() async {
    var assetFiles = [
      'stars-les-secrets-de-kalimsshar.json',
    ];

    for (var f in assetFiles) {
      if(!_cache.containsCollection(f)) {
        _cache.addCollection(f);

        for (var model in await loadJSONAssetObjectList(f)) {
          try {
            // ignore:unused_local_variable
            var instance = Star.fromJson(model);
          } catch (e, stacktrace) {
            print('Error loading star ${model["name"]}: ${e.toString()}\n${stacktrace.toString()}');
          }
        }
      }
    }

    if(!_cache.containsCollection(StarStore().getCollectionUri())) {
      _cache.addCollection(StarStore().getCollectionUri());
      await StarStore().getAll();
    }
  }

  static void preImportFilter(Map<String, dynamic> json) {
    json.remove('uuid');
    json.remove('source');
  }

  static Future<Star> import(Map<String, dynamic> json) async {
    preImportFilter(json);
    json['source'] = ObjectSource.local.toJson();

    var model = Star.fromJson(json);
    await Star.saveLocalModel(model);
    return model;
  }

  static String _getId(String name) =>
      sentenceToCamelCase(transliterateFrenchToAscii(name));

  static final _cache = ResourceMemoryCache<Star, StarStore>(
    jsonConverter: Star.fromJson,
    store: () => StarStore()
  );

  factory Star.fromJson(Map<String, dynamic> json) =>
      _$StarFromJson(json);

  Map<String, dynamic> toJson() =>
      _$StarToJson(this);
}

class PlayersStarStore extends JsonStoreAdapter<PlayersStar> {
  @override
  String storeCategory() => 'playersStar';

  @override
  String key(Star object) => object.id;

  @override
  Future<PlayersStar> fromJsonRepresentation(Map<String, dynamic> json) async =>
      PlayersStar.fromJson(json);

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(PlayersStar object) async =>
      object.toJson();

  @override
  Future<void> willSave(Star object) async {
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
class PlayersStar extends Star {
  PlayersStar({
    required super.name,
    required super.source,
    super.location,
    super.description,
    required super.envergure,
    required super.motivations,
    super.powers,
    this.experience = 0,
    this.circles = const <MotivationType, int>{},
  })
    : super._create();

  int experience;
  Map<MotivationType, int> circles;

  int getCircles(MotivationType motivation) => circles[motivation] ?? 0;
  void setCircles(MotivationType motivation, int v) => circles[motivation] = v;

  factory PlayersStar.fromJson(Map<String, dynamic> json) =>
      _$PlayersStarFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$PlayersStarToJson(this);
}