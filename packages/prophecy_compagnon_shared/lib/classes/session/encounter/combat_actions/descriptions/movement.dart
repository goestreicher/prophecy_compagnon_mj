import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action_description.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action_type.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/action_configuration/definition/action_configuration.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/action_configuration/definition/movement/run.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/action_configuration/definition/movement/simple.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/action_configuration/definition/movement/sprint.dart';

enum CombatActionMovementType {
  simple(title: 'Déplacement simple', icon: Icons.directions_walk),
  run(title: 'Course', icon: Icons.directions_run),
  sprint(title: 'Sprint', icon: Symbols.sprint),
  ;

  final String title;
  final IconData icon;

  const CombatActionMovementType({ required this.title, required this.icon });
}

class CombatActionMovementDescription extends CombatActionDescription {
  CombatActionMovementDescription({
    required this.movementType,
  })
    : super(type: CombatActionType.movement);

  CombatActionMovementType movementType;

  @override
  ActionConfiguration instantiate() {
    ActionConfiguration ret;

    switch(movementType) {
      case CombatActionMovementType.simple:
        ret = ActionConfigurationMovementSimple();
      case CombatActionMovementType.run:
        ret = ActionConfigurationMovementRun();
      case CombatActionMovementType.sprint:
        ret = ActionConfigurationMovementSprint();
        break;
    }

    return ret;
  }
}