import 'package:prophecy_compagnon_shared/ui/session/messages/session_action.dart';

class SessionActionMapMessage extends SessionActionMessage {
  SessionActionMapMessage({
    super.source,
    required super.destination,
    super.hasResponse,
    super.waitResponseTimeout,
  });
}