import 'dart:ui';

import 'map_model_item.dart';
import 'map_movement_description.dart';

abstract class MapModelMovableItem extends MapModelItem {
  MapModelMovableItem({
    required super.map,
    super.x,
    super.y,
  });

  double get movementLimit;

  void moveStart() {
    map.itemMoveStart(this);
    if(map.movementRangeSpecification == null) {
      _currentMovement = MovementDescription(
        startX: x,
        startY: y,
      );
    }
    else {
      _currentMovement = MovementDescription(
        startX: map.movementRangeSpecification!.center.dx,
        startY: map.movementRangeSpecification!.center.dy,
        currentX: x,
        currentY: y,
      );
    }
  }

  void moveUpdate(Offset delta) {
    var newX = x + delta.dx;
    var newY = y + delta.dy;

    if(map.isInBoundaries(newX, newY)) {
      _currentMovement!.currentX = newX;
      _currentMovement!.currentY = newY;
      x += delta.dx;
      y += delta.dy;

      if(map.freeMovementEnabled || _currentMovement!.distance <= (movementLimit - size/2)) {
        _currentMovement!.lastValidX = newX;
        _currentMovement!.lastValidY = newY;
      }
    }
  }

  void moveEnd() {
    x = _currentMovement!.lastValidX;
    y = _currentMovement!.lastValidY;
    _currentMovement = null;
    map.itemMoveEnd(this);
  }

  void moveTo(double newX, double newY) {
    x = newX;
    y = newY;
    map.itemMoveEnd(this);
  }

  MovementDescription? _currentMovement;
}