import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../classes/character/base.dart';
import '../../../../classes/character/injury.dart';
import '../../../../classes/entity_base.dart';
import '../../../../classes/human_character.dart';
import '../../../../classes/non_player_character.dart';
import '../../../../classes/player_character.dart';
import '../../character_digit_input_widget.dart';
import '../change_stream.dart';
import '../widget_group_container.dart';

class CharacterEditInjuriesWidget extends StatefulWidget {
  const CharacterEditInjuriesWidget({
    super.key,
    required this.character,
    required this.changeStreamController,
    this.initialManager,
    this.onChanged,
  });

  final EntityBase character;
  final StreamController<CharacterChange> changeStreamController;
  final InjuryManager? initialManager;
  final void Function(InjuryManager)? onChanged;

  @override
  State<CharacterEditInjuriesWidget> createState() => _CharacterEditInjuriesWidgetState();
}

class _CharacterEditInjuriesWidgetState extends State<CharacterEditInjuriesWidget> {
  late int currentResistance;
  late int currentVolonte;
  late InjuryManager currentManager;

  @override
  void initState() {
    super.initState();

    currentResistance = widget.character.ability(Ability.resistance);
    currentVolonte = widget.character.ability(Ability.volonte);
    currentManager = widget.initialManager ?? widget.character.injuries;

    widget.changeStreamController.stream.listen((CharacterChange change) {
      if(
          change.item == CharacterChangeItem.ability
          && change.value != null
          && change.value is CharacterAbilityChangeValue
      ) {
        var v = change.value as CharacterAbilityChangeValue;
        if(v.ability == Ability.resistance) {
          currentResistance = v.value;
          updateInjuryManager();
        }
        else if(v.ability == Ability.volonte) {
          currentVolonte = v.value;
          updateInjuryManager();
        }
      }
    });
  }

  void updateInjuryManager() {
    if(
        widget.character is PlayerCharacter
        || (
            widget.character is NonPlayerCharacter
            && (widget.character as NonPlayerCharacter).useHumanInjuryManager
        )
    ) {
      setState(() {
        currentManager = InjuryManager.getInjuryManagerForAbilities(
          resistance: currentResistance,
          volonte: currentVolonte,
          source: currentManager,
        );
      });

      widget.onChanged?.call(currentManager);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var useSimpleInjuryManager =
        widget.character is! PlayerCharacter
        && (
            widget.character is NonPlayerCharacter
            && !(widget.character as NonPlayerCharacter).useHumanInjuryManager
        );
    var widgets = <Widget>[];

    if(widget.character is NonPlayerCharacter) {
      widgets.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8.0,
          children: [
            Switch(
              value: (widget.character as NonPlayerCharacter).useHumanInjuryManager,
              onChanged: (bool value) {
                var npc = widget.character as NonPlayerCharacter;
                currentManager = value
                  ? fullCharacterDefaultInjuries(npc, null)
                  : humanCharacterDefaultInjuries(npc, null);

                widget.onChanged?.call(currentManager);

                setState(() {
                  npc.useHumanInjuryManager = value;
                });
              },
            ),
            Expanded(
              child: Text(
                'Utiliser les seuils de blessure par défaut',
                style: theme.textTheme.bodySmall,
                softWrap: true,
              ),
            ),
          ]
        )
      );
    }

    if(useSimpleInjuryManager) {
      widgets.add(
        ElevatedButton(
          child: Text(
            'Modifier les cases',
            style: theme.textTheme.bodySmall,
          ),
          onPressed: () async {
            var manager = await showDialog(
              context: context,
              builder: (BuildContext context) => _EditSimpleInjuryManagerLevelsDialog(
                levels: currentManager.levels(),
                source: currentManager,
              ),
            );
            if(manager == null) return;
            if(!context.mounted) return;

            setState(() {
              currentManager = manager;
            });
          },
        )
      );
    }

    widgets.add(
      Center(child: _InjuryManagerEditWidget(manager: currentManager))
    );

    return WidgetGroupContainer(
      title: Text(
        'Blessures',
        style: theme.textTheme.bodyMedium!.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        )
      ),
      child: Column(
        spacing: 12.0,
        mainAxisSize: MainAxisSize.min,
        children: widgets,
      ),
    );
  }
}

class _EditSimpleInjuryManagerLevelsDialog extends StatefulWidget {
  const _EditSimpleInjuryManagerLevelsDialog({
    required this.levels,
    this.source,
  });

  final List<InjuryLevel> levels;
  final InjuryManager? source;

  @override
  State<_EditSimpleInjuryManagerLevelsDialog> createState() => _EditSimpleInjuryManagerLevelsDialogState();
}

