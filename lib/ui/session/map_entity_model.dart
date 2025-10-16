import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../classes/combat.dart';
import '../../classes/entity/status.dart';
import '../../classes/entity_base.dart';
import '../../classes/equipment.dart';
import '../../classes/weapon.dart';
import 'command_dispatcher.dart';
import 'map_model.dart';

class MapEntityModel extends MapModelMovableItem {
  MapEntityModel({
    required this.entity,
    required super.map,
    super.x,
    super.y,
  });

  EntityBase entity;

  @override
  String get id => entity.id;

  @override
  double get size => entity.size * map.background.pixelsPerMeter;

  @override
  double get movementLimit {
    var ret = 0.0;

    if(entity.status.value & EntityStatusValue.moving != EntityStatusValue.none) {
      ret = entity.attributes.physique.toDouble();
    }
    else if(entity.status.value & EntityStatusValue.running != EntityStatusValue.none) {
      ret = entity.attributes.physique * 2.0;
    }
    // TODO: manage the sprinting case, this requires a dice throw
    else if(entity.status.value & EntityStatusValue.attacking != EntityStatusValue.none) {
      ret = entity.attackMovementDistance;
    }

    return ret * map.background.pixelsPerMeter;
  }

  double get attackMovementDistance => entity.attackMovementDistance * map.background.pixelsPerMeter;

  @override
  void setActive(bool active) {
    showCombatRange = active;
  }

  EntityStatusValue get status => entity.status.value;
  set status(EntityStatusValue st) {
    entity.status.value = st;
    notifyListeners();
  }

  bool get showCombatRange => _showCombatRange;
  set showCombatRange(bool b) {
    _showCombatRange = b;
    notifyListeners();
  }
  bool _showCombatRange = false;

  double get contactCombatRange => entity.contactCombatRange * map.background.pixelsPerMeter;

  double get combatRange => max(
      combatRangeFor(EquipableItemTarget.dominantHand),
      combatRangeFor(EquipableItemTarget.weakHand),
    );

  double combatRangeFor(EquipableItemTarget eqTarget) {
    var ret = 0.0;

    for(var dp in entity.damageProviderForHand(eqTarget)) {
      if(dp is Weapon && dp.model.range != WeaponRange.contact) {
        var dist = dp.model.rangeMax.calculate(entity.abilities.force);
        if(dist > ret) ret = dist;
      }
    }

    return ret * map.background.pixelsPerMeter;
  }

  WeaponRange get combatWeaponRange {
    var dHand = combatWeaponRangeFor(EquipableItemTarget.dominantHand);
    var wHand = combatWeaponRangeFor(EquipableItemTarget.weakHand);
    return dHand.index > wHand.index ? dHand : wHand;
  }

  WeaponRange combatWeaponRangeFor(EquipableItemTarget eqTarget) {
    var ret = WeaponRange.contact;
    for(var dp in entity.damageProviderForHand(eqTarget)) {
      if(dp is Weapon && dp.model.range.index > ret.index) {
        ret = dp.model.range;
      }
    }
    return ret;
  }
}

class MapEntityWidget extends StatefulWidget {
  const MapEntityWidget({ super.key });

  @override
  State<MapEntityWidget> createState() => _MapEntityWidgetState();
}

class _MapEntityWidgetState extends State<MapEntityWidget> {
  bool showTargetSelector = false;

  final ContextMenuController _contextMenuController = ContextMenuController();

  void _displayContextMenu(Offset position, MapModelItem model, CommandDispatcher dispatcher) {
    _contextMenuController.show(
      context: context,
      contextMenuBuilder: (BuildContext context) {
        return AdaptiveTextSelectionToolbar.buttonItems(
          anchors: TextSelectionToolbarAnchors(
            primaryAnchor: position,
          ),
          buttonItems: [
            ContextMenuButtonItem(
              onPressed: () {
                _hideContextMenu();
                dispatcher.dispatchCommand(SessionCommand.mapRemoveItem, <String, dynamic>{'item': model});
              },
              label: 'Supprimer',
            )
          ],
        );
      }
    );
  }

  void _hideContextMenu() {
    _contextMenuController.remove();
  }

