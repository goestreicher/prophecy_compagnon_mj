import 'package:flutter/material.dart';

import '../../../../classes/session/encounter/combat_action_type.dart';
import '../../../../classes/session/encounter/entity_action.dart';
import '../clients/session_message_bus_client.dart';
import '../entity_pill_widget.dart';
import '../messages/encounter/turn/delay_action.dart';
import '../messages/session_message.dart';
import '../messages/session_message_response.dart';
import 'action_button/movement.dart';
import 'action_configuration/button_renderer.dart';
import 'action_configuration/finder.dart';

class TurnActionWidget extends StatelessWidget {
  const TurnActionWidget({
    super.key,
    required this.action,
    this.isActive = false,
    this.onSetActive,
    this.locked = false,
  });

  final SessionEncounterEntityAction action;
  final bool isActive;
  final void Function()? onSetActive;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var controlling = SessionMessageBusClient.instance?.controlling(action.entity.id) ?? false;
    var bottomRow = <Widget>[];

    if(action.stage == SessionEncounterEntityActionStage.planned) {
      bottomRow.add(
        Text(
          'Action planifiée',
          style: theme.textTheme.bodySmall,
        )
      );
    }
    else if(action.stage == SessionEncounterEntityActionStage.approved) {
      bottomRow.add(
        Text(
          'Action prête',
          style: theme.textTheme.bodySmall,
        )
      );
    }
    else {
      if(!isActive) {
        bottomRow.add(
          Text(
            'Cliquer pour activer',
            style: theme.textTheme.bodySmall,
          )
        );
      }
      else {
        if(action.stage == SessionEncounterEntityActionStage.none) {
          if(controlling) {
            bottomRow.add(
              IconButton(
                icon: Icon(Icons.pause),
                iconSize: 18.0,
                padding: const EdgeInsets.all(4.0),
                constraints: const BoxConstraints(),
                tooltip: "Retarder l'action",
                onPressed: () async {
                  var messageBus = SessionMessageBusClient.instance;
                  if(messageBus == null) {
                    // TODO: display a message
                    return;
                  }

                  var response = await messageBus.publishAndWaitForResponse(
                    SessionEncounterTurnDelayActionMessage(
                      destination: SessionMessage.masterIdentifier,
                      actionUuid: action.uuid,
                    )
                  );

                  if(response.status != SessionMessageResponseStatus.accepted) {
                    // TODO: display a message
                    return;
                  }
                },
              )
            );

            if(action.entity.canMove() && action.canBeUsedFor(CombatActionType.movement)) {
              bottomRow.add(
                ActionMovementButtonMenu(
                  action: action,
                )
              );
            }
          }
          else {
            bottomRow.add(
              Text(
                'Action contrôlée par un autre client',
                style: theme.textTheme.bodySmall,
              )
            );
          }
        }
        else if (action.stage == SessionEncounterEntityActionStage.assigned) {
          var actionConfiguration = action.combatAction == null
              ? null
              : actionConfigurationForCombatAction(action.combatAction!);

          if(actionConfiguration == null) {
            // TODO: propose to un-assign the action
          }
          else {
            bottomRow.add(
              Row(
                spacing: 8.0,
                children: [
                  Text(
                    'Action assignée',
                    style: theme.textTheme.bodySmall,
                  ),
                  ActionConfigurationButtonRenderer(
                    action: action,
                    actionConfiguration: actionConfiguration,
                  )
                ],
              )
            );
          }
        }
      }
    }

    var child = InkWell(
      onTap: (isActive || locked) ? null : onSetActive,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 8.0,
          children: [
            Row(
              spacing: 8.0,
              children: [
                SessionEntityPillWidget(
                  entity: action.entity,
                  width: 40,
                  height: 40,
                ),
                Text(
                  action.entity.name,
                  style: theme.textTheme.titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
            Row(
              spacing: 8.0,
              children: bottomRow,
            ),
          ],
        )
      ),
    );

    if(isActive) {
      return Card(child: child);
    }
    else {
      return Card.filled(child: child);
    }
  }
}