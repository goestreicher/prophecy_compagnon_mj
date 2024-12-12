import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';

import '../../classes/character/base.dart';
import '../../classes/character/skill.dart';
import '../../classes/combat.dart';
import '../../classes/combat_turn.dart';
import '../../classes/dice.dart';
import '../../classes/entity_base.dart';
import '../../classes/shield.dart';
import '../../classes/weapon.dart';
import 'attack_throw_dialog.dart';
import 'command_dispatcher.dart';
import 'defense_action_select_dialog.dart';
import 'defense_throw_dialog.dart';
import '../utils/custom_icons.dart';
import '../utils/dice_roll_input_dialog.dart';
import '../utils/opposition_throw_dialog.dart';
import '../utils/single_digit_input_dialog.dart';
import '../utils/single_dropdown_input_dialog.dart';
import '../utils/combat_weapon_selection_dialog.dart';

class CombatTurnActionListWidget extends StatefulWidget {
  const CombatTurnActionListWidget({
    super.key,
    // required this.onSetUuidActive,
    // required this.onActionSelected,
    // required this.onActionCommitted,
    required this.onCenterOn,
    // required this.onEntityStatusChanged,
    // required this.onTurnCompleted,
  });

  // final void Function(String, bool) onSetUuidActive;
  // final void Function(
  //     String,
  //     CombatActionType,
  //     CombatActionSubtype,
  //     void Function()
  //   ) onActionSelected;
  // final void Function(String) onActionCommitted;
  final void Function(String) onCenterOn;
  // final void Function(EntityBase) onEntityStatusChanged;
  // final void Function(CombatTurn) onTurnCompleted;

  @override
  State<CombatTurnActionListWidget> createState() => _CombatTurnActionListWidgetState();
}

class _CombatTurnActionListWidgetState extends State<CombatTurnActionListWidget> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var dispatcher = context.read<CommandDispatcher>();
    var turn = context.watch<CombatTurn>();

    var actions = turn.actionsForRank(turn.currentRank);
    var committedCount = actions.where((CombatTurnAction a) => a.used || !a.entity.canAct()).length;

    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            Card(
              color: theme.colorScheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Text(
                  'Rang ${turn.currentRank}',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if(committedCount >= actions.length)
              const SizedBox(width: 4.0),
            if(committedCount >= actions.length)
              FilledButton(
                onPressed: () async {
                  var actionsToResolve = actions
                      .where((CombatTurnAction action) => action.hasRankEndCallback());
                  debugPrint('${actionsToResolve.length} actions to resolve for rank ${turn.currentRank}');

                  Future.forEach(
                    actionsToResolve,
                    (action) async {
                      if(!context.mounted) return;
                      if(action.environment.containsKey(CombatTurnActionEnvironmentKey.onRankResolution)) {
                        await action.environment[CombatTurnActionEnvironmentKey.onRankResolution]!(context, action);
                      }
                      if(action.environment.containsKey(CombatTurnActionEnvironmentKey.onLongRunningActionFinished)) {
                        await action.environment[CombatTurnActionEnvironmentKey.onLongRunningActionFinished]!();
                      }
                    }
                  )
                  .then(
                    (_) async {
                      dispatcher.dispatchCommand(
                        SessionCommand.combatTurnNextRank,
                        <String, dynamic>{},
                      );
                    },
                  );
                },
                child: const Icon(Icons.check_circle_outline),
              ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 12.0),
        if(actions.isNotEmpty)
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  for(var action in actions)
                    CombatTurnSingleActionWidget(
                      action: action,
                      active: action == turn.activeAction,
                      canBecomeActive: () => turn.activeAction == null,
                      onSetActive: (bool active) {
                        if(!active) {
                          if(turn.activeAction != null) {
                            dispatcher.dispatchCommand(
                                SessionCommand.mapSetActive,
                                <String, dynamic>{
                                  'uuid': action.entity.uuid,
                                  'active': false,
                                }
                            );
                          }
                        }
                        else {
                          for (var a in actions) {
                            if (a == turn.activeAction) {
                              dispatcher.dispatchCommand(
                                  SessionCommand.mapSetActive,
                                  <String, dynamic>{
                                    'uuid': action.entity.uuid,
                                    'active': false,
                                  }
                              );
                            }
                          }

                          dispatcher.dispatchCommand(
                              SessionCommand.mapSetActive,
                              <String, dynamic>{
                                'uuid': action.entity.uuid,
                                'active': active,
                              }
                          );
                        }
                      },
                      onActionSelected: (void Function() cb) {
                        action.environment[CombatTurnActionEnvironmentKey.preCommitCallback] = cb;
                        dispatcher.dispatchCommand(
                          SessionCommand.combatActionTypeSelected,
                          <String, dynamic>{
                            'action': action,
                          }
                        );
                      },
                      onActionCancelled: () {
                        dispatcher.dispatchCommand(
                          SessionCommand.combatActionTypeCancelled,
                          <String, dynamic>{
                            'action': action,
                          }
                        );
                      },
                      onActionCommitted: () {
                        dispatcher.dispatchCommand(
                          SessionCommand.combatActionTypeCommitted,
                          <String, dynamic>{
                            'action': action,
                          }
                        );

                        setState(() {
                          ++committedCount;
                        });
                      },
                      onCenterOn: (String uuid) => widget.onCenterOn(uuid),
                      onEntityStatusChanged: (EntityBase e) {
                        dispatcher.dispatchCommand(
                          SessionCommand.mapItemStatusChanged,
                          <String, dynamic>{'uuid': e.uuid},
                        );
                      }
                    ),
                ],
              ),
            )
          ),
      ],
    );
  }
}

