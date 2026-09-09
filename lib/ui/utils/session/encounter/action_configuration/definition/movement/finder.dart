import '../../../../../../../classes/session/encounter/combat_actions/movement/base.dart';
import '../action_configuration.dart';
import 'run.dart';
import 'simple.dart';

ActionConfiguration? actionMovementConfigurationForCombatAction(CombatActionAssignedMovement ca) {
  ActionConfiguration? ret;

  switch(ca.movementType) {
    case CombatActionMovementType.simple:
      ret = ActionConfigurationMovementSimple();
    case CombatActionMovementType.run:
      ret = ActionConfigurationMovementRun();
    case CombatActionMovementType.sprint:
      // TODO
      break;
  }

  return ret;
}