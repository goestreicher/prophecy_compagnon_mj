import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'map_model.dart';
import 'map_movement_description.dart';

abstract class MapModelItem extends ChangeNotifier {
  MapModelItem({
    required this.map,
    double? x,
    double? y,
  })
      : _x = x ?? 0.0, _y = y ?? 0.0;

  String get id;
  double get size;
  void setActive(bool active);

  double get x => _x;
  set x(double v) {
    _x = v;
    notifyListeners();
  }

  double get y => _y;
  set y(double v) {
    _y = v;
    notifyListeners();
  }

  bool get isSelectable => _isSelectable;
  set isSelectable(bool b) {
    _isSelectable = b;
    notifyListeners();
  }

  MapModel map;
  double _x;
  double _y;
  bool _isSelectable = false;
}