class CombatTurnSingleActionWidget extends StatefulWidget {
  const CombatTurnSingleActionWidget({
    super.key,
    required this.action,
    required this.active,
    required this.canBecomeActive,
    required this.onSetActive,
    required this.onActionSelected,
    required this.onActionCancelled,
    required this.onActionCommitted,
    required this.onCenterOn,
    required this.onEntityStatusChanged,
  });

  final CombatTurnAction action;
  final bool active;
  final bool Function() canBecomeActive;
  final void Function(bool) onSetActive;
  final void Function(void Function()) onActionSelected;
  final void Function() onActionCancelled;
  final void Function() onActionCommitted;
  final void Function(String) onCenterOn;
  final void Function(EntityBase) onEntityStatusChanged;

  @override
  State<CombatTurnSingleActionWidget> createState() => _CombatTurnSingleActionWidgetState();
}

class _CombatTurnSingleActionWidgetState extends State<CombatTurnSingleActionWidget> {
  late bool active;
  bool committable = false;

  @override
  void initState() {
    super.initState();
    active = widget.active;
    committable = widget.action.used;
  }

  @override
  Widget build(BuildContext context) {
    var buttonRow = <Widget>[];
    if(widget.action.used) {
      buttonRow.addAll([
        _getSelectedActionIcon(widget.action.type, widget.action.subtype.specification),
        const SizedBox(width: 4.0),
        const Text('Action validée'),
      ]);
    }
    else if(widget.action.entity.status & EntityStatus.unconscious != EntityStatus.none) {
      buttonRow.add(const Text('Inconscient(e)'));
    }
    else if(!active) {
      buttonRow.add(const Text('Cliquer pour activer'));
    }
    else if(widget.action.type == CombatActionType.none) {
      buttonRow.addAll(_createSelectionButtonRow());
    }
    else {
      buttonRow.addAll(_createCommitButtonRow());
    }

    return InkWell(
      onTap: () {
        if(!widget.action.used && widget.canBecomeActive()) {
          widget.onCenterOn(widget.action.entity.uuid);
          widget.onSetActive(true);
          setState(() {
            active = true;
          });
        }
      },
      child: AbsorbPointer(
        absorbing: !active,
        child: Opacity(
          opacity: (widget.action.used || !widget.action.entity.canAct()) ? 0.8 : 1.0,
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.action.entity.name),
                  const SizedBox(height: 4.0),
                  Row(
                    children: buttonRow,
                  ),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }

  List<Widget> _createSelectionButtonRow() {
    var ret = <Widget>[];

    ret.addAll([
      IconButton(
        icon: const Icon(Icons.timer),
        iconSize: 18.0,
        onPressed: () {
          setState(() {
            widget.action.type = CombatActionType.delay;
            widget.action.environment[CombatTurnActionEnvironmentKey.onRankResolution] =
              (BuildContext runContext, CombatTurnAction action) {
                action.turn.delayAction(action);
              };
          });
          widget.onActionSelected(
            () {
              committable = true;
            }
          );
        }
      ),
      const SizedBox(width: 4.0),
      _MovementButton(
        selectedType: widget.action.type,
        selectedSubtype: widget.action.subtype,
        onMovementSelected: (CombatActionSubtype st) {
          setState(() {
            widget.action.type = CombatActionType.move;
            widget.action.subtype = st;
          });
          widget.onActionSelected(
            () {
              setState(() {
                committable = true;
              });
            }
          );
        }
      ),
    ]);

    var weapons = <Weapon>[];
    for(var dp in widget.action.entity.damageProviderForHand(widget.action.hand)) {
      if(dp is Weapon) weapons.add(dp);
    }

    if(weapons.isNotEmpty) {
      var rangedWeapons = weapons
          .where((Weapon w) => w.model.initiative.containsKey(WeaponRange.ranged))
          .toList();

      var hasTargets = widget.action.turn.encounter.targetsInMovementRangeFor(widget.action.entity, WeaponRange.ranged).isNotEmpty ||
          widget.action.turn.encounter.targetsInWeaponRangeFor(widget.action.entity, WeaponRange.ranged).isNotEmpty;
      if(rangedWeapons.isNotEmpty && hasTargets) {
        ret.addAll([
          const SizedBox(width: 4.0),
          _RangedAttackButton(
            weapons: rangedWeapons,
            selectedType: widget.action.type,
            selectedSubtype: widget.action.subtype,
            onAttackSelected: (CombatActionSubtype st, Weapon w) {
              widget.action.environment[CombatTurnActionEnvironmentKey.attacker] = widget.action.entity;
              widget.action.environment[CombatTurnActionEnvironmentKey.weapon] = w;

              setState(() {
                widget.action.type = CombatActionType.attack;
                widget.action.subtype = st;
              });

              widget.onActionSelected(
                () {
                  widget.action.environment[CombatTurnActionEnvironmentKey.onRankResolution] =
                      _resolveAttack;

                  setState(() {
                    committable = true;
                  });
                }
              );
            },
          ),
        ]);
      }

      var meleeWeapons = weapons
          .where((Weapon w) => w.model.initiative.containsKey(WeaponRange.melee))
          .toList();

      hasTargets = widget.action.turn.encounter.targetsInMovementRangeFor(widget.action.entity, WeaponRange.melee).isNotEmpty ||
          widget.action.turn.encounter.targetsInWeaponRangeFor(widget.action.entity, WeaponRange.melee).isNotEmpty;
      if(meleeWeapons.isNotEmpty && hasTargets) {
        ret.addAll([
          const SizedBox(width: 8.0),
          _MeleeAttackButton(
            weapons: meleeWeapons,
            selectedType: widget.action.type,
            selectedSubtype: widget.action.subtype,
            onAttackSelected: (CombatActionSubtype st, Weapon w) {
              widget.action.environment[CombatTurnActionEnvironmentKey.attacker] = widget.action.entity;
              widget.action.environment[CombatTurnActionEnvironmentKey.weapon] = w;

              setState(() {
                widget.action.type = CombatActionType.attack;
                widget.action.subtype = st;
              });

              widget.onActionSelected(
                () {
                  widget.action.environment[CombatTurnActionEnvironmentKey.onRankResolution] =
                      _resolveAttack;

                  setState(() {
                    committable = true;
                  });
                }
              );
            },
          ),
        ]);
      }

      var contactWeapons = weapons
          .where((Weapon w) => w.model.initiative.containsKey(WeaponRange.contact))
          .toList();

      hasTargets = widget.action.turn.encounter.targetsInMovementRangeFor(widget.action.entity, WeaponRange.contact).isNotEmpty ||
          widget.action.turn.encounter.targetsInWeaponRangeFor(widget.action.entity, WeaponRange.contact).isNotEmpty;
      if(contactWeapons.isNotEmpty && hasTargets) {
        ret.addAll([
          const SizedBox(width: 8.0),
          _ContactAttackButton(
            weapons: contactWeapons,
            selectedType: widget.action.type,
            selectedSubtype: widget.action.subtype,
            onAttackSelected: (CombatActionSubtype st, Weapon w) {
              widget.action.environment[CombatTurnActionEnvironmentKey.attacker] = widget.action.entity;
              widget.action.environment[CombatTurnActionEnvironmentKey.weapon] = w;

              setState(() {
                widget.action.type = CombatActionType.attack;
                widget.action.subtype = st;
              });

              widget.onActionSelected(
                () {
                  widget.action.environment[CombatTurnActionEnvironmentKey.onRankResolution] =
                      _resolveAttack;

                  setState(() {
                    committable = true;
                  });
                }
              );
            },
          ),
        ]);
      }
    }

    return ret;
  }

  Widget _getSelectedActionIcon(CombatActionType type, CombatActionSpecification specification) {
    Widget ret;
    var theme = Theme.of(context);

    if(type == CombatActionType.delay) {
      ret = Ink(
        decoration: ShapeDecoration(
          color: theme.colorScheme.primary,
          shape: const CircleBorder(),
        ),
        width: 36.0,
        height: 36.0,
        child: Icon(
          Icons.timer,
          size: 18.0,
          color: theme.colorScheme.onPrimary,
        ),
      );
    }
    else if(type == CombatActionType.move) {
      ret = Ink(
        decoration: ShapeDecoration(
          color: theme.colorScheme.primary,
          shape: const CircleBorder(),
        ),
        width: 36.0,
        height: 36.0,
        child: Icon(
          Icons.directions_run,
          size: 18.0,
          color: theme.colorScheme.onPrimary,
        ),
      );
    }
    else if(type == CombatActionType.attack) {
      if(widget.action.subtype.range == WeaponRange.ranged) {
        ret = Ink(
          decoration: ShapeDecoration(
            color: theme.colorScheme.primary,
            shape: const CircleBorder(),
          ),
          width: 36.0,
          height: 36.0,
          child: Icon(
            CustomIcons.archery,
            size: 18.0,
            color: theme.colorScheme.onPrimary,
          ),
        );
      }
      else if(widget.action.subtype.range == WeaponRange.melee) {
        ret = Ink(
          decoration: ShapeDecoration(
            color: theme.colorScheme.primary,
            shape: const CircleBorder(),
          ),
          width: 36.0,
          height: 36.0,
          child: Icon(
            Symbols.swords,
            size: 18.0,
            color: theme.colorScheme.onPrimary,
          ),
        );
      }
      else {
        ret = Ink(
          decoration: ShapeDecoration(
            color: theme.colorScheme.primary,
            shape: const CircleBorder(),
          ),
          width: 36.0,
          height: 36.0,
          child: Icon(
            Symbols.sports_kabaddi,
            size: 18.0,
            color: theme.colorScheme.onPrimary,
          ),
        );
      }
    }
    else {
      ret = Ink(
        decoration: ShapeDecoration(
          color: theme.colorScheme.primary,
          shape: const CircleBorder(),
        ),
        width: 36.0,
        height: 36.0,
        child: Icon(
          Icons.check,
          size: 18.0,
          color: theme.colorScheme.onPrimary,
        ),
      );
    }

    return ret;
  }

  List<Widget> _createCommitButtonRow() {
    var theme = Theme.of(context);
    var ret = <Widget>[
      _getSelectedActionIcon(widget.action.type, widget.action.subtype.specification),
      const SizedBox(width: 4.0),
      Text(
        widget.action.subtype == CombatActionSubtype.none
            ? widget.action.type.title
            : widget.action.subtype.description,
        style: theme.textTheme.bodySmall,
      ),
      const Spacer(),
      IconButton(
        icon: const Icon(Icons.cancel_outlined),
        onPressed: () {
          setState(() {
            committable = false;
          });

          widget.onActionCancelled();
        },
      ),
      const SizedBox(width: 4.0),
      IconButton(
        icon: const Icon(Icons.check_circle_outline),
        onPressed: !committable
            ? null
            : () {
          setState(() {
            widget.action.used = true;
            committable = false;
            active = false;
          });

          widget.action.subtype.prepareEnvironment(widget.action, widget.action.type);
          widget.onSetActive(false);
          widget.onActionCommitted();
        },
      ),
    ];

    return ret;
  }

  Future<void> _resolveAttack(BuildContext context, CombatTurnAction action) async {
    var weapon = action.environment[CombatTurnActionEnvironmentKey.weapon] as Weapon;
    var target = action.environment[CombatTurnActionEnvironmentKey.defender] as EntityBase;

    if(action.subtype.specification == CombatActionSpecification.feint) {
      var attackerThrowDifficulty = 15 +
          widget.action.entity.actionMalus() +
          widget.action.turn.attackMalus(widget.action.entity);
      var defenderThrowDifficulty = 15 +
          target.actionMalus() +
          widget.action.turn.defenseMalus(target);

      var result = await showDialog<OppositionThrowResult>(
        context: context,
        builder: (BuildContext context) => OppositionThrowDialog(
          title: 'Résolution de la feinte',
          attacker: widget.action.entity,
          attackerThrowDescription: 'Manuel + Arme',
          attackerThrowDifficulty: attackerThrowDifficulty,
          defender: target,
          defenderThrowDescription: 'Mental + Arme',
          defenderThrowDifficulty: defenderThrowDifficulty,
        )
      );

      if(result != null && result.attackerNr > result.defenderNr) {
        // The target must discard one of its remaining actions
        action.turn.addDefense(target);
        var availableRanks = <String>[];
        for (var action in action.turn.actionsForEntity(target)) {
          if (!action.used) {
            availableRanks.add(action.rank.toString());
          }
        }

        if(!context.mounted) return;
        if(availableRanks.isNotEmpty) {
          var selectedActionStr = await showDialog<String>(
            context: context,
            builder: (BuildContext context) =>
                SingleDropdownInputDialog(
                  title: 'Feinte - Action de défense à utiliser',
                  label: 'Action',
                  entries: availableRanks,
                ),
          );

          selectedActionStr ??= availableRanks.last;
          var selectedActionRank = int.parse(selectedActionStr);
          for(var action in action.turn
              .actionsForRank(selectedActionRank)
              .where((CombatTurnAction a) => a.entity.uuid == target.uuid)
          ) {
            if(!action.used) {
              action.used = true;
              action.type = CombatActionType.defense;
              break;
            }
          }
        }
      }
    }

    var attackDifficulty = (action.environment[CombatTurnActionEnvironmentKey.attackDifficulty] ?? 15) as int;
    attackDifficulty += action.turn.attackMalus(widget.action.entity);
    attackDifficulty += widget.action.entity.actionMalus();

    var attackFailed = false;
    var attackNr = 0;
    var defenseFailed = false;
    var defenseNr = 0;

    if(action.subtype.specification == CombatActionSpecification.attackPrecise) {
      if(!context.mounted) return;
      var additionalDifficulty = await showDialog<int>(
        context: context,
        builder: (BuildContext context) => SingleDigitInputDialog(
          title: 'Difficulté additionnelle',
          label: 'Diff.',
        )
      );

      if(additionalDifficulty != null) {
        attackDifficulty += additionalDifficulty;
        action.environment[CombatTurnActionEnvironmentKey.attackPreciseAdditionalDifficulty] = additionalDifficulty;
      }
    }

    if(!context.mounted) return;
    var attackResult = await showDialog<DiceThrowResult>(
      context: context,
      builder: (BuildContext context) => AttackThrowDialog(
          attacker: action.entity,
          defender: target,
          attribute: Attribute.physique,
          skill: weapon.model.skill.parent,
          specialization: weapon.model.skill.title,
          difficulty: attackDifficulty,
      ),
    );
    if(attackResult == null) return;

    switch(attackResult.type) {
      case DiceThrowResultType.pass:
        attackNr = attackResult.nrCount;
        break;
      case DiceThrowResultType.criticalPass:
        attackNr = attackResult.nrCount + 1;
        break;
      case DiceThrowResultType.fail:
      case DiceThrowResultType.criticalFail:
        attackFailed = true;
        break;
    }

    action.turn.addAttack(action.entity);
    action.environment[CombatTurnActionEnvironmentKey.attackFailure] = attackFailed;
    action.environment[CombatTurnActionEnvironmentKey.attackSuccessCount] = attackNr;

    if(!attackFailed) {
      // Check if the target can defend itself or not
      var availableRanks = <int>[];

      for (var action in action.turn.actionsForEntity(target)) {
        if (!action.used) {
          availableRanks.add(action.rank);
        }
      }

      var targetDominantEquipedItem = target.dominantHandEquiped;
      var targetWeakEquipedItem = target.weakHandEquiped;

      if (availableRanks.isNotEmpty) {
        if(!context.mounted) return;
        var selectedDefenseAction = await showDialog<DefenseAction>(
          context: context,
          builder: (BuildContext context) => DefenseActionSelectDialog(
            entityName: target.name,
            ranks: availableRanks,
            canBlock: (
                (targetDominantEquipedItem != null && targetDominantEquipedItem is Weapon) ||
                (targetWeakEquipedItem != null && targetWeakEquipedItem is Weapon)
            ), // TODO: check the type of weapons used (attack & defense)
            canBlockShield: targetWeakEquipedItem is Shield,
          ),
        );

        if (selectedDefenseAction != null) {
          for(var action in action.turn
              .actionsForRank(selectedDefenseAction.actionRank)
              .where((CombatTurnAction a) => a.entity.uuid == target.uuid)
          ) {
            if(!action.used) {
              action.used = true;
              action.type = CombatActionType.defense;
              break;
            }
          }

          int defenseDifficulty = 15;
          if(selectedDefenseAction.type == DefenseType.dodge && action.environment.containsKey(CombatTurnActionEnvironmentKey.dodgeDifficulty)) {
            defenseDifficulty = action.environment[CombatTurnActionEnvironmentKey.dodgeDifficulty] as int;
          }
          else if(action.environment.containsKey(CombatTurnActionEnvironmentKey.blockDifficulty)) {
            defenseDifficulty = action.environment[CombatTurnActionEnvironmentKey.blockDifficulty];
          }

          if(action.environment.containsKey(CombatTurnActionEnvironmentKey.attackPreciseAdditionalDifficulty)) {
            defenseDifficulty += action.environment[CombatTurnActionEnvironmentKey.attackPreciseAdditionalDifficulty] as int;
          }

          defenseDifficulty += action.turn.defenseMalus(target);
          defenseDifficulty += target.actionMalus();
          action.turn.addDefense(target);

          Skill? defenseThrowSkill;
          SpecializedSkill? defenseThrowSpecialization;
          if (selectedDefenseAction.type == DefenseType.dodge) {
            defenseThrowSkill = Skill.esquive;
          }
          else if(selectedDefenseAction.type == DefenseType.blockShield) {
            // TODO: are shields specialized?
            // TODO: if the shield has been used here, its protection will not be substracted from damages
            defenseThrowSkill = Skill.bouclier;
          }
          else {
            if(targetDominantEquipedItem != null) {
              defenseThrowSpecialization = (targetDominantEquipedItem as Weapon).model.skill;
            }
            else {
              defenseThrowSpecialization = (targetWeakEquipedItem as Weapon).model.skill;
            }
            defenseThrowSkill = defenseThrowSpecialization.parent;
          }

          if(!context.mounted) return;
          var defenseResult = await showDialog<DiceThrowResult>(
            context: context,
            builder: (BuildContext context) => DefenseThrowDialog(
              attacker: action.entity,
              defender: target,
              attribute: Attribute.physique,
              skill: defenseThrowSkill!,
              specialization: defenseThrowSpecialization?.title,
              difficulty: defenseDifficulty,
            ),
          );

          if (defenseResult != null) {
            switch (defenseResult.type) {
              case DiceThrowResultType.criticalFail:
              case DiceThrowResultType.fail:
                defenseFailed = true;
                break;
              case DiceThrowResultType.pass:
              case DiceThrowResultType.criticalPass:
                defenseNr = defenseResult.nrCount;
                break;
            }
          }
          else {
            defenseFailed = true;
          }

          action.environment[CombatTurnActionEnvironmentKey.defenseFailure] = defenseFailed;
          action.environment[CombatTurnActionEnvironmentKey.defenseSuccessCount] = defenseNr;
        }
      }

      if (defenseFailed || attackNr > defenseNr) {
        var nrCount = attackNr - defenseNr;

        if(action.subtype.specification == CombatActionSpecification.stun) {
          if(!context.mounted) return;
          var usedNrs = await showDialog<int>(
            context: context,
            builder: (BuildContext context) => SingleDigitInputDialog(
              title: "Nombre de NR pour le jet de dégâts",
              label: "#NR",
              initialValue: nrCount,
              minValue: 1,
              maxValue: nrCount,
            ),
          );

          if(usedNrs != null) nrCount = usedNrs;
        }

        if(!context.mounted) return;
        var damageThrows = await showDialog<List<int>>(
          context: context,
          builder: (BuildContext context) => DiceRollInputDialog(
            title: "Résolution d'attaque - Jets de dégâts",
            text: "Attaquant : ${action.entity.name} / Défenseur : ${target.name}",
            count: nrCount,
          ),
        );

        var damage = weapon.damage(action.entity, throws: damageThrows);
        if(action.environment.containsKey(CombatTurnActionEnvironmentKey.damageCallback)) {
          action.environment[CombatTurnActionEnvironmentKey.damage] = damage;
          damage = action.environment[CombatTurnActionEnvironmentKey.damageCallback]!(action.environment);
        }

        // Considering that the damage is augmented by the precise attack additional difficulty
        if(action.environment.containsKey(CombatTurnActionEnvironmentKey.attackPreciseAdditionalDifficulty)) {
          damage += action.environment[CombatTurnActionEnvironmentKey.attackPreciseAdditionalDifficulty] as int;
        }

        var prevStatus = target.status;

        if(action.subtype.specification == CombatActionSpecification.stun) {
          if(!context.mounted) return;
          var stunResistResults = await showDialog<List<int>>(
            context: context,
            builder: (BuildContext context) => DiceRollInputDialog(
              title: "Jet de résistance à 'Assommer'",
              text: "Défenseur: ${target.name}, Difficulté: $damage",
              count: 1
            ),
          );

          if(stunResistResults == null) return;
          if(!context.mounted) return;

          var stunResist = stunResistResults.first;
          stunResist += target.attribute(Attribute.physique);
          stunResist += target.ability(Ability.resistance);

          if(stunResist < damage ~/ 2) {
            // Target is unconscious for 2D10 turns and takes full damage
            target.status = target.status | EntityStatus.unconscious;
            var turnCount = Random().nextInt(10) + Random().nextInt(10) + 2;
            var duration = CombatActionDuration(
              entity: target,
              turns: turnCount,
              onFinished: () {
                target.status = target.status & ~EntityStatus.unconscious;
              }
            );
            action.turn.addLongRunningAction(duration);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(
                '${target.name} est inconscient(e) pour $turnCount tour(s)',
              ))
            );
          }
          else if(stunResist < damage) {
            // Target is stunned for 1D10 turns, but takes no damage
            target.status = target.status | EntityStatus.stunned;
            damage = 0;
            var turnCount = Random().nextInt(10) + 1;
            var duration = CombatActionDuration(
                entity: target,
                turns: turnCount,
                onFinished: () {
                  target.status = target.status & ~EntityStatus.stunned;
                }
            );
            action.turn.addLongRunningAction(duration);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(
                '${target.name} est étourdi(e) pour $turnCount tour(s)',
              ))
            );
          }
        }

        int finalDamage = target.takeDamage(damage);

        if(target.status & EntityStatus.dead != EntityStatus.none && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(
              '${target.name} est mort(e)',
            ))
          );
          action.turn.removeEntity(target, startAt: action.rank);
        }
        else if(finalDamage > 0 && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(
              '${target.name} prend $finalDamage dégâts',
            ))
          );
        }

        if(prevStatus != target.status) {
          widget.onEntityStatusChanged(target);
        }
      }
    }
  }
}

