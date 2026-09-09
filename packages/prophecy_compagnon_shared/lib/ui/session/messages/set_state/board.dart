import 'package:prophecy_compagnon_shared/classes/session/board/item.dart';
import 'package:prophecy_compagnon_shared/classes/session/game_session.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/session_message.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/session_set_state.dart';

class SessionSetStateBoardPush extends SessionSetStateMessage {
  SessionSetStateBoardPush({
    required this.item,
    super.source,
  })
    : super(
      category: SessionSetStateCategory.board,
      destination: SessionMessage.broadcast,
    );

  final SessionBoardItem item;

  @override
  void apply(GameSession session) {
    session.board.insert(0, item);
  }
}

class SessionSetStateBoardSelect extends SessionSetStateMessage {
  SessionSetStateBoardSelect({
    required this.index,
    super.source,
  })
    : super(
        category: SessionSetStateCategory.board,
        destination: SessionMessage.broadcast,
      );

  final int index;

  @override
  void apply(GameSession session) {
    session.board.selected = index;
  }
}

class SessionSetStateBoardRemove extends SessionSetStateMessage {
  SessionSetStateBoardRemove({
    required this.index,
    super.source,
  })
    : super(
        category: SessionSetStateCategory.board,
        destination: SessionMessage.broadcast,
      );

  final int index;

  @override
  void apply(GameSession session) {
    session.board.removeAt(index);
  }
}