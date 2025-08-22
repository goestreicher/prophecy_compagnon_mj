import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'calendar.dart';
import 'creature.dart';
import 'faction.dart';
import 'non_player_character.dart';
import 'object_source.dart';
import 'place.dart';
import 'scenario_encounter.dart';
import 'scenario_event.dart';
import 'scenario_map.dart';
import 'storage/storable.dart';

part 'scenario.g.dart';

class ScenarioSummaryStore extends JsonStoreAdapter<ScenarioSummary> {
  ScenarioSummaryStore();

  @override
  String storeCategory() => 'scenarioSummaries';

  @override
  String key(ScenarioSummary object) => object.uuid;

  @override
  Future<ScenarioSummary> fromJsonRepresentation(Map<String, dynamic> j) async => ScenarioSummary.fromJson(j);

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(ScenarioSummary object) async => object.toJson();
}

class ScenarioStore extends JsonStoreAdapter<Scenario> {
  ScenarioStore();

  @override
  String storeCategory() => 'scenarios';

  @override
  String key(Scenario object) => object.uuid;

  @override
  Future<Scenario> fromJsonRepresentation(Map<String, dynamic> j) async {
    if(j.containsKey('npcs')) {
      var npcsJson = <Map<String, dynamic>>[];
      for (var npcId in j['npcs']) {
        var npc = await NonPlayerCharacter.get(npcId);
        if(npc != null) {
          var npcJson = npc.toJson();
          npcsJson.add(npcJson);
        }
      }
      j['npcs'] = npcsJson;
    }

    if(j.containsKey('creatures')) {
      var creaturesJson = <Map<String, dynamic>>[];
      for(var creatureId in j['creatures']) {
        var creature = await CreatureModel.get(creatureId);
        if(creature != null) {
          var creatureJson = creature.toJson();
          // Same here, we have to set the location manually
          creaturesJson.add(creatureJson);
        }
      }
      j['creatures'] = creaturesJson;
    }

    if(j.containsKey('maps')) {
      var mapsJson = <Map<String, dynamic>>[];
      for(var mapId in j['maps']) {
        var map = await ScenarioMapStore().get(mapId);
        if(map != null) {
          mapsJson.add(map.toJson());
        }
      }
      j['maps'] = mapsJson;
    }

    if(j.containsKey('places')) {
      var placesJson = <Map<String, dynamic>>[];
      for(var placeId in j['places']) {
        var place = Place.byId(placeId);
        if(place != null) {
          placesJson.add(place.toJson());
        }
      }
      j['places'] = placesJson;
    }

    if(j.containsKey('factions')) {
      var factionsJson = <Map<String, dynamic>>[];
      for(var factionId in j['factions']) {
        var faction = Faction.byId(factionId);
        if(faction != null) {
          factionsJson.add(faction.toJson());
        }
      }
      j['factions'] = factionsJson;
    }

    return Scenario.fromJson(j);
  }

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(Scenario object) async {
    var j = object.toJson();

    var npcIds = <String>[];
    for(var npc in object.npcs) {
      npcIds.add(npc.id);
    }
    j['npcs'] = npcIds;

    var creatureIds = <String>[];
    for(var creature in object.creatures) {
      creatureIds.add(creature.id);
    }
    j['creatures'] = creatureIds;

    var mapIds = <String>[];
    for(var map in object.maps) {
      mapIds.add(map.uuid);
    }
    j['maps'] = mapIds;

    var placeIds = <String>[];
    for(var place in object.places) {
      placeIds.add(place.id);
    }
    j['places'] = placeIds;

    var factionIds = <String>[];
    for(var faction in object.factions) {
      factionIds.add(faction.id);
    }
    j['factions'] = factionIds;

    return j;
  }

  @override
  Future<void> willSave(Scenario object) async {
    ScenarioSummaryStore().save(object.summary());

    for(var npc in object.npcs) {
      await NonPlayerCharacter.saveLocalModel(npc);
    }

    for(var creature in object.creatures) {
      await CreatureModel.saveLocalModel(creature);
    }

    for(var map in object.maps) {
      await ScenarioMapStore().save(map);
    }

    for(var place in object.places) {
      await PlaceStore().save(place);
    }

    for(var faction in object.factions) {
      await FactionStore().save(faction);
    }
  }

