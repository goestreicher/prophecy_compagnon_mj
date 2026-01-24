import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../classes/entity/injury.dart';
import '../../../../classes/entity/abilities.dart';
import '../../../../classes/creature.dart';
import '../../../../classes/entity_base.dart';
import '../../../../classes/human_character.dart';
import '../../../../classes/non_player_character.dart';
import '../../../../classes/player_character.dart';
import '../../num_input_widget.dart';
import '../../widget_group_container.dart';
import 'injury_manager_widget.dart';

class EntityEditInjuriesWidget extends StatelessWidget {
  const EntityEditInjuriesWidget({
    super.key,
    required this.entity,
  });

  final EntityBase entity;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var useSimpleInjuryManager =
        entity is Creature
        || (
            entity is NonPlayerCharacter
            && !(entity as NonPlayerCharacter).useHumanInjuryManager
        );
    var widgets = <Widget>[];

    if(entity is NonPlayerCharacter) {
      widgets.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8.0,
          children: [
            ValueListenableBuilder(
              valueListenable: (entity as NonPlayerCharacter).useHumanInjuryManagerNotifier,
              builder: (BuildContext context, bool useHumanInjuryManager, _) {
                return Switch(
                  value: useHumanInjuryManager,
                  onChanged: (bool value) {
                    var npc = entity as NonPlayerCharacter;
                    npc.useHumanInjuryManager = value;
                    npc.injuries.manager = value
                      ? fullCharacterDefaultInjuries(npc, null)
                      : humanCharacterDefaultInjuries(npc, null);
                  },
                );
              }
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

    widgets.add(
      Center(
        child: StreamBuilder<AbilityStreamChange>(
          stream: entity.abilities.streamController.stream,
          builder: (BuildContext context, AsyncSnapshot<AbilityStreamChange> snapshot) {
            if(snapshot.hasData && snapshot.data != null) {
              var change = snapshot.data!;

              if(
                (entity is PlayerCharacter
                  || (
                      entity is NonPlayerCharacter
                      && (entity as NonPlayerCharacter).useHumanInjuryManager
                  ))
                &&  (
                      change.ability == Ability.resistance
                      || change.ability == Ability.volonte
                    )
              ) {
                entity.injuries.manager =
                    InjuryManager.getInjuryManagerForAbilities(
                      resistance: entity.abilities.resistance,
                      volonte: entity.abilities.volonte,
                      source: entity.injuries.manager,
                    );
              }
            }

            return ValueListenableBuilder(
              valueListenable: entity.injuries.managerNotifier,
              builder: (BuildContext context, InjuryManager value, _) {
                return EntityInjuryManagerWidget(
                  manager: value
                );
              }
            );
          }
        )
      )
    );

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
                levels: InjuryManager(levels: entity.injuries.manager.levels()).levels(),
                source: entity.injuries.manager,
              ),
            );
            if(manager == null) return;
            if(!context.mounted) return;

            entity.injuries.manager = manager;
          },
        )
      );
    }

    return WidgetGroupContainer(
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
  InjuryManager? currentSourceManager;
  Map<Injury, UniqueKey> levelWidgetKeys = <Injury, UniqueKey>{};

  @override
  void initState() {
    super.initState();

    if(widget.source != null) {
      currentSourceManager = InjuryManager(levels: widget.levels, source: widget.source);
    }

    for(var level in widget.levels) {
      levelWidgetKeys[level.type] = UniqueKey();
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var levelsWidgets = <Widget>[];
    for(var i = 0; i < widget.levels.length; ++i) {
      levelsWidgets.add(
        _InjuryLevelEditWidget(
          key: levelWidgetKeys[widget.levels[i].type],
          level: widget.levels[i],
          previous: i == 0 ? null : widget.levels[i-1],
          next: i == widget.levels.length - 1 ? null : widget.levels[i+1],
          onTypeChanged: (Injury type) {
            var prevCount = currentSourceManager?.count(widget.levels[i]) ?? 0;

            setState(() {
              levelWidgetKeys[type] = levelWidgetKeys[widget.levels[i].type]!;
              levelWidgetKeys.remove(widget.levels[i].type);
              widget.levels[i].type = type;
            });

            if(prevCount > 0) {
              currentSourceManager = InjuryManager(
                levels: widget.levels,
                source: currentSourceManager,
              );
              currentSourceManager?.dealInjuries(type, prevCount);
            }
          },
          onCapacityChanged: (int value) {
            setState(() {
              widget.levels[i].capacity = value;
            });
          },
          onStartChanged: (int value) {
            if(i == 0) return;
            setState(() {
              widget.levels[i].start = value;
              widget.levels[i-1].end = value;
              levelWidgetKeys[widget.levels[i-1].type] = UniqueKey();
            });
          },
          onEndChanged: (int value) {
            if(i == widget.levels.length - 1) return;
            setState(() {
              widget.levels[i].end = value;
              widget.levels[i+1].start = value;
              levelWidgetKeys[widget.levels[i+1].type] = UniqueKey();
            });
          },
          onInsertBefore: (InjuryLevel level) {
            if(widget.levels[i].type.rank == 0) return;

            levelWidgetKeys[level.type] = UniqueKey();
            var levelSpread = level.end - level.start;
            var currentSpread = widget.levels[i].end - widget.levels[i].start;

            // If the current level can shrink with enough space left (10), simply do it
            if(currentSpread - levelSpread >= 10) {
              setState(() {
                levelWidgetKeys[widget.levels[i].type] = UniqueKey();
                widget.levels[i].start = level.end;
                widget.levels.insert(i, level);
              });
            }
            // Otherwise, shift all subsequent levels
            else {
              for(var j = i; j < widget.levels.length; ++j) {
                widget.levels[j].start += levelSpread;
                levelWidgetKeys[widget.levels[j].type] = UniqueKey();
                if(!widget.levels[j].type.isFinal) {
                  widget.levels[j].end += levelSpread;
                }
              }
              setState(() {
                widget.levels.insert(i, level);
              });
            }
          },
          onInsertAfter: (InjuryLevel level) {
            if(widget.levels[i].type.isFinal) return;

            levelWidgetKeys[level.type] = UniqueKey();
            var levelSpread = level.end - level.start;
            // Shift all following levels by the new level spread
            for(var j = i+1; j < widget.levels.length; ++j) {
              levelWidgetKeys[widget.levels[j].type] = UniqueKey();
              widget.levels[j].start += levelSpread;
              if(!widget.levels[j].type.isFinal) {
                widget.levels[j].end += levelSpread;
              }
            }
            setState(() {
              widget.levels.insert(i+1, level);
            });
          },
        )
      );
    }

    return AlertDialog(
      title: const Text('Niveaux de blessure'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12.0,
          children: [
            ...levelsWidgets,
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

                      var manager = InjuryManager(
                        levels: widget.levels,
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

class _InjuryLevelEditWidget extends StatelessWidget {
  const _InjuryLevelEditWidget({
    super.key,
    required this.level,
    this.previous,
    this.next,
    required this.onTypeChanged,
    required this.onCapacityChanged,
    required this.onStartChanged,
    required this.onEndChanged,
    required this.onInsertBefore,
    required this.onInsertAfter,
  });

  final InjuryLevel level;
  final InjuryLevel? previous;
  final InjuryLevel? next;
  final void Function(Injury) onTypeChanged;
  final void Function(int) onCapacityChanged;
  final void Function(int) onStartChanged;
  final void Function(int) onEndChanged;
  final void Function(InjuryLevel) onInsertBefore;
  final void Function(InjuryLevel) onInsertAfter;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var typeEntries = <DropdownMenuEntry<Injury>>[];
    for(var injury in Injury.values) {
      if(previous != null && injury.rank <= previous!.type.rank) continue;
      if(next != null && injury.rank >= next!.type.rank) continue;
      if(level.type.isFinal && !injury.isFinal) continue;

      typeEntries.add(DropdownMenuEntry(value: injury, label: injury.title));
    }

    var canInsertAbove = true;
    if(level.type.rank == 0) {
      canInsertAbove = false;
    }
    else if(previous != null && previous!.type.rank + 1 == level.type.rank) {
      canInsertAbove = false;
    }

    var canInsertBelow = true;
    if(level.type.isFinal) {
      canInsertBelow = false;
    }
    else if(next != null && next!.type.rank - 1 == level.type.rank) {
      canInsertBelow = false;
    }

    return Row(
      spacing: 12.0,
      children: [
        SizedBox(
          width: 150,
          child: DropdownMenu(
            initialSelection: level.type,
            expandedInsets: EdgeInsets.zero,
            textStyle: theme.textTheme.bodySmall,
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
              isCollapsed: true,
              constraints: BoxConstraints(maxHeight: 36.0),
              contentPadding: EdgeInsets.all(12.0),
            ),
            dropdownMenuEntries: typeEntries,
            onSelected: (Injury? injury) {
              if(injury == null) return;
              onTypeChanged(injury);
            },
          ),
        ),
        SizedBox(
            width: 80,
            child: NumIntInputWidget(
              label: 'Cases',
              initialValue: level.capacity,
              minValue: 1,
              maxValue: 12,
              onChanged: (int value) => onCapacityChanged(value),
            )
        ),
        SizedBox(
            width: 80,
            child: NumIntInputWidget(
              enabled: previous != null,
              label: 'Début',
              initialValue: level.start + 1,
              minValue: 1,
              maxValue: 999,
              onChanged: (int value) => onStartChanged(value - 1),
            )
        ),
        if(!level.type.isFinal)
          SizedBox(
              width: 80,
              child: NumIntInputWidget(
                label: 'Fin',
                initialValue: level.end,
                minValue: 1,
                maxValue: 999,
                onChanged: (int value) => onEndChanged(value),
              )
          ),
        if(canInsertAbove)
          IconButton(
            icon: Icon(Symbols.add_row_above),
            tooltip: 'Ajouter un niveau avant',
            onPressed: () {
              Injury? prevType;
              for(var injury in Injury.values) {
                if(injury.rank < level.type.rank) prevType = injury;
              }
              if(prevType == null) return;

              var prevStart = level.start;
              var prevEnd = level.start + 10;
              var prevCapacity = 1;

              onInsertBefore(
                InjuryLevel(
                  type: prevType,
                  start: prevStart,
                  end: prevEnd,
                  capacity: prevCapacity,
                )
              );
            },
          ),
        if(canInsertBelow)
          IconButton(
            icon: Icon(Symbols.add_row_below),
            tooltip: 'Ajouter un niveau après',
            onPressed: () {
              Injury? nextType;
              for(var injury in Injury.values) {
                if(injury.rank > level.type.rank) {
                  nextType = injury;
                  break;
                }
              }
              if(nextType == null) return;

              var nextStart = level.end;
              var nextEnd = level.end + 10;
              var nextCapacity = 1;
              onInsertAfter(
                InjuryLevel(
                  type: nextType,
                  start: nextStart,
                  end: nextEnd,
                  capacity: nextCapacity,
                )
              );
            },
          ),
      ],
    );
  }
}