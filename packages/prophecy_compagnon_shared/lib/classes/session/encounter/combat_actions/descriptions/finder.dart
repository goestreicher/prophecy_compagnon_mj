import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action_description.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action_type.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_actions/descriptions/movement.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_actions/implementations/movement.dart';

CombatActionDescription? actionDescriptionForCombatAction(CombatAction action) {
  CombatActionDescription? ret;

  switch(action.type) {
    case CombatActionType.movement:
      if(action is CombatActionAssignedMovement) {
        ret = CombatActionMovementDescription(movementType: action.movementType);
      }
  }

  return ret;
}