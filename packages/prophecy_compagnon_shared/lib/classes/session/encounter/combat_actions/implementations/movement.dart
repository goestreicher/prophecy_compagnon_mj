import 'dart:ui';

import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action_type.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_actions/descriptions/movement.dart';
import 'package:prophecy_compagnon_shared/classes/session/map/movement_path.dart';

class CombatActionAssignedMovement extends CombatAction {
  CombatActionAssignedMovement({
    required super.rank,
    required this.movementType,
    super.interpolate = false,
    this.distanceMultiplier = 1.0,
  })
    : super(type: CombatActionType.movement);

  final CombatActionMovementType movementType;
  final double distanceMultiplier;
}

class CombatActionMovement extends CombatActionAssignedMovement {
  CombatActionMovement({
    required super.rank,
    required super.movementType,
    super.distanceMultiplier,
    required this.mapId,
    required this.entityId,
    required this.path,
  })
    : super(interpolate: true);

  final String mapId;
  final String entityId;
  final MovementPath path;

  @override
  CombatAction? lerp(int rank, double x) {
    final ret = CombatActionMovement(
      rank: rank,
      movementType: movementType,
      mapId: mapId,
      entityId: entityId,
      path: MovementPath(),
    );

    if(x == 1.0) {
      ret.path.segments.addAll(path.segments);
      return ret;
    }

    var interpolatedLength = path.length * x;
    MovementPathSegment finalSegment = path.segments.first;

    for(var s in path.segments.sublist(1)) {
      if((interpolatedLength - finalSegment.length) <= 0.0) {
        break;
      }

      interpolatedLength -= finalSegment.length;
      ret.path.segments.add(finalSegment);
      finalSegment = s;
    }

    var segmentLengthRatio = interpolatedLength / finalSegment.length;
    var partialSegment = MovementPathSegment(
      start: finalSegment.start,
      end: Offset(
        finalSegment.start.dx + ((finalSegment.end.dx - finalSegment.start.dx) * segmentLengthRatio),
        finalSegment.start.dy + ((finalSegment.end.dy - finalSegment.start.dy) * segmentLengthRatio),
      ),
    );
    ret.path.segments.add(partialSegment);

    return ret;
  }
}