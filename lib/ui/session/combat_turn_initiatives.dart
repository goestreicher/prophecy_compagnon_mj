import 'package:flutter/material.dart';

import '../../classes/combat.dart';
import '../../classes/combat_turn.dart';
import '../../classes/encounter.dart';
import '../../classes/entity_base.dart';
import '../../classes/player_character.dart';
import '../utils/dice_roll_input.dart';

class CombatTurnInitiativesInputWidget extends StatefulWidget {
  const CombatTurnInitiativesInputWidget({
    super.key,
    required this.encounter,
    this.previousTurn,
  });

  final Encounter encounter;
  final CombatTurn? previousTurn;

  @override
  State<CombatTurnInitiativesInputWidget> createState() => _CombatTurnInitiativesInputWidgetState();
}

class _CombatTurnInitiativesInputWidgetState extends State<CombatTurnInitiativesInputWidget> {
  Map<String, (List<int>, int?)> initiativesDone = <String, (List<int>, int?)>{};

  @override
  void initState() {
    super.initState();
    for(var e in widget.encounter.deployedNpcs) {
      var extraInitiatives = widget.previousTurn != null
          ? widget.previousTurn!.unspentActionsForEntity(e).length
          : 0;

      initiativesDone[e.uuid] = e.rollInitiatives(
        additionalDices: extraInitiatives,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var pcWidgets = widget.encounter.characters
        .where((PlayerCharacter pc) => pc.canAct())
        .map((PlayerCharacter pc) => _CharacterInitiativeInputWidget(
          character: pc,
          engagementRange: widget.encounter.smallestEngagementRangeFor(pc),
          previousTurn: widget.previousTurn,
          onInitiativeInputDone: (List<int> dominantHandInitiatives, int? weakHandInitiative) {
            setState(() {
              initiativesDone[pc.uuid] = (dominantHandInitiatives, weakHandInitiative);
            });
          },
        ))
        .toList();

    var npcWidgets = widget.encounter.deployedNpcs
        .where((EntityBase npc) => npc.canAct())
        .map((EntityBase e) => _CharacterInitiativeInputWidget(
          initialValues: initiativesDone[e.uuid]!,
          character: e,
          engagementRange: widget.encounter.smallestEngagementRangeFor(e),
          previousTurn: widget.previousTurn,
          onInitiativeInputDone: (List<int> dominantHandInitiatives, int? weakHandInitiative) {
            setState(() {
              initiativesDone[e.uuid] = (dominantHandInitiatives, weakHandInitiative);
            });
          },
        ))
        .toList();

    return Dialog(
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 280.0,
                  maxHeight: constraints.maxHeight,
                ),
                child: IntrinsicWidth(
                  stepWidth: 24.0,
                  child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Initiatives',
                            style: theme.textTheme.headlineMedium,
                          ),
                          for(var w in pcWidgets)
                            w,
                          for(var w in npcWidgets)
                            w,
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: initiativesDone.length < (widget.encounter.characters.length + widget.encounter.deployedNpcs.length)
                                    ? null
                                    : () {
                                  var nextTurn = CombatTurn(encounter: widget.encounter);

                                  for(var pc in widget.encounter.characters) {
                                    var damageMalus = pc.damageMalus();
                                    List<int> initiativesFinal = initiativesDone[pc.uuid]!.$1
                                        .map((int i) => i - damageMalus)
                                        .toList()
                                      ..removeWhere((int i) => i < 1);

                                    nextTurn.setEntityInitiatives(
                                        entity: pc,
                                        dominantHandInitiatives: initiativesFinal,
                                        weakHandInitiative: initiativesDone[pc.uuid]!.$2);
                                  }

                                  for(var e in widget.encounter.deployedNpcs) {
                                    var damageMalus = e.damageMalus();
                                    List<int> initiativesFinal = initiativesDone[e.uuid]!.$1
                                        .map((int i) => i - damageMalus)
                                        .toList()
                                      ..removeWhere((int i) => i < 1);

                                    nextTurn.setEntityInitiatives(
                                        entity: e,
                                        dominantHandInitiatives: initiativesFinal,
                                        weakHandInitiative: initiativesDone[e.uuid]!.$2);
                                  }

                                  Navigator.of(context).pop(nextTurn);
                                },
                                icon: const Icon(Icons.check),
                                label: const Text('Prêts'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.primary,
                                  foregroundColor: theme.colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                  ),
                ),
              )
          );
        }
      ),
    );
  }
}

