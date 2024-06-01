import 'dart:convert';

import 'package:hive_flutter/adapters.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'calendar.dart';
import 'scenario.dart';
import 'table.dart';

part 'game_session.g.dart';

Future<List<GameSession>> getGameSessions() async {
  List<GameSession> ret = <GameSession>[];
  var box = await Hive.openBox('sessionsBox');
  for(var t in box.keys) {
    var jsonStr = await box.get(t);
    ret.add(GameSession.fromJson(json.decode(jsonStr)));
  }
  return ret;
}

Future<GameSession> getGameSession(String uuid) async {
  var box = await Hive.openBox('sessionsBox');
  var jsonStr = await box.get(uuid);
  return GameSession.fromJson(json.decode(jsonStr));
}

Future<void> saveGameSession(GameSession session) async {
  var sessionBox = await Hive.openBox('sessionsBox');
  await sessionBox.put(session.uuid, json.encode(session.toJson()));
}

Future<void> deleteGameSession(String uuid) async {
  var summaryBox = await Hive.openBox('sessionSummariesBox');
  await summaryBox.delete(uuid);
  var sessionBox = await Hive.openLazyBox('sessionsBox');
  await sessionBox.delete(uuid);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class GameSession {
  GameSession({
    String? uuid,
    required this.table,
    required this.scenario,
    int? scenarioDay,
    required this.startDate,
    KorDate? currentDate,
  })
    : uuid = uuid ?? const Uuid().v4().toString(),
      scenarioDay = scenarioDay ?? 1,
      currentDate = currentDate ?? startDate;

  final String uuid;
  final GameTableSummary table;
  final ScenarioSummary scenario;
  int scenarioDay;
  KorDate startDate;
  KorDate currentDate;

  Map<String, dynamic> toJson() => _$GameSessionToJson(this);
  factory GameSession.fromJson(Map<String, dynamic> json) => _$GameSessionFromJson(json);
}