import 'package:prophecy_compagnon_shared/ui/session/messages/session_message.dart';

abstract class SessionActionMessage extends SessionMessage {
  SessionActionMessage({
    super.source,
    required super.destination,
    super.hasResponse,
    super.waitResponseTimeout,
  });
}