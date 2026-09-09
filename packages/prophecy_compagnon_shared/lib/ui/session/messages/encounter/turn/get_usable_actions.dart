import 'package:prophecy_compagnon_shared/ui/session/messages/encounter/session_encounter_turn.dart';

class SessionEncounterTurnGetUsableActions extends SessionEncounterTurnMessage {
  SessionEncounterTurnGetUsableActions({
    super.source,
    required super.destination,
    required this.entityId,
    this.excludedActionUuids = const <String>[],
  })
    : super(hasResponse: true, waitResponseTimeout: 5);

  final String entityId;
  final List<String> excludedActionUuids;
}