import 'dart:math';
import 'dart:ui';

class MovementDescription {
  MovementDescription({
    required this.startX, required this.startY,
    double? currentX, double? currentY,
  })
      : currentX = currentX ?? startX,
        currentY = currentY ?? startY,
        lastValidX = currentX ?? startX,
        lastValidY = currentY ?? startY;

  double startX;
  double startY;
  double currentX;
  double currentY;
  double lastValidX;
  double lastValidY;

  Offset get offset => Offset(startX - currentX, startY - currentY);

  double get distance {
    var d = offset;
    return sqrt(d.dx * d.dx + d.dy * d.dy);
  }
}