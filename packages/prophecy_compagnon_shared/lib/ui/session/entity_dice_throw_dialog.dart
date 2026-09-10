import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_shared/classes/character/tendencies.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_modifier.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_result.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/human_character.dart';
import 'package:prophecy_compagnon_shared/ui/custom_icons.dart';
import 'package:prophecy_compagnon_shared/ui/num_input_widget.dart';
import 'package:prophecy_compagnon_shared/ui/session/entity_pill_widget.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class EntityDiceThrowDialog extends StatefulWidget {
  const EntityDiceThrowDialog({
    super.key,
    required this.entity,
    required this.request,
  });

  final EntityBase entity;
  final DiceThrowRequest request;

  @override
  State<EntityDiceThrowDialog> createState() => _EntityDiceThrowDialogState();
}

class _EntityDiceThrowDialogState extends State<EntityDiceThrowDialog> {
  int? proficiency;
  bool useTendencies = false;
  bool diceThrowDone = false;
  int? mainDie;
  Tendency? announcedTendency;
  Tendency? keptTendency;
  int? dragonDie;
  int? fatalityDie;
  int? humanDie;
  int? luck;
  int? criticalDie;

  bool hasDieResult() {
    if(!diceThrowDone) {
      return false;
    }

    if(useTendencies) {
      if(keptTendency == null) {
        return false;
      }

      if(dragonDie == null || fatalityDie == null || humanDie == null) {
        return false;
      }
    }
    else {
      return mainDie != null;
    }

    return true;
  }

  DiceThrowResult createResult() => DiceThrowResult(
    mainDie: mainDie,
    usedTendencies: useTendencies,
    announcedTendency: announcedTendency,
    keptTendency: keptTendency,
    dragonDie: dragonDie,
    fatalityDie: fatalityDie,
    humanDie: humanDie,
    proficiency: proficiency,
    luck: luck,
    criticalDie: criticalDie,
  );

  bool canRollCritical() {
    if(!hasDieResult()) return false;
    var die = createResult().dieResult();
    return die == 1 || die == 10;
  }

  List<DiceThrowModifier> modifiers() {
    var ret = widget.entity.throwModifiers(widget.request);

    if(
        hasDieResult()
        && criticalDie != null
        && createResult().criticalType(
              widget.request.base.componentValue(widget.entity)
           ) == DiceThrowResultType.criticalSuccess
    ) {
      ret.add(
        DiceThrowModifier(
          label: 'Réussite critique',
          value: 5,
        )
      );
    }

    return ret;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var modifiersTotal = 0;
    var modifierRows = <Widget>[];
    for(var m in modifiers()) {
      modifiersTotal += m.value;

      modifierRows.add(
        Row(
          children: [
            Text(m.label),
            Spacer(),
            _ValuePill(value: m.value),
          ],
        )
      );
    }

    int? total;
    if(hasDieResult()) {
      total =
          widget.request.base.value(widget.entity)
          + createResult().total()
          + modifiersTotal;
    }

    var totalColor = Colors.indigo;
    if(total != null && widget.request.difficulty != null) {
      if(total >= widget.request.difficulty!) {
        totalColor = Colors.green;
      }
      else {
        totalColor = Colors.red;
      }
    }
    var totalWidget = Container(
      decoration: BoxDecoration(
        color: totalColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        child: Text(
          total != null ? total.toString() : '?',
          style: theme.textTheme.headlineSmall!
            .copyWith(color: Colors.white),
        ),
      ),
    );

    Widget? difficultyWidget;
    if(widget.request.difficulty != null) {
      difficultyWidget = Container(
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
          child: Text(
            widget.request.difficulty.toString(),
            style: theme.textTheme.headlineSmall!
              .copyWith(color: Colors.white),
          ),
        ),
      );
    }

