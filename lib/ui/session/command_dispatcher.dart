import 'package:flutter/widgets.dart';

import '../../classes/combat.dart';
import '../../classes/combat_turn.dart';
import '../../classes/encounter.dart';
import '../../classes/entity/status.dart';
import '../../classes/weapon.dart';
import 'map_entity_model.dart';
import 'map_model.dart';
import 'session_model.dart';

enum SessionCommand {
  mapPush,
  mapPop,
  mapItemDeployed,
  mapSetActive,
  mapItemMoveEnd,
  mapItemSelected,
  mapItemStatusChanged,
  mapRemoveItem,
  encounterStart,
  encounterEnd,
  combatStart,
  combatEnd,
  combatNextTurn,
  combatTurnNextRank,
  combatTurnCompleted,
  combatActionTypeSelected,
  combatActionTypeCancelled,
  combatActionTypeCommitted,
}

typedef SessionCommandArguments = Map<String, dynamic>;

class CommandDispatcher extends ChangeNotifier {
  CommandDispatcher({ required session })
    : _session = session;

  void dispatchCommand(SessionCommand command, SessionCommandArguments args) {
    switch(command) {
      case SessionCommand.mapPush:
      case SessionCommand.mapPop:
      case SessionCommand.mapItemDeployed:
      case SessionCommand.mapSetActive:
      case SessionCommand.mapItemMoveEnd:
      case SessionCommand.mapItemSelected:
      case SessionCommand.mapItemStatusChanged:
      case SessionCommand.mapRemoveItem:
        _parseCommandMap(command, args);
        break;
      case SessionCommand.encounterStart:
      case SessionCommand.encounterEnd:
        _parseCommandEncounter(command, args);
        break;
      case SessionCommand.combatStart:
      case SessionCommand.combatEnd:
      case SessionCommand.combatNextTurn:
      case SessionCommand.combatTurnNextRank:
      case SessionCommand.combatTurnCompleted:
        _parseCommandCombat(command, args);
        break;
      case SessionCommand.combatActionTypeSelected:
      case SessionCommand.combatActionTypeCancelled:
      case SessionCommand.combatActionTypeCommitted:
        _parseCommandCombatAction(command, args);
        break;
    }
  }

  bool get _hasEncounter => _session.encounter != null;
  bool get _hasTurn => _hasEncounter && _session.encounter!.currentTurn != null;
  bool get _hasAction => _hasTurn && _session.encounter!.currentTurn!.activeAction != null;

