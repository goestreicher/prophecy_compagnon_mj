import 'package:prophecy_compagnon_shared/ui/session/messages/map/session_action_map.dart';

class SessionMapGetMovementPath extends SessionActionMapMessage {
  SessionMapGetMovementPath({
    super.source,
    required super.destination,
    super.waitResponseTimeout,
    required this.entityId,
    this.distanceMultiplier = 1.0,
  });

  final String entityId;
  final double distanceMultiplier;
}

class SessionMapCancelGetMovementPath extends SessionActionMapMessage {
  SessionMapCancelGetMovementPath({
    super.source,
    required super.destination,
    required this.entityId,
    this.cancelReason,
  })
    : super(hasResponse: false);

  final String entityId;
  final String? cancelReason;
}