class _MovementButton extends StatelessWidget {
  const _MovementButton({
    required this.selectedType,
    required this.selectedSubtype,
    required this.onMovementSelected,
  });

  final CombatActionType selectedType;
  final CombatActionSubtype selectedSubtype;
  final void Function(CombatActionSubtype) onMovementSelected;

  @override
  Widget build(BuildContext context) {
    var validSpecifications = [
      CombatActionSpecification.none,
      CombatActionSpecification.run,
      CombatActionSpecification.sprint,
    ];

    var submenus = <MenuItemButton>[];
    for(var specification in validSpecifications) {
      submenus.add(
          MenuItemButton(
            onPressed: () {
              onMovementSelected(CombatActionSubtype(specification: specification));
            },
            child: Text(
              specification == CombatActionSpecification.none
                ? CombatActionType.move.title
                : specification.title,
            ),
          )
      );
    }

    return MenuAnchor(
      menuChildren: submenus,
      builder: (BuildContext context, MenuController controller, Widget? child) {
        return IconButton(
          icon: const Icon(Icons.directions_run),
          iconSize: 18.0,
          onPressed: () {
            if(controller.isOpen) {
              controller.close();
            }
            else {
              controller.open();
            }
          }
        );
      },
    );
  }
}

class _RangedAttackButton extends StatelessWidget {
  const _RangedAttackButton({
    required this.weapons,
    required this.selectedType,
    required this.selectedSubtype,
    required this.onAttackSelected,
  });

