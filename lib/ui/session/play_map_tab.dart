import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';

import '../../classes/combat_turn.dart';
import '../../classes/encounter.dart';
import '../../classes/entity_base.dart';
import '../../classes/player_character.dart';
import 'command_dispatcher.dart';
import 'encounter_actions.dart';
import 'combat_turn_initiatives.dart';
import 'map_entity_model.dart';
import 'map_model.dart';
import 'session_model.dart';

class PlayMapPage extends StatefulWidget {
  const PlayMapPage({ super.key });

  @override
  State<PlayMapPage> createState() => _PlayMapPageState();
}

class _PlayMapPageState extends State<PlayMapPage> {
  BoxConstraints? _viewerConstraints;
  late List<EntityBase> _undeployedPcs;
  late List<EntityBase> _undeployedNpcs;
  late bool _showPcDeploymentWidget;
  late bool _showNpcDeploymentWidget;

  @override
  void initState() {
    // TODO: what when a new map is loaded? Should reset this widget
    super.initState();

    var session = context.read<SessionModel>();

    if(session.encounter == null) {
      _undeployedPcs = session.table.players
          .where((PlayerCharacter pc) => !session.map!.pcs.contains(pc.uuid))
          .toList();
      _undeployedNpcs = <EntityBase>[];
    }
    else {
      _undeployedPcs = session.encounter!.characters
          .where((PlayerCharacter pc) => !session.map!.pcs.contains(pc.uuid))
          .toList();
      _undeployedNpcs = session.encounter!.npcs
          .where((EntityBase e) => !session.map!.npcs.contains(e.uuid))
          .toList();
    }

    _showPcDeploymentWidget = _undeployedPcs.isNotEmpty;
    _showNpcDeploymentWidget = _undeployedNpcs.isNotEmpty;
  }

  void _onEntityDeployed(String uuid) {
    var session = context.read<SessionModel>();

    int idx = _undeployedNpcs.indexWhere((e) => e.uuid == uuid);
    if(idx != -1) {
      session.encounter!.deployNpc(_undeployedNpcs[idx]);
    }

    setState(() {
      _undeployedPcs.removeWhere((pc) => pc.uuid == uuid);
      _undeployedNpcs.removeWhere((npc) => npc.uuid == uuid);
    });
  }

  List<Widget> _contextMenuItemProvider(Offset menuPosition, Offset mapPosition) {
    var session = context.read<SessionModel>();
    var ret = <Widget>[];

    List<Widget> pcsDeploymentButtons = session.table.players
      .map((PlayerCharacter pc) => MenuItemButton(
        onPressed: () {
          ContextMenuController.removeAny();

          if(!session.map!.items.containsKey(pc.uuid)) {
            var entityModel = MapEntityModel(
              entity: pc,
              map: session.map!,
              x: mapPosition.dx,
              y: mapPosition.dy,
            );
            session.map!.addPlayerCharacter(entityModel);
            _onEntityDeployed(pc.uuid);
          }
          else {
            var entityModel = session.map!.items[pc.uuid]! as MapEntityModel;
            entityModel.moveTo(mapPosition.dx, mapPosition.dy);
          }
        },
      child: Text(pc.name),
    )).toList();

    var pcsSubMenu = SubmenuButton(
      menuChildren: [
        ...pcsDeploymentButtons,
      ],
      child: const Text('PJs'),
    );
    ret.add(pcsSubMenu);

    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      _viewerConstraints = constraints;
      var dispatcher = context.read<CommandDispatcher>();
      var session = context.watch<SessionModel>();

      if(!session.map!.displayInitializationDone && _viewerConstraints != null) {
        var scale = max(
          _viewerConstraints!.maxWidth / session.map!.background.imageWidth,
          _viewerConstraints!.maxHeight / session.map!.background.imageHeight,
        );
        session.map!.controller.value = Matrix4.identity()..scale(scale);
        session.map!.displayInitializationDone = true;
      }

      return Stack(
        children: [
          MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: dispatcher),
              ChangeNotifierProvider.value(value: session.map!),
            ],
            child: _MapViewWidget(
              onEntityDeployed: _onEntityDeployed,
              contextMenuItemProvider: _contextMenuItemProvider,
            ),
          ),
          if(_showPcDeploymentWidget)
            Positioned(
              top: 16.0,
              left: 16.0,
              child: AnimatedOpacity(
                opacity: _undeployedPcs.isEmpty ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 200),
                onEnd: () {
                  setState(() {
                    _showPcDeploymentWidget = false;
                  });
                },
                child: _MapEntityDeploymentWidget(
                  title: 'PJs',
                  entities: _undeployedPcs,
                  constraints: BoxConstraints(
                    minWidth: 100.0,
                    maxWidth: 100.0,
                    minHeight: 100.0,
                    maxHeight: _viewerConstraints!.maxHeight - 32.0,
                  ),
                ),
              ),
            ),
          if(_showNpcDeploymentWidget && !_showPcDeploymentWidget)
            Positioned(
              top: 16.0,
              left: 16.0,
              child: AnimatedOpacity(
                opacity: _undeployedNpcs.isEmpty ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 200),
                onEnd: () {
                  setState(() {
                    _showNpcDeploymentWidget = false;
                  });
                },
                child: _MapEntityDeploymentWidget(
                  title: 'PNJs',
                  entities: _undeployedNpcs,
                  constraints: BoxConstraints(
                    minWidth: 100.0,
                    maxWidth: 100.0,
                    minHeight: 100.0,
                    maxHeight: _viewerConstraints!.maxHeight - 32.0,
                  ),
                  allowPartialDeployment: true,
                  onDeploymentDone: () {
                    setState(() {
                      _undeployedNpcs.clear();
                    });
                  }
                ),
              ),
            ),
          if(session.encounter != null && !_showPcDeploymentWidget && !_showNpcDeploymentWidget)
            Positioned(
              top: 16.0,
              left: 16.0,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: 100.0,
                    maxWidth: 300.0,
                    maxHeight: constraints.maxHeight - 32.0
                ),
                child: MultiProvider(
                  providers: [
                    ChangeNotifierProvider.value(value: dispatcher),
                    ChangeNotifierProvider.value(value: session.encounter),
                  ],
                  child: const _EncounterTurnDisplayWidget(),
                ),
              ),
            )
        ],
      );
    });
  }
}

