import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/encounter/session_encounter_turn.dart';

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