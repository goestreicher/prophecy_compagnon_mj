import 'dart:math';

import 'package:flutter/widgets.dart';

import '../../classes/place.dart';

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

class MovementDescription {
  MovementDescription({
    required this.startX, required this.startY,
    currentX, currentY,
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

class MapModel extends ChangeNotifier {
  MapModel({ required this.background })
    : controller = TransformationController();

  final PlaceMap background;
  TransformationController controller;
  bool displayInitializationDone = false;

  final Map<String, MapModelItem> items = <String, MapModelItem>{};
  final Set<String> pcs = <String>{};
  final Set<String> npcs = <String>{};

  MovementRangeSpecification? get movementRangeSpecification => _movementRangeSpecification;
  set movementRangeSpecification(MovementRangeSpecification? spec) {
    _movementRangeSpecification = spec;
    notifyListeners();
  }

  bool get freeMovementEnabled => _freeMovementEnabled;
  set freeMovementEnabled(bool b) {
    _freeMovementEnabled = b;
    notifyListeners();
  }

  void addPlayerCharacter(MapModelItem pc) {
    pcs.add(pc.id);
    _addItem(pc.id, pc);
  }

  void addNonPlayerCharacter(MapModelItem npc) {
    npcs.add(npc.id);
    _addItem(npc.id, npc);
  }

  void removeItem(MapModelItem item) {
    _distances.removeWhere((key, value) => key.node1 == item.id || key.node2 == item.id);
    pcs.remove(item.id);
    npcs.remove(item.id);
    items.remove(item.id);
    notifyListeners();
  }

  void _addItem(String uuid, MapModelItem item) {
    items[uuid] = item;
    updateDistances(uuid);
    notifyListeners();
  }

  void setItemActive(String uuid, bool active) {
    if(!items.containsKey(uuid)) {
      return;
    }

    items[uuid]!.setActive(active);
  }

  void moveItemTo(MapModelItem item, double x, double y) {
    item.x = x;
    item.y = y;
  }
  
  bool isInBoundaries(double x, double y) {
    return x > 0.0
        && x <= background.imageWidth
        && y > 0.0
        && y <= background.imageHeight;
  }

  void itemMoveStart(MapModelMovableItem item) {
    _controlsMovementRangeSpecification = (movementRangeSpecification == null);

    if(!freeMovementEnabled && _controlsMovementRangeSpecification) {
      movementRangeSpecification = MovementRangeSpecification(
        center: Offset(item.x, item.y),
        radius: item.movementLimit,
      );
    }

    notifyListeners();
  }

  void itemMoveEnd(MapModelMovableItem item) {
    updateDistances(item.id);

    if(!freeMovementEnabled && _controlsMovementRangeSpecification) {
      movementRangeSpecification = null;
    }

    notifyListeners();
  }

  void updateDistances(String source) {
    if(!items.containsKey(source)) {
      return;
    }
    debugPrint('Updating items distances');

    _distances.removeWhere((key, value) => key.node1 == source || key.node2 == source);

    for(var destination in items.keys) {
      if(destination == source) {
        continue;
      }

      var edge = MapDistanceEdge(node1: source, node2: destination);

      var dx = items[source]!.x - items[destination]!.x;
      var dy = items[source]!.y - items[destination]!.y;
      var distance = sqrt(dx*dx + dy*dy);

      _distances[edge] = distance;
    }
  }

  double distance(MapModelItem source, MapModelItem destination) {
    var ret = -1.0;

    for(var edge in _distances.keys) {
      if((edge.node1 == source.id || edge.node2 == source.id) && (edge.node1 == destination.id || edge.node2 == destination.id)) {
        ret = _distances[edge]!;
        break;
      }
    }

    return ret;
  }

  List<MapModelItem> itemsInRange(MapModelItem source, double distance) {
    var ret = <MapModelItem>[];

    for(var edge in _distances.keys) {
      if(edge.node1 == source.id && _distances[edge]! < distance) {
        ret.add(items[edge.node2]!);
      }
      else if(edge.node2 == source.id && _distances[edge]! < distance) {
        ret.add(items[edge.node1]!);
      }
    }

    return ret;
  }

  bool _freeMovementEnabled = true;
  MovementRangeSpecification? _movementRangeSpecification;
  bool _controlsMovementRangeSpecification = true;
  final Map<MapDistanceEdge, double> _distances = <MapDistanceEdge, double>{};
}

class MovementRangeSpecification {
  MovementRangeSpecification({ required this.center, required this.radius });
  Offset center;
  double radius;
}

class MapDistanceEdge {
  MapDistanceEdge({ required this.node1, required this.node2 });

  final String node1;
  final String node2;

  @override
  bool operator==(Object other) {
    return other is MapDistanceEdge &&
      (other.node1 == node1 || other.node1 == node2) &&
      (other.node2 == node1 || other.node2 == node2);
  }

  @override
  int get hashCode => Object.hash(node1, node2);
}