  final List<Weapon> weapons;
  final CombatActionType selectedType;
  final CombatActionSubtype selectedSubtype;
  final void Function(CombatActionSubtype, Weapon) onAttackSelected;

  @override
  Widget build(BuildContext context) {
    var validSpecifications = [
      CombatActionSpecification.none,
      CombatActionSpecification.attackPrecise,
    ];

    var submenus = <MenuItemButton>[];
    for(var specification in validSpecifications) {
      submenus.add(
          MenuItemButton(
            onPressed: () async {
              var usedWeapon = weapons.first;

              if(weapons.length > 1) {
                var w = await showDialog<Weapon>(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) => CombatWeaponSelectionDialog(weapons: weapons),
                );
                if(w != null) usedWeapon = w;
              }

              var subtype = CombatActionSubtype(
                  specification: specification,
                  range: WeaponRange.ranged,
              );

              onAttackSelected(
                subtype,
                usedWeapon,
              );
            },
            child: Text(
              specification == CombatActionSpecification.none
                  ? CombatActionType.attack.title
                  : specification.title,
            ),
          )
      );
    }

    return MenuAnchor(
      menuChildren: submenus,
      builder: (BuildContext context, MenuController controller, Widget? child) {
        return IconButton(
          icon: const Icon(CustomIcons.archery),
          iconSize: 18.0,
          onPressed: () {
            if(controller.isOpen) {
              controller.close();
            }
            else {
              controller.open();
            }
          }
        );
      },
    );
  }
}

