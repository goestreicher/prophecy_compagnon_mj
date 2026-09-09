import 'package:uuid/uuid.dart';

abstract class SessionMessage {
  static const String busIdentifier = 'BUS';
  static const String broadcast = 'ALL';
  static const String masterIdentifier = 'MASTER';

  SessionMessage({
    this.source,
    required this.destination,
    this.hasResponse = true,
    this.waitResponseTimeout,
    this.broadcastIncludesSelf = false,
  })
    : uuid = Uuid().v4().toString();

  final String uuid;
  String? source;
  String destination;
  bool hasResponse;
  int? waitResponseTimeout;
  bool broadcastIncludesSelf;
}