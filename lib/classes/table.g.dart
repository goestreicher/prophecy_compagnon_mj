// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameTableSummary _$GameTableSummaryFromJson(Map<String, dynamic> json) =>
    GameTableSummary(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$GameTableSummaryToJson(GameTableSummary instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'players_uuids': instance.playersUuids,
    };

GameTable _$GameTableFromJson(Map<String, dynamic> json) => GameTable(
      uuid: json['uuid'] as String?,
      name: json['name'] as String,
      playerSummaries: (json['players'] as List<dynamic>?)
          ?.map(
              (e) => PlayerCharacterSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GameTableToJson(GameTable instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'players': instance.playerSummaries,
    };
