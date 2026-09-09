import 'dart:async';

import 'package:uuid/uuid.dart';

import '../../../../classes/session/game_session.dart';
import '../../../session/session_message_bus.dart';
import '../messages/session_message.dart';
import '../messages/session_message_response.dart';
import '../messages/session_set_state.dart';

abstract class SessionMessageBusClient {
  SessionMessageBusClient()
    : uuid = Uuid().v4().toString(),
      stream = StreamController<SessionMessage>.broadcast(),
      _responses = <String, SessionMessageResponse?>{},
      _responseCallbacks = <String, SessionMessageResponseCallback>{}
  {
    SessionMessageBus.instance
      .subscribe(uuid)
      .listen((SessionMessage m) => _sessionMessageReceived(m));
  }

  static SessionMessageBusClient? instance;

  Future<GameSession?> connect();

  final String uuid;
  final StreamController<SessionMessage> stream;
  final Map<String, SessionMessageResponse?> _responses;
  final Map<String, SessionMessageResponseCallback> _responseCallbacks;

  GameSession? get session => _session;
  set session(GameSession? s) {
    if(_session != null) {
      // TODO: disconnect or throw?
    }

    if(s != null) {
      _session = s;
    }
  }
  GameSession? _session;

  // TODO: implement entities control
  String clientControlling(String entityId) =>
      SessionMessageBus.instance.master ?? SessionMessage.masterIdentifier;

  bool controlling(String entityId) =>
      clientControlling(entityId) == uuid;

  void publish(SessionMessage m) {
    m.source = uuid;

    // Shortcut for internal process communications: do not go back to the
    // central message bus
    if(m.destination == uuid) {
      _sessionMessageReceived(m);
    }
    else {
      SessionMessageBus.instance.publish(m);
    }
  }

  Future<SessionMessageResponse> publishAndWaitForResponse(SessionMessage m) async {
    if(!m.hasResponse) {
      throw ArgumentError("Session message ${m.runtimeType} does not expect a response");
    }

    _responses[m.uuid] = null;

    var waitDone = false;
    var waitFuture = Future.doWhile(() async {
      if(waitDone) return false;
      await Future.delayed(Duration(milliseconds: 200));
      return _responses[m.uuid] == null;
    });
    if(m.waitResponseTimeout != null) {
      waitFuture = waitFuture
        .timeout(
          Duration(seconds: m.waitResponseTimeout!),
        )
        .catchError((Object e) {
          waitDone = true;
          if(e is TimeoutException) {
            _responses[m.uuid] = SessionMessageResponse(
              source: m.destination,
              destination: m.source!,
              ack: m.uuid,
              status: SessionMessageResponseStatus.timeout,
            );
          }
          else {
            throw e;
          }
        });
    }
    publish(m);
    await waitFuture;

    return _responses.remove(m.uuid)!;
  }

  void publishWithResponseCallback(SessionMessage m, SessionMessageResponseCallback cb) {
    if(!m.hasResponse) {
      throw ArgumentError("Session message ${m.runtimeType} does not expect a response");
    }

    if(_responseCallbacks.containsKey(m.uuid)) {
      throw ArgumentError("Callback already registered for ${m.uuid}");
    }

    _responseCallbacks[m.uuid] = cb;
    publishAndWaitForResponse(m);
  }

  void sendResponse(
      SessionMessage m,
      dynamic data,
      {
        SessionMessageResponseStatus status = SessionMessageResponseStatus.accepted,
        String? statusMessage,
      }
  ) {
    if(!m.hasResponse) {
      throw ArgumentError("Session message ${m.runtimeType} does not expect a response");
    }

    var r = SessionMessageResponse(
      source: m.destination,
      destination: m.source!,
      ack: m.uuid,
      status: status,
      statusMessage: statusMessage,
      data: data,
    );
    publish(r);
  }

  void _sessionMessageReceived(SessionMessage m) {
    if(m is SessionSetStateMessage) {
      m.apply(_session!);
    }
    else if(m is SessionMessageResponse) {
      if(_responseCallbacks.containsKey(m.ack)) {
        var cb = _responseCallbacks.remove(m.ack);
        cb!(m);
      }
      else if(_responses.containsKey(m.ack)) {
        _responses[m.ack] = m;
      }
    }
    else {
      stream.add(m);
    }
  }
}