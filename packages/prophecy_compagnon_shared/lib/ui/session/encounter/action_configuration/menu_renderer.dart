import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/entity_action.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/action_configuration/definition/action_configuration.dart';

class ActionConfigurationMenuRenderer extends StatelessWidget {
  const ActionConfigurationMenuRenderer({
    super.key,
    required this.action,
    required this.actionConfiguration,
  });

  final SessionEncounterEntityAction action;
  final ActionConfiguration actionConfiguration;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return MenuItemButton(
      leadingIcon: Icon(
        actionConfiguration.icon,
        size: 18.0,
      ),
      onPressed: () {
        actionConfiguration.plan(action);
      },
      child: Text(
        actionConfiguration.name,
        style: theme.textTheme.bodySmall,
      ),
    );
  }
}