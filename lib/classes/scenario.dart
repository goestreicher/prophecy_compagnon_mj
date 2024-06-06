import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'map_background_data.dart';
import 'non_player_character.dart';
import 'scenario_encounter.dart';

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
    for (dynamic npcId in scenarioJson['npcs'] as List<dynamic>) {
      var npc = NonPlayerCharacter.get(npcId);
      npcs.add(npc!.toJson());
    }
  }
  scenarioJson['npcs'] = npcs;

  return Scenario.fromJson(scenarioJson);
}

Future<void> saveScenario(Scenario scenario) async {
  var binariesBox = await Hive.openLazyBox('binariesBox');
  var scenarioJson = scenario.toJson();

  for(var map in scenarioJson['maps']) {
    var binary = map['data']['image_data'];
    var hash = sha256.convert(utf8.encode(binary));
    await binariesBox.put(hash.toString(), binary);
    map['data']['image_data'] = hash.toString();
  }

  var npcIds = <String>[];
  for(var npc in scenario.npcs) {
    await NonPlayerCharacter.saveLocalModel(npc);
    npcIds.add(npc.id);
  }
  scenarioJson['npcs'] = json.encode(npcIds);

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
  var scenarioBox = await Hive.openLazyBox('scenariosBox');
  await scenarioBox.delete(uuid);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ScenarioEvent {
  ScenarioEvent({ required this.day, required this.description });

  int day;
  String description;

  factory ScenarioEvent.fromJson(Map<String, dynamic> json) => _$ScenarioEventFromJson(json);
  Map<String, dynamic> toJson() => _$ScenarioEventToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ScenarioMap {
  ScenarioMap({
    required this.name,
    required this.data,
    bool? isDefault,
  })
    : isDefault = isDefault ?? false;

  String name;
  MapBackgroundData data;
  bool isDefault;

  factory ScenarioMap.fromJson(Map<String, dynamic> json) => _$ScenarioMapFromJson(json);
  Map<String, dynamic> toJson() => _$ScenarioMapToJson(this);
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
        List<ScenarioEncounter>? encounters,
        Map<int, List<ScenarioEvent>>? pcEvents,
        Map<int, List<ScenarioEvent>>? worldEvents,
      })
    : uuid = uuid ?? const Uuid().v4().toString(),
      maps = maps ?? <ScenarioMap>[],
      npcs = npcs ?? <NonPlayerCharacter>[],
      encounters = encounters ?? <ScenarioEncounter>[],
      pcEvents = pcEvents ?? <int, List<ScenarioEvent>>{},
      worldEvents = worldEvents ?? <int, List<ScenarioEvent>>{};

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
  final List<ScenarioEncounter> encounters;
  final Map<int, List<ScenarioEvent>> pcEvents;
  final Map<int, List<ScenarioEvent>> worldEvents;

  ScenarioSummary summary() => ScenarioSummary(
    uuid: uuid,
    name: name,
    subtitle: subtitle,
  );

  ScenarioMap? defaultMap() {
    var idx = maps.indexWhere((ScenarioMap m) => m.isDefault);
    return idx == -1 ? null : maps[idx];
  }

  void addPcEvent(ScenarioEvent event, { int index = -1 }) {
    if(!pcEvents.containsKey(event.day)) {
      pcEvents[event.day] = <ScenarioEvent>[];
    }
    var position = index == -1 ? pcEvents[event.day]!.length : index;
    pcEvents[event.day]!.insert(position, event);
  }

  void removePcEvent({ required int day, required int index }) {
    if(pcEvents.containsKey(day) && index >= 0 && index < pcEvents[day]!.length) {
      pcEvents[day]!.removeAt(index);
    }
  }

  void addWorldEvent(ScenarioEvent event, { int index = -1 }) {
    if(!worldEvents.containsKey(event.day)) {
      worldEvents[event.day] = <ScenarioEvent>[];
    }
    var position = index == -1 ? worldEvents[event.day]!.length : index;
    worldEvents[event.day]!.insert(position, event);
  }

  void removeWorldEvent({ required int day, required int index }) {
    if(worldEvents.containsKey(day) && index >= 0 && index < worldEvents[day]!.length) {
      worldEvents[day]!.removeAt(index);
    }
  }

  Map<String, dynamic> toJson() => _$ScenarioToJson(this);
  factory Scenario.fromJson(Map<String, dynamic> json) => _$ScenarioFromJson(json);
}