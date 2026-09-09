import '../../../../../classes/session/game_session.dart';
import '../session_message.dart';
import '../session_set_state.dart';


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