import 'entity_status.dart';

enum EntityMessageProperty {
  useLuckPoints,
  gainLuckPoints,
  useProficiencyPoints,
  gainProficiencyPoints,
}

class SessionEntitySetPropertyMessage extends SessionEntityStatusMessage {
  SessionEntitySetPropertyMessage({
    super.source,
    super.broadcastIncludesSelf,
    required super.entityId,
    required this.property,
    required this.value,
  });

  EntityMessageProperty property;
  dynamic value;
}