class _MeleeAttackButton extends StatelessWidget {
  const _MeleeAttackButton({
    required this.weapons,
    required this.selectedType,
    required this.selectedSubtype,
    required this.onAttackSelected,
  });

  final List<Weapon> weapons;
  final CombatActionType selectedType;
  final CombatActionSubtype selectedSubtype;
  final void Function(CombatActionSubtype, Weapon) onAttackSelected;

  @override
  Widget build(BuildContext context) {
    // TODO: move the valid specifications directly into CombatActionSubtype
    var validSpecifications = [
      CombatActionSpecification.none,
      CombatActionSpecification.attackBrutal,
      CombatActionSpecification.attackPrecise,
      CombatActionSpecification.stun,
      // CombatActionSpecification.disarm,
      CombatActionSpecification.feint,
      // CombatActionSpecification.keepDistance,
    ];

    var submenus = <MenuItemButton>[];
    for(var specification in validSpecifications) {
      submenus.add(
          MenuItemButton(
            onPressed: () async {
              var usedWeapon = weapons.first;

              if(weapons.length > 1) {
                var w = await showDialog<Weapon>(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) => CombatWeaponSelectionDialog(weapons: weapons),
                );
                if(w != null) usedWeapon = w;
              }

              var subtype = CombatActionSubtype(
                  specification: specification,
                  range: WeaponRange.melee
              );

              onAttackSelected(
                  subtype,
                  usedWeapon,
              );
            },
            child: Text(
              specification == CombatActionSpecification.none
                  ? CombatActionType.attack.title
                  : specification.title,
            ),
          )
      );
    }

