// TODO: implement limits on who can send these messages (master and the client controlling the entity)
import 'package:prophecy_compagnon_shared/ui/session/messages/session_status_message.dart';

abstract class SessionEntityStatusMessage extends SessionStatusMessage {
  SessionEntityStatusMessage({
    super.source,
    super.broadcastIncludesSelf,
    required this.entityId,
  });

  final String entityId;
}