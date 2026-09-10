import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_mj/ui/session/encounter/turn_management_widget.dart';
import 'package:prophecy_compagnon_shared/classes/entity_instance.dart';
import 'package:prophecy_compagnon_shared/classes/player_character.dart';
import 'package:prophecy_compagnon_shared/classes/session/board/item_map.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/turn.dart';
import 'package:prophecy_compagnon_shared/classes/session/game_session.dart';
import 'package:prophecy_compagnon_shared/classes/session/map/item.dart';

import 'entities_initiative.dart';
import 'map_deployment_widget.dart';

class EncounterManagementWidget extends StatefulWidget {
  const EncounterManagementWidget({
    super.key,
    required this.session,
    required this.map,
  });

  final GameSession session;
  final SessionBoardItemMap map;

  @override
  State<EncounterManagementWidget> createState() => _EncounterManagementWidgetState();
}

class _EncounterManagementWidgetState extends State<EncounterManagementWidget> {
  late SessionEncounter encounter;
  final Set<String> deployed = <String>{};

  @override
  void initState() {
    super.initState();

    encounter = widget.map.encounter!;

    deployed.addAll(
      widget.map.items.values.map((SessionMapItem i) => i.id)
    );
  }

  void updateEncounterStatus() {
    switch(encounter.status) {
      case SessionEncounterStatus.positioning:
        checkEncounterPositioningDone();
      default:
        break;
    }
  }

  void checkEncounterPositioningDone() {
    var undeployed = <String>{};
    undeployed.addAll(
        encounter.characters
            .where((PlayerCharacter p) => !deployed.contains(p.id))
            .map((PlayerCharacter p) => p.id)
    );
    undeployed.addAll(
        encounter.npcs
            .where((EntityInstance i) => !deployed.contains(i.id))
            .map((EntityInstance i) => i.id)
    );

    var remaining = undeployed.difference(deployed);
    if(remaining.isEmpty) {
      encounter.status = SessionEncounterStatus.ready;
    }
  }

  Future<bool> startNewTurn() async {
    var actions = await showDialog(
      context: context,
      builder: (BuildContext context) =>
        SessionEncounterEntitiesInitiativeDialog(
          encounter: encounter,
        ),
    );
    if(!context.mounted) return false;
    if(actions == null) return false;

    var turn = SessionEncounterTurn(
        actions: actions,
      );
    encounter.turns.add(turn);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    InlineSpan stage;
    switch(encounter.status) {
      case SessionEncounterStatus.positioning:
        stage = TextSpan(
          text: 'Déploiement',
        );
      case SessionEncounterStatus.ready:
        stage = TextSpan(
            text: 'Prête à commencer'
        );
      case SessionEncounterStatus.ongoing:
        stage = TextSpan(
          text: 'Tour ${encounter.currentTurnNumber}',
        );
      default:
        stage = TextSpan(
          text: 'non géré !',
        );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.0,
      children: [
        Center(
          child: Text(
            'Rencontre: ${encounter.name}',
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyLarge!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Text.rich(
          TextSpan(
            text: 'Étape : ',
            children: [stage],
          ),
          textAlign: TextAlign.start,
          style: theme.textTheme.bodyMedium!
              .copyWith(color: Colors.white),
        ),
        if(encounter.status == SessionEncounterStatus.positioning)
          MapDeploymentWidget(
            session: widget.session,
            encounter: encounter,
            onEntityDeployed: (String id) {
              setState(() {
                deployed.add(id);
                updateEncounterStatus();
              });
            },
            deployed: deployed,
            showDeployed: false,
            onEntityRemoved: (String id) {
              encounter.characters.removeWhere((PlayerCharacter p) => p.id == id);
              encounter.npcs.removeWhere((EntityInstance i) => i.id == id);
              setState(() {
                deployed.remove(id);
                updateEncounterStatus();
              });
            },
          ),
        if(encounter.status == SessionEncounterStatus.ready)
          Row(
            spacing: 8.0,
            children: [
              IconButton.filled(
                onPressed: () async {
                  var started = await startNewTurn();
                  if(started) {
                    widget.map.freeMovementEnabled = false;

                    setState(() {
                      encounter.status = SessionEncounterStatus.ongoing;
                      updateEncounterStatus();
                    });
                  }
                },
                icon: Icon(Icons.play_arrow),
                padding: const EdgeInsets.all(4.0),
                constraints: const BoxConstraints(),
              ),
              Text(
                'Lancer la rencontre',
                style: theme.textTheme.titleLarge!
                    .copyWith(color: Colors.white),
              )
            ],
          ),
        if(encounter.status == SessionEncounterStatus.ongoing)
          TurnManagementWidget(
            turn: encounter.currentTurn!,
            onTurnFinished: () async {
              // TODO: check if there are still NPCs alive and end the encounter if not
              var startNextTurn = await startNewTurn();

              // TODO: if the user cancels, ask if they want to stop the encounter

              setState(() {
                // no-op but required to trigger a redraw
              });
            },
          ),
      ],
    );
  }
}