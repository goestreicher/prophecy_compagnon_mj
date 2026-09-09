import '../session_encounter_turn.dart';

class SessionEncounterTurnDelayActionMessage extends SessionEncounterTurnActionMessage {
  SessionEncounterTurnDelayActionMessage({
    super.source,
    required super.destination,
    required super.actionUuid,
  })
    : super(waitResponseTimeout: 5);
}