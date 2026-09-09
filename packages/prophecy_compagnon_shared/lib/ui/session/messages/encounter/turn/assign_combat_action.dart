import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/encounter/session_encounter_turn.dart';

class SessionEncounterTurnAssignCombatActionMessage extends SessionEncounterTurnActionMessage {
  SessionEncounterTurnAssignCombatActionMessage({
    super.source,
    required super.destination,
    required super.actionUuid,
    required this.combatAction,
  })
    : super(waitResponseTimeout: 5);

  final CombatAction combatAction;
}

class SessionEncounterTurnUnassignCombatActionMessage extends SessionEncounterTurnActionMessage {
  SessionEncounterTurnUnassignCombatActionMessage({
    super.source,
    required super.destination,
    required super.actionUuid,
  })
    : super(hasResponse: false);
}