  void _parseCommandMap(SessionCommand command, SessionCommandArguments args) {
    if(command == SessionCommand.mapPush) {
      if(!args.containsKey('map')) {
        debugPrint('CommandDispatcher::_parseCommandMap: no map in mapPush');
        return;
      }

      if(args['map'] is! MapModel) {
        debugPrint('CommandDispatcher::_parseCommandMap: invalid map object in mapPush');
        return;
      }

      _session.map = args['map'] as MapModel;
    }
    else if(command == SessionCommand.mapPop) {
      _session.map = null;
    }
    else if(command == SessionCommand.mapItemDeployed) {
      if(!args.containsKey('entity')) {
        debugPrint('CommandDispatcher::_parseCommandMap: no entity model in mapItemDeployed');
        return;
      }

      if(args['entity'] is! MapEntityModel) {
        debugPrint('CommandDispatcher::_parseCommandMap: entity model in mapItemMoveEnd is not a mapItemDeployed');
        return;
      }

      var entityModel = args['entity'] as MapEntityModel;

      // Update the encounter with the list of targetable entities
      if(_hasEncounter) {
        _updateTargetableEntities(entityModel);
      }
    }
    else if(command == SessionCommand.mapSetActive) {
      if(!args.containsKey('uuid') || args['uuid'] is! String) {
        debugPrint('CommandDispatcher::_parseCommandMap: no UUID or invalid UUID in mapSetActive');
        return;
      }

      if(!args.containsKey('active') || args['active'] is! bool) {
        debugPrint('CommandDispatcher::_parseCommandMap: no "active" parameter or invalid parameter in mapSetActive');
        return;
      }

      _session.map?.setItemActive(args['uuid'] as String, args['active'] as bool);
    }
    else if(command == SessionCommand.mapItemMoveEnd) {
      if(!args.containsKey('entity')) {
        debugPrint('CommandDispatcher::_parseCommandMap: no entity model in mapItemMoveEnd');
        return;
      }

      if(args['entity'] is! MapEntityModel) {
        debugPrint('CommandDispatcher::_parseCommandMap: entity model in mapItemMoveEnd is not a MapEntityModel');
        return;
      }

      var entityModel = args['entity'] as MapEntityModel;

      if(_hasAction) {
        // We can call the pre-commit callback if the current action is a movement
        if(_session.encounter!.currentTurn!.activeAction!.type == CombatActionType.move &&
          _session.encounter!.currentTurn!.activeAction!.environment.containsKey(CombatTurnActionEnvironmentKey.preCommitCallback)
        ) {
          _session.encounter!.currentTurn!.activeAction!.environment[CombatTurnActionEnvironmentKey.preCommitCallback]!();
        }
      }

      // Update the encounter with the list of targetable entities
      if(_hasEncounter) {
        _updateTargetableEntities(entityModel);
      }
      if(_hasAction && _session.encounter!.currentTurn!.activeAction!.type == CombatActionType.attack) {
        _updateCurrentActionSelectableEntities();
        // TODO: if the currently selected target of an attack becomes out of range, invalidate the current action
      }
    }
    else if(command == SessionCommand.mapItemSelected) {
      if(!args.containsKey('entity')) {
        debugPrint('CommandDispatcher::_parseCommandMap: no entity model in mapItemSelected');
        return;
      }

      if(args['entity'] is! MapEntityModel) {
        debugPrint('CommandDispatcher::_parseCommandMap: entity model in mapItemSelected is not a MapEntityModel');
        return;
      }

      var selectedEntityModel = args['entity'] as MapEntityModel;

      if(_hasAction &&
          _session.encounter!.currentTurn!.activeAction!.type == CombatActionType.attack &&
          _session.encounter!.currentTurn!.activeAction!.environment.containsKey(CombatTurnActionEnvironmentKey.selectableEntities)
      ) {
        var selectable = _session.encounter!.currentTurn!.activeAction!.environment[CombatTurnActionEnvironmentKey.selectableEntities] as List<String>;
        if(selectable.contains(selectedEntityModel.id)) {
          _session.encounter!.currentTurn!.activeAction!.environment[CombatTurnActionEnvironmentKey.defender] = selectedEntityModel.entity;
          _session.encounter!.currentTurn!.activeAction!.environment[CombatTurnActionEnvironmentKey.preCommitCallback]!();
        }
      }
    }
    else if(command == SessionCommand.mapItemStatusChanged) {
      MapEntityModel entityModel;

      if(args.containsKey('uuid') && args['uuid'] is String && _session.map!.items.containsKey(args['uuid'])) {
        entityModel = _session.map!.items[args['uuid']]! as MapEntityModel;
      }
      else {
        if(!args.containsKey('entity')) {
          debugPrint('CommandDispatcher::_parseCommandMap: no entity model in mapItemSelected');
          return;
        }

        if(args['entity'] is! MapEntityModel) {
          debugPrint('CommandDispatcher::_parseCommandMap: entity model in mapItemSelected is not a MapEntityModel');
          return;
        }

        entityModel = args['entity'] as MapEntityModel;
      }

      entityModel.notifyListeners();
      if(_hasEncounter) {
        _session.encounter!.notifyListeners();
      }
    }
    else if(command == SessionCommand.mapRemoveItem) {
      if(!args.containsKey('item')) {
        debugPrint('CommandDispatcher::_parseCommandMap: no item in mapRemoveItem');
        return;
      }

      var item = args['item'] as MapModelItem;

      if(item is MapEntityModel) {
        if (_hasTurn) {
          _session.encounter!.currentTurn!.removeEntity(
            item.entity,
            startAt: _session.encounter!.currentTurn!.currentRank,
          );
        }

        if(_hasEncounter) {
          _session.encounter!.removeEntity(item.entity);
        }
      }

      _session.map!.removeItem(item);
    }
  }

