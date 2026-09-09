import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_actions/movement/base.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/action_configuration/definition/action_configuration.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/action_configuration/definition/movement/run.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/action_configuration/definition/movement/simple.dart';

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