  @override
  Widget build(BuildContext context) {
    var dispatcher = context.watch<CommandDispatcher>();
    var model = context.watch<MapModelItem>() as MapEntityModel;
    var theme = Theme.of(context);

    var textPainter = TextPainter()
      ..text = TextSpan(
        text: model.entity.name,
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 6
            ..color = Colors.black87
        ),
      )
      ..textDirection = TextDirection.ltr
      ..layout(minWidth: 0, maxWidth: double.infinity);
    var textLabelWidth = textPainter.size.width;

    var movable = true;
    Color borderColor = Colors.green;
    if(model.entity.status.value & EntityStatusValue.dead != EntityStatusValue.none) {
      movable = false;
      borderColor = Colors.black;
    }
    else if(model.entity.status.value & EntityStatusValue.unconscious != EntityStatusValue.none) {
      movable = false;
      borderColor = Colors.black45;
    }

    return Positioned(
      left: model.x - model.size / 2,
      top: model.y - model.size / 2,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if(model.showCombatRange)
            Positioned(
              left: -model.combatRange,
              top: -model.combatRange,
              child: Opacity(
                  opacity: 0.3,
                  child: Container(
                    width: model.combatRange * 2 + model.size,
                    height: model.combatRange * 2 + model.size,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange),
                        borderRadius: BorderRadius.circular(model.combatRange + model.size / 2),
                        gradient: const RadialGradient(
                          colors: [
                            Colors.transparent,
                            Colors.yellow,
                          ],
                        )
                    ),
                  )
              ),
            ),
          if(model.showCombatRange)
            Positioned(
              left: -model.contactCombatRange,
              top: -model.contactCombatRange,
              child: Opacity(
                  opacity: 0.3,
                  child: Container(
                    width: model.contactCombatRange * 2 + model.size,
                    height: model.contactCombatRange * 2 + model.size,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(model.contactCombatRange + model.size / 2),
                        gradient: const RadialGradient(
                            colors: [
                              Colors.transparent,
                              Colors.deepOrange,
                            ]
                        )
                    ),
                  )
              ),
            ),
          if(showTargetSelector)
            Positioned(
              top: -(model.size / 2),
              left: -(model.size / 2),
              child: Container(
                width: model.size * 2,
                height: model.size * 2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(model.size),
                    gradient: const RadialGradient(
                        colors: [
                          Colors.red,
                          Colors.black54,
                          Colors.transparent,
                        ],
                        stops: [
                          0.5,
                          0.7,
                          0.9,
                        ]
                    )
                ),
              )
            ),
          MouseRegion(
            onEnter: (PointerEnterEvent event) {
              if(model.isSelectable) {
                setState(() {
                  showTargetSelector = true;
                });
              }
            },
            onExit: (PointerExitEvent event) {
              if(model.isSelectable) {
                setState(() {
                  showTargetSelector = false;
                });
              }
            },
            child: GestureDetector(
              onPanStart: !movable ? null :  (DragStartDetails? details) {
                model.moveStart();
              },
              onPanUpdate: !movable ? null : (DragUpdateDetails? details) {
                if(details == null) return;
                model.moveUpdate(details.delta);
              },
              onPanEnd: !movable ? null : (DragEndDetails? details) {
                dispatcher.dispatchCommand(
                  SessionCommand.mapItemMoveEnd,
                  <String, dynamic>{
                    'entity': model,
                  },
                );
                model.moveEnd();
              },
              onTap: () {
                if(_contextMenuController.isShown) {
                  _hideContextMenu();
                }

                dispatcher.dispatchCommand(
                  SessionCommand.mapItemSelected,
                  <String, dynamic>{
                    'entity': model,
                  },
                );
              },
              onSecondaryTapUp: (TapUpDetails details) {
                _displayContextMenu(
                  details.globalPosition,
                  model,
                  dispatcher
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor, width: 4.0),
                  borderRadius: BorderRadius.circular(model.size / 2),
                  color: Colors.white,
                ),
                width: model.size,
                height: model.size,
              ),
            ),
          ),
          Positioned(
            top: model.size + 4.0,
            left: -((textLabelWidth - model.size) / 2),
            child: Text(
              model.entity.name,
              style: theme.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 6
                  ..color = Colors.black87
              ),
            ),
          ),
          Positioned(
            top: model.size + 4.0,
            left: -((textLabelWidth - model.size) / 2),
            child: Text(
              model.entity.name,
              style: theme.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      )
    );
  }
}