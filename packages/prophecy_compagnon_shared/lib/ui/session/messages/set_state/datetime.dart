import 'package:prophecy_compagnon_shared/classes/session/game_session.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/session_message.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/session_set_state.dart';

class SessionSetStateNextHour extends SessionSetStateMessage {
  SessionSetStateNextHour({
      super.source,
  })
    : super(
        category: SessionSetStateCategory.datetime,
        destination: SessionMessage.broadcast,
      );

  @override
  void apply(GameSession session) {
    session.nextHour();
  }
}

class SessionSetStateNextDay extends SessionSetStateMessage {
  SessionSetStateNextDay({
    super.source,
  })
    : super(
        category: SessionSetStateCategory.datetime,
        destination: SessionMessage.broadcast,
      );

  @override
  void apply(GameSession session) {
    session.day += 1;
  }
}