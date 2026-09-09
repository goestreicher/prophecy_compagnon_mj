import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

import '../../generic_image.dart';
import '../../place_map.dart';
import '../../string_pair_map_key.dart';
import '../map/item.dart';
import '../encounter.dart';
import 'item.dart';

class SessionBoardItemMap extends SessionBoardItem {
  SessionBoardItemMap({
    required super.title,
    required this.background,
    Map<String, SessionMapItem>? items,
    this.encounter,
  })
    : _bgImage = GenericImage.memory(binary: background.exportableBinaryData!),
      items = SessionBoardItemMapItems(items: items ?? <String, SessionMapItem>{}),
      freeMovementEnabled = true
  {
    distances = MapDistances(this.items);
  }

  @override
  Future<GenericImage> thumbnail(double maxDimension) async =>
      _bgImage.thumbnail(maxDimension);

  @override
  GenericImage image() =>
      _bgImage;

  final PlaceMap background;
  final GenericImage _bgImage;
  vm.Matrix4? transformation;
  final SessionBoardItemMapItems items;
  late final MapDistances distances;
  SessionEncounter? encounter;
  bool freeMovementEnabled;

  @override get removable =>
    (encounter == null || encounter!.status == SessionEncounterStatus.finished);

  @override
  Map<String, dynamic> toJson() {
    // TODO
    return <String, dynamic>{};
  }
}

class MapDistances {
  MapDistances(SessionBoardItemMapItems items)
    : _distances = <StringPairMapKey, double>{}, _items = items
  {
    rebuild();
  }

  double? between(SessionMapItem first, SessionMapItem second) {
    var search = StringPairMapKey(first.id, second.id);
    return _distances[search];
  }

  Map<String, double> from(SessionMapItem item) {
    var ret = <String, double>{};
    for(var k in _distances.keys) {
      if(k.pair.$1 == item.id) {
        ret[k.pair.$2] = _distances[k]!;
      }
      else if(k.pair.$2 == item.id) {
        ret[k.pair.$1] = _distances[k]!;
      }
    }
    return ret;
  }

  void updateFrom(SessionMapItem item) {
    for(var other in _items.values) {
      if(other == item) continue;

      var key = StringPairMapKey(item.id, other.id);
      var dx = item.x - other.x;
      var dy = item.y - other.y;
      var distance = sqrt(dx*dx + dy*dy);

      // This assumes that all objects are circles
      // TODO: manage different shapes some day
      distance -= max(item.size.width, item.size.height);
      distance -= max(other.size.width, other.size.height);

      _distances[key] = distance;
    }
  }

  void remove(SessionMapItem item) => _distances.removeWhere(
      (StringPairMapKey k, double v) =>
          k.pair.$1 == item.id || k.pair.$2 == item.id
  );

  void rebuild() {
    for(var item in _items.values) {
      updateFrom(item);
    }
  }

  final Map<StringPairMapKey, double> _distances;
  final SessionBoardItemMapItems _items;
}

class SessionBoardItemMapItems with IterableMixin<MapEntry<String, SessionMapItem>>, ChangeNotifier {
  SessionBoardItemMapItems({
    Map<String, SessionMapItem> items = const <String, SessionMapItem>{}
  })
    : _items = items;

  @override
  Iterator<MapEntry<String, SessionMapItem>> get iterator => _items.entries.iterator;

  Iterable<SessionMapItem> get values => _items.values;

  SessionMapItem? remove(String k) {
    var ret = _items.remove(k);
    notifyListeners();
    return ret;
  }

  SessionMapItem? operator [](String k) => _items[k];

  void operator []=(String k, SessionMapItem v) {
    _items[k] = v;
    notifyListeners();
  }

  final Map<String, SessionMapItem> _items;
}