class _MapViewWidget extends StatefulWidget {
  const _MapViewWidget({
    required this.onEntityDeployed,
    this.contextMenuItemProvider,
  });

  final void Function(String) onEntityDeployed;
  final List<Widget> Function(Offset, Offset)? contextMenuItemProvider;

  @override
  State<_MapViewWidget> createState() => _MapViewWidgetState();
}

class _MapViewWidgetState extends State<_MapViewWidget> with SingleTickerProviderStateMixin {
  GlobalKey interactiveViewerKey = GlobalKey();

  final ContextMenuController _contextMenuController = ContextMenuController();

  void _displayContextMenu(Offset globalPosition, Offset mapPosition, CommandDispatcher dispatcher) {
    var contextMenuItems = <Widget>[];

    if(widget.contextMenuItemProvider != null) {
      contextMenuItems.addAll(widget.contextMenuItemProvider!(globalPosition, mapPosition));
    }

    _contextMenuController.show(
        context: context,
        contextMenuBuilder: (BuildContext context) {
          return AdaptiveTextSelectionToolbar(
            anchors: TextSelectionToolbarAnchors(primaryAnchor: globalPosition),
            children: [
              ...contextMenuItems,
            ],
          );
        }
    );
  }

  @override
  void initState() {
    super.initState();
    if(kIsWeb) {
      BrowserContextMenu.disableContextMenu();
    }
  }

  @override
  void dispose() {
    if(kIsWeb) {
      BrowserContextMenu.enableContextMenu();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dispatcher = context.read<CommandDispatcher>();
    var map = context.watch<MapModel>();

    return GestureDetector(
      onTap: () {
        ContextMenuController.removeAny();
      },
      onSecondaryTapUp: (TapUpDetails details) {
        var renderBox = interactiveViewerKey.currentContext!.findRenderObject() as RenderBox;
        var position = map.controller.toScene(renderBox.globalToLocal(details.globalPosition));

        _displayContextMenu(
            details.globalPosition,
            position,
            dispatcher,
        );
      },
      child: InteractiveViewer(
        key: interactiveViewerKey,
        transformationController: map.controller,
        constrained: false,
        minScale: 0.1,
        maxScale: 3.0,
        child: DragTarget<EntityBase>(
          builder: (BuildContext context, List<dynamic> accepted, List<dynamic> rejected) {
            return Stack(
              children: [
                Image.memory(map.background.image.data),
                if(map.movementRangeSpecification != null)
                  Positioned(
                    left: map.movementRangeSpecification!.center.dx - map.movementRangeSpecification!.radius,
                    top: map.movementRangeSpecification!.center.dy - map.movementRangeSpecification!.radius,
                    child: Opacity(
                      opacity: 0.3,
                      child: Container(
                        width: map.movementRangeSpecification!.radius * 2,
                        height: map.movementRangeSpecification!.radius * 2,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.indigo),
                          borderRadius: BorderRadius.circular(map.movementRangeSpecification!.radius),
                          gradient: const RadialGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white,
                            ],
                          ),
                        ),
                      ),
                    )
                  ),
                for(var em in map.items.values)
                  MultiProvider(
                    providers: [
                      ChangeNotifierProvider.value(value: dispatcher),
                      ChangeNotifierProvider.value(value: em),
                    ],
                    child: const MapEntityWidget(),
                  )
              ],
            );
          },
          onAcceptWithDetails: (DragTargetDetails<EntityBase> details) {
            var entityBase = details.data;
            var renderBox = interactiveViewerKey.currentContext!.findRenderObject() as RenderBox;
            // We have to add half the width of the drag feedback widget
            var dropCenterOffset = details.offset + const Offset(25.0, 25.0);
            var posOffset = map.controller.toScene(renderBox.globalToLocal(dropCenterOffset));

            var entityModel = MapEntityModel(
              entity: entityBase,
              map: map,
              x: posOffset.dx,
              y: posOffset.dy,
            );

            if(entityBase is PlayerCharacter) {
              map.addPlayerCharacter(entityModel);
            }
            else {
              map.addNonPlayerCharacter(entityModel);
            }

            widget.onEntityDeployed(entityBase.uuid);
          },
        )
      ),
    );
  }
}

