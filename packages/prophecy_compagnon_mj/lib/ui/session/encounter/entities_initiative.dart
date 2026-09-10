import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/entity_action.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/turn_initiative_input_widget.dart';

class SessionEncounterEntitiesInitiativeDialog extends StatelessWidget {
  const SessionEncounterEntitiesInitiativeDialog({
    super.key,
    required this.encounter,
  });

  final SessionEncounter encounter;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Tour ${(encounter.currentTurnNumber+1).toString()} - Initiatives'),
      content: SingleChildScrollView(
        child: SessionEncounterEntitiesInitiativeWidget(
          encounter: encounter,
          onDone: (List<SessionEncounterEntityAction> actions) {
            Navigator.of(context, rootNavigator: true).pop(actions);
          },
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text('Annuler'),
        ),
      ]
    );
  }
}

class SessionEncounterEntitiesInitiativeWidget extends StatefulWidget {
  const SessionEncounterEntitiesInitiativeWidget({
    super.key,
    required this.encounter,
    required this.onDone,
  });

  final SessionEncounter encounter;
  final void Function(List<SessionEncounterEntityAction>) onDone;

  @override
  State<SessionEncounterEntitiesInitiativeWidget> createState() => _SessionEncounterEntitiesInitiativeWidgetState();
}

class _SessionEncounterEntitiesInitiativeWidgetState extends State<SessionEncounterEntitiesInitiativeWidget> {
  final List<EntityBase> pending = <EntityBase>[];
  final Map<String, int> unusedActions = <String, int>{};
  final List<SessionEncounterEntityAction> actions = <SessionEncounterEntityAction>[];

  @override
  void initState() {
    super.initState();

    pending.addAll(
      widget.encounter.characters
        .where((EntityBase e) => e.canAct())
    );
    pending.addAll(
      widget.encounter.npcs
        .where((EntityBase e) => e.canAct())
    );

    // TODO: get count of unused actions in the previous turn
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.0,
      children: [
        for(var e in pending)
          TurnInitiativeInputWidget(
            // key is necessary so that widget won't be reused when an entity
            // is removed from pending
            key: ValueKey(e.id),
            entity: e,
            dice: e.initiative + (unusedActions[e.id] ?? 0),
            engagementRange: widget.encounter.engagements.smallestFor(e),
            onDone: (TurnInitiative i) {
              for(var a in i.dominantHand) {
                actions.add(
                  SessionEncounterEntityAction(
                    entity: e,
                    initialRank: a.raw + (a.weaponModifier ?? 0) - e.damageMalus(),
                  )
                );
              }

              if(i.weakHand != null) {
                actions.add(
                  SessionEncounterEntityAction(
                    entity: e,
                    initialRank: i.weakHand!.raw + (i.weakHand!.weaponModifier ?? 0) - e.damageMalus(),
                    weakHand: true,
                  )
                );
              }

              setState(() {
                pending.remove(e);
              });

              if(pending.isEmpty) {
                widget.onDone(actions);
              }
            },
          ),
      ],
    );
  }
}