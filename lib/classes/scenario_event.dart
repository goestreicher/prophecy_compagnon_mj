import 'package:json_annotation/json_annotation.dart';

part 'scenario_event.g.dart';

enum ScenarioEventCategory {
  world,
  pc,
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ScenarioEvent {
  ScenarioEvent({ required this.title, required this.description });

  String title;
  String description;

  factory ScenarioEvent.fromJson(Map<String, dynamic> json) => _$ScenarioEventFromJson(json);
  Map<String, dynamic> toJson() => _$ScenarioEventToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ScenarioDayEvents {
  ScenarioDayEvents();

  ScenarioEvent? get(ScenarioEventCategory category, int pos) {
    if(!events.containsKey(category)) {
      return null;
    }
    if(pos < 0 || pos >= events[category]!.length) {
      return null;
    }
    return events[category]![pos];
  }

  void add(ScenarioEventCategory category, ScenarioEvent event, int pos) {
    if(!events.containsKey(category)) {
      events[category] = <ScenarioEvent>[];
    }
    if(pos < 0 || pos >= events[category]!.length) {
      events[category]!.add(event);
    }
    else {
      events[category]!.insert(pos, event);
    }
  }

  void remove(ScenarioEventCategory category, int pos) {
    if(!events.containsKey(category)) {
      return;
    }
    if(pos < 0 || pos >= events[category]!.length) {
      return;
    }
    events[category]!.removeAt(pos);
    if(events[category]!.isEmpty) {
      events.remove(category);
    }
  }

  void move(ScenarioEventCategory category, int start, int dest) {
    if(!events.containsKey(category)) {
      return;
    }
    if(start == dest) {
      return;
    }
    if(start < 0 || start >= events[category]!.length) {
      return;
    }
    if(dest < 0 || dest > events[category]!.length) {
      return;
    }

    ScenarioEvent event = events[category]!.removeAt(start);
    if(start < dest) {
      dest -= 1;
    }
    events[category]!.insert(dest, event);
  }

  bool empty(ScenarioEventCategory category) => !events.containsKey(category) || events[category]!.isEmpty;

  Map<ScenarioEventCategory, List<ScenarioEvent>> events = <ScenarioEventCategory, List<ScenarioEvent>>{};

  factory ScenarioDayEvents.fromJson(Map<String, dynamic> json) => _$ScenarioDayEventsFromJson(json);
  Map<String, dynamic> toJson() => _$ScenarioDayEventsToJson(this);
}

class ScenarioEventDayRange {
  ScenarioEventDayRange({ required this.start, int end = -1 })
      : end = end == -1 ? start : end;

  final int start;
  final int end;

  @override
  String toString() => "$start,$end";

  factory ScenarioEventDayRange.fromString(String s) {
    var regexp = RegExp(r'(-?\d+)');
    var values = regexp.allMatches(s).map((v) => int.parse(v[0]!)).toList();
    if(values.length < 2) {
      values[1] = values[0];
    }
    return ScenarioEventDayRange(start: values[0], end: values[1]);
  }

  @override
  bool operator==(Object other) =>
      other is ScenarioEventDayRange && start == other.start && end == other.end;

  @override
  int get hashCode => Object.hash(start, end);
}