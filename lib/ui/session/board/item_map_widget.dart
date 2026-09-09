import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

import '../../../classes/session/board/item_map.dart';
import '../../../classes/session/game_session.dart';
import '../../../classes/session/map/item.dart';
import '../../../classes/session/map/item_entity.dart';
import '../../../classes/session/map/movement_path.dart';
import '../../utils/generic_image_widget.dart';
import '../../utils/session/clients/session_message_bus_client.dart';
import '../../utils/session/map/item_widget.dart';
import '../../utils/session/messages/map/get_movement_path.dart';
import '../../utils/session/messages/map/session_action_map.dart';
import '../../utils/session/messages/responses/action/movement_path_result.dart';
import '../../utils/session/messages/session_message.dart';
import '../../utils/session/messages/session_message_response.dart';
import '../../utils/session/messages/status/entity_map_status.dart';
import '../../utils/session/messages/status/entity_position_status.dart';
import '../encounter/encounter_management_widget.dart';
import '../encounter/map_deployment_widget.dart';

class SessionBoardItemMapWidget extends StatelessWidget {
  const SessionBoardItemMapWidget({
    super.key,
    required this.map,
  });

  final SessionBoardItemMap map;

  @override
  Widget build(BuildContext context) {
    var session = context.read<GameSession>();

    Widget rightSide;
    if(map.encounter != null) {
      rightSide = EncounterManagementWidget(
        session: session,
        map: map,
      );
    }
    else {
      rightSide = MapDeploymentWidget(
        session: session,
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _MapActionWidget(map: map),
        ),
        Container(
          width: 300,
          decoration: BoxDecoration(
            color: Colors.white12,
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: rightSide,
            ),
          ),
        )
      ],
    );
  }
}

class _MapActionWidget extends StatefulWidget {
  const _MapActionWidget({ required this.map });

  final SessionBoardItemMap map;

  @override
  State<_MapActionWidget> createState() => _MapActionWidgetState();
}

class _MapActionWidgetState extends State<_MapActionWidget> {
  late StreamSubscription<SessionMessage> subscription;
  GlobalKey interactiveViewerKey = GlobalKey();
  bool transformationControllerInitialized = false;
  TransformationController transformationController = TransformationController();
  SessionMapGetMovementPath? currentMovementRequestMessage;
  SessionMapItem? currentMovingItem;
  MovementPath? currentMovement;

  @override
  void initState() {
    super.initState();

    subscription = SessionMessageBusClient.instance!.stream
      .stream
      .where(
        (SessionMessage m) =>
          m is SessionActionMapMessage
          || (
              m is SessionEntityMapStatusMessage
              && m.mapId == widget.map.background.uuid
            )
      )
      .listen(onMapMessage);

    if(kIsWeb) {
      BrowserContextMenu.disableContextMenu();
    }

    if(widget.map.transformation != null) {
      transformationController.value = widget.map.transformation!;
    }
    transformationController.addListener(transformationControllerChanged);
  }

  @override
  void dispose() {
    subscription.cancel();

    transformationController.removeListener(transformationControllerChanged);

    if(kIsWeb) {
      BrowserContextMenu.enableContextMenu();
    }

    super.dispose();
  }

