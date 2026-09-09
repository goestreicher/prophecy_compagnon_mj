import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:prophecy_compagnon_shared/classes/calendar.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/scenario/scenario.dart';
import 'package:prophecy_compagnon_shared/classes/scenario/scenario_event.dart';
import 'package:prophecy_compagnon_shared/classes/session/board/board.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter.dart';
import 'package:prophecy_compagnon_shared/classes/session/event.dart';
import 'package:prophecy_compagnon_shared/classes/storage/storable.dart';
import 'package:prophecy_compagnon_shared/classes/table.dart';
import 'package:uuid/uuid.dart';

part 'game_session.g.dart';

class GameSessionStore extends JsonStoreAdapter<GameSession> {
  GameSessionStore();

  @override
  String storeCategory() => 'gameSessions';

  @override
  String key(GameSession object) => object.uuid;

  @override
  Future<GameSession> fromJsonRepresentation(Map<String, dynamic> j) async {
    var jsonFull = j;

    // TODO: manage when scenario or table were removed or when get() fails
    jsonFull['scenario'] = (await ScenarioStore().get(j['scenario']))!.toJson();
    jsonFull['table'] = (await GameTableStore().getWithPlayers(j['table']))!.toJson();

    return GameSession.fromJson(jsonFull);
  }

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(GameSession object) async {
    var j = object.toJson();

    j['table'] = object.table.uuid;
    j['scenario'] = object.scenario.uuid;

    return j;
  }
}

@ScenarioDaysJsonConverter()
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class GameSession extends ChangeNotifier {
  GameSession({
    String? uuid,
    required this.table,
    required this.scenario,
    required this.startDate,
    int? scenarioDay,
    this.dayHour = 0,
    SessionDays? sessionDays,
    SessionEncounter? encounter,
    SessionGameBoard? board,
  })
    : uuid = uuid ?? const Uuid().v4().toString(),
      encounter = ValueNotifier<SessionEncounter?>(encounter),
      board = board ?? SessionGameBoard()
  {
    if(sessionDays == null) {
      this.sessionDays = SessionDays.fromJson(
        sessionDays: <String, dynamic>{},
        remapped: <String, dynamic>{},
        scenarioDays: scenario.events,
      );
    }

    this.sessionDays.updateWithScenarioDays(scenario.events);

    // If scenarioDay is null, assume this is a new session, and mark all
    // events before the start as realized, for the world category
    if(scenarioDay == null) {
      for(var range in this.sessionDays.daysBefore(0)) {
        for(var event in (this.sessionDays[range]!.events[ScenarioEventCategory.world] ?? <SessionEvent>[])) {
          event.realized = range;
        }
      }
    }
    this.scenarioDay = scenarioDay ?? 0;
  }

  final String uuid;
  final GameTable table;
  final Scenario scenario;

  KorDate startDate;
  late int scenarioDay;
  late int dayHour;

  EntityBase? entity(String id) {
    for(var e in table.players) {
      if(e.id == id) return e;
    }
    for(var e in (encounter.value?.npcs ?? <EntityBase>[])) {
      if(e.id == id) return e;
    }
    return null;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  late SessionDays sessionDays;

  @JsonKey(includeFromJson: false, includeToJson: false)
  int get day => scenarioDay;
  set day(int d) {
    scenarioDay = d;
    dayHour = 0;
    notifyListeners();
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  int get hour => dayHour;
  set hour(int h) {
    dayHour = h;
    notifyListeners();
  }
  void nextHour() {
    if(dayHour == 23) {
      scenarioDay += 1;
      dayHour = 0;
    }
    else {
      dayHour += 1;
    }
    notifyListeners();
  }

  KorDate get currentDate =>
      startDate.clone()..addDays(day);

  KorDate relativeSessionDate(int dayOffset) =>
      startDate.clone()..addDays(dayOffset);

  String relativeSessionDateDescription(int dayOffset) {
    if(dayOffset == 0) {
      return "Aujourd'hui";
    }
    else {
      var plural = dayOffset < -1 || dayOffset > 1
          ? 's'
          : '';
      var relative = dayOffset < 0
          ? 'Il y a'
          : 'Dans';
      return '$relative ${dayOffset.abs()} jour$plural';
    }
  }

  // TODO: add this to JSON
  @JsonKey(includeFromJson: false, includeToJson: false)
  ValueNotifier<SessionEncounter?> encounter;

  // set encounter(SessionEncounter? newEncounter) {
  //   if(encounter != null) {
  //     throw ArgumentError("Une rencontre est déjà en cours");
  //   }
  //   _currentEncounter = newEncounter;
  //   notifyListeners();
  // }
  //
  // SessionEncounter? _currentEncounter;

  // TODO: add this to JSON
  @JsonKey(includeFromJson: false, includeToJson: false)
  SessionGameBoard board;

  factory GameSession.fromJson(Map<String, dynamic> json) {
    var ret = _$GameSessionFromJson(json);

    if(
        json.containsKey('session_days')
        && json['session_days'] is Map
        && json['session_days']!.containsKey('days')
    ) {
      var entry = json['session_days'] as Map<String, dynamic>;

      ret.sessionDays = SessionDays.fromJson(
        sessionDays: entry['days'] as Map<String, dynamic>,
        remapped: (entry['remapped'] ?? <String, dynamic>{}) as Map<String, dynamic>,
        scenarioDays: ret.scenario.events,
      );
    }

    return ret;
  }

  Map<String, dynamic> toJson() {
    var ret = _$GameSessionToJson(this);

    ret['session_days'] = sessionDays.toJson();

    return ret;
  }
}