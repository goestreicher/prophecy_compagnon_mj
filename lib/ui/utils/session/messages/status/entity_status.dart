import '../session_status_message.dart';

// TODO: implement limits on who can send these messages (master and the client controlling the entity)
abstract class SessionEntityStatusMessage extends SessionStatusMessage {
  SessionEntityStatusMessage({
    super.source,
    super.broadcastIncludesSelf,
    required this.entityId,
  });

  final String entityId;
}