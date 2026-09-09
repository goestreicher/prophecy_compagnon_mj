import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:prophecy_compagnon_shared/classes/generic_image.dart';

abstract class SessionMapItem extends ChangeNotifier {
  SessionMapItem({
    double? x,
    double? y,
  })
    : _x = x ?? 0.0, _y = y ?? 0.0;

  String get id;
  String? get label;
  Size get size;
  Future<GenericImage?> get image;

  double get x => _x;
  set x(double v) {
    _x = v;
    notifyListeners();
  }
  double _x;

  double get y => _y;
  set y(double v) {
    _y = v;
    notifyListeners();
  }
  double _y;

  bool get movable => false;
  double get movementDistance => 0.0;
}