    return MenuAnchor(
      menuChildren: submenus,
      builder: (BuildContext context, MenuController controller, Widget? child) {
        return IconButton(
            icon: const Icon(Symbols.swords),
            iconSize: 18.0,
            onPressed: () {
              if(controller.isOpen) {
                controller.close();
              }
              else {
                controller.open();
              }
            }
        );
      },
    );
  }
}

class _ContactAttackButton extends StatelessWidget {
  const _ContactAttackButton({
    required this.weapons,
    required this.selectedType,
    required this.selectedSubtype,
    required this.onAttackSelected,
  });

  final List<Weapon> weapons;
  final CombatActionType selectedType;
  final CombatActionSubtype selectedSubtype;
  final void Function(
      CombatActionSubtype,
      Weapon,
    ) onAttackSelected;

  @override
  Widget build(BuildContext context) {
    var validSpecifications = [
      CombatActionSpecification.none,
      CombatActionSpecification.attackBrutal,
      CombatActionSpecification.attackPrecise,
      CombatActionSpecification.stun,
      CombatActionSpecification.feint,
      // CombatActionSpecification.incapacitate,
      // CombatActionSpecification.topple,
      // CombatActionSpecification.crush,
      // CombatActionSpecification.grapple,
    ];

    var submenus = <MenuItemButton>[];
    for(var specification in validSpecifications) {
      submenus.add(
        MenuItemButton(
          onPressed: () async {
            var usedWeapon = weapons.first;

            if(weapons.length > 1) {
              var w = await showDialog<Weapon>(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) => CombatWeaponSelectionDialog(weapons: weapons),
              );
              if(w != null) usedWeapon = w;
            }

            var subtype = CombatActionSubtype(
                specification: specification,
                range: WeaponRange.contact
            );

            onAttackSelected(
                subtype,
                usedWeapon,
            );
          },
          child: Text(
            specification == CombatActionSpecification.none
                ? CombatActionType.attack.title
                : specification.title,
          ),
        )
      );
    }

    return MenuAnchor(
      menuChildren: submenus,
      builder: (BuildContext context, MenuController controller, Widget? child) {
        return IconButton(
          icon: const Icon(Symbols.sports_kabaddi),
          iconSize: 18.0,
          onPressed: () {
            if(controller.isOpen) {
              controller.close();
            }
            else {
              controller.open();
            }
          }
        );
      },
    );
  }
}