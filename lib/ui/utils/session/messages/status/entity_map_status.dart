import 'entity_status.dart';

abstract class SessionEntityMapStatusMessage extends SessionEntityStatusMessage {
  SessionEntityMapStatusMessage({
    super.source,
    super.broadcastIncludesSelf,
    required super.entityId,
    required this.mapId,
  });

  final String mapId;
}