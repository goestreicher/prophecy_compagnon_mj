import 'package:flutter/material.dart';

import '../../../../../classes/session/encounter/entity_action.dart';
import 'definition/action_configuration.dart';

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