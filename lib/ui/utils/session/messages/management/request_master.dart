import '../session_message.dart';

class SessionRequestMaster extends SessionMessage {
  SessionRequestMaster({
    required super.source,
    required this.runUuid,
    super.waitResponseTimeout,
  })
    : super(destination: SessionMessage.busIdentifier);

  final String runUuid;
}