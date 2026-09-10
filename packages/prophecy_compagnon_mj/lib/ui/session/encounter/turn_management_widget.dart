import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_mj/ui/session/encounter/execute_turn_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/entity_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/turn.dart';
import 'package:prophecy_compagnon_shared/ui/session/clients/session_message_bus_client.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/action_select_dialog.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/turn_action_widget.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/encounter/session_encounter_turn.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/encounter/turn/action_planning.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/encounter/turn/assign_combat_action.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/encounter/turn/delay_action.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/encounter/turn/get_usable_actions.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/encounter/turn/select_actions.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/encounter/turn/set_combat_action.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/session_message.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/session_message_response.dart';

class TurnManagementWidget extends StatefulWidget {
  const TurnManagementWidget({
    super.key,
    required this.turn,
    required this.onTurnFinished,
  });

  final SessionEncounterTurn turn;
  final void Function() onTurnFinished;

  @override
  State<TurnManagementWidget> createState() => _TurnManagementWidgetState();
}

class _TurnManagementWidgetState extends State<TurnManagementWidget> {
  late StreamSubscription<SessionMessage> subscription;
  late int rank;
  final List<SessionEncounterEntityAction> actions = <SessionEncounterEntityAction>[];
  final List<SessionEncounterEntityAction> approvedActions = <SessionEncounterEntityAction>[];
  final List<CombatAction> interpolatedActions = <CombatAction>[];
  String? activeActionUuid;
  String? planningActionUuid;

  @override
  void initState() {
    super.initState();

    subscription = SessionMessageBusClient.instance!.stream
        .stream
        .where((SessionMessage m) => m is SessionEncounterTurnMessage)
        .listen(onTurnMessage);


    rank = getHighestRank();
    setupRank();
  }

  @override
  void dispose() {
    subscription.cancel();

    super.dispose();
  }

  int getHighestRank() {
    var ranks = widget.turn.ranksWithActionFilter(
        (SessionEncounterEntityAction a) =>
            a.stage == SessionEncounterEntityActionStage.none
            || a.stage == SessionEncounterEntityActionStage.assigned
        )
        .toList()
        ..sort((int a, int b) => b - a);

    return ranks.isNotEmpty ? ranks.first : -1;
  }

  bool hasInterpolatedActions() =>
      interpolatedActions.where((CombatAction a) => a.rank == rank).isNotEmpty;

  void executeRankActions() {
    // TODO: display a dialog to order the approved and interpolated actions execution
    for(var a in approvedActions) {
      if(!a.combatAction!.interpolate) {
        // Interpolated actions are executed separately
        executeTurnAction(a.combatAction!);
      }
      a.stage = SessionEncounterEntityActionStage.executed;
    }

    for(var a in interpolatedActions.where((CombatAction a) => a.rank == rank)) {
      executeTurnAction(a);
    }
  }

  void checkRankDone() {
    if(approvedActions.length != actions.length) {
      return;
    }

    executeRankActions();

    do {
      rank -= 1;
      setupRank();

      // If there are only interpolated actions, execute them now
      if(actions.isEmpty && approvedActions.isEmpty && hasInterpolatedActions()) {
        executeRankActions();
      }
    } while(actions.isEmpty && rank > 0);

    if(rank == 0) {
      widget.onTurnFinished();
    }
  }

