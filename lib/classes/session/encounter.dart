import 'package:flutter/foundation.dart';

import '../combat.dart';
import '../entity_instance.dart';
import '../player_character.dart';
import 'encounter/engagements_manager.dart';
import 'encounter/turn.dart';

enum SessionEncounterStatus {
  positioning,
  ready,
  ongoing,
  finished,
}

// TODO: make this exportable to JSON
class SessionEncounter with ChangeNotifier {
  SessionEncounter({
    required this.name,
    required this.characters,
    required this.npcs,
    List<SessionEncounterTurn>? turns,
    List<(String, String, WeaponRange)>? engagements,
  })
    : _status = SessionEncounterStatus.positioning,
      turns = turns ?? <SessionEncounterTurn>[],
      engagements = EngagementsManager(engagements);

  final String name;
  final List<PlayerCharacter> characters;
  final List<EntityInstance> npcs;
  final List<SessionEncounterTurn> turns;
  final EngagementsManager engagements;

  SessionEncounterStatus get status => _status;
  set status(SessionEncounterStatus s) {
    _status = s;
    notifyListeners();
  }
  SessionEncounterStatus _status;

  int get currentTurnNumber => turns.isEmpty ? 0 : turns.length;

  SessionEncounterTurn? get currentTurn => turns.isEmpty ? null : turns.last;
}