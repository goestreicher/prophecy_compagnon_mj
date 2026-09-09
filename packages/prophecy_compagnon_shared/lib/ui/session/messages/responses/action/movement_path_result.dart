import 'package:prophecy_compagnon_shared/classes/session/map/movement_path.dart';

class SessionMovementPathResult {
  const SessionMovementPathResult({
    required this.mapId,
    required this.path,
  });

  final String mapId;
  final MovementPath path;
}