  void _parseCommandEncounter(SessionCommand command, SessionCommandArguments args) {
    if(command == SessionCommand.encounterStart) {
      if(_hasEncounter) {
        debugPrint('CommandDispatcher::_parseCommandEncounter: encounter already started');
        return;
      }

      if(!args.containsKey('encounter')) {
        debugPrint('CommandDispatcher::_parseCommandEncounter: no encounter argument');
        return;
      }

      if(args['encounter'] is! Encounter) {
        debugPrint('CommandDispatcher::_parseCommandEncounter: invalid encounter argument');
        return;
      }

      _session.encounter = args['encounter'] as Encounter;
      // TODO: switch to the map tab here
    }
    else if(command == SessionCommand.encounterEnd) {
      if(!_hasEncounter) {
        debugPrint('CommandDispatcher::_parseCommandEncounter: no current encounter');
        return;
      }

      _session.encounter = null;
    }
  }

  void _parseCommandCombat(SessionCommand command, SessionCommandArguments args) {
    if(!_hasEncounter) {
      debugPrint('CommandDispatcher::_parseCommandCombat: no encounter started');
      return;
    }

    if(command == SessionCommand.combatStart) {
      // TODO: ?
    }
    else if(command == SessionCommand.combatEnd) {
      // TODO: ?
    }
    else if(command == SessionCommand.combatNextTurn) {
      if(!args.containsKey('turn')) {
        debugPrint('CommandDispatcher::_parseCommandCombat: no turn argument to combatNextTurn');
        return;
      }

      if(args['turn'] is! CombatTurn) {
        debugPrint('CommandDispatcher::_parseCommandCombat: invalid turn argument to combatNextTurn');
        return;
      }

      // No need to notify listeners here, the encounter takes care of it
      _session.encounter!.currentTurn = args['turn'] as CombatTurn;

      for(var item in _session.map!.items.values) {
        if(item is MapEntityModel) {
          _updateTargetableEntities(item);
        }
      }
    }
    else if(command == SessionCommand.combatTurnNextRank) {
      if(!_hasTurn) {
        return;
      }

      for(var item in _session.map!.items.values) {
        if(item is MapEntityModel) {
          _updateTargetableEntities(item);
        }
      }

      _session.encounter!.currentTurn!.nextRank();
      if(_session.encounter!.currentTurn!.currentRank == 0) {
        _session.encounter!.previousTurn = _session.encounter!.currentTurn;
        _session.encounter!.currentTurn = null;
      }
    }
    else if(command == SessionCommand.combatTurnCompleted) {
      if(!_hasTurn) {
        return;
      }

      _session.encounter!.previousTurn = _session.encounter!.currentTurn;
      _session.encounter!.currentTurn = null;
    }
  }

