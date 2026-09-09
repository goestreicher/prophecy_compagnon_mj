import 'package:prophecy_compagnon_shared/ui/session/messages/session_message.dart';

abstract class SessionStatusMessage extends SessionMessage {
  SessionStatusMessage({
    super.source,
    super.broadcastIncludesSelf,
  })
    : super(destination: SessionMessage.broadcast, hasResponse: false);
}