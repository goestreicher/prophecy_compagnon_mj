import 'package:hive_flutter/adapters.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'dart:convert';

import 'player_character.dart';

part 'table.g.dart';

Future<List<GameTableSummary>> getGameTableSummaries() async {
  List<GameTableSummary> ret = <GameTableSummary>[];
  var box = await Hive.openBox('tableSummariesBox');
  for(var t in box.keys) {
    var jsonStr = await box.get(t);
    ret.add(GameTableSummary.fromJson(json.decode(jsonStr)));
  }
  return ret;
}

Future<GameTable> getGameTable(String uuid, { bool loadPlayers = false }) async {
  var box = await Hive.openLazyBox('tablesBox');
  var jsonStr = await box.get(uuid);
  var table = GameTable.fromJson(json.decode(jsonStr));
  if(loadPlayers) {
    await table.loadPlayers();
  }
  return table;
}

Future<void> saveGameTable(GameTable table) async {
  // Saving the summary
  var summaryBox = await Hive.openBox('tableSummariesBox');
  var summary = table.summary();
  await summaryBox.put(summary.uuid, json.encode(summary.toJson()));

  // Saving the table itself
  var tableBox = await Hive.openLazyBox('tablesBox');
  // Saving with the latest and cleanest PC summaries
  var uuids = table.summary().playersUuids;
  table.playerSummaries.clear();
  for(var uuid in uuids) {
    await getPlayerCharacter(uuid)
        .then((PlayerCharacter pc) => table.playerSummaries.add(pc.summary()));
  }
  await tableBox.put(table.uuid, json.encode(table.toJson()));
}

Future<void> importGameTable(Map<String, dynamic> json) async {
  // Just replace the UUID if it exists. If not, the Table constructor will add it
  if(json.containsKey('uuid')) {
    json['uuid'] = const Uuid().v4().toString();
  }

  // Re-create all characters
  var summaries = <Map<String, dynamic>>[];
  for(var pcJson in json['players']) {
    var pc = PlayerCharacter.fromJson(pcJson);
    await savePlayerCharacter(pc);
    summaries.add(pc.summary().toJson());
  }
  json['players'] = summaries;

  var table = GameTable.fromJson(json);
  await saveGameTable(table);
}

Future<void> deleteGameTable(String uuid) async {
  var table = await getGameTable(uuid);
  for(var character in table.playerSummaries) {
    await deletePlayerCharacter(character.uuid);
  }
  var summaryBox = await Hive.openBox('tableSummariesBox');
  await summaryBox.delete(uuid);
  var tableBox = await Hive.openLazyBox('tablesBox');
  await tableBox.delete(uuid);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class GameTableSummary {
  GameTableSummary({ required this.uuid, required this.name });

  final String uuid;
  final String name;
  @JsonKey(includeToJson: true, includeFromJson: true)
  final List<String> playersUuids = <String>[];

  Map<String, dynamic> toJson() => _$GameTableSummaryToJson(this);

  factory GameTableSummary.fromJson(Map<String, dynamic> json) {
    var ret = _$GameTableSummaryFromJson(json);
    for(var p in json["players_uuids"]) {
      ret.playersUuids.add(p);
    }
    return ret;
  }
}

@JsonSerializable()
class GameTable {
  GameTable(
      {
        String? uuid,
        required this.name,
        List<PlayerCharacterSummary>? playerSummaries,
      })
    : uuid = uuid ?? const Uuid().v4().toString(),
      playerSummaries = playerSummaries ?? <PlayerCharacterSummary>[];

  GameTable.create({ required this.name })
    : uuid = const Uuid().v4().toString(),
      playerSummaries = <PlayerCharacterSummary>[];

  GameTableSummary summary() {
    var ret = GameTableSummary(uuid: uuid, name: name);
    for(var pc in playerSummaries) {
      ret.playersUuids.add(pc.uuid);
    }
    return ret;
  }

  final String uuid;
  final String name;

  @JsonKey(name: 'players', includeToJson: true, includeFromJson: true)
    final List<PlayerCharacterSummary> playerSummaries;

  @JsonKey(includeToJson: false, includeFromJson: false)
    final List<PlayerCharacter> players = <PlayerCharacter>[];

  Future<void> loadPlayers() async {
    for(var pcSummary in playerSummaries) {
      var pcFull = await getPlayerCharacter(pcSummary.uuid);
      players.add(pcFull);
    }
  }

  Map<String, dynamic> toJson() => _$GameTableToJson(this);
  factory GameTable.fromJson(Map<String, dynamic> json) => _$GameTableFromJson(json);

  Future<Map<String, dynamic>> toJsonFull() async {
    await loadPlayers();
    Map<String, dynamic> json = toJson();
    List<Map<String, dynamic>> playersFull = <Map<String, dynamic>>[];
    for(var pc in players) {
      playersFull.add(pc.toJson());
    }
    json['players'] = playersFull;
    return json;
  }
}