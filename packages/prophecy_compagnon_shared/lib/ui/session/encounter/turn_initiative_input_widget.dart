import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:prophecy_compagnon_shared/classes/combat.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/enums.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/equipment.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/weapon.dart';
import 'package:prophecy_compagnon_shared/ui/custom_icons.dart';
import 'package:prophecy_compagnon_shared/ui/dice_roll_input.dart';

part 'turn_initiative_input_widget.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ActionInitiative {
  const ActionInitiative({
    required this.raw,
    this.weaponModifier,
  });

  final int raw;
  final int? weaponModifier;

  factory ActionInitiative.fromJson(Map<String, dynamic> json) =>
      _$ActionInitiativeFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ActionInitiativeToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TurnInitiative {
  TurnInitiative({
    required this.dominantHand,
    this.weakHand,
  });

  List<ActionInitiative> dominantHand;
  ActionInitiative? weakHand;

  factory TurnInitiative.fromJson(Map<String, dynamic> json) =>
      _$TurnInitiativeFromJson(json);

  Map<String, dynamic> toJson() =>
      _$TurnInitiativeToJson(this);
}

class TurnInitiativeInputWidget extends StatefulWidget {
  const TurnInitiativeInputWidget({
    super.key,
    required this.entity,
    required this.dice,
    this.engagementRange,
    required this.onDone,
    this.random = false,
  });

  final EntityBase entity;
  final int dice;
  final WeaponRange? engagementRange;
  final void Function(TurnInitiative) onDone;
  final bool random;

  @override
  State<TurnInitiativeInputWidget> createState() => _TurnInitiativeInputWidgetState();
}

class _TurnInitiativeInputWidgetState extends State<TurnInitiativeInputWidget> {
  late int dominantHandWeaponModifier;
  late String dominantHandWeaponModifierDescription;
  late List<int?> dominantHandDieResults;
  int dominantHandModifierIndex = -1;
  late List<bool> dominantHandKeptDice;

  bool showWeakHand = false;
  late int weakHandWeaponModifier;
  late String weakHandWeaponModifierDescription;
  int? weakHandDieResult;

  List<String> validationErrors = <String>[];
  bool canValidate = false;

  @override
  void initState() {
    super.initState();

    int? dhModifier;
    String? dhModifierDescription;
    int? whModifier;
    String? whModifierDescription;

    if(widget.engagementRange != null) {
      for(var dp in widget.entity.damageProviderForHand(EquipableItemSlot.dominantHand)) {
        if(dp is InitiativeProvider) {
          var mod = (dp as InitiativeProvider).initiativeForRange(widget.engagementRange!);
          if(dhModifier == null || mod < dhModifier) {
            dhModifier = mod;
            dhModifierDescription = (dp as EquipableItem).name;
          }
        }
      }

      bool weakHandFree = true;
      var dps = widget.entity.damageProviderForHand(EquipableItemSlot.weakHand);
      for(var dp in dps) {
        if(dp is Weapon && (dp.model as WeaponModel).handiness == 2) {
          weakHandFree = false;
        }
        if(dp is InitiativeProvider) {
          var mod = (dp as InitiativeProvider).initiativeForRange(widget.engagementRange!);
          if(whModifier == null || mod < whModifier) {
            whModifier = mod;
            whModifierDescription = (dp as EquipableItem).name;
          }
        }
      }
      showWeakHand = weakHandFree && whModifier != null;
    }

    if(widget.dice == 1) dominantHandModifierIndex = 0;
    dominantHandWeaponModifier = dhModifier ?? 0;
    dominantHandWeaponModifierDescription = dhModifierDescription ?? "Pas de modificateur d'arme";

    weakHandWeaponModifier = whModifier ?? 0;
    weakHandWeaponModifierDescription = whModifierDescription ?? "Pas de modificateur d'arme";

    dominantHandDieResults = List.generate(widget.dice, (_) => null);

    dominantHandKeptDice = List.generate(
        widget.dice, (_) => widget.dice > widget.entity.initiative ? false : true
    );

    updateCanValidate();
  }

