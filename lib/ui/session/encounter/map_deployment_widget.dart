import 'package:flutter/material.dart';

import '../../../classes/entity_base.dart';
import '../../../classes/entity_instance.dart';
import '../../../classes/player_character.dart';
import '../../../classes/session/encounter.dart';
import '../../../classes/session/game_session.dart';
import '../../../classes/session/map/item.dart';
import '../../../classes/session/map/item_entity.dart';
import '../../utils/session/entity_pill_widget.dart';

class MapDeploymentWidget extends StatelessWidget {
  const MapDeploymentWidget({
    super.key,
    required this.session,
    this.encounter,
    this.onEntityDeployed,
    this.deployed = const <String>{},
    this.showDeployed = true,
    this.onEntityRemoved,
  });

  static const feedbackWidgetSize = Size(40.0, 40.0);

  final GameSession session;
  final SessionEncounter? encounter;
  final void Function(String)? onEntityDeployed;
  final Set<String> deployed;
  final bool showDeployed;
  final void Function(String)? onEntityRemoved;

  @override
  Widget build(BuildContext context) {
    var deploymentWidgets = <Widget>[];
    if(encounter != null) {
      var pcs = showDeployed
          ? encounter!.characters
          : encounter!.characters
          .where((PlayerCharacter p) => !deployed.contains(p.id))
          .toList();
      if(pcs.isNotEmpty) {
        deploymentWidgets.add(
            _MapEntityDeploymentWidget(
              title: 'PJs',
              entities: pcs,
              onEntityDeployed: onEntityDeployed,
              onEntityRemoved: onEntityRemoved,
            )
        );
      }

      var npcs = showDeployed
          ? encounter!.npcs
          : encounter!.npcs
          .where((EntityInstance i) => !deployed.contains(i.id))
          .toList();
      if(npcs.isNotEmpty) {
        deploymentWidgets.add(
            _MapEntityDeploymentWidget(
              title: 'PNJs',
              entities: npcs,
              onEntityDeployed: onEntityDeployed,
              onEntityRemoved: onEntityRemoved,
            )
        );
      }
    }
    else {
      deploymentWidgets.add(
          _MapEntityDeploymentWidget(
            title: 'PJs',
            entities: session.table.players,
            onEntityDeployed: onEntityDeployed,
          )
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: deploymentWidgets,
      ),
    );
  }
}

class _MapEntityDeploymentWidget extends StatelessWidget {
  const _MapEntityDeploymentWidget({
    required this.title,
    required this.entities,
    this.onEntityDeployed,
    this.onEntityRemoved,
  });

  final String title;
  final List<EntityBase> entities;
  final void Function(String)? onEntityDeployed;
  final void Function(String)? onEntityRemoved;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: theme.colorScheme.outline,
      ),
      child: Column(
        children: [
          Text(
            title,
            style: theme.textTheme.bodySmall!
                .copyWith(color: theme.colorScheme.onPrimary),
          ),
          ListView.builder(
            itemCount: entities.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Draggable<SessionMapItem>(
                  data: SessionMapEntityItem(entity: entities[index]),
                  dragAnchorStrategy: (_, _, _) {
                    return Offset(MapDeploymentWidget.feedbackWidgetSize.width/2, MapDeploymentWidget.feedbackWidgetSize.height/2);
                  },
                  feedback: SessionEntityPillWidget(
                    entity: entities[index],
                    width: MapDeploymentWidget.feedbackWidgetSize.width,
                    height: MapDeploymentWidget.feedbackWidgetSize.height,
                  ),
                  childWhenDragging: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.black54,
                    ),
                  ),
                  onDragEnd: (DraggableDetails details) {
                    if(details.wasAccepted) {
                      onEntityDeployed?.call(entities[index].id);
                    }
                  },
                  child: Row(
                    spacing: 8.0,
                    children: [
                      SessionEntityPillWidget(
                        entity: entities[index],
                        width: 40.0,
                        height: 40.0,
                      ),
                      Expanded(
                        child: Text(
                          entities[index].name,
                        ),
                      ),
                      if(onEntityRemoved != null)
                        IconButton(
                          onPressed: () {
                            onEntityRemoved!(entities[index].id);
                          },
                          icon: Icon(Icons.cancel_outlined),
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(4.0),
                          iconSize: 18.0,
                        )
                    ],
                  ),
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}