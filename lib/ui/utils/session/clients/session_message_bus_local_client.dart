import '../../../../classes/session/game_session.dart';
import '../../../settings/settings.dart';
import '../messages/management/request_master.dart';
import '../messages/session_message_response.dart';
import 'session_message_bus_client.dart';

class SessionCommandBusLocalClient extends SessionMessageBusClient {
  SessionCommandBusLocalClient({
    required this.sessionUuid,
  })
  {
    SessionMessageBusClient.instance = this;
  }

  final String sessionUuid;

  @override
  Future<GameSession?> connect() async {
    var s = await GameSessionStore().get(sessionUuid);

    var response = await publishAndWaitForResponse(
      SessionRequestMaster(
        source: uuid,
        runUuid: ApplicationSettings.instance.runUuid,
        waitResponseTimeout: 2,
      )
    );

    if(response.status == SessionMessageResponseStatus.accepted) {
      if(s != null) {
        await s.table.loadPlayers();
      }
      session = s;
    }
    else {
      // TODO: throw an exception here; custom class?
    }

    return session;
  }
}