import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';

import '../calendar.dart';
import '../resource_link/resource_link.dart';

part 'scenario_event.g.dart';

enum ScenarioEventCategory {
  world,
  pc,
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ScenarioEvent {
  ScenarioEvent({
    required this.uuid,
    required this.title,
    required this.description,
    required this.isRealizedInASingleDay,
  }) {
    refreshResourceLinks();
  }

  final String uuid;
  String title;
  String description;
  bool isRealizedInASingleDay;
  @JsonKey(includeToJson: false, includeFromJson: false)
    List<ResourceLink> resourceLinks = <ResourceLink>[];

  void refreshResourceLinks() {
    resourceLinks.clear();

    var resourceLinkRegExp = RegExp(r'\[([^\]]+)\]\((resource://[^)]+)\)');
    for(var match in resourceLinkRegExp.allMatches(description)) {
      if(match.groupCount == 2 && ResourceLink.isValidLink(match[2]!)) {
        var link = ResourceLink(name: match[1]!, link: match[2]!);
        resourceLinks.add(link);
      }
    }
  }

  factory ScenarioEvent.fromJson(Map<String, dynamic> json) =>
      _$ScenarioEventFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ScenarioEventToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ScenarioDayEvents {
  ScenarioDayEvents();

  Map<ScenarioEventCategory, List<ScenarioEvent>> events =
      <ScenarioEventCategory, List<ScenarioEvent>>{};

  ScenarioEvent? event(String uuid) {
    for(var c in events.values) {
      for(var e in c) {
        if(e.uuid == uuid) {
          return e;
        }
      }
    }
    return null;
  }

  ScenarioEvent? eventAt(ScenarioEventCategory category, int pos) {
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

  bool empty(ScenarioEventCategory category) =>
      !events.containsKey(category) || events[category]!.isEmpty;

  factory ScenarioDayEvents.fromJson(Map<String, dynamic> json) =>
      _$ScenarioDayEventsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ScenarioDayEventsToJson(this);
}

class ScenarioDays {
  ScenarioDays({
    Map<DayRange, ScenarioDayEvents>? days,
  })
    : _days = SplayTreeMap<DayRange, ScenarioDayEvents>.from(
                days ?? <DayRange, ScenarioDayEvents>{}
              );

  Iterable<DayRange> daysBefore(int before) =>
      _days.keys.where(
        (DayRange r) => r.start < before && r.end < before
      );

  Iterable<DayRange> get keys => _days.keys;

  bool isEmpty() =>
      _days.isEmpty;

  bool isNotEmpty() =>
      _days.isNotEmpty;

  bool containsKey(DayRange range) =>
      _days.containsKey(range);

  DayRange? rangeAfter(DayRange range) =>
      _days.firstKeyAfter(range);

  DayRange? rangeBefore(DayRange range) =>
      _days.lastKeyBefore(range);

  ScenarioDayEvents? operator [](DayRange range) =>
      _days[range];

  void operator []=(DayRange range, ScenarioDayEvents value) =>
      _days[range] = value;

  void remove(DayRange range) =>
      _days.remove(range);

  ScenarioEvent? event(String uuid) {
    for(var events in _days.values) {
      var e = events.event(uuid);
      if(e != null) {
        return e;
      }
    }
    return null;
  }

  final SplayTreeMap<DayRange, ScenarioDayEvents> _days;
}

class ScenarioDaysJsonConverter extends JsonConverter<ScenarioDays, Map<String, dynamic>> {
  const ScenarioDaysJsonConverter();

  @override
  ScenarioDays fromJson(Map<String, dynamic> json) {
    var days = Map<DayRange, ScenarioDayEvents>.fromEntries(
      json.entries.map(
        (MapEntry<String, dynamic> e) =>
          MapEntry<DayRange, ScenarioDayEvents>(
            DayRange.fromString(e.key),
            ScenarioDayEvents.fromJson(e.value as Map<String, dynamic>),
          )
      )
    );

    return ScenarioDays(days: days);
  }

  @override
  Map<String, dynamic> toJson(ScenarioDays object) {
    return Map<String, dynamic>.fromEntries(
      object._days.entries.map(
        (MapEntry<DayRange, ScenarioDayEvents> e) =>
          MapEntry(
            e.key.toString(),
            e.value.toJson()
          )
      )
    );
  }
}