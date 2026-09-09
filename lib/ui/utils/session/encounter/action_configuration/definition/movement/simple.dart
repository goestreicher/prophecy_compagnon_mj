import 'package:flutter/material.dart';

import '../../../../../../../classes/session/encounter/combat_actions/movement/base.dart';
import '../../../../../../../classes/session/encounter/entity_action.dart';
import '../../../../clients/session_message_bus_client.dart';
import '../../../../messages/encounter/turn/set_combat_action.dart';
import '../../../../messages/map/get_movement_path.dart';
import '../../../../messages/responses/action/movement_path_result.dart';
import '../../../../messages/session_message.dart';
import '../../../../messages/session_message_response.dart';
import '../action_configuration.dart';

class ActionConfigurationMovementSimple extends ActionConfiguration {
  ActionConfigurationMovementSimple();

  @override
  String get name => 'Déplacement simple';

  @override
  IconData get icon => Icons.directions_walk;

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

    var controllingClient = messageBus.clientControlling(action.entity.id);

    var pathResponse = await messageBus.publishAndWaitForResponse(
      SessionMapGetMovementPath(
        destination: controllingClient,
        entityId: action.entity.id,
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

      return;
    }

    var r = (pathResponse.data as SessionMovementPathResult?);
    if(r == null || r.path.isEmpty || r.path.length == 0.0) {
      // TODO: display a nice message?
      return;
    }

    var setResponse = await messageBus.publishAndWaitForResponse(
      SessionEncounterTurnSetCombatActionMessage(
        destination: SessionMessage.masterIdentifier,
        actionUuid: action.uuid,
        combatAction: CombatActionMovement(
          movementType: CombatActionMovementType.simple,
          rank: action.rank,
          mapId: r.mapId,
          entityId: action.entity.id,
          path: r.path,
        )
      )
    );

    if(setResponse.status != SessionMessageResponseStatus.accepted) {
      // TODO: display a message
      return;
    }
  }
}