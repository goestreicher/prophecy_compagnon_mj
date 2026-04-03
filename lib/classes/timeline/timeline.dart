import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';

import '../calendar.dart';
import 'event.dart';

part 'timeline.g.dart';

enum TimelineResolution {
  year,
  day,
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Timeline {
  Timeline({
    TimelineResolution resolution = TimelineResolution.year,
    List<TimelineEvent>? events,
  })
      : _events = events ?? <TimelineEvent>[], _resolution = resolution
  {
    _createBuckets();
  }

  factory Timeline.from(Timeline other) =>
      Timeline(
        resolution: other.resolution,
        events: List<TimelineEvent>.from(other._events),
      );

  TimelineResolution get resolution => _resolution;
  set resolution(TimelineResolution r) {
    if(r == _resolution) return;
    _buckets.clear();
    _resolution = r;
    _createBuckets();
  }

  int get length => _buckets.length;
  Iterable<KorDateRange> get keys => _buckets.keys;
  Iterable<MapEntry<KorDateRange, List<TimelineEvent>>> get entries => _buckets.entries;

  void add(TimelineEvent event) {
    _events.add(event);
    _addToBucket(event);
  }

  TimelineResolution _resolution;
  @JsonKey(includeToJson: true, name: 'events')
  final List<TimelineEvent> _events;
  final SplayTreeMap<KorDateRange, List<TimelineEvent>> _buckets =
      SplayTreeMap<KorDateRange, List<TimelineEvent>>();

  void _createBuckets() {
    _buckets.clear();
    for(var event in _events) {
      _addToBucket(event);
    }
  }

  void _addToBucket(TimelineEvent event) {
    var bucketRange = _toBucketRange(event.range);
    if(_buckets.containsKey(bucketRange)) {
      _buckets[bucketRange]!.add(event);
    }
    else {
      _buckets[bucketRange] = <TimelineEvent>[event];
    }
  }

  KorDateRange _toBucketRange(KorDateRange range) =>
      KorDateRange(
        start: _toBucketDate(range.start),
        end: _toBucketDate(range.end),
      );

  KorDate _toBucketDate(KorDate date) {
    switch(_resolution) {
      case TimelineResolution.year:
        return KorDate(
          age: date.age,
          year: date.year,
          cycle: KorCycle.values[0],
          week: 1,
          day: WeekDay.values[0],
        );
      case TimelineResolution.day:
        return KorDate(
          age: date.age,
          year: date.year,
          cycle: date.cycle,
          week: date.week,
          day: date.day,
        );
    }
  }

  static Timeline fromJson(Map<String, dynamic> json) {
    var tl = _$TimelineFromJson(json);
    tl._events.addAll(
      ((json['events'] as List<dynamic>?))
          ?.map((e) => TimelineEvent.fromJson(e as Map<String, dynamic>))
      ?? <TimelineEvent>[]
    );
    tl._createBuckets();
    return tl;
  }

  Map<String, dynamic> toJson() =>
      _$TimelineToJson(this);
}