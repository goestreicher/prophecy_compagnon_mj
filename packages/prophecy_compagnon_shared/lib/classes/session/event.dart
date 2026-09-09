import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:prophecy_compagnon_shared/classes/calendar.dart';
import 'package:prophecy_compagnon_shared/classes/scenario/scenario_event.dart';

class SessionEvent {
  SessionEvent({
    this.parent,
    this.me,
    this.realized,
    this.notes = const <String>[],
  })
  {
    if(me != null && parent != null) {
      throw(ArgumentError('Either "parent" or "me" can be specified, not both'));
    }
    if(me == null && parent == null) {
      throw(ArgumentError('Either "parent" or "me" must be specified'));
    }
  }

  ScenarioEvent? parent;
  ScenarioEvent? me;
  DayRange? realized;
  List<String> notes;

  String get uuid =>
      parent?.uuid ?? me!.uuid;

  String get title =>
      parent?.title ?? me!.title;

  String get description =>
      parent?.description ?? me!.description;

  bool get isRealizedInASingleDay =>
      parent?.isRealizedInASingleDay ?? me!.isRealizedInASingleDay;

  factory SessionEvent.fromJson(
      Map<String, dynamic> json,
      List<ScenarioEvent> scenarioEvents
  ) {
    if(json.containsKey('type') && json['type'] == 'reference') {
      var e = scenarioEvents.firstWhere(
                (ScenarioEvent e) => e.uuid == json['uuid']!
              );
      return SessionEvent(
        parent: e,
        realized: json['realized'] != null
          ? DayRange.fromString(json['realized']! as String)
          : null,
        notes: ((json['notes'] as List<dynamic>?) ?? <dynamic>[])
          .map((dynamic e) => e.toString())
          .toList(),
      );
    }
    else {
      var e = ScenarioEvent.fromJson(json);
      return SessionEvent(
        me: e,
        realized: json['realized'] != null
          ? DayRange.fromString(json['realized']! as String)
          : null,
        notes: ((json['notes'] as List<dynamic>?) ?? <dynamic>[])
          .map((dynamic e) => e.toString())
          .toList(),
      );
    }
  }

  Map<String, dynamic> toJson() {
    var ret = <String, dynamic>{};

    if(parent != null) {
      ret['type'] = 'reference';
      ret['uuid'] = parent!.uuid;
    }
    else {
      ret = me!.toJson();
    }

    ret['realized'] = realized?.toString();
    ret['notes'] = notes;

    return ret;
  }
}

class SessionDayEvents {
  SessionDayEvents();

  Map<ScenarioEventCategory, List<SessionEvent>> events =
      <ScenarioEventCategory, List<SessionEvent>>{};

  ScenarioEventCategory? eventCategory(String uuid) {
    for(var c in events.keys) {
      for(var e in events[c]!) {
        if(e.uuid == uuid) {
          return c;
        }
      }
    }
    return null;
  }

  SessionEvent? event(String uuid) {
    for(var c in events.values) {
      for(var e in c) {
        if(e.uuid == uuid) {
          return e;
        }
      }
    }
    return null;
  }

  void add(ScenarioEventCategory category, SessionEvent event) {
    if(!events.containsKey(category)) {
      events[category] = <SessionEvent>[];
    }
    events[category]!.add(event);
  }

  void remove(String uuid) {
    for(var e in events.values) {
      e.removeWhere((SessionEvent evt) => evt.uuid == uuid);
    }
  }

  List<SessionEvent> unrealized() {
    var ret = <SessionEvent>[];
    for(var c in ScenarioEventCategory.values) {
      if(events.containsKey(c)) {
        ret.addAll(events[c]!.where((SessionEvent e) => e.realized == null));
      }
    }
    return ret;
  }

  List<SessionEvent>? operator [](ScenarioEventCategory c) =>
      events[c];

  factory SessionDayEvents.fromJson(
      Map<String, dynamic> json,
      ScenarioDayEvents scenarioDayEvents,
  ) {
    var ret = SessionDayEvents();

    for(var c in json.keys) {
      ScenarioEventCategory? category = ScenarioEventCategory.values.asNameMap()[c];
      if(category == null) continue;

      ret.events[category] = ((json[c] as List<dynamic>?) ?? <dynamic>[])
          .map(
              (dynamic e) => SessionEvent.fromJson(
                  e as Map<String, dynamic>,
                  (scenarioDayEvents.events[category] ?? <ScenarioEvent>[])
              )
          )
          .toList();
    }

    return ret;
  }

  Map<String, dynamic> toJson() {
    var ret = <String, dynamic>{};

    for(var c in ScenarioEventCategory.values) {
      var l = (events[c] ?? <SessionEvent>[])
          .map((SessionEvent e) => e.toJson());
      ret[c.name] = l.toList();
    }

    return ret;
  }
}

