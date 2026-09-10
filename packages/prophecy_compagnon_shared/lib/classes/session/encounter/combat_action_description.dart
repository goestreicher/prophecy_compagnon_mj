import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action_type.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/action_configuration/definition/action_configuration.dart';

abstract class CombatActionDescription {
  CombatActionDescription({
    required this.type,
  });

  CombatActionType type;

  ActionConfiguration instantiate();
}