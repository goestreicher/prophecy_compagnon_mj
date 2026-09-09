import 'package:prophecy_compagnon_shared/ui/session/messages/session_message.dart';

typedef SessionMessageResponseCallback = void Function(SessionMessageResponse);

enum SessionMessageResponseStatus {
  accepted,
  cancelled,
  rejected,
  error,
  timeout,
}

class SessionMessageResponse extends SessionMessage {
  SessionMessageResponse({
    required super.source,
    required super.destination,
    super.hasResponse = false,
    required this.ack,
    required this.status,
    this.statusMessage,
    this.data,
  }) {
    if(destination == SessionMessage.broadcast) {
      throw ArgumentError("A message response cannot be broadcast");
    }
  }

  final String ack;
  final SessionMessageResponseStatus status;
  final String? statusMessage;
  final dynamic data;
}