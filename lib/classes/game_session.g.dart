// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameSession _$GameSessionFromJson(Map<String, dynamic> json) => GameSession(
  uuid: json['uuid'] as String?,
  table: GameTableSummary.fromJson(json['table'] as Map<String, dynamic>),
  scenario: ScenarioSummary.fromJson(json['scenario'] as Map<String, dynamic>),
  scenarioDay: (json['scenario_day'] as num?)?.toInt(),
  startDate: KorDate.fromJson(json['start_date'] as Map<String, dynamic>),
  currentDate: json['current_date'] == null
      ? null
      : KorDate.fromJson(json['current_date'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GameSessionToJson(GameSession instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'table': instance.table.toJson(),
      'scenario': instance.scenario.toJson(),
      'scenario_day': instance.scenarioDay,
      'start_date': instance.startDate.toJson(),
      'current_date': instance.currentDate.toJson(),
    };