class _MapEntityDeploymentWidget extends StatelessWidget {
  const _MapEntityDeploymentWidget({
    required this.title,
    required this.entities,
    required this.constraints,
    allowPartialDeployment,
    this.onDeploymentDone,
  })
    : allowPartialDeployment = allowPartialDeployment ?? false;

  final String title;
  final List<EntityBase> entities;
  final BoxConstraints constraints;
  final bool allowPartialDeployment;
  final Function()? onDeploymentDone;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var listViewWidget = <Widget>[];
    listViewWidget.addAll(entities.map((EntityBase e) => Column(
      children: [
        Draggable<EntityBase>(
          data: e,
          feedback: Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.white,
            ),
            child: Center(
              child: Text(
                e.name[0],
                style: theme.textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          childWhenDragging: Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.black54,
            ),
          ),
          child: Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 2.0),
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 4.0),
        Text(e.name, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 8.0),
      ],
    )));

    if(allowPartialDeployment) {
      listViewWidget.add(
        IconButton.filled(
          onPressed: onDeploymentDone,
          icon: const Icon(Icons.check),
          tooltip: 'Terminé',
        )
      );
    }

    return Container(
      constraints: constraints,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Spacer(),
              Card(
                color: Colors.indigo,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: Text(
                    title,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 8.0),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListView(
              shrinkWrap: true,
              children: listViewWidget,
            ),
          )
        ],
      ),
    );
  }
}

class _EncounterTurnDisplayWidget extends StatelessWidget {
  const _EncounterTurnDisplayWidget();

  @override
  Widget build(BuildContext context) {
    var dispatcher = context.read<CommandDispatcher>();
    var encounter = context.watch<Encounter>();

    Widget ret;

    var encounterDone = encounter.deployedNpcs.isEmpty || encounter.deployedNpcs.every((e) => e.status & EntityStatus.dead == EntityStatus.dead);

    if(encounterDone) {
      ret = ElevatedButton.icon(
        onPressed: () {
          dispatcher.dispatchCommand(SessionCommand.encounterEnd, <String, dynamic>{});
        },
        icon: const Icon(Icons.check),
        label: const Text('Terminer la rencontre'),
      );
    }
    else if(encounter.currentTurn == null) {
      ret = ElevatedButton.icon(
        onPressed: () async {
          var turn = await startNextTurn(context, encounter);
          if(turn != null) {
            dispatcher.dispatchCommand(
                SessionCommand.combatStart,
                <String, dynamic>{}
            );
            dispatcher.dispatchCommand(
                SessionCommand.combatNextTurn,
                <String, dynamic>{'turn': turn}
            );
          }
          // TODO: decide what to do if the user cancels the dialog
        },
        icon: const Icon(Symbols.swords),
        label: encounter.previousTurn == null ?
          const Text('Commencer') :
          const Text('Tour suivant'),
      );
    }
    else {
      ret = MultiProvider(
        providers:[
          ChangeNotifierProvider.value(value: dispatcher),
          ChangeNotifierProvider.value(value: encounter.currentTurn!),
        ],
        child: CombatTurnActionListWidget(
          onCenterOn: (String uuid) {},
        )
      );
    }

    return ret;
  }

  Future<CombatTurn?> startNextTurn(BuildContext context, Encounter encounter, { CombatTurn? previousTurn }) async {
    var nextTurn = await showDialog<CombatTurn>(
        context: context,
        builder: (BuildContext context) => CombatTurnInitiativesInputWidget(
          encounter: encounter,
          previousTurn: previousTurn,
        )
    );

    return nextTurn;
  }
}