class SessionDays extends ChangeNotifier {
  SessionDays({
    Map<DayRange, SessionDayEvents>? sessionDays,
    Map<String, DayRange>? remapped,
  })
    : _days = sessionDays != null
                ? SplayTreeMap<DayRange, SessionDayEvents>.from(sessionDays)
                : SplayTreeMap<DayRange, SessionDayEvents>(),
      _remapped = remapped ?? <String, DayRange>{};

  final SplayTreeMap<DayRange, SessionDayEvents> _days;
  final Map<String, DayRange> _remapped;

  Iterable<DayRange> get keys => _days.keys;

  Iterable<DayRange> rangesForDay(int day) =>
      _days.keys
        .where((DayRange r) => r.start <= day && day <= r.end);

  void add(DayRange range, ScenarioEventCategory category, SessionEvent event) {
    if(!_days.containsKey(range)) {
      _days[range] = SessionDayEvents();
    }
    _days[range]!.add(category, event);
    notifyListeners();
  }

  Iterable<DayRange> daysBefore(int before) =>
      _days.keys.where(
        (DayRange r) => r.end < before
      );

  void markEventAsRealized(DayRange originalRange, String uuid, DayRange realizationRange) {
    if(!_days.containsKey(originalRange)) return;

    var event = _days[originalRange]!.event(uuid);
    if(event == null) return;

    if(originalRange != realizationRange) {
      var category = _days[originalRange]!.eventCategory(uuid)!;

      if(!_days.containsKey(realizationRange)) {
        _days[realizationRange] = SessionDayEvents();
      }
      _days[realizationRange]!.add(
        category,
        event,
      );

      _remapped[uuid] = originalRange;
      _days[originalRange]!.remove(uuid);
    }

    event.realized = realizationRange;
    notifyListeners();
  }

  List<SessionEvent> unrealized(DayRange range) =>
      _days[range]?.unrealized() ?? <SessionEvent>[];

  SessionDayEvents? operator [](DayRange range) =>
      _days[range];

  void updateWithScenarioDays(ScenarioDays scenarioDays) {
    for(var range in _days.keys) {
      if(scenarioDays.containsKey(range)) {
        for(var c in scenarioDays[range]!.events.keys) {
          if(!_days[range]!.events.containsKey(c)) {
            _days[range]!.events[c] = <SessionEvent>[];
          }

          for(var e in scenarioDays[range]!.events[c]!) {
            if(_remapped.containsKey(e.uuid)) continue;
            var se = _days[range]!.event(e.uuid);
            if(se == null) {
              _days[range]!.events[c]!.add(
                SessionEvent(parent: e)
              );
            }
          }
        }
      }
    }

    for(var range in scenarioDays.keys) {
      if(!_days.containsKey(range)) {
        var sessionDayEvents = SessionDayEvents();

        for(var c in scenarioDays[range]!.events.keys) {
          sessionDayEvents.events[c] = <SessionEvent>[];

          for(var e in scenarioDays[range]!.events[c]!) {
            if(_remapped.containsKey(e.uuid)) continue;
            sessionDayEvents.events[c]!.add(
              SessionEvent(parent: e)
            );
          }
        }

        _days[range] = sessionDayEvents;
      }
    }
  }

  factory SessionDays.fromJson({
      required Map<String, dynamic> sessionDays,
      required Map<String, dynamic> remapped,
      required ScenarioDays scenarioDays,
  }) {
    var days = <DayRange, SessionDayEvents>{};
    var remappedDays = <String, DayRange>{};

    for(var r in sessionDays.keys) {
      var range = DayRange.fromString(r);
      var events = SessionDayEvents.fromJson(
          sessionDays[r] as Map<String, dynamic>,
          scenarioDays[range] ?? ScenarioDayEvents()
      );

      days[range] = events;
    }

    for(var uuid in remapped.keys) {
      var range = DayRange.fromString(remapped[uuid]! as String);
      remappedDays[uuid] = range;
    }

    var ret = SessionDays(
      sessionDays: days,
      remapped: remappedDays,
    );
    ret.updateWithScenarioDays(scenarioDays);

    return ret;
  }

  Map<String, dynamic> toJson() {
    return {
      "days": Map<String, dynamic>.fromEntries(
          _days.entries.map(
              (MapEntry<DayRange, SessionDayEvents> e) =>
                  MapEntry(
                      e.key.toString(),
                      e.value.toJson()
                  )
          )
      ),
      "remapped": Map<String, String>.fromEntries(
          _remapped.entries.map(
              (MapEntry<String, DayRange> e) =>
                  MapEntry(
                    e.key,
                    e.value.toString()
                  )
          )
      )
    };
  }
}