class _CharacterInitiativeInputWidget extends StatefulWidget {
  const _CharacterInitiativeInputWidget({
    required this.character,
    required this.engagementRange,
    this.previousTurn,
    required this.onInitiativeInputDone,
    this.initialValues,
  });

  final EntityBase character;
  final WeaponRange engagementRange;
  final CombatTurn? previousTurn;
  final void Function(List<int>, int?) onInitiativeInputDone;
  final (List<int>, int?)? initialValues;

  @override
  State<_CharacterInitiativeInputWidget> createState() => _CharacterInitiativeInputWidgetState();
}

class _CharacterInitiativeInputWidgetState extends State<_CharacterInitiativeInputWidget> {
  late List<int?> dominantHandInitiatives;
  bool requireWeakHandInitiative = false;
  int? weakHandInitiative;
  int selectedInitiativeModifierRank = -1;

  @override void initState() {
    super.initState();
    dominantHandInitiatives = List<int?>.generate(widget.character.initiative, (index) => null);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    int dominantHandInitiativeModifier = 0;
    if(widget.character.dominantHandEquiped != null
        && widget.character.dominantHandEquiped is InitiativeProvider) {
      dominantHandInitiativeModifier =
          (widget.character.dominantHandEquiped as InitiativeProvider).initiativeForRange(widget.engagementRange);
    }

    bool useInitialValues = widget.initialValues != null && widget.initialValues!.$1.length == widget.character.initiative;

    List<Widget> initiativesWidget = <Widget>[];
    for(var i = 0; i < widget.character.initiative; ++i) {
      initiativesWidget.add(_SingleInitiativeInputWidget(
        initialValue: useInitialValues ? widget.initialValues!.$1[i] : null,
        initiativeModifier: dominantHandInitiativeModifier,
        onInitiativeSelected: (int v) {
          if(i == selectedInitiativeModifierRank) {
            v += dominantHandInitiativeModifier;
          }

          setState(() {
            dominantHandInitiatives[i] = v;
          });

          if(selectedInitiativeModifierRank != -1
              && !dominantHandInitiatives.contains(null)
              && (!requireWeakHandInitiative || weakHandInitiative != null)
          ) {
            widget.onInitiativeInputDone(dominantHandInitiatives.cast<int>(), weakHandInitiative);
          }
        },
        onInitiativeModifierSet: () {
          if(selectedInitiativeModifierRank != -1) {
            dominantHandInitiatives[selectedInitiativeModifierRank] =
                dominantHandInitiatives[selectedInitiativeModifierRank]! - dominantHandInitiativeModifier;
          }
          dominantHandInitiatives[i] = dominantHandInitiatives[i]! + dominantHandInitiativeModifier;

          setState(() {
            selectedInitiativeModifierRank = i;
          });

          if(selectedInitiativeModifierRank != -1
              && !dominantHandInitiatives.contains(null)
              && (!requireWeakHandInitiative || weakHandInitiative != null)
          ) {
            widget.onInitiativeInputDone(dominantHandInitiatives.cast<int>(), weakHandInitiative);
          }
        },
        selectedForModifier: selectedInitiativeModifierRank == i,
      ));
    }

    // If the initiative modifier is set to zero, we set the modifier rank to the first
    // initiative, otherwise we have to ask the user to set the modifier on a rank.
    if(dominantHandInitiativeModifier == 0) {
      selectedInitiativeModifierRank = 0;
    }

    if(widget.character.weakHandEquiped != null
        && widget.character.weakHandEquiped is InitiativeProvider
        && widget.character.weakHandEquiped != widget.character.dominantHandEquiped) {
      requireWeakHandInitiative = true;
      int weakHandInitiativeModifier =
      (widget.character.weakHandEquiped as InitiativeProvider).initiativeForRange(widget.engagementRange);
      initiativesWidget.add(_SingleInitiativeInputWidget(
        initialValue: useInitialValues ? widget.initialValues!.$2 : null,
        isWeakHand: true,
        initiativeModifier: weakHandInitiativeModifier,
        onInitiativeSelected: (int v) {
          setState(() {
            weakHandInitiative = v + weakHandInitiativeModifier;
          });
        },
        onInitiativeModifierSet: () {
          // NO-OP, as the modifier is always set
        },
        selectedForModifier: true,
      ));
    }

    Widget? damageMalusWidget;
    if(widget.character.damageMalus() > 0) {
      damageMalusWidget = Container(
          width: 30.0,
          height: 30.0,
          decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(15.0)
          ),
          child: Center(
            child: Text(
              '-${widget.character.damageMalus().toString()}',
              style: theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          )
      );
    }

    var diceCount = widget.character.initiative;
    if(widget.previousTurn != null) {
      diceCount += widget.previousTurn!.unspentActionsForEntity(widget.character).length;
    }

    return Card(
      color: theme.colorScheme.surfaceVariant,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Text(
              widget.character.name,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(width: 4.0),
            Text('(${diceCount}D)'),
            if(damageMalusWidget != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: damageMalusWidget,
              ),
            const SizedBox(width: 16.0),
            for(var w in initiativesWidget)
              w,
          ],
        ),
      ),
    );
  }
}