  void transformationControllerChanged() {
    widget.map.transformation = transformationController.value;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            var xScale = constraints.maxWidth / widget.map.background.imageWidth;
            var yScale = constraints.maxHeight / widget.map.background.imageHeight;
            var minScale = min(xScale, yScale);

            if(!transformationControllerInitialized) {
              var xT = 0.0;
              var yT = 0.0;

              if(xScale == minScale) {
                yT = ((constraints.maxHeight / 2) / minScale) - widget.map.background.imageHeight / 2;
              }
              else {
                xT = ((constraints.maxWidth / 2) / minScale) - widget.map.background.imageWidth / 2;
              }

              transformationController.value = Matrix4.identity()
                ..scaleByVector3(vm.Vector3(minScale, minScale, 1.0))
                ..translateByDouble(xT, yT, 0.0, 1.0)
              ;
              transformationControllerInitialized = true;
            }

            return InteractiveViewer(
              key: interactiveViewerKey,
              transformationController: transformationController,
              constrained: false,
              minScale: minScale,
              maxScale: 5.0,
              boundaryMargin: EdgeInsets.all(double.infinity),
              child: DragTarget<SessionMapItem>(
                onAcceptWithDetails: (DragTargetDetails<SessionMapItem> details) {
                  var item = details.data;
                  var renderBox = interactiveViewerKey.currentContext!.findRenderObject() as RenderBox;
                  // We have to add half the width of the drag feedback widget
                  var dropCenterOffset = details.offset + Offset(
                      MapDeploymentWidget.feedbackWidgetSize.width / 2,
                      MapDeploymentWidget.feedbackWidgetSize.height / 2
                  );
                  var posOffset = transformationController.toScene(
                      renderBox.globalToLocal(dropCenterOffset)
                  );

                  item.x = posOffset.dx;
                  item.y = posOffset.dy;
                  widget.map.items[item.id] = item;
                  widget.map.distances.updateFrom(item);
                  // TODO: send a message that a new item has been deployed
                },
                builder: (BuildContext context, List<dynamic> accepted, List<dynamic> rejected) {
                  return ListenableBuilder(
                    listenable: widget.map.items,
                    builder: (BuildContext context, Widget? child) {
                      return Stack(
                        children: [
                          GenericImageWidget(
                            image: widget.map.image(),
                          ),
                          CustomPaint(
                            size: Size(
                              widget.map.background.imageWidth.toDouble(),
                              widget.map.background.imageHeight.toDouble(),
                            ),
                            painter: currentMovement == null ? null : _MovementPathPainter(path: currentMovement!),
                          ),
                          for(var item in widget.map.items.values)
                            ListenableBuilder(
                              listenable: item,
                              child: SessionMapItemWidget(
                                item: item,
                                ppm: widget.map.background.pixelsPerMeter,
                              ),
                              builder: (BuildContext context, Widget? child) {
                                var canMove =
                                    item.movable
                                    && (widget.map.freeMovementEnabled || currentMovingItem == item);

                                return Positioned(
                                  left: item.x - (item.size.width * widget.map.background.pixelsPerMeter) / 2,
                                  top: item.y - (item.size.height * widget.map.background.pixelsPerMeter) / 2,
                                  child: GestureDetector(
                                    onPanStart: !canMove ? null : (DragStartDetails? details) {
                                      if(details == null) return;
                                      if(widget.map.freeMovementEnabled) {
                                        currentMovingItem = item;
                                        return;
                                      }

                                      var renderBox = interactiveViewerKey.currentContext!.findRenderObject() as RenderBox;
                                      var pos = transformationController.toScene(
                                        renderBox.globalToLocal(details.globalPosition)
                                      );

                                      setState(() {
                                        if(currentMovement == null || currentMovement!.last == null) {
                                          currentMovement = MovementPath(
                                              segments: <MovementPathSegment>[
                                                MovementPathSegment(
                                                  start: pos,
                                                  end: pos,
                                                ),
                                              ]
                                          );
                                        }
                                        else {
                                          currentMovement!.segments.add(
                                              MovementPathSegment(
                                                start: currentMovement!.last!.end,
                                                end: pos,
                                              )
                                          );
                                        }
                                      });
                                    },
                                    onPanUpdate: !canMove ? null : (DragUpdateDetails? details) {
                                      if(details == null) return;

                                      var target = Offset(
                                          item.x + details.delta.dx,
                                          item.y + details.delta.dy
                                      );

                                      if(
                                          target.dx > 0
                                          && target.dx <= widget.map.background.imageWidth
                                          && target.dy > 0
                                          && target.dy <= widget.map.background.imageHeight
                                      ) {
                                        if(currentMovement?.last != null) {
                                          var prevEnd = currentMovement!.last!.end;
                                          currentMovement!.last!.end += details.delta;
                                          var maxLength =
                                            item.movementDistance
                                            * (currentMovementRequestMessage?.distanceMultiplier ?? 1.0)
                                            * widget.map.background.pixelsPerMeter;

                                          if(currentMovement!.length > maxLength) {
                                            currentMovement!.last!.end = prevEnd;
                                            return;
                                          }

                                          setState(() {
                                            // no-op, but required to trigger
                                            // a redraw of the path
                                          });
                                        }

                                        moveItemTo(
                                          item,
                                          item.x + details.delta.dx,
                                          item.y + details.delta.dy
                                        );
                                      }
                                    },
                                    onPanEnd: !canMove ? null : (DragEndDetails? details) {
                                      if(widget.map.freeMovementEnabled && currentMovingItem != null) {
                                        widget.map.distances.updateFrom(currentMovingItem!);
                                        currentMovingItem = null;
                                      }
                                    },
                                    child: child,
                                  ),
                                );
                              }
                            ),
                        ],
                      );
                    }
                  );
                }
              ),
            );
          }
        ),
        if(currentMovement != null)
          Positioned(
            bottom: 10.0,
            left: 10.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  spacing: 8.0,
                  children: [
                    Text(
                      'Déplacement : ${(currentMovement!.length / widget.map.background.pixelsPerMeter).toStringAsFixed(2)} m',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if(currentMovementRequestMessage != null) {
                            SessionMessageBusClient.instance?.sendResponse(
                              currentMovementRequestMessage!,
                              SessionMovementPathResult(
                                mapId: widget.map.background.uuid,
                                path: MovementPath.from(currentMovement!),
                              )
                            );

                            moveItemTo(
                              currentMovingItem!,
                              currentMovement!.segments.first.start.dx,
                              currentMovement!.segments.first.start.dy,
                            );

                            currentMovementRequestMessage = null;
                          }
                          else {
                            widget.map.distances.updateFrom(currentMovingItem!);
                          }

                          currentMovement = null;
                          currentMovingItem = null;
                        });
                      },
                      constraints: const BoxConstraints(),
                      iconSize: 18.0,
                      padding: const EdgeInsets.all(4.0),
                      icon: Icon(Icons.check),
                      color: Colors.green,
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if(currentMovementRequestMessage != null) {
                            SessionMessageBusClient.instance?.sendResponse(
                              currentMovementRequestMessage!,
                              null,
                              status: SessionMessageResponseStatus.cancelled,
                            );

                            currentMovementRequestMessage = null;
                          }

                          if(currentMovingItem != null && currentMovement != null) {
                            moveItemTo(
                              currentMovingItem!,
                              currentMovement!.first!.start.dx,
                              currentMovement!.first!.start.dy
                            );
                          }
                          currentMovement = null;
                          currentMovingItem = null;
                        });
                      },
                      constraints: const BoxConstraints(),
                      iconSize: 18.0,
                      padding: const EdgeInsets.all(4.0),
                      icon: Icon(Icons.close),
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            )
          )
      ],
    );
  }

  void moveItemTo(SessionMapItem item, double x, double y) {
    item.x = x;
    item.y = y;

    if(item is SessionMapEntityItem) {
      // TODO: limit the number of message per second
      SessionMessageBusClient.instance?.publish(
          SessionEntityPositionStatusMessage(
            mapId: widget.map.background.uuid,
            entityId: item.id,
            x: x,
            y: y,
          )
      );
    }
  }

  void onMapMessage(SessionMessage m) {
    if(m is SessionMapGetMovementPath) {
      getMovementPath(m);
    }
    else if(m is SessionMapCancelGetMovementPath) {
      cancelGetMovementPath(m);
    }
    else if(m is SessionEntityPositionStatusMessage) {
      var i = widget.map.items[m.entityId];
      if(i == null) return;
      i.x = m.x;
      i.y = m.y;
    }
  }

  void getMovementPath(SessionMapGetMovementPath m) {
    if(widget.map.freeMovementEnabled) {
      SessionMessageBusClient.instance?.sendResponse(
        m,
        null,
        status: SessionMessageResponseStatus.rejected,
        statusMessage: "Pas de limites de mouvement en cours, planification impossible",
      );
      return;
    }

    if(currentMovingItem != null && currentMovingItem != widget.map.items[m.entityId]) {
      SessionMessageBusClient.instance?.sendResponse(
        m,
        null,
        status: SessionMessageResponseStatus.rejected,
        statusMessage: "Un autre déplacement est déjà en cours (${(currentMovingItem as SessionMapEntityItem).entity.name})",
      );
      return;
    }

    if(widget.map.items[m.entityId] == null) {
      SessionMessageBusClient.instance?.sendResponse(
        m,
        null,
        status: SessionMessageResponseStatus.rejected,
        statusMessage: "Impossible de trouver ce personnage sur la carte",
      );
      return;
    }

    setState(() {
      currentMovingItem = widget.map.items[m.entityId];
      currentMovement = null;
      currentMovementRequestMessage = m;
    });
    // TODO: scroll to the selected active item and highlight it
  }

  void cancelGetMovementPath(SessionMapCancelGetMovementPath m) {
    if(currentMovingItem == null) {
      return;
    }
    if(currentMovementRequestMessage == null) {
      currentMovingItem = null;
      return;
    }
    if(currentMovement == null) {
      currentMovingItem = null;
      currentMovementRequestMessage = null;
      return;
    }
    if(m.source != currentMovementRequestMessage!.source) return;
    if(m.entityId != currentMovementRequestMessage!.entityId) return;

    moveItemTo(
      currentMovingItem!,
      currentMovement!.first!.start.dx,
      currentMovement!.first!.start.dy
    );
    setState(() {
      currentMovingItem = null;
      currentMovement = null;
      currentMovementRequestMessage = null;
    });
  }
}

class _MovementPathPainter extends CustomPainter {
  _MovementPathPainter({ required this.path });

  final MovementPath path;

  @override
  void paint(Canvas canvas, Size size) {
    var painter = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    for(var segment in path.segments) {
      canvas.drawLine(segment.start, segment.end, painter);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}