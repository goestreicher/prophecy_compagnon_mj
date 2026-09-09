// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scenario_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScenarioEvent _$ScenarioEventFromJson(Map<String, dynamic> json) =>
    ScenarioEvent(
      uuid: json['uuid'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      isRealizedInASingleDay: json['is_realized_in_a_single_day'] as bool,
    );

Map<String, dynamic> _$ScenarioEventToJson(ScenarioEvent instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'title': instance.title,
      'description': instance.description,
      'is_realized_in_a_single_day': instance.isRealizedInASingleDay,
    };

ScenarioDayEvents _$ScenarioDayEventsFromJson(Map<String, dynamic> json) =>
    ScenarioDayEvents()
      ..events = (json['events'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          $enumDecode(_$ScenarioEventCategoryEnumMap, k),
          (e as List<dynamic>)
              .map((e) => ScenarioEvent.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );

Map<String, dynamic> _$ScenarioDayEventsToJson(ScenarioDayEvents instance) =>
    <String, dynamic>{
      'events': instance.events.map(
        (k, e) => MapEntry(
          _$ScenarioEventCategoryEnumMap[k]!,
          e.map((e) => e.toJson()).toList(),
        ),
      ),
    };

const _$ScenarioEventCategoryEnumMap = {
  ScenarioEventCategory.world: 'world',
  ScenarioEventCategory.pc: 'pc',
};