  @override
  Future<void> willDelete(Scenario object) async {
    await ScenarioSummaryStore().delete(object.summary());

    for(var npc in object.npcs) {
      await NonPlayerCharacter.deleteLocalModel(npc.id);
    }

    for(var creature in object.creatures) {
      await CreatureModel.deleteLocalModel(creature.id);
    }

    for(var map in object.maps) {
      await ScenarioMapStore().delete(map);
    }

    for(var place in object.places) {
      await PlaceStore().delete(place);
    }

    for(var faction in object.factions) {
      await FactionStore().delete(faction);
    }
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ScenarioSummary {
  ScenarioSummary({
    required this.uuid,
    required this.name,
    this.subtitle = '',
  });

  final String uuid;
  final String name;
  final String subtitle;

  Map<String, dynamic> toJson() => _$ScenarioSummaryToJson(this);
  factory ScenarioSummary.fromJson(Map<String, dynamic> json) => _$ScenarioSummaryFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Scenario {
  Scenario(
      {
        String? uuid,
        required this.name,
        this.subtitle = '',
        this.danger = 0,
        this.discovery = 0,
        this.magic = 0,
        this.implication = 0,
        this.synopsys = '',
        this.story = '',
        List<ScenarioMap>? maps,
        List<NonPlayerCharacter>? npcs,
        List<CreatureModel>? creatures,
        List<ScenarioEncounter>? encounters,
        Map<DayRange, ScenarioDayEvents>? events,
        List<Place>? places,
        List<Faction>? factions,
      })
    : uuid = uuid ?? const Uuid().v4().toString(),
      maps = maps ?? <ScenarioMap>[],
      npcs = npcs ?? <NonPlayerCharacter>[],
      creatures = creatures ?? <CreatureModel>[],
      encounters = encounters ?? <ScenarioEncounter>[],
      events = events ?? <DayRange, ScenarioDayEvents>{},
      places = places ?? <Place>[],
      factions = factions ?? <Faction>[];

  factory Scenario.import(Map<String, dynamic> json) {
    // Force-set the UUID
    json['uuid'] = const Uuid().v4().toString();

    // Force source for items requiring it
    var source = ObjectSource(
      type: ObjectSourceType.scenario,
      name: json['name'],
      uuid: json['uuid'],
    ).toJson();

    for(var npc in json['npcs'] as List<dynamic>? ?? []) {
      npc['source'] = source;
    }

    for(var creature in json['creatures'] as List<dynamic>? ?? []) {
      creature['source'] = source;
    }

    for(var place in json['places'] as List<dynamic>? ?? []) {
      Place.preImportFilter(place as Map<String, dynamic>);
      place['source'] = source;
    }

    for(var faction in json['factions'] as List<dynamic>? ?? []) {
      faction['source'] = source;
    }

    for(var map in json['maps']) {
      ScenarioMap.preImportFilter(map as Map<String, dynamic>);
    }

    return Scenario.fromJson(json);
  }

  String uuid;
  final String name;
  String subtitle;
  int danger;
  int discovery;
  int magic;
  int implication;
  String synopsys;
  String story;
  final List<ScenarioMap> maps;
  final List<NonPlayerCharacter> npcs;
  final List<CreatureModel> creatures;
  final List<ScenarioEncounter> encounters;
  final List<Place> places;
  final List<Faction> factions;
  @JsonKey(includeToJson: false, includeFromJson: false)
    final Map<DayRange, ScenarioDayEvents> events;

  ObjectSource get source => ObjectSource(
    type: ObjectSourceType.scenario,
    name: name,
    uuid: uuid,
  );

  ScenarioSummary summary() => ScenarioSummary(
    uuid: uuid,
    name: name,
    subtitle: subtitle,
  );

  ScenarioMap? defaultMap() {
    var idx = maps.indexWhere((ScenarioMap m) => m.isDefault);
    return idx == -1 ? null : maps[idx];
  }

  void addEvent(DayRange day, ScenarioEventCategory category, ScenarioEvent event, { int pos = -1 }) {
    if(!events.containsKey(day)) {
      events[day] = ScenarioDayEvents();
    }
    events[day]!.add(category, event, pos);
  }

  void removeEvent(DayRange day, ScenarioEventCategory category, int pos) {
    if(!events.containsKey(day)) {
      return;
    }
    events[day]!.remove(category, pos);
    if(events[day]!.empty(ScenarioEventCategory.world) && events[day]!.empty(ScenarioEventCategory.pc)) {
      events.remove(day);
    }
  }

  void moveEvent(ScenarioEventCategory category,
      DayRange startDay, DayRange endDay,
      int start, int dest
  ) {
    if(!events.containsKey(startDay)) {
      return;
    }

    if(startDay == endDay) {
      events[startDay]!.move(category, start, dest);
    }
    else {
      var event = events[startDay]!.get(category, start);
      if(event == null) {
        // TODO: raise an exception here?
        return;
      }
      removeEvent(startDay, category, start);
      addEvent(endDay, category, event, pos: dest);
    }
  }

  Map<String, dynamic> toJson() {
    var json = _$ScenarioToJson(this);
    json['events'] = events.map((k, v) => MapEntry(k.toString(), v.toJson()));
    return json;
  }

  factory Scenario.fromJson(Map<String, dynamic> json) {
    var ret = _$ScenarioFromJson(json);
    (json['events'] as Map<String, dynamic>?)?.forEach(
        (k, v) => ret.events[DayRange.fromString(k)] = ScenarioDayEvents.fromJson(v as Map<String, dynamic>)
    );
    return ret;
  }
}