class _SingleInitiativeInputWidget extends StatefulWidget {
  const _SingleInitiativeInputWidget({
    this.initialValue,
    this.initiativeModifier = 0,
    required this.onInitiativeSelected,
    required this.onInitiativeModifierSet,
    this.selectedForModifier = false,
    this.isWeakHand = false,
  });

  final int? initialValue;
  final int initiativeModifier;
  final void Function(int) onInitiativeSelected;
  final void Function() onInitiativeModifierSet;
  final bool selectedForModifier;
  final bool isWeakHand;

  @override
  State<_SingleInitiativeInputWidget> createState() => _SingleInitiativeInputWidgetState();
}

class _SingleInitiativeInputWidgetState extends State<_SingleInitiativeInputWidget> {
  int rawInitiativeValue = -1;
  bool modifierZoneHovered = false;

  @override
  Widget build(BuildContext context) {
    Widget modifierZoneWidget;
    if(rawInitiativeValue > 0 && widget.initiativeModifier != 0 && (modifierZoneHovered || widget.selectedForModifier)) {
      var sign = widget.initiativeModifier > 0 ? '+' : '';
      modifierZoneWidget = Text(
        '$sign${widget.initiativeModifier}',
        style: Theme.of(context).textTheme.bodySmall,
      );
    }
    else {
      modifierZoneWidget = const SizedBox(height: 16.0);
    }

    Widget handIcon;
    if(widget.isWeakHand) {
      handIcon = Transform.flip(flipX: true, child: const Icon(Icons.back_hand_outlined));
    }
    else {
      handIcon = const Icon(
        Icons.back_hand,
        size: 20.0,
      );
    }

    return SizedBox(
      width: 80.0,
      child: Column(
        children: [
          DiceRollInputWidget(
            initialValue: widget.initialValue,
            onValueSelected: (int v) {
              rawInitiativeValue = v;
              widget.onInitiativeSelected(v);
            },
          ),
          const SizedBox(height: 4.0),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: (modifierZoneHovered && rawInitiativeValue > 0 && widget.initiativeModifier != 0)
                  ? Colors.lightGreenAccent
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: InkWell(
              onTap: () {
                if(widget.initiativeModifier == 0) return;
                if(rawInitiativeValue <= 0) return;
                widget.onInitiativeModifierSet();
              },
              onHover: (hovering) {
                setState(() {
                  modifierZoneHovered = hovering;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  handIcon,
                  const SizedBox(height: 8.0),
                  modifierZoneWidget,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}