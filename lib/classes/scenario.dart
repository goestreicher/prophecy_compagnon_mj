import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'creature.dart';
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
    var hash = sha256.convert(utf8.encode(imageDataToBase64(map.data.imageData)));
    await binariesBox.delete(hash.toString());
  }

  var scenarioBox = await Hive.openLazyBox('scenariosBox');
  await scenarioBox.delete(uuid);
}

enum ScenarioEventCategory {
  world,
  pc,
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ScenarioEvent {
  ScenarioEvent({ required this.title, required this.description });

  String title;
  String description;

  factory ScenarioEvent.fromJson(Map<String, dynamic> json) => _$ScenarioEventFromJson(json);
  Map<String, dynamic> toJson() => _$ScenarioEventToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ScenarioDayEvents {
  ScenarioDayEvents();

  ScenarioEvent? get(ScenarioEventCategory category, int pos) {
    if(!events.containsKey(category)) {
      return null;
    }
    if(pos < 0 || pos >= events[category]!.length) {
      return null;
    }
    return events[category]![pos];
  }

  void add(ScenarioEventCategory category, ScenarioEvent event, int pos) {
    if(!events.containsKey(category)) {
      events[category] = <ScenarioEvent>[];
    }
    if(pos < 0 || pos >= events[category]!.length) {
      events[category]!.add(event);
    }
    else {
      events[category]!.insert(pos, event);
    }
  }

  void remove(ScenarioEventCategory category, int pos) {
    if(!events.containsKey(category)) {
      return;
    }
    if(pos < 0 || pos >= events[category]!.length) {
      return;
    }
    events[category]!.removeAt(pos);
    if(events[category]!.isEmpty) {
      events.remove(category);
    }
  }

  void move(ScenarioEventCategory category, int start, int dest) {
    if(!events.containsKey(category)) {
      return;
    }
    if(start == dest) {
      return;
    }
    if(start < 0 || start >= events[category]!.length) {
      return;
    }
    if(dest < 0 || dest > events[category]!.length) {
      return;
    }

    ScenarioEvent event = events[category]!.removeAt(start);
    if(start < dest) {
      dest -= 1;
    }
    events[category]!.insert(dest, event);
  }

  bool empty(ScenarioEventCategory category) => !events.containsKey(category) || events[category]!.isEmpty;

  Map<ScenarioEventCategory, List<ScenarioEvent>> events = <ScenarioEventCategory, List<ScenarioEvent>>{};

  factory ScenarioDayEvents.fromJson(Map<String, dynamic> json) => _$ScenarioDayEventsFromJson(json);
  Map<String, dynamic> toJson() => _$ScenarioDayEventsToJson(this);
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

class ScenarioEventDayRange {
  ScenarioEventDayRange({ required this.start, int end = -1 })
    : end = end == -1 ? start : end;

  final int start;
  final int end;

  @override
  String toString() => "$start,$end";

  factory ScenarioEventDayRange.fromString(String s) {
    var regexp = RegExp(r'(-?\d+)');
    var values = regexp.allMatches(s).map((v) => int.parse(v[0]!)).toList();
    if(values.length < 2) {
      values[1] = values[0];
    }
    return ScenarioEventDayRange(start: values[0], end: values[1]);
  }

  @override
  bool operator==(Object other) =>
      other is ScenarioEventDayRange && start == other.start && end == other.end;

  @override
  int get hashCode => Object.hash(start, end);
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