class _EditSimpleInjuryManagerLevelsDialogState extends State<_EditSimpleInjuryManagerLevelsDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late int injuredCeiling;
  late int injuredCount;
  late int deathCount;

  @override
  void initState() {
    super.initState();

    injuredCeiling = widget.levels[0].end;
    injuredCount = widget.levels[0].capacity;
    deathCount = widget.levels[1].capacity;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Niveaux de blessure'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12.0,
          children: [
            Row(
              children: [
                Expanded(child: const Text('Cases de blessure')),
                SizedBox(
                  width: 80,
                  child: CharacterDigitInputWidget(
                    initialValue: injuredCount,
                    minValue: 1,
                    maxValue: 10,
                    onChanged: (int value) {
                      setState(() {
                        injuredCount = value;
                      });
                    },
                  )
                )
              ],
            ),
            Row(
              children: [
                Expanded(child: const Text('Seuil de mort')),
                SizedBox(
                    width: 80,
                    child: CharacterDigitInputWidget(
                      initialValue: injuredCeiling,
                      minValue: 1,
                      maxValue: 501,
                      onChanged: (int value) {
                        setState(() {
                          injuredCeiling = value;
                        });
                      },
                    )
                )
              ],
            ),
            Row(
              children: [
                Expanded(child: const Text('Cases de mort')),
                SizedBox(
                  width: 80,
                  child: CharacterDigitInputWidget(
                    initialValue: deathCount,
                    minValue: 1,
                    maxValue: 10,
                    onChanged: (int value) {
                      setState(() {
                        deathCount = value;
                      });
                    },
                  )
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Annuler'),
                  ),
                  const SizedBox(width: 12.0),
                  ElevatedButton(
                    onPressed: () {
                      if(!_formKey.currentState!.validate()) return;

                      var manager = InjuryManager.simple(
                        injuredCeiling: injuredCeiling,
                        injuredCount: injuredCount,
                        deathCount: deathCount,
                        source: widget.source,
                      );
                      Navigator.of(context).pop(manager);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                    ),
                    child: const Text('OK'),
                  )
                ],
              )
            )
          ],
        ),
      )
    );
  }
}

class _InjuryManagerEditWidget extends StatefulWidget {
  const _InjuryManagerEditWidget({
    required this.manager,
  });

  final InjuryManager manager;

  @override
  State<_InjuryManagerEditWidget> createState() => _InjuryManagerEditWidgetState();
}

class _InjuryManagerEditWidgetState extends State<_InjuryManagerEditWidget> {
  @override
  Widget build(BuildContext context) {
    var levelNames = <Widget>[];
    var levelInputs = <Widget>[];
    for(var level in widget.manager.levels()) {
      levelNames.add(
        Text(
          level.title,
        )
      );

      levelInputs.add(
        _InjuryLevelInputWidget(
          level: level,
          count: widget.manager.count(level),
          increase: () {
            setState(() {
              widget.manager.setDamage(level.start + 1);
            });
          },
          decrease: () {
            setState(() {
              widget.manager.heal(level);
            });
          },
        )
      );
    }

    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8.0,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: levelNames,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: levelInputs,
            ),
          )
        ],
      ),
    );
  }
}

class _InjuryLevelInputWidget extends StatelessWidget {
  const _InjuryLevelInputWidget({
    required this.level,
    required this.count,
    required this.increase,
    required this.decrease,
    this.circlesDiameter = 12.0,
  });

  final InjuryLevel level;
  final int count;
  final void Function() increase;
  final void Function() decrease;
  final double circlesDiameter;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    List<Widget> circles = <Widget>[];
    var colored = 0;

    for(var i = 0; i < level.capacity; ++i) {
      if(colored < count) {
        circles.add(
            UnconstrainedBox(
              child: Container(
                width: circlesDiameter,
                height: circlesDiameter,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black),
                ),
              ),
            )
        );
        ++colored;
      }
      else {
        circles.add(
          UnconstrainedBox(
            child: Container(
              width: circlesDiameter,
              height: circlesDiameter,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceBright,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black),
              ),
            ),
          )
        );
      }
    }

    var minWidth = circlesDiameter * 2 + 2.0;

    return Row(
      spacing: 4.0,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          style: IconButton.styleFrom(
            minimumSize: Size.square(28.0),
            maximumSize: Size.square(28.0),
            iconSize: 12.0,
          ),
          onPressed: () => decrease(),
        ),
        Flexible(
          child: ConstraintsTransformBox(
            clipBehavior: Clip.hardEdge,
            constraintsTransform: (BoxConstraints constraints) {
              if(constraints.maxWidth < minWidth) {
                return BoxConstraints(
                  minWidth: minWidth,
                  maxWidth: minWidth,
                  minHeight: constraints.minHeight,
                  maxHeight: constraints.maxHeight,
                );
              }
              else {
                return constraints;
              }
            },
            child: Wrap(
              spacing: 2.0,
              runSpacing: 2.0,
              children: circles,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          style: IconButton.styleFrom(
            minimumSize: Size.square(28.0),
            maximumSize: Size.square(28.0),
            iconSize: 12.0,
          ),
          onPressed: () => increase(),
        ),
      ],
    );
  }
}