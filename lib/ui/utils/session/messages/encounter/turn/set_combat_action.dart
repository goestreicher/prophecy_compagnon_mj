import '../../../../../../classes/session/encounter/combat_action.dart';
import '../session_encounter_turn.dart';

class SessionEncounterTurnSetCombatActionMessage extends SessionEncounterTurnActionMessage {
  SessionEncounterTurnSetCombatActionMessage({
    super.source,
    required super.destination,
    required super.actionUuid,
    required this.combatAction,
  })
    : super(waitResponseTimeout: 5);

  final CombatAction combatAction;
}