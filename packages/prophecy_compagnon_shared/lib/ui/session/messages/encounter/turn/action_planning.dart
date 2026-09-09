import 'package:prophecy_compagnon_shared/ui/session/messages/encounter/session_encounter_turn.dart';

class SessionEncounterTurnActionPlanningStart extends SessionEncounterTurnActionMessage {
  SessionEncounterTurnActionPlanningStart({
    super.source,
    required super.destination,
    required super.actionUuid,
  });
}

class SessionEncounterTurnActionPlanningEnd extends SessionEncounterTurnActionMessage {
  SessionEncounterTurnActionPlanningEnd({
    super.source,
    required super.destination,
    required super.actionUuid,
  })
    : super(hasResponse: false);
}