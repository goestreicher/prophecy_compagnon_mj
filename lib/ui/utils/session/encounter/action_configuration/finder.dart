import '../../../../../classes/session/encounter/combat_action.dart';
import '../../../../../classes/session/encounter/combat_action_type.dart';
import '../../../../../classes/session/encounter/combat_actions/movement/base.dart';
import 'definition/action_configuration.dart';
import 'definition/movement/finder.dart';

ActionConfiguration? actionConfigurationForCombatAction(CombatAction ca) {
  ActionConfiguration? ret;

  switch(ca.type) {
    case CombatActionType.movement:
      if(ca is CombatActionAssignedMovement) {
        ret = actionMovementConfigurationForCombatAction(ca);
      }
    case CombatActionType.attack:
      // TODO
      break;
    case CombatActionType.defense:
      // TODO
      break;
  }

  return ret;
}