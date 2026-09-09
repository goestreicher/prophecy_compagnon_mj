import 'package:flutter/material.dart';

import '../../../../../../classes/session/encounter/entity_action.dart';
import '../../../clients/session_message_bus_client.dart';
import '../../../messages/encounter/turn/action_planning.dart';
import '../../../messages/session_message_response.dart';

abstract class ActionConfiguration {
  ActionConfiguration();

  String get name;
  IconData get icon;

  Future<void> plan(SessionEncounterEntityAction action);

  @protected
  Future<void> guardPlan(
      SessionEncounterEntityAction action,
      Future<void> Function(SessionEncounterEntityAction action) guarded
  ) async {
    var planResponse = await SessionMessageBusClient.instance?.publishAndWaitForResponse(
      SessionEncounterTurnActionPlanningStart(
        destination: SessionMessageBusClient.instance!.uuid,
        actionUuid: action.uuid,
      )
    );

    if(planResponse == null) {
      // TODO: display a nice message?
      return;
    }

    if(planResponse.status != SessionMessageResponseStatus.accepted) {
      // TODO: display a nice message?
      return;
    }

    await guarded(action);

    SessionMessageBusClient.instance?.publish(
      SessionEncounterTurnActionPlanningEnd(
        destination: SessionMessageBusClient.instance!.uuid,
        actionUuid: action.uuid,
      )
    );
  }

  @protected
  (bool, String?) mustCancelAction(SessionMessageResponse response) {
    bool cancel = false;
    String? reason;

    switch(response.status) {
      case SessionMessageResponseStatus.cancelled:
        // User cancelled input, no need to cancel the
        // action as the widget that handled the action
        // is already aware of it
        break;
      case SessionMessageResponseStatus.rejected:
        cancel = true;
        reason = response.statusMessage;
      case SessionMessageResponseStatus.timeout:
        cancel = true;
        reason = "Délai d'attente dépassé";
      case SessionMessageResponseStatus.error:
        cancel = true;
        reason = "Erreur : ${response.statusMessage ?? 'pas de message remonté'}";
      case SessionMessageResponseStatus.accepted:
        break;
    }

    return (cancel, reason);
  }
}