  void updateCanValidate() {
    var errors = <String>[];

    if(dominantHandDieResults.any((int? v) => v == null)) {
      errors.add("Lancer(s) de dé non renseigné(s) pour la main dominante");
    }

    if(dominantHandWeaponModifier != 0 && dominantHandModifierIndex == -1) {
      errors.add("Modificateur d'arme non appliqué pour la main dominante");
    }

    var selectedDice = dominantHandKeptDice
      .where((bool v) => v)
      .length;
    if(widget.dice > widget.entity.initiative) {
      if(selectedDice > widget.entity.initiative) {
        errors.add("Trop de dés sélectionnés (max. ${widget.entity.initiative})");
      }
      else if(selectedDice < widget.entity.initiative) {
        errors.add("Pas assez de dés sélectionnés (max. ${widget.entity.initiative})");
      }
    }

    if(showWeakHand && weakHandDieResult == null) {
      errors.add("Lancer de dé non renseigné pour la main faible");
    }

    validationErrors = errors;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          spacing: 12.0,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.entity.name,
                  style: theme.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.engagementRange == null
                      ? 'Pas engagé en combat'
                      : 'Engagé en combat : ${widget.engagementRange!.title}',
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  'Initiative : ${widget.entity.initiative}',
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  'Mod. blessures : ${widget.entity.damageMalus()}',
                  style: theme.textTheme.bodySmall,
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(CustomIcons.d10),
                      tooltip: "Tirer les initiatives",
                      onPressed: () {
                        setState(() {
                          for(var i = 0; i < widget.dice; ++i) {
                            dominantHandDieResults[i] = Random().nextInt(10) + 1;
                          }

                          if(showWeakHand) {
                            weakHandDieResult = Random().nextInt(10) + 1;
                          }

                          updateCanValidate();
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.check),
                      tooltip: validationErrors.isEmpty
                        ? "Valider"
                        : "Impossible de valider :\n  * ${validationErrors.join('\n  * ')}",
                      onPressed: validationErrors.isNotEmpty ? null : () {
                        var dhInit = <ActionInitiative>[];
                        ActionInitiative? whInit;

                        for(var i = 0; i < widget.dice; ++i) {
                          if(!dominantHandKeptDice[i]) continue;

                          dhInit.add(
                            ActionInitiative(
                              raw: dominantHandDieResults[i]!,
                              weaponModifier: i == dominantHandModifierIndex
                                ? dominantHandWeaponModifier
                                : null,
                            )
                          );
                        }

                        if(showWeakHand) {
                          whInit = ActionInitiative(
                            raw: weakHandDieResult!,
                            weaponModifier: weakHandWeaponModifier,
                          );
                        }

                        widget.onDone(
                          TurnInitiative(
                            dominantHand: dhInit,
                            weakHand: whInit,
                          )
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8.0,
              children: [
                Row(
                  spacing: 12.0,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          EquipableItemSlot.dominantHand.title,
                          style: theme.textTheme.bodySmall!
                            .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          dominantHandWeaponModifierDescription,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            for(var i = 0; i < widget.dice; ++i)
                              Column(
                                children: [
                                  Text(
                                    'Dé ${i+1}',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                  _ActionInitiativeInputWidget(
                                    value: dominantHandDieResults[i],
                                    onValueSelected: (int v) {
                                      setState(() {
                                        dominantHandDieResults[i] = v;
                                        updateCanValidate();
                                      });
                                    },
                                    modifier: dominantHandWeaponModifier,
                                    modifierSet: i == dominantHandModifierIndex,
                                    onModifierSelected: () {
                                      setState(() {
                                        dominantHandModifierIndex = i;
                                        updateCanValidate();
                                      });
                                    },
                                  ),
                                  SizedBox(height: 8.0),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4.0),
                                    child: Material(
                                      color: dominantHandKeptDice[i] ? theme.colorScheme.tertiary : theme.disabledColor,
                                      child: InkWell(
                                        onTap: widget.dice == widget.entity.initiative ? null : () {
                                          setState(() {
                                            dominantHandKeptDice[i] = !dominantHandKeptDice[i];
                                            updateCanValidate();
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                          child: Text(
                                            dominantHandDieResults[i] == null
                                              ? '?'
                                              : (dominantHandDieResults[i]! + (dominantHandModifierIndex == i ? dominantHandWeaponModifier : 0) - widget.entity.damageMalus()).toString(),
                                            style: theme.textTheme.bodyLarge!
                                              .copyWith(color: theme.colorScheme.onTertiary),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if(showWeakHand)
                  Row(
                    spacing: 12.0,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            EquipableItemSlot.weakHand.title,
                            style: theme.textTheme.bodySmall!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            weakHandWeaponModifierDescription,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              _ActionInitiativeInputWidget(
                                value: weakHandDieResult,
                                onValueSelected: (int v) {
                                  setState(() {
                                    weakHandDieResult = v;
                                    updateCanValidate();
                                  });
                                },
                                modifier: weakHandWeaponModifier,
                                modifierSet: true,
                                onModifierSelected: () {
                                  // no-op
                                },
                              ),
                              SizedBox(height: 8.0),
                              Container(
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.tertiaryFixed,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                  child: Text(
                                    weakHandDieResult == null
                                        ? '?'
                                        : (weakHandDieResult! + weakHandWeaponModifier - widget.entity.damageMalus()).toString(),
                                    style: theme.textTheme.bodyLarge!
                                        .copyWith(color: theme.colorScheme.onTertiaryFixed),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionInitiativeInputWidget extends StatelessWidget {
  const _ActionInitiativeInputWidget({
    this.value,
    required this.onValueSelected,
    this.modifier = 0,
    this.modifierSet = false,
    required this.onModifierSelected,
  });

  final int? value;
  final void Function(int) onValueSelected;
  final int modifier;
  final bool modifierSet;
  final void Function() onModifierSelected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      children: [
        DiceRollInputWidget(
          initialValue: value,
          onValueSelected: onValueSelected,
        ),
        if(modifier != 0)
          TextButton(
            onPressed: onModifierSelected,
            style: TextButton.styleFrom(
              foregroundColor: modifierSet ? theme.colorScheme.onPrimary : theme.disabledColor,
              backgroundColor: modifierSet ? theme.colorScheme.primary : null,
              textStyle: theme.textTheme.bodySmall,
              padding: const EdgeInsets.all(8.0),
              minimumSize: Size.zero,
            ),
            child: Text(
              '${modifier > 0 ? "+" : ""}${modifier.toString()}',
            ),
          ),
      ],
    );
  }
}