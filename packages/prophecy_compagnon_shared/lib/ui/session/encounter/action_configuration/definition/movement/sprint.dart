import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_entity_base_skill.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_result.dart';
import 'package:prophecy_compagnon_shared/classes/entity/abilities.dart';
import 'package:prophecy_compagnon_shared/classes/entity/attributes.dart';
import 'package:prophecy_compagnon_shared/classes/entity/skill.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action_type.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_actions/movement/base.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/entity_action.dart';
import 'package:prophecy_compagnon_shared/ui/session/clients/session_message_bus_client.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/action_configuration/definition/action_configuration.dart';
import 'package:prophecy_compagnon_shared/ui/session/evaluate_dice_throw.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/action/dice_throw_request.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/encounter/turn/assign_combat_action.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/encounter/turn/get_usable_actions.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/session_message.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/session_message_response.dart';

class ActionConfigurationMovementSprint extends ActionConfiguration {
  ActionConfigurationMovementSprint();

  @override
  String get name => 'Sprint';

  @override
  IconData get icon => Symbols.sprint;

  @override
  Future<void> plan(SessionEncounterEntityAction action) async {
    await guardPlan(action, _doPlan);
  }

  Future<void> _doPlan(SessionEncounterEntityAction action) async {
    var messageBus = SessionMessageBusClient.instance;
    if(messageBus == null) {
      // TODO: display a message
      return;
    }

    var assignedActions = <SessionEncounterEntityAction>[];
    double distanceMultiplier;

    if(action.stage == SessionEncounterEntityActionStage.none) {
      var controllingClient = messageBus.clientControlling(action.entity.id);

      // TODO: request the difficulty from master
      var difficulty = 15;
      var request = DiceThrowRequest(
        difficulty: difficulty,
        base: DiceThrowEntityBaseSkill(
          attribute: Attribute.physique,
          ability: Ability.force,
          skill: Skill.athletisme,
        )
      );

      var diceThrowResponse = await messageBus.publishAndWaitForResponse(
        SessionActionDiceThrowRequestMessage(
          destination: controllingClient,
          entityId: action.entity.id,
          request: request,
        )
      );

      if(diceThrowResponse.status != SessionMessageResponseStatus.accepted) {
        // TODO: display a nice message ?
        return;
      }

      if(diceThrowResponse.data is! DiceThrowResult) {
        // TODO: display a nice message ?
        return;
      }

      var bundle = EntityThrowBundle(
        entity: action.entity,
        request: request,
        result: diceThrowResponse.data,
      );

      // TODO: manage duration
      // TODO: manage critical fail
      var throwResultType = evaluateDiceThrow(bundle);
      if(throwResultType.resultType == DiceThrowResultType.fail) {
        distanceMultiplier = 3.0;
      }
      else {
        distanceMultiplier = 5.0;
      }

      var usableActionsResponse = await messageBus.publishAndWaitForResponse(
        SessionEncounterTurnGetUsableActions(
          destination: SessionMessage.masterIdentifier,
          entityId: action.entity.id,
          excludedActionUuids: [action.uuid],
        )
      );

      if(usableActionsResponse.status != SessionMessageResponseStatus.accepted) {
        // TODO: display a nice message ?
        return;
      }

      if(usableActionsResponse.data != null) {
        var actions = (usableActionsResponse.data as List<SessionEncounterEntityAction>)
            .where((SessionEncounterEntityAction a) => a.canBeUsedFor(CombatActionType.movement));

        for(var a in actions) {
          var assignResponse = await messageBus.publishAndWaitForResponse(
            SessionEncounterTurnAssignCombatActionMessage(
              destination: SessionMessage.masterIdentifier,
              actionUuid: a.uuid,
              combatAction: CombatActionAssignedMovement(
                rank: a.rank,
                movementType: CombatActionMovementType.run,
                distanceMultiplier: distanceMultiplier,
              ),
            )
          );

          if(assignResponse.status != SessionMessageResponseStatus.accepted) {
            // TODO: display a message
            continue;
          }

          assignedActions.add(a);
        }
      }
    }
    else if(action.stage == SessionEncounterEntityActionStage.assigned) {
      distanceMultiplier = (action.combatAction! as CombatActionMovement).distanceMultiplier;
    }
  }
}