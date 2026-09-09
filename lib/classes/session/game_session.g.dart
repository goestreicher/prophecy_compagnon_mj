// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameSession _$GameSessionFromJson(Map<String, dynamic> json) => GameSession(
  uuid: json['uuid'] as String?,
  table: GameTable.fromJson(json['table'] as Map<String, dynamic>),
  scenario: Scenario.fromJson(json['scenario'] as Map<String, dynamic>),
  startDate: KorDate.fromJson(json['start_date'] as Map<String, dynamic>),
  scenarioDay: (json['scenario_day'] as num?)?.toInt(),
  dayHour: (json['day_hour'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$GameSessionToJson(GameSession instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'table': instance.table.toJson(),
      'scenario': instance.scenario.toJson(),
      'start_date': instance.startDate.toJson(),
      'scenario_day': instance.scenarioDay,
      'day_hour': instance.dayHour,
    };
