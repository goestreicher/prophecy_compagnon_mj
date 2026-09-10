import 'package:material_ui/material_ui.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/entity_action.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/action_configuration/definition/movement/run.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/action_configuration/definition/movement/simple.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/action_configuration/definition/movement/sprint.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/action_configuration/menu_renderer.dart';

class ActionMovementButtonMenu extends StatelessWidget {
  const ActionMovementButtonMenu({
    super.key,
    required this.action,
  });

  final SessionEncounterEntityAction action;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: [
        ActionConfigurationMenuRenderer(
          action: action,
          actionConfiguration: ActionConfigurationMovementSimple(),
        ),
        ActionConfigurationMenuRenderer(
          action: action,
          actionConfiguration: ActionConfigurationMovementRun(),
        ),
        ActionConfigurationMenuRenderer(
          action: action,
          actionConfiguration: ActionConfigurationMovementSprint(),
        ),
      ],
      builder: (BuildContext context, MenuController controller, Widget? child) {
        return IconButton(
          icon: Icon(Symbols.arrows_output),
          iconSize: 18.0,
          padding: const EdgeInsets.all(4.0),
          constraints: const BoxConstraints(),
          tooltip: "Déplacement",
          onPressed: () {
            if(controller.isOpen) {
              controller.close();
            }
            else {
              controller.open();
            }
          }
        );
      },
    );
  }
}