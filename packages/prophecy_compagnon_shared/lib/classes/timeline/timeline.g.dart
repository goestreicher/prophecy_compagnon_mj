// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Timeline _$TimelineFromJson(Map<String, dynamic> json) => Timeline(
  resolution:
      $enumDecodeNullable(_$TimelineResolutionEnumMap, json['resolution']) ??
      TimelineResolution.year,
);

Map<String, dynamic> _$TimelineToJson(Timeline instance) => <String, dynamic>{
  'resolution': _$TimelineResolutionEnumMap[instance.resolution]!,
  'events': instance._events.map((e) => e.toJson()).toList(),
};

const _$TimelineResolutionEnumMap = {
  TimelineResolution.year: 'year',
  TimelineResolution.day: 'day',
};
