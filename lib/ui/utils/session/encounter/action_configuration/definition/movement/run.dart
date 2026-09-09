import 'package:flutter/material.dart';

import '../../../../../../../classes/session/encounter/combat_action_type.dart';
import '../../../../../../../classes/session/encounter/combat_actions/movement/base.dart';
import '../../../../../../../classes/session/encounter/entity_action.dart';
import '../../../../clients/session_message_bus_client.dart';
import '../../../../messages/encounter/turn/assign_combat_action.dart';
import '../../../../messages/encounter/turn/get_usable_actions.dart';
import '../../../../messages/encounter/turn/set_combat_action.dart';
import '../../../../messages/map/get_movement_path.dart';
import '../../../../messages/responses/action/movement_path_result.dart';
import '../../../../messages/session_message.dart';
import '../../../../messages/session_message_response.dart';
import '../action_configuration.dart';

class ActionConfigurationMovementRun extends ActionConfiguration {
  ActionConfigurationMovementRun();

  @override
  String get name => 'Course';

  @override
  IconData get icon => Icons.directions_run;

  @override
  Future<void> plan(SessionEncounterEntityAction action) async {
    await guardPlan(action, _doPlan);
  }

  Future<void> _doPlan(SessionEncounterEntityAction action) async {
    var messageBus = SessionMessageBusClient.instance;
    if(messageBus == null) {
      // TODO: display a message
      return;
    }

    var assignedActions = <SessionEncounterEntityAction>[];

    if(action.stage == SessionEncounterEntityActionStage.none) {
      var usableActionsResponse = await messageBus.publishAndWaitForResponse(
        SessionEncounterTurnGetUsableActions(
          destination: SessionMessage.masterIdentifier,
          entityId: action.entity.id,
          excludedActionUuids: [action.uuid],
        )
      );

      if(usableActionsResponse.status != SessionMessageResponseStatus.accepted) {
        // TODO: display a nice message ?
        return;
      }

      if(usableActionsResponse.data != null) {
        var actions = (usableActionsResponse.data as List<SessionEncounterEntityAction>)
            .where((SessionEncounterEntityAction a) => a.canBeUsedFor(CombatActionType.movement));

        for(var a in actions) {
          var assignResponse = await messageBus.publishAndWaitForResponse(
            SessionEncounterTurnAssignCombatActionMessage(
              destination: SessionMessage.masterIdentifier,
              actionUuid: a.uuid,
              combatAction: CombatActionAssignedMovement(
                rank: a.rank,
                movementType: CombatActionMovementType.run,
                distanceMultiplier: 2.0,
              ),
            )
          );

          if(assignResponse.status != SessionMessageResponseStatus.accepted) {
            // TODO: display a message
            continue;
          }

          assignedActions.add(a);
        }
      }
    }

    var controllingClient = messageBus.clientControlling(action.entity.id);

    var pathResponse = await messageBus.publishAndWaitForResponse(
      SessionMapGetMovementPath(
        destination: controllingClient,
        entityId: action.entity.id,
        distanceMultiplier: 2.0,
        waitResponseTimeout: 60,
      ),
    );

    var (cancelAction, cancelReason) = mustCancelAction(pathResponse);

    if(cancelAction) {
      messageBus.publish(
        SessionMapCancelGetMovementPath(
          destination: SessionMessage.masterIdentifier,
          entityId: action.entity.id,
          cancelReason: cancelReason,
        )
      );

      for(var a in assignedActions) {
        messageBus.publish(
          SessionEncounterTurnUnassignCombatActionMessage(
            destination: SessionMessage.masterIdentifier,
            actionUuid: a.uuid,
          )
        );
      }

      return;
    }

    var r = (pathResponse.data as SessionMovementPathResult?);
    if(r == null || r.path.isEmpty || r.path.length == 0.0) {
      for(var a in assignedActions) {
        messageBus.publish(
          SessionEncounterTurnUnassignCombatActionMessage(
            destination: SessionMessage.masterIdentifier,
            actionUuid: a.uuid,
          )
        );
      }

      // TODO: display a nice message?
      return;
    }

    var setResponse = await messageBus.publishAndWaitForResponse(
      SessionEncounterTurnSetCombatActionMessage(
        destination: SessionMessage.masterIdentifier,
        actionUuid: action.uuid,
        combatAction: CombatActionMovement(
          movementType: CombatActionMovementType.run,
          rank: action.rank,
          mapId: r.mapId,
          entityId: action.entity.id,
          path: r.path,
        )
      )
    );

    if(setResponse.status != SessionMessageResponseStatus.accepted) {
      for(var a in assignedActions) {
        messageBus.publish(
          SessionEncounterTurnUnassignCombatActionMessage(
            destination: SessionMessage.masterIdentifier,
            actionUuid: a.uuid,
          )
        );
      }

      // TODO: display a message
      return;
    }
  }
}