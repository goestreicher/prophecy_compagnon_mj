import 'package:flutter/foundation.dart';
import 'combat.dart';
import 'combat_turn.dart';
import 'entity_base.dart';
import 'player_character.dart';

class Encounter extends ChangeNotifier {
  Encounter({
    required this.name,
    required this.characters,
    required this.npcs
  });

  final String name;
  final List<PlayerCharacter> characters;
  final List<EntityBase> npcs;
  final List<EntityBase> deployedNpcs = <EntityBase>[];
  Map<String, List<(EntityBase, WeaponRange)>> targetAttackWeaponRanges = <String, List<(EntityBase, WeaponRange)>>{};
  Map<String, List<(EntityBase, WeaponRange)>> targetAttackMovementRanges = <String, List<(EntityBase, WeaponRange)>>{};
  List<(EntityBase, EntityBase, WeaponRange)> engagements = <(EntityBase, EntityBase, WeaponRange)>[];

  CombatTurn? get currentTurn => _currentTurn;

  set currentTurn(CombatTurn? t) {
    _currentTurn = t;
    notifyListeners();
  }

  CombatTurn? previousTurn;

  void deployNpc(EntityBase entity) {
    if(!npcs.contains(entity)) {
      return;
    }

    deployedNpcs.add(entity);
    npcs.remove(entity);
    notifyListeners();
  }

  void removeEntity(EntityBase entity) {
    if(currentTurn != null) {
      currentTurn!.removeEntity(entity, startAt: currentTurn!.currentRank);
    }

    targetAttackMovementRanges.remove(entity.uuid);
    for(var l in targetAttackMovementRanges.values) {
      l.removeWhere((element) => element.$1 == entity);
    }

    targetAttackWeaponRanges.remove(entity.uuid);
    for(var l in targetAttackWeaponRanges.values) {
      l.removeWhere((element) => element.$1 == entity);
    }

    engagements.removeWhere((element) => element.$1 == entity || element.$2 == entity);

    characters.remove(entity);
    npcs.remove(entity);
    deployedNpcs.remove(entity);
    notifyListeners();
  }

  void clearTargetRanges(EntityBase entity) {
    targetAttackWeaponRanges.remove(entity.uuid);
    targetAttackMovementRanges.remove(entity.uuid);
  }

  void addTargetInMovementRange(EntityBase source, EntityBase destination, WeaponRange range) {
    if(!targetAttackMovementRanges.containsKey(source.uuid)) {
      targetAttackMovementRanges[source.uuid] = [(destination, range)];
    }
    else {
      targetAttackMovementRanges[source.uuid]!.removeWhere((record) => record.$1.uuid == destination.uuid);
      targetAttackMovementRanges[source.uuid]!.add((destination, range));
    }
  }

  List<EntityBase> targetsInMovementRangeFor(EntityBase entity, WeaponRange range) {
    var ret = <EntityBase>[];

    if(targetAttackMovementRanges.containsKey(entity.uuid)) {
      for(var (targetEntity, targetRange) in targetAttackMovementRanges[entity.uuid]!) {
        if(targetRange.index <= range.index) {
          ret.add(targetEntity);
        }
      }
    }

    return ret;
  }

  void addTargetInWeaponRange(EntityBase source, EntityBase destination, WeaponRange range) {
    if(!targetAttackWeaponRanges.containsKey(source.uuid)) {
      targetAttackWeaponRanges[source.uuid] = [(destination, range)];
    }
    else {
      targetAttackWeaponRanges[source.uuid]!.removeWhere((record) => record.$1.uuid == destination.uuid);
      targetAttackWeaponRanges[source.uuid]!.add((destination, range));
    }
  }

  List<(EntityBase, WeaponRange)> targetsFor(EntityBase entity) {
    var ret = <(EntityBase, WeaponRange)>[];

    if(targetAttackWeaponRanges.containsKey(entity.uuid)) {
      ret.addAll(targetAttackWeaponRanges[entity.uuid]!);
    }

    return ret;
  }
  
  List<EntityBase> targetsInWeaponRangeFor(EntityBase entity, WeaponRange range) {
    var ret = <EntityBase>[];

    if(targetAttackWeaponRanges.containsKey(entity.uuid)) {
      for(var (targetEntity, targetRange) in targetAttackWeaponRanges[entity.uuid]!) {
        if(targetRange.index <= range.index) {
          ret.add(targetEntity);
        }
      }
    }

    return ret;
  }

  WeaponRange smallestEngagementRangeFor(EntityBase entity) {
    var ret = WeaponRange.ranged;

    for(var (_, range) in engagementsFor(entity)) {
      if(range.index < ret.index) {
        ret = range;
      }
    }

    return ret;
  }

  List<(EntityBase, WeaponRange)> engagementsFor(EntityBase entity) {
    var ret = <(EntityBase, WeaponRange)>[];

    for(var (e1, e2, range) in engagements) {
      if(e1 == entity) {
        ret.add((e2, range));
      }
      else if(e2 == entity) {
        ret.add((e1, range));
      }
    }

    return ret;
  }

  bool areEngaged(EntityBase source, EntityBase destination) {
    for(var (e1, e2, _) in engagements) {
      if((e1 == source || e1 == destination) && (e2 == source || e2 == destination)) {
        return true;
      }
    }
    return false;
  }

  void newEngagement(EntityBase source, EntityBase destination, WeaponRange range) {
    if(areEngaged(source, destination)) {
      removeEngagement(source, destination);
    }
    engagements.add((source, destination, range));
  }

  void removeEngagement(EntityBase source, EntityBase destination) {
    engagements.removeWhere((record) => (record.$1 == source || record.$1 == destination) && (record.$2 == source || record.$2 == destination));
  }

  CombatTurn? _currentTurn;
}