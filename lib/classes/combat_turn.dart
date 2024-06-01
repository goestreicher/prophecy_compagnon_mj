import 'package:flutter/foundation.dart';

import 'character/base.dart';
import 'combat.dart';
import 'encounter.dart';
import 'entity_base.dart';
import 'equipment.dart';
import 'weapon.dart';

enum CombatActionType{
  none(title: 'Aucune action',),
  delay(title: 'Retarder',),
  move(title: 'Déplacement',),
  attack(title: 'Attaque simple',),
  defense(title: 'Défense'),
  ;

  const CombatActionType({
    required this.title,
  });

  final String title;
}

enum CombatActionSpecification {
  none(title: '',),
  run(title: 'Course',),
  sprint(title: 'Sprint',),
  attackBrutal(title: 'Attaque brutale',),
  attackPrecise(title: 'Attaque précise',),
  stun(title: 'Assommer',),
  charge(title: 'Charger',),
  disarm(title: 'Désarmer',),
  feint(title: 'Feinte',),
  keepDistance(title: 'Maintenir à distance',),
  enterContact(title: 'Entrer au corps-à-corps',),
  incapacitate(title: 'Incapaciter',),
  topple(title: 'Renverser',),
  crush(title: 'Écraser',),
  grapple(title: 'Saisir',),
  strangle(title: 'Étrangler',),
  immobilise(title: 'Immobiliser',),
  project(title: 'Projeter',);

  const CombatActionSpecification({
    required this.title
  });

  final String title;
}

class CombatActionSubtype {
  const CombatActionSubtype({
    required this.specification,
    this.range,
  });

  final CombatActionSpecification specification;
  final WeaponRange? range;

  String get description => specification.title;

  bool isValidFor(CombatActionType parent) {
    if(!_validSpecificationsForType.containsKey(parent)) {
      return false;
    }

    if(parent == CombatActionType.attack) {
      if(range == null || !_validSpecificationsForType[CombatActionType.attack]!.containsKey(range)) {
        return false;
      }
      return _validSpecificationsForType[parent]![range]!.containsKey(specification);
    }
    else {
      return _validSpecificationsForType[parent]!.containsKey(specification);
    }
  }

  void prepareEnvironment(CombatTurnAction action, CombatActionType parent) {
    if(!isValidFor(parent)) {
      return;
    }

    if(parent == CombatActionType.attack) {
      for(var k in _validSpecificationsForType[parent]![range]![specification]!.keys) {
        action.environment[k] = _validSpecificationsForType[parent]![range]![specification]![k]!;
      }
    }
    else {
      for(var k in _validSpecificationsForType[parent]![specification]!.keys) {
        action.environment[k] = _validSpecificationsForType[parent]![specification]![k]!;
      }
    }
  }

  static const CombatActionSubtype none =
    CombatActionSubtype(specification: CombatActionSpecification.none);

  static final _validSpecificationsForType = <CombatActionType, dynamic>{
    CombatActionType.none: {
      CombatActionSpecification.none: <CombatTurnActionEnvironmentKey, dynamic>{},
    },
    CombatActionType.move: {
      CombatActionSpecification.none: <CombatTurnActionEnvironmentKey, dynamic>{},
      CombatActionSpecification.run: <CombatTurnActionEnvironmentKey, dynamic>{},
      CombatActionSpecification.sprint: <CombatTurnActionEnvironmentKey, dynamic>{},
    },
    CombatActionType.attack: {
      WeaponRange.ranged: {
        CombatActionSpecification.none: <CombatTurnActionEnvironmentKey, dynamic>{},
        CombatActionSpecification.attackPrecise: <CombatTurnActionEnvironmentKey, dynamic>{},
      },
      WeaponRange.melee: {
        CombatActionSpecification.none: <CombatTurnActionEnvironmentKey, dynamic>{},
        CombatActionSpecification.attackBrutal: _attackBrutalEnvironment,
        CombatActionSpecification.attackPrecise: <CombatTurnActionEnvironmentKey, dynamic>{},
        CombatActionSpecification.charge: <CombatTurnActionEnvironmentKey, dynamic>{},
        CombatActionSpecification.disarm: <CombatTurnActionEnvironmentKey, dynamic>{},
        CombatActionSpecification.feint: <CombatTurnActionEnvironmentKey, dynamic>{},
        CombatActionSpecification.keepDistance: <CombatTurnActionEnvironmentKey, dynamic>{},
        CombatActionSpecification.incapacitate: <CombatTurnActionEnvironmentKey, dynamic>{},
      },
      WeaponRange.contact: {
        CombatActionSpecification.none: <CombatTurnActionEnvironmentKey, dynamic>{},
        CombatActionSpecification.attackBrutal: _attackBrutalEnvironment,
        CombatActionSpecification.attackPrecise: <CombatTurnActionEnvironmentKey, dynamic>{},
        CombatActionSpecification.charge: <CombatTurnActionEnvironmentKey, dynamic>{},
        CombatActionSpecification.disarm: <CombatTurnActionEnvironmentKey, dynamic>{},
        CombatActionSpecification.feint: <CombatTurnActionEnvironmentKey, dynamic>{},
        CombatActionSpecification.incapacitate: <CombatTurnActionEnvironmentKey, dynamic>{},
        CombatActionSpecification.enterContact: <CombatTurnActionEnvironmentKey, dynamic>{},
        CombatActionSpecification.topple: <CombatTurnActionEnvironmentKey, dynamic>{},
        CombatActionSpecification.crush: <CombatTurnActionEnvironmentKey, dynamic>{},
        CombatActionSpecification.grapple: <CombatTurnActionEnvironmentKey, dynamic>{},
        CombatActionSpecification.strangle: <CombatTurnActionEnvironmentKey, dynamic>{},
        CombatActionSpecification.immobilise: <CombatTurnActionEnvironmentKey, dynamic>{},
        CombatActionSpecification.project: <CombatTurnActionEnvironmentKey, dynamic>{},
      },
    },
  };
}

