import 'package:flutter/material.dart';

import '../../../../../classes/session/encounter/entity_action.dart';
import 'definition/action_configuration.dart';

class ActionConfigurationButtonRenderer extends StatelessWidget {
  const ActionConfigurationButtonRenderer({
    super.key,
    required this.action,
    required this.actionConfiguration,
  });

  final SessionEncounterEntityAction action;
  final ActionConfiguration actionConfiguration;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        actionConfiguration.plan(action);
      },
      icon: Icon(actionConfiguration.icon),
      iconSize: 18.0,
      padding: const EdgeInsets.all(4.0),
      constraints: const BoxConstraints(),
      tooltip: actionConfiguration.name,
    );
  }
}