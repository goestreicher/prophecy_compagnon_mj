// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimelineEvent _$TimelineEventFromJson(Map<String, dynamic> json) =>
    TimelineEvent(
      uuid: json['uuid'] as String,
      source: ObjectSource.fromJson(json['source'] as Map<String, dynamic>),
      range: KorDateRange.fromJson(json['range'] as Map<String, dynamic>),
      title: json['title'] as String,
      content: json['content'] as String?,
    );

Map<String, dynamic> _$TimelineEventToJson(TimelineEvent instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'source': instance.source.toJson(),
      'range': instance.range.toJson(),
      'title': instance.title,
      'content': instance.content,
    };
