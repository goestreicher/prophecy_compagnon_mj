import '../session_encounter_turn.dart';

class SessionEncounterTurnSelectActions extends SessionEncounterTurnMessage {
  SessionEncounterTurnSelectActions({
    super.source,
    required super.destination,
    required this.description,
    required this.entityId,
    this.excludedActionUuids = const <String>[],
    this.multiselect = false,
    this.selectRange = false,
    this.allowEmptySelection = false,
    this.usableOnly = true,
    this.showWeakHandAction = true,
  })
    : super(hasResponse: true, waitResponseTimeout: 60);

  final String description;
  final String entityId;
  final List<String> excludedActionUuids;
  final bool multiselect;
  final bool selectRange;
  final bool allowEmptySelection;
  final bool usableOnly;
  final bool showWeakHandAction;
}