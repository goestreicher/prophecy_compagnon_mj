// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scenario_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScenarioEvent _$ScenarioEventFromJson(Map<String, dynamic> json) =>
    ScenarioEvent(
      title: json['title'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$ScenarioEventToJson(ScenarioEvent instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
    };

ScenarioDayEvents _$ScenarioDayEventsFromJson(Map<String, dynamic> json) =>
    ScenarioDayEvents()
      ..events = (json['events'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            $enumDecode(_$ScenarioEventCategoryEnumMap, k),
            (e as List<dynamic>)
                .map((e) => ScenarioEvent.fromJson(e as Map<String, dynamic>))
                .toList()),
      );

Map<String, dynamic> _$ScenarioDayEventsToJson(ScenarioDayEvents instance) =>
    <String, dynamic>{
      'events': instance.events
          .map((k, e) => MapEntry(_$ScenarioEventCategoryEnumMap[k]!, e)),
    };

const _$ScenarioEventCategoryEnumMap = {
  ScenarioEventCategory.world: 'world',
  ScenarioEventCategory.pc: 'pc',
};