class CombatActionDuration {
  CombatActionDuration({
    required this.entity,
    this.turns = -1,
    this.actions = -1,
    required this.onFinished,
    this.type = CombatActionType.none,
    this.subtype = CombatActionSubtype.none,
    this.useAction = false,
  });

  final EntityBase entity;
  int turns;
  int actions;
  final void Function() onFinished;
  final CombatActionType type;
  final CombatActionSubtype subtype;
  final bool useAction;
}

class CombatTurn extends ChangeNotifier {
  CombatTurn({ required this.encounter, this.previous }) {
    if(previous != null) {
      _longRunningActions.addAll([...(previous!._longRunningActions)]);
    }
  }

  Encounter encounter;
  CombatTurn? previous;
  int currentRank = 1;
  List<CombatTurnAction> actions = <CombatTurnAction>[];
  final List<CombatTurnAction> _unspentActions = <CombatTurnAction>[];
  final List<CombatActionDuration> _longRunningActions = <CombatActionDuration>[];

  void setEntityInitiatives(
      {
        required EntityBase entity,
        required List<int> dominantHandInitiatives,
        int? weakHandInitiative
      }
  ) {
    for(var init in dominantHandInitiatives) {
      if(init > currentRank) currentRank = init;

      var action = CombatTurnAction(
        turn: this,
        rank: init,
        entity: entity,
        hand: EquipableItemTarget.dominantHand,
      );

      actions.add(action);
    }

    if(weakHandInitiative != null) {
      if(weakHandInitiative > currentRank) currentRank = weakHandInitiative;

      actions.add(CombatTurnAction(
        turn: this,
        rank: weakHandInitiative,
        entity: entity,
        hand: EquipableItemTarget.weakHand,
      ));
    }

    for(var d in _longRunningActions.where((CombatActionDuration d) => d.entity.uuid == entity.uuid)) {
      _applyLongRunningActionToTurn(d);
    }

    actions.sort((a, b) => b.rank - a.rank);
    notifyListeners();
  }

  void addLongRunningAction(CombatActionDuration d) {
    _applyLongRunningActionToTurn(d);

    if(d.actions > 0 || d.turns > 0) {
      _longRunningActions.add(d);
    }
  }
  
  void _applyLongRunningActionToTurn(CombatActionDuration d) {
    for(var a in actionsForEntity(d.entity, startAt: currentRank).where((CombatTurnAction a) => a.hand == EquipableItemTarget.dominantHand)) {
      _applyLongRunningActionToAction(d, a);
      if (d.actions == 0) break;
    }

    if(d.turns == 1) {
      var actions = actionsForEntity(d.entity, startAt: currentRank)
          .where((CombatTurnAction a) => a.hand == EquipableItemTarget.dominantHand)
          .toList();
      if(actions.isNotEmpty) {
        actions.sort((a, b) => a.rank - b.rank);
        var a = actions.first;
        a.environment[CombatTurnActionEnvironmentKey.onLongRunningActionFinished] = d.onFinished;
        --d.turns;
      }
    }
    else if(d.turns > 1) {
      --d.turns;
    }
  }

  void _applyLongRunningActionToAction(CombatActionDuration d, CombatTurnAction action) {
    action.used = d.useAction;
    action.type = d.type;
    action.subtype = d.subtype;

    if(d.actions > 0) {
      --d.actions;
    }
    
    if(d.actions == 0) {
      action.environment[CombatTurnActionEnvironmentKey.onLongRunningActionFinished] = d.onFinished;
    }
  }

  void nextRank() {
    // Get the biggest next rank with free actions
    var rank = 0;
    for(var action in actions) {
      if (!action.used && action.rank > rank) {
        rank = action.rank;
      }
    }

    _activeAction = null;
    currentRank = rank;
    notifyListeners();
  }