  void _parseCommandCombatAction(SessionCommand command, SessionCommandArguments args) {
    if(!_hasEncounter) {
      debugPrint('CommandDispatcher::_parseCommandCombatAction: no encounter started');
      return;
    }

    if(!_hasTurn) {
      debugPrint('CommandDispatcher::_parseCommandCombatAction: no current turn');
      return;
    }

    if(!args.containsKey('action') || args['action'] is! CombatTurnAction) {
      debugPrint('CommandDispatcher::_parseCommandCombatAction: no action in args');
      return;
    }

    if(!_session.map!.items.containsKey(args['action']!.entity.id)) {
      debugPrint('CommandDispatcher::_parseCommandCombatAction: unknown UUID ${args["action"]!.entity.id}');
      return;
    }

    var entityModel = _session.map!.items[args['action']!.entity.id] as MapEntityModel;

    if(command == SessionCommand.combatActionTypeSelected) {
      if(args['action']!.type == CombatActionType.none) {
        debugPrint('CommandDispatcher::_parseCommandCombatAction: selected action type should not be none');
        return;
      }

      if(_hasAction) {
        debugPrint('CommandDispatcher::_parseCommandCombatAction: already an active action');
        return;
      }

      _session.encounter!.currentTurn!.activeAction = args['action'] as CombatTurnAction;
      _updateEntityStatusForCurrentCombatAction(entityModel);

      if(entityModel.movementLimit > 0.0) {
        _session.map!.movementRangeSpecification = MovementRangeSpecification(
          center: Offset(entityModel.x, entityModel.y),
          radius: entityModel.movementLimit,
        );
      }

      if(_session.encounter!.currentTurn!.activeAction!.type == CombatActionType.delay) {
        // It is possible to call the pre-commit callback immediately
        _session.encounter!.currentTurn!.activeAction!.environment[CombatTurnActionEnvironmentKey.preCommitCallback]!();
      }
      // TODO: complete as needed with other action types
    }
    else if(command == SessionCommand.combatActionTypeCancelled) {
      if(!_hasAction) {
        debugPrint('CommandDispatcher::_parseCommandCombatAction: no current action to cancel');
        return;
      }

      _clearEntityStatusForCurrentCombatAction(entityModel);
      if(_session.encounter!.currentTurn!.activeAction!.type == CombatActionType.attack) {
        _clearCurrentActionSelectableEntities();
      }

      if(_session.map!.movementRangeSpecification != null) {
        _session.map!.moveItemTo(
          entityModel,
          _session.map!.movementRangeSpecification!.center.dx,
          _session.map!.movementRangeSpecification!.center.dy,
        );
        _session.map!.movementRangeSpecification = null;
      }

      _session.encounter!.currentTurn!.activeAction!.type = CombatActionType.none;
      _session.encounter!.currentTurn!.activeAction!.subtype = CombatActionSubtype.none;
      _session.encounter!.currentTurn!.activeAction!.environment.clear();
      _session.encounter!.currentTurn!.activeAction = null;
    }
    else if(command == SessionCommand.combatActionTypeCommitted) {
      if(!_hasAction) {
        debugPrint('CommandDispatcher::_parseCommandCombatAction: no current action to commit');
        return;
      }

      _clearEntityStatusForCurrentCombatAction(entityModel);
      if(_session.encounter!.currentTurn!.activeAction!.type == CombatActionType.attack) {
        _clearCurrentActionSelectableEntities();
      }

      _session.map!.movementRangeSpecification = null;
      _session.encounter!.currentTurn!.activeAction = null;
    }
  }

  void _updateEntityStatusForCurrentCombatAction(MapEntityModel entityModel) {
    if(!_hasAction) {
      debugPrint('CommandDispatcher::_updateEntityStatusForCurrentCombatAction: no current action');
      return;
    }

    if(_session.encounter!.currentTurn!.activeAction!.type == CombatActionType.move) {
      if(_session.encounter!.currentTurn!.activeAction!.subtype.specification == CombatActionSpecification.none) {
        entityModel.status = entityModel.status | EntityStatusValue.moving;
      }
      else if(_session.encounter!.currentTurn!.activeAction!.subtype.specification == CombatActionSpecification.run) {
        entityModel.status = entityModel.status | EntityStatusValue.running;
      }
      else if(_session.encounter!.currentTurn!.activeAction!.subtype.specification == CombatActionSpecification.run) {
        entityModel.status = entityModel.status | EntityStatusValue.sprinting;
      }
    }
    else if(_session.encounter!.currentTurn!.activeAction!.type == CombatActionType.attack &&
        _session.encounter!.currentTurn!.activeAction!.subtype.isValidFor(_session.encounter!.currentTurn!.activeAction!.type)
    ) {
      entityModel.status = entityModel.status | EntityStatusValue.attacking;
      _updateCurrentActionSelectableEntities();
    }
    // TODO
  }

  void _clearEntityStatusForCurrentCombatAction(MapEntityModel entityModel) {
    if(!_hasAction) {
      debugPrint('CommandDispatcher::_clearEntityStatusForCurrentCombatAction: no current action');
      return;
    }

    if(_session.encounter!.currentTurn!.activeAction!.type == CombatActionType.move) {
      if(_session.encounter!.currentTurn!.activeAction!.subtype.specification == CombatActionSpecification.none) {
        entityModel.status = entityModel.status & ~EntityStatusValue.moving;
      }
      else if(_session.encounter!.currentTurn!.activeAction!.subtype.specification == CombatActionSpecification.run) {
        entityModel.status = entityModel.status & ~EntityStatusValue.running;
      }
      else if(_session.encounter!.currentTurn!.activeAction!.subtype.specification == CombatActionSpecification.run) {
        entityModel.status = entityModel.status & ~EntityStatusValue.sprinting;
      }
    }
    else if(_session.encounter!.currentTurn!.activeAction!.type == CombatActionType.attack &&
        _session.encounter!.currentTurn!.activeAction!.subtype.isValidFor(_session.encounter!.currentTurn!.activeAction!.type)
    ) {
      entityModel.status = entityModel.status & ~EntityStatusValue.attacking;
      _clearCurrentActionSelectableEntities();
    }
    // TODO
  }