    return AlertDialog(
      title: Row(
        spacing: 8.0,
        children: [
          SessionEntityPillWidget(
            entity: widget.entity,
            width: 40,
            height: 40,
          ),
          Expanded(
            child: Text(
              'Jet de ${widget.request.base.label}',
            ),
          )
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 400,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                spacing: 12.0,
                children: [
                  _DiceThrowRow(
                    label: Column(
                      children: [
                        Text(
                          'Score de base',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${widget.request.base.attribute.title} : ${widget.entity.attributes[widget.request.base.attribute]}',
                                style: theme.textTheme.bodySmall,
                              ),
                              Text(
                                '${widget.request.base.componentLabel(widget.entity)} : ${widget.request.base.componentValue(widget.entity)}',
                                style: theme.textTheme.bodySmall,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    child: _ValuePill(
                      value: widget.request.base.value(widget.entity),
                    ),
                  ),
                  if(widget.entity is HumanCharacter)
                    _DiceThrowRow(
                      label: Text('Maîtrise (max ${(widget.entity as HumanCharacter).availableProficiency})'),
                      child: SizedBox(
                        width: 70,
                        child: NumIntInputWidget(
                          enabled: !diceThrowDone,
                          initialValue: 0,
                          minValue: 0,
                          maxValue: (widget.entity as HumanCharacter).availableProficiency,
                          onChanged: (int v) {
                            setState(() {
                              proficiency = v;
                            });
                          },
                        ),
                      ),
                    ),
                  if(widget.entity is HumanCharacter)
                    Row(
                      children: [
                        Switch(
                          value: useTendencies,
                          onChanged: diceThrowDone ? null : (bool v) async {
                            if(v) {
                              var hc = widget.entity as HumanCharacter;
                              var highestValue = [
                                    hc.tendencies.dragon.value,
                                    hc.tendencies.fatality.value,
                                    hc.tendencies.human.value
                                  ]
                                  .reduce(max);

                              var announcedCandidates = <Tendency>[];
                              for(var t in Tendency.values) {
                                if(hc.tendencies[t].value == highestValue) {
                                  announcedCandidates.add(t);
                                }
                              }

                              Tendency announced;
                              if(announcedCandidates.length == 1) {
                                announced = announcedCandidates[0];
                              }
                              else {
                                var r = await showDialog<Tendency>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return SimpleDialog(
                                      title: Text(
                                        "Sélectionner la tendance annoncée"
                                      ),
                                      children: [
                                        for(var t in announcedCandidates)
                                          SimpleDialogOption(
                                            onPressed: () {
                                              Navigator.of(context, rootNavigator: true).pop(t);
                                            },
                                            child: Text(
                                              t.title,
                                            ),
                                          ),
                                      ],
                                    );
                                  }
                                );
                                if(!context.mounted) return;
                                if(r == null) return;
                                announced = r;
                              }

                              setState(() {
                                announcedTendency = announced;
                              });
                            }

                            setState(() {
                              useTendencies = v;
                            });
                          },
                        ),
                        Text(
                          'Utiliser les Tendances',
                        ),
                      ],
                    ),
                  if(!useTendencies)
                    _DiceThrowRow(
                      label: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: 'Dé '),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: IconButton(
                                onPressed: diceThrowDone ? null : () {
                                  setState(() {
                                    mainDie = Random().nextInt(10) + 1;
                                    diceThrowDone = true;
                                  });
                                },
                                icon: Icon(CustomIcons.d10),
                                iconSize: 18.0,
                                tooltip: 'Lancer',
                                constraints: const BoxConstraints(),
                                padding: const EdgeInsets.all(8.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      child: _TextPill(
                        text: mainDie?.toString(),
                      ),
                    ),
                  if(useTendencies)
                    _TendencyThrowWidget(
                      diceThrowDone: diceThrowDone,
                      onDieChanged: (Tendency t, int v) {
                        setState(() {
                          diceThrowDone = true;
                          switch(t) {
                            case Tendency.dragon:
                              dragonDie = v;
                            case Tendency.fatality:
                              fatalityDie = v;
                            case Tendency.human:
                              humanDie = v;
                          }
                        });
                      },
                      announcedTendency: announcedTendency!,
                      keptTendency: keptTendency,
                      onDieKept: (Tendency t) {
                        setState(() {
                          keptTendency = t;
                        });
                      },
                      dragonDie: dragonDie,
                      fatalityDie: fatalityDie,
                      humanDie: humanDie,
                    ),
                  if(canRollCritical())
                    _DiceThrowRow(
                      label: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: 'Dé de Critique '),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: IconButton(
                                onPressed: criticalDie != null ? null : () {
                                  setState(() {
                                    criticalDie = Random().nextInt(10) + 1;
                                  });
                                },
                                icon: Icon(CustomIcons.d10),
                                iconSize: 18.0,
                                tooltip: 'Lancer',
                                constraints: const BoxConstraints(),
                                padding: const EdgeInsets.all(8.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      child: _TextPill(
                        text: criticalDie?.toString(),
                      ),
                    ),
                  if(widget.entity is HumanCharacter)
                    _DiceThrowRow(
                      label: Text('Chance (max ${(widget.entity as HumanCharacter).availableLuck})'),
                      child: SizedBox(
                        width: 70,
                        child: NumIntInputWidget(
                          enabled: diceThrowDone,
                          initialValue: 0,
                          minValue: 0,
                          maxValue: (widget.entity as HumanCharacter).availableLuck,
                          onChanged: (int v) {
                            setState(() {
                              luck = v;
                            });
                          },
                        ),
                      ),
                    ),
                  if(modifierRows.isNotEmpty)
                    WidgetGroupContainer(
                      child: Column(
                        children: modifierRows,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Text(
                'Total',
                style: theme.textTheme.headlineSmall,
              ),
              Spacer(),
              totalWidget,
              if(difficultyWidget != null)
                Text(
                  ' vs. ',
                  style: theme.textTheme.headlineSmall,
                ),
              ?difficultyWidget,
            ],
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(createResult());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class _DiceThrowRow extends StatelessWidget {
  const _DiceThrowRow({
    required this.label,
    required this.child,
  });

  final Widget label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return WidgetGroupContainer(
      child: Row(
        spacing: 8.0,
        children: [
          label,
          Spacer(),
          child,
        ],
      )
    );
  }
}

class _TextPill extends StatelessWidget {
  const _TextPill({
    this.text,
  });

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
          child: Text(
            text ?? '?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class _ValuePill extends StatelessWidget {
  const _ValuePill({
    required this.value,
  });

  final int value;

  @override
  Widget build(BuildContext context) {
    // TODO: manage text color if the value is positive or negative
    return _TextPill(
      text: value.toString(),
    );
  }
}

class _TendencyThrowWidget extends StatefulWidget {
  const _TendencyThrowWidget({
    this.diceThrowDone = false,
    required this.onDieChanged,
    required this.announcedTendency,
    this.keptTendency,
    required this.onDieKept,
    this.dragonDie,
    this.fatalityDie,
    this.humanDie,
  });

  final bool diceThrowDone;
  final void Function(Tendency, int) onDieChanged;
  final Tendency announcedTendency;
  final Tendency? keptTendency;
  final void Function(Tendency) onDieKept;
  final int? dragonDie;
  final int? fatalityDie;
  final int? humanDie;

  @override
  State<_TendencyThrowWidget> createState() => _TendencyThrowWidgetState();
}

class _TendencyThrowWidgetState extends State<_TendencyThrowWidget> {
  int? dragon;
  int? fatality;
  int? human;
  bool kept = false;

  @override
  void initState() {
    super.initState();

    dragon = widget.dragonDie;
    fatality = widget.fatalityDie;
    human = widget.humanDie;
  }

  bool canSelectKeptDie() =>
      !kept && dragon != null && fatality != null && human != null;

  @override
  Widget build(BuildContext context) {
    return WidgetGroupContainer(
      child: Column(
        spacing: 8.0,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Lancer tous les dés '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: IconButton(
                    onPressed: widget.diceThrowDone ? null : () {
                      setState(() {
                        dragon = Random().nextInt(10) + 1;
                        fatality = Random().nextInt(10) + 1;
                        human = Random().nextInt(10) + 1;
                      });

                      widget.onDieChanged(Tendency.dragon, dragon!);
                      widget.onDieChanged(Tendency.fatality, fatality!);
                      widget.onDieChanged(Tendency.human, human!);
                    },
                    icon: Icon(CustomIcons.d10),
                    iconSize: 18.0,
                    tooltip: 'Lancer',
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8.0),
                  ),
                ),
              ],
            ),
          ),
          Row(
            spacing: 8.0,
            children: [
              _TendencyDieLabel(
                label: 'Dé du Dragon',
                announced: widget.announcedTendency == Tendency.dragon,
                kept: widget.keptTendency == Tendency.dragon,
              ),
              Spacer(),
              _TextPill(
                text: dragon?.toString(),
              ),
              if(!kept)
                Tooltip(
                  message: 'Conserver ce dé',
                  child: ElevatedButton(
                    onPressed: !canSelectKeptDie() ? null : () {
                      setState(() {
                        kept = true;
                      });
                      widget.onDieKept(Tendency.dragon);
                    },
                    child: Icon(Icons.check),
                  ),
                ),
            ],
          ),
          Row(
            spacing: 8.0,
            children: [
              _TendencyDieLabel(
                label: 'Dé de la Fatalité',
                announced: widget.announcedTendency == Tendency.fatality,
                kept: widget.keptTendency == Tendency.fatality,
              ),
              Spacer(),
              _TextPill(
                text: fatality?.toString(),
              ),
              if(!kept)
                Tooltip(
                  message: 'Conserver ce dé',
                  child: ElevatedButton(
                    onPressed: !canSelectKeptDie() ? null : () {
                      setState(() {
                        kept = true;
                      });
                      widget.onDieKept(Tendency.fatality);
                    },
                    child: Icon(Icons.check),
                  ),
                ),
            ],
          ),
          Row(
            spacing: 8.0,
            children: [
              _TendencyDieLabel(
                label: "Dé de l'Homme",
                announced: widget.announcedTendency == Tendency.human,
                kept: widget.keptTendency == Tendency.human,
              ),
              Spacer(),
              _TextPill(
                text: human?.toString(),
              ),
              if(!kept)
                Tooltip(
                  message: 'Conserver ce dé',
                  child: ElevatedButton(
                    onPressed: !canSelectKeptDie() ? null : () {
                      setState(() {
                        kept = true;
                      });
                      widget.onDieKept(Tendency.human);
                    },
                    child: Icon(Icons.check),
                  ),
                ),
            ],
          ),
        ],
      )
    );
  }
}

class _TendencyDieLabel extends StatelessWidget {
  const _TendencyDieLabel({
    required this.label,
    required this.announced,
    required this.kept,
  });

  final String label;
  final bool announced;
  final bool kept;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      spacing: 8.0,
      children: [
        Text('$label '),
        if(announced)
          Tooltip(
            message: 'Annoncé',
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Text(
                  'A',
                  style: theme.textTheme.bodySmall!
                      .copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        if(kept)
          Tooltip(
            message: 'Conservé',
            child: Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Text(
                  'C',
                  style: theme.textTheme.bodySmall!
                      .copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ),
          ),
      ]
    );
  }
}