  List<CombatTurnAction> actionsForRank(int rank) {
    return actions
        .where((CombatTurnAction action) => action.rank == rank)
        .toList();
  }

  CombatTurnAction? get activeAction => _activeAction;
  set activeAction(CombatTurnAction? action) {
    if(_activeAction == null || action == null) {
      _activeAction = action;
      notifyListeners();
    }
  }

  List<CombatTurnAction> actionsForEntity(EntityBase entity, { int startAt = 0 }) {
    return actions
        .where((CombatTurnAction action) => action.entity == entity && action.rank >= startAt)
        .toList();
  }

  List<CombatTurnAction> unspentActionsForEntity(EntityBase entity) {
    return _unspentActions
        .where((CombatTurnAction action) => action.entity == entity)
        .toList();
  }

  void delayAction(CombatTurnAction action) {
    action.type = CombatActionType.none;
    action.subtype = CombatActionSubtype.none;
    action.used = false;
    action.environment.clear();

    if(action.rank == 1) {
      _unspentActions.add(action);
      if(action.environment.containsKey(CombatTurnActionEnvironmentKey.onLongRunningActionFinished)) {
        action.environment[CombatTurnActionEnvironmentKey.onLongRunningActionFinished]!();
      }
      actions.remove(action);
    }
    else {
      action.rank = action.rank - 1;
    }
  }

  void removeEntity(EntityBase entity, { int startAt = -1 }) {
    _longRunningActions.removeWhere((CombatActionDuration d) => d.entity.uuid == entity.uuid);
    _unspentActions.removeWhere((CombatTurnAction a) => a.entity.uuid == entity.uuid);
    actions.removeWhere((CombatTurnAction a) => a.entity.uuid == entity.uuid && (startAt == -1 || a.rank < startAt));
    notifyListeners();
  }

  void addAttack(EntityBase entity) {
    _entitiesAttackMalus[entity.uuid] =
        (_entitiesAttackMalus[entity.uuid] ?? 0) + 5;
    notifyListeners();
  }

  int attackMalus(EntityBase entity) {
    return _entitiesAttackMalus[entity.uuid] ?? 0;
  }

  void addDefense(EntityBase entity) {
    _entitiesDefenseMalus[entity.uuid] =
        (_entitiesDefenseMalus[entity.uuid] ?? 0) + 5;
    notifyListeners();
  }

  int defenseMalus(EntityBase entity) {
    return _entitiesDefenseMalus[entity.uuid] ?? 0;
  }

  final Map<String, int> _entitiesAttackMalus = <String, int>{};
  final Map<String, int> _entitiesDefenseMalus = <String, int>{};
  CombatTurnAction? _activeAction;
}

enum CombatTurnActionEnvironmentKey {
  preCommitCallback,
  onRankResolution,
  onLongRunningActionFinished,
  selectableEntities,
  attacker,
  defender,
  weapon,
  attackDifficulty,
  attackPreciseAdditionalDifficulty,
  attackFailure,
  attackSuccessCount,
  dodgeDifficulty,
  dodgeDifficultyModifier,
  blockDifficulty,
  blockDifficultyModifier,
  defenseFailure,
  defenseSuccessCount,
  damageCallback,
  damage,
}

class CombatTurnAction {
  CombatTurnAction({
    required this.turn,
    required this.rank,
    required this.entity,
    required this.hand,
    this.type = CombatActionType.none,
    this.subtype = CombatActionSubtype.none,
    environment,
  })
    : environment = environment ?? <CombatTurnActionEnvironmentKey, dynamic>{};

  CombatTurn turn;
  int rank;
  final EntityBase entity;
  final EquipableItemTarget hand;
  CombatActionType type;
  CombatActionSubtype subtype;
  Map<CombatTurnActionEnvironmentKey, dynamic> environment;
  bool used = false;

  bool hasRankEndCallback() {
    return environment.containsKey(CombatTurnActionEnvironmentKey.onRankResolution) ||
        environment.containsKey(CombatTurnActionEnvironmentKey.onLongRunningActionFinished);
  }
}

Map<CombatTurnActionEnvironmentKey, dynamic> _attackBrutalEnvironment = {
  CombatTurnActionEnvironmentKey.dodgeDifficulty: 10,
  CombatTurnActionEnvironmentKey.damageCallback:
    (Map<CombatTurnActionEnvironmentKey, dynamic> env) {
      var initialDamage = env[CombatTurnActionEnvironmentKey.damage] as int;
      var finalDamage = initialDamage + (env[CombatTurnActionEnvironmentKey.attacker] as EntityBase).ability(Ability.force);
      if((env[CombatTurnActionEnvironmentKey.weapon] as Weapon).handiness == 2) {
        finalDamage += (env[CombatTurnActionEnvironmentKey.attacker] as EntityBase).ability(Ability.force);
      }
      return finalDamage;
    },
};