import 'package:prophecy_compagnon_shared/classes/session/game_session.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/session_message.dart';

enum SessionSetStateCategory {
  board,
  datetime,
}

abstract class SessionSetStateMessage extends SessionMessage {
  SessionSetStateMessage({
    super.source,
    required super.destination,
    required this.category,
    super.hasResponse = false,
  })
    : super(broadcastIncludesSelf: true);

  SessionSetStateCategory category;

  void apply(GameSession session);
}