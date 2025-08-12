import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'creature.dart';
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
        List<ScenarioMap>? maps,
        List<NonPlayerCharacter>? npcs,
        List<CreatureModel>? creatures,
        List<ScenarioEncounter>? encounters,
        Map<ScenarioEventDayRange, ScenarioDayEvents>? events,
        List<Place>? places,
      })
    : uuid = uuid ?? const Uuid().v4().toString(),
      maps = maps ?? <ScenarioMap>[],
      npcs = npcs ?? <NonPlayerCharacter>[],
      creatures = creatures ?? <CreatureModel>[],
      encounters = encounters ?? <ScenarioEncounter>[],
      events = events ?? <ScenarioEventDayRange, ScenarioDayEvents>{},
      places = places ?? <Place>[];

  factory Scenario.import(Map<String, dynamic> json) {
    if(json.containsKey('uuid')) {
      // Just replace the existing UUID to prevent any conflicts
      json['uuid'] = const Uuid().v4().toString();
    }

    // Force source for items requiring it
    var source = ObjectSource(
      type: ObjectSourceType.scenario,
      name: json['name'],
    );
    for(var npc in json['npcs'] as List<dynamic>? ?? []) {
      npc['source'] = source.toJson();
    }
    for(var creature in json['creatures'] as List<dynamic>? ?? []) {
      creature['source'] = source.toJson();
    }
    for(var place in json['places'] as List<dynamic>? ?? []) {
      place['source'] = source.toJson();
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
  final List<ScenarioMap> maps;
  final List<NonPlayerCharacter> npcs;
  final List<CreatureModel> creatures;
  final List<ScenarioEncounter> encounters;
  final List<Place> places;
  @JsonKey(includeToJson: false, includeFromJson: false)
    final Map<ScenarioEventDayRange, ScenarioDayEvents> events;

  ScenarioSummary summary() => ScenarioSummary(
    uuid: uuid,
    name: name,
    subtitle: subtitle,
  );

  ScenarioMap? defaultMap() {
    var idx = maps.indexWhere((ScenarioMap m) => m.isDefault);
    return idx == -1 ? null : maps[idx];
  }

  void addEvent(ScenarioEventDayRange day, ScenarioEventCategory category, ScenarioEvent event, { int pos = -1 }) {
    if(!events.containsKey(day)) {
      events[day] = ScenarioDayEvents();
    }
    events[day]!.add(category, event, pos);
  }

  void removeEvent(ScenarioEventDayRange day, ScenarioEventCategory category, int pos) {
    if(!events.containsKey(day)) {
      return;
    }
    events[day]!.remove(category, pos);
    if(events[day]!.empty(ScenarioEventCategory.world) && events[day]!.empty(ScenarioEventCategory.pc)) {
      events.remove(day);
    }
  }

  void moveEvent(ScenarioEventCategory category,
      ScenarioEventDayRange startDay, ScenarioEventDayRange endDay,
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
        (k, v) => ret.events[ScenarioEventDayRange.fromString(k)] = ScenarioDayEvents.fromJson(v as Map<String, dynamic>)
    );
    return ret;
  }
}