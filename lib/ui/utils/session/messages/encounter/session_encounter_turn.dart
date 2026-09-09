import '../session_action.dart';

class SessionEncounterTurnMessage extends SessionActionMessage {
  SessionEncounterTurnMessage({
    super.source,
    required super.destination,
    super.hasResponse,
    super.waitResponseTimeout,
  });
}

class SessionEncounterTurnActionMessage extends SessionEncounterTurnMessage {
  SessionEncounterTurnActionMessage({
    super.source,
    required super.destination,
    super.hasResponse,
    super.waitResponseTimeout,
    required this.actionUuid,
  });

  final String actionUuid;
}