  void setupRank() {
    activeActionUuid = null;
    actions.clear();
    approvedActions.clear();
    interpolatedActions.removeWhere((CombatAction a) => a.rank > rank);

    actions.addAll(
        widget.turn.actionsForRank(rank)
            .where(
                (SessionEncounterEntityAction a) =>
                    a.stage == SessionEncounterEntityActionStage.none
                    || a.stage == SessionEncounterEntityActionStage.assigned
            )
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.0,
        children: [
          Text(
            'Rang $rank',
            style: TextStyle(color: Colors.white),
          ),
          for(var a in actions)
            TurnActionWidget(
              action: a,
              isActive: a.uuid == activeActionUuid,
              onSetActive: () {
                setState(() {
                  activeActionUuid = a.uuid;
                });
              },
            ),
        ],
      ),
    );
  }

  void onTurnMessage(SessionMessage m) async {
    if(m is! SessionEncounterTurnMessage) return;

    var messageBus = SessionMessageBusClient.instance;
    if(messageBus == null) return;

    if(m is SessionEncounterTurnGetUsableActions) {
      var actions = widget.turn.filteredActions(
          (SessionEncounterEntityAction a) =>
              a.entity.id == m.entityId
              && a.stage == SessionEncounterEntityActionStage.none
              && !m.excludedActionUuids.contains(a.uuid)
        )
        .toList();

      messageBus.sendResponse(
        m,
        actions,
      );
    }
    else if(m is SessionEncounterTurnSelectActions) {
      var selected = await showDialog<List<SessionEncounterEntityAction>>(
        context: context,
        builder: (BuildContext context) =>
          SessionEncounterTurnSelectActionDialog(
            description: m.description,
            turn: widget.turn,
            entityId: m.entityId,
            excludedActionUuids: m.excludedActionUuids,
            multiselect: m.multiselect,
            selectRange: m.selectRange,
            allowEmptySelection: m.allowEmptySelection,
            usableOnly: m.usableOnly,
            showWeakHandAction: m.showWeakHandAction,
          )
      );

      if((selected == null || selected.isEmpty) && !m.allowEmptySelection) {
        messageBus.sendResponse(
          m,
          null,
          status: SessionMessageResponseStatus.cancelled
        );
      }
      else {
        messageBus.sendResponse(
          m,
          selected ?? <SessionEncounterEntityAction>[],
        );
      }
    }

    if(m is! SessionEncounterTurnActionMessage) return;

    var matches = widget.turn.filteredActions(
        (SessionEncounterEntityAction a) =>
            a.uuid == m.actionUuid
      );

    SessionEncounterEntityAction? action = matches.isEmpty ? null : matches.first;

    if(m is SessionEncounterTurnActionPlanningStart) {
      // TODO: there is a potential race condition (TOCTOU) here
      if(planningActionUuid != null) {
        messageBus.sendResponse(
          m,
          null,
          status: SessionMessageResponseStatus.rejected,
          statusMessage: "Une action est déjà en cours de planification"
        );

        return;
      }

      messageBus.sendResponse(
        m,
        null,
        status: SessionMessageResponseStatus.accepted,
      );

      setState(() {
        planningActionUuid = m.actionUuid;
        activeActionUuid = planningActionUuid;
      });
    }
    else if(m is SessionEncounterTurnActionPlanningEnd) {
      if(action == null) {
        return;
      }

      setState(() {
        planningActionUuid = null;
        activeActionUuid = null;
      });
    }
    else if(m is SessionEncounterTurnDelayActionMessage) {
      if(action == null) {
        messageBus.sendResponse(
          m,
          null,
          status: SessionMessageResponseStatus.rejected,
          statusMessage: "Pas d'action avec cet identifiant"
        );

        return;
      }

      setState(() {
        action.delayed += 1;
        actions.remove(action);
        checkRankDone();
      });

      messageBus.sendResponse(
        m,
        null,
        status: SessionMessageResponseStatus.accepted,
      );
    }
    else if(m is SessionEncounterTurnAssignCombatActionMessage) {
      if(action == null) {
        messageBus.sendResponse(
          m,
          null,
          status: SessionMessageResponseStatus.rejected,
          statusMessage: "Pas d'action avec cet identifiant"
        );

        return;
      }

      setState(() {
        action.combatAction = m.combatAction;
        action.stage = SessionEncounterEntityActionStage.assigned;
      });

      messageBus.sendResponse(
        m,
        null,
        status: SessionMessageResponseStatus.accepted,
      );
    }
    else if(m is SessionEncounterTurnUnassignCombatActionMessage) {
      if(action == null) {
        messageBus.sendResponse(
          m,
          null,
          status: SessionMessageResponseStatus.rejected,
          statusMessage: "Pas d'action avec cet identifiant"
        );

        return;
      }

      if(action.stage == SessionEncounterEntityActionStage.assigned) {
        setState(() {
          action.combatAction = null;
          action.stage = SessionEncounterEntityActionStage.none;
        });
      }
    }
    else if(m is SessionEncounterTurnSetCombatActionMessage) {
      if(action == null) {
        messageBus.sendResponse(
          m,
          null,
          status: SessionMessageResponseStatus.rejected,
          statusMessage: "Pas d'action avec cet identifiant"
        );

        return;
      }

      if(m.combatAction.interpolate) {
        var stepActions = widget.turn.filteredActions(
            (SessionEncounterEntityAction a) =>
                a.entity.id == action.entity.id
                && a.uuid != action.uuid
                && (
                  a.stage == SessionEncounterEntityActionStage.none
                  || a.stage == SessionEncounterEntityActionStage.assigned
                )
          )
          .toList();

        int targetRank;
        if(stepActions.isEmpty) {
          targetRank = 0;
        }
        else if(stepActions.length == 1) {
          targetRank = stepActions.first.rank;
        }
        else {
          stepActions.sort(
              (SessionEncounterEntityAction a, SessionEncounterEntityAction b) =>
                  b.rank - a.rank
            );

          if (stepActions.first.rank < action.rank) {
            targetRank = stepActions.first.rank + 1;
          }
          else {
            targetRank = action.rank;
          }
        }

        if(targetRank == action.rank) {
          interpolatedActions.add(m.combatAction);
        }
        else {
          var actionsCount = action.rank - targetRank + 1;
          for(var i = 0; i < actionsCount; ++i) {
            var x = (1/actionsCount) * (i+1);
            interpolatedActions.add(
              m.combatAction.lerp(action.rank - i, x)!
            );
          }
        }
      }

      setState(() {
        // TODO: implement approval here
        action.combatAction = m.combatAction;
        action.stage = SessionEncounterEntityActionStage.approved;
        approvedActions.add(action);
        checkRankDone();
      });

      messageBus.sendResponse(
        m,
        null,
        status: SessionMessageResponseStatus.accepted,
      );
    }
  }
}