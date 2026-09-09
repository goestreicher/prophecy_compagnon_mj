import 'entity_map_status.dart';

class SessionEntityPositionStatusMessage extends SessionEntityMapStatusMessage {
  SessionEntityPositionStatusMessage({
    super.source,
    super.broadcastIncludesSelf,
    required super.entityId,
    required super.mapId,
    required this.x,
    required this.y,
  });

  final double x;
  final double y;
}