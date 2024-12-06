import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:prophecy_compagnon_mj/classes/storage/storable.dart';
import 'package:uuid/uuid.dart';

import 'calendar.dart';
import 'scenario.dart';
import 'table.dart';

part 'game_session.g.dart';

class GameSessionStore extends JsonStoreAdapter<GameSession> {
  GameSessionStore();

  @override
  String storeCategory() => 'gameSessions';

  @override
  String key(GameSession object) => object.uuid;

  @override
  Future<GameSession> fromJsonRepresentation(Map<String, dynamic> j) async => GameSession.fromJson(j);

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(GameSession object) async => object.toJson();
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
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