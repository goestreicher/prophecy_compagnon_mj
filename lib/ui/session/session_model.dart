import 'package:flutter/foundation.dart';

import '../../classes/encounter.dart';
import '../../classes/scenario/scenario.dart';
import '../../classes/session/game_session.dart';
import '../../classes/table.dart';
import '../../classes/session/map_model.dart';

@Deprecated('Deprecated, use GameSession')
class SessionModel extends ChangeNotifier {
  SessionModel({
    required this.session,
    required this.table,
    required this.scenario,
  });

  final GameSession session;
  final GameTable table;
  final Scenario scenario;

  MapModel? get map => _mapStack.isEmpty ? null : _mapStack.first;

  set map(MapModel? newMap) {
    if(newMap == null) {
      if(_mapStack.isNotEmpty) {
        _mapStack.removeAt(0);
        notifyListeners();
      }
    }
    else {
      _mapStack.insert(0, newMap);
      notifyListeners();
    }
  }

  Encounter? get encounter => _currentEncounter;

  set encounter(Encounter? newEncounter) {
    if(!map!.freeMovementEnabled && newEncounter == null) {
      map!.freeMovementEnabled = true;
    }

    _currentEncounter?.removeListener(_encounterChangeListener);
    _currentEncounter = newEncounter;
    _currentEncounter?.addListener(_encounterChangeListener);
    notifyListeners();
  }

  final List<MapModel> _mapStack = <MapModel>[];
  Encounter? _currentEncounter;

  void _encounterChangeListener() {
    if(map!.freeMovementEnabled && encounter!.currentTurn != null) {
      map!.freeMovementEnabled = false;
    }
    else if(!map!.freeMovementEnabled && encounter!.currentTurn == null) {
      map!.freeMovementEnabled = true;
    }
  }
}