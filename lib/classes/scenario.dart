import 'dart:convert';

import 'package:hive_flutter/adapters.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'creature.dart';
import 'non_player_character.dart';
import 'scenario_encounter.dart';
import 'scenario_event.dart';
import 'scenario_map.dart';

part 'scenario.g.dart';

Future<List<ScenarioSummary>> getScenarioSummaries() async {
  List<ScenarioSummary> ret = <ScenarioSummary>[];
  var box = await Hive.openBox('scenarioSummariesBox');
  for(var t in box.keys) {
    var jsonStr = await box.get(t);
    ret.add(ScenarioSummary.fromJson(json.decode(jsonStr)));
  }
  return ret;
}

Future<Scenario> getScenario(String uuid) async {
  var box = await Hive.openLazyBox('scenariosBox');
  var binariesBox = await Hive.openLazyBox('binariesBox');
  var jsonStr = await box.get(uuid);
  var scenarioJson = json.decode(jsonStr);

  for(var map in scenarioJson['maps']) {
    var hash = map['data']['image_data'];
    var binary = await binariesBox.get(hash);
    map['data']['image_data'] = binary;
  }

  var npcs = <Map<String, dynamic>>[];
  if(scenarioJson.containsKey('npcs') && scenarioJson['npcs'] is List<dynamic>) {
    for(dynamic npcId in scenarioJson['npcs'] as List<dynamic>) {
      var npc = NonPlayerCharacter.get(npcId);
      npcs.add(json.decode(json.encode(npc!.toJson())));
    }
  }
  scenarioJson['npcs'] = npcs;

  var creatures = <Map<String, dynamic>>[];
  if(scenarioJson.containsKey('creatures') && scenarioJson['creatures'] is List<dynamic>) {
    for(dynamic creatureId in scenarioJson['creatures'] as List<dynamic>) {
      var creature = CreatureModel.get(creatureId);
      creatures.add(json.decode(json.encode(creature!.toJson())));
    }
  }
  scenarioJson['creatures'] = creatures;

  return Scenario.fromJson(scenarioJson);
}

Future<void> saveScenario(Scenario scenario) async {
  var binariesBox = await Hive.openLazyBox('binariesBox');
  var scenarioJson = scenario.toJson();

  // It's safer to rewrite the whole 'maps' key in the JSON to
  // ensure that the maps are correctly split between tables
  var mapsJson = <Map<String, dynamic>>{};
  for(var map in scenario.maps) {
    var mapJson = map.toJson();
    var mapHash = map.data.hash;
    await binariesBox.put(mapHash, mapJson['data']['image_data']);
    mapJson['data']['image_data'] = mapHash;
    mapsJson.add(mapJson);
  }
  scenarioJson['maps'] = mapsJson;

  var npcIds = <String>[];
  for(var npc in scenario.npcs) {
    await NonPlayerCharacter.saveLocalModel(npc);
    npcIds.add(npc.id);
  }
  scenarioJson['npcs'] = npcIds;

  var creatureIds = <String>[];
  for(var creature in scenario.creatures) {
    await CreatureModel.saveLocalModel(creature);
    creatureIds.add(creature.id);
  }
  scenarioJson['creatures'] = creatureIds;

  var scenarioBox = await Hive.openLazyBox('scenariosBox');
  await scenarioBox.put(scenario.uuid, json.encode(scenarioJson));

  // Saving the summary
  var summaryBox = await Hive.openBox('scenarioSummariesBox');
  var summary = scenario.summary();
  await summaryBox.put(summary.uuid, json.encode(summary.toJson()));
}

Future<void> deleteScenario(String uuid) async {
  var summaryBox = await Hive.openBox('scenarioSummariesBox');
  await summaryBox.delete(uuid);

  var scenario = await getScenario(uuid);
  for(var npc in scenario.npcs) {
    await NonPlayerCharacter.deleteLocalModel(npc.id);
  }
  for(var creature in scenario.creatures) {
    await CreatureModel.deleteLocalModel(creature.id);
  }
  var binariesBox = await Hive.openLazyBox('binariesBox');
  for(var map in scenario.maps) {
    await binariesBox.delete(map.data.hash);
  }

  var scenarioBox = await Hive.openLazyBox('scenariosBox');
  await scenarioBox.delete(uuid);
}

@JsonSerializable(fieldRename: FieldRename.snake)
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
      })
    : uuid = uuid ?? const Uuid().v4().toString(),
      maps = maps ?? <ScenarioMap>[],
      npcs = npcs ?? <NonPlayerCharacter>[],
      creatures = creatures ?? <CreatureModel>[],
      encounters = encounters ?? <ScenarioEncounter>[],
      events = events ?? <ScenarioEventDayRange, ScenarioDayEvents>{};

  factory Scenario.import(Map<String, dynamic> json) {
    if(json.containsKey('uuid')) {
      // Just replace the existing UUID to prevent any conflicts
      json['uuid'] = const Uuid().v4().toString();
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