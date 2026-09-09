import 'entity_action.dart';

class SessionEncounterTurn {
  SessionEncounterTurn({
    required this.actions,
  });

  final List<SessionEncounterEntityAction> actions;

  Iterable<SessionEncounterEntityAction> filteredActions(
      bool Function(SessionEncounterEntityAction) filter
  ) =>
      actions.where((SessionEncounterEntityAction a) => filter(a));

  Iterable<int> ranksWithActionFilter(
      bool Function(SessionEncounterEntityAction) filter
  ) =>
      filteredActions(filter)
        .map((SessionEncounterEntityAction a) => a.rank)
        .toSet()
        .toList()
        ..sort((int a, int b) => b - a);

  Iterable<SessionEncounterEntityAction> actionsForRank(int rank) => actions
      .where((SessionEncounterEntityAction a) => a.rank == rank);
}