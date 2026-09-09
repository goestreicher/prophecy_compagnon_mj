import 'package:uuid/uuid.dart';

import '../../entity_base.dart';
import 'combat_action.dart';
import 'combat_action_type.dart';

enum SessionEncounterEntityActionStage {
  none,
  assigned,
  planned,
  approved,
  executed,
}

class SessionEncounterEntityAction {
  SessionEncounterEntityAction({
    String? uuid,
    required this.entity,
    required this.initialRank,
    this.weakHand = false,
    this.combatAction,
  })
    : uuid = uuid ?? Uuid().v4().toString();

  final String uuid;
  final EntityBase entity;
  int initialRank;
  int delayed = 0;
  bool weakHand;
  SessionEncounterEntityActionStage stage = SessionEncounterEntityActionStage.none;
  CombatAction? combatAction;

  int get rank => initialRank - delayed;

  bool canBeUsedFor(CombatActionType type) {
    if(
        stage != SessionEncounterEntityActionStage.none
        && stage != SessionEncounterEntityActionStage.assigned
    ) {
      return false;
    }

    if(weakHand) {
      return
        type == CombatActionType.attack
        || type == CombatActionType.defense;
    }

    return true;
  }
}