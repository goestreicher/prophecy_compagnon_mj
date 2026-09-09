import '../../../classes/session/encounter/combat_action.dart';
import '../../../classes/session/encounter/combat_action_type.dart';
import '../../../classes/session/encounter/combat_actions/movement/base.dart';
import '../../utils/session/clients/session_message_bus_client.dart';
import '../../utils/session/messages/status/entity_position_status.dart';

void executeTurnAction(CombatAction action) {
  switch(action.type) {
    case CombatActionType.movement:
      _executeMovementAction(action as CombatActionMovement);
    case CombatActionType.attack:
      // TODO
      break;
    case CombatActionType.defense:
      // TODO
      break;
  }
}

void _executeMovementAction(CombatActionMovement action) {
  SessionMessageBusClient.instance?.publish(
    SessionEntityPositionStatusMessage(
      broadcastIncludesSelf: true,
      mapId: action.mapId,
      entityId: action.entityId,
      x: action.path.segments.last.end.dx,
      y: action.path.segments.last.end.dy,
    )
  );
}