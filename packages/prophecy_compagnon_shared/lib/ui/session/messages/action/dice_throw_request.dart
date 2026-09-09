import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/session_action.dart';

class SessionActionDiceThrowRequestMessage extends SessionActionMessage {
  SessionActionDiceThrowRequestMessage({
    super.source,
    required super.destination,
    required this.entityId,
    required this.request,
  })
    : super(waitResponseTimeout: 60);

  final String entityId;
  final DiceThrowRequest request;
}