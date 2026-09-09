import 'session_message.dart';

abstract class SessionStatusMessage extends SessionMessage {
  SessionStatusMessage({
    super.source,
    super.broadcastIncludesSelf,
  })
    : super(destination: SessionMessage.broadcast, hasResponse: false);
}