  void _updateTargetableEntities(MapEntityModel entityModel) {
    debugPrint('Updating targetable entities for ${entityModel.entity.name}');

    _session.encounter!.clearTargetRanges(entityModel.entity);
    _session.map!.updateDistances(entityModel.id);

    // Contact combat
    var weaponRangeDistance = entityModel.size + entityModel.contactCombatRange;
    var movementRangeDistance = entityModel.size + entityModel.contactCombatRange + entityModel.attackMovementDistance;
    for(var itemModel in _session.map!.itemsInRange(entityModel, movementRangeDistance)) {
      if(itemModel is! MapEntityModel) {
        continue;
      }

      var distance = _session.map!.distance(entityModel, itemModel);
      debugPrint('contact distance ${entityModel.entity.name} - ${itemModel.entity.name}: $distance (targetable at $weaponRangeDistance / $movementRangeDistance)');
      if(distance < weaponRangeDistance) {
        _session.encounter!.addTargetInWeaponRange(entityModel.entity, itemModel.entity, WeaponRange.contact);
      }
      else {
        _session.encounter!.addTargetInMovementRange(entityModel.entity, itemModel.entity, WeaponRange.contact);
      }
    }

    // Non-contact combat
    weaponRangeDistance = entityModel.size + entityModel.combatRange;
    movementRangeDistance = entityModel.size + entityModel.combatRange + entityModel.attackMovementDistance;
    var combatWeaponRange = entityModel.combatWeaponRange;
    for(var itemModel in _session.map!.itemsInRange(entityModel, movementRangeDistance)) {
      if(itemModel is! MapEntityModel) {
        continue;
      }

      var distance = _session.map!.distance(entityModel, itemModel);
      debugPrint('combat distance ${entityModel.entity.name} - ${itemModel.entity.name}: $distance (targetable at $weaponRangeDistance / $movementRangeDistance)');
      if(distance < weaponRangeDistance) {
        _session.encounter!.addTargetInWeaponRange(entityModel.entity, itemModel.entity, combatWeaponRange);
      }
      else {
        _session.encounter!.addTargetInMovementRange(entityModel.entity, itemModel.entity, combatWeaponRange);
      }
    }
  }

  void _updateCurrentActionSelectableEntities() {
    _clearCurrentActionSelectableEntities();
    var selectable = <String>[];

    var weapon = _session.encounter!.currentTurn!.activeAction!.environment[CombatTurnActionEnvironmentKey.weapon] as Weapon;
    for(var entity in _session.encounter!.targetsInWeaponRangeFor(_session.encounter!.currentTurn!.activeAction!.entity, weapon.model.range)) {
      debugPrint('${entity.name} in weapon range');

      // TODO: check if the entity can be selected for the current action subtype
      // e.g., disarm should not be possible for entity without a weapon

      if(_session.map!.items.containsKey(entity.id)) {
        selectable.add(entity.id);
        _session.map!.items[entity.id]!.isSelectable = true;
      }
    }

    _session.encounter!.currentTurn!.activeAction!.environment[CombatTurnActionEnvironmentKey.selectableEntities] = selectable;
  }

  void _clearCurrentActionSelectableEntities() {
    if(_session.encounter!.currentTurn!.activeAction!.environment.containsKey(CombatTurnActionEnvironmentKey.selectableEntities)) {
      for (var uuid in (_session.encounter!.currentTurn!.activeAction!.environment[CombatTurnActionEnvironmentKey.selectableEntities] as List<String>)) {
        _session.map!.items[uuid]?.isSelectable = false;
      }
      _session.encounter!.currentTurn!.activeAction!.environment.remove(CombatTurnActionEnvironmentKey.selectableEntities);
    }
  }

  final SessionModel _session;
}
