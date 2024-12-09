import 'package:flutter/material.dart';

import '../../classes/scenario_encounter.dart';
import '../../classes/encounter_entity_factory.dart';
import 'creature_picker_dialog.dart';
import 'npc_picker_dialog.dart';

class EncounterEditWidget extends StatefulWidget {
  const EncounterEditWidget({ super.key, required this.encounter });

  final ScenarioEncounter encounter;

  @override
  State<EncounterEditWidget> createState() => _EncounterEditWidgetState();
}

class _EncounterEditWidgetState extends State<EncounterEditWidget> {
  void onEntityDeleted(EncounterEntity entity) {
    setState(() {
      widget.encounter.entities.remove(entity);
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Text(
            'Rencontre ${widget.encounter.name}',
            style: theme.textTheme.headlineMedium,
          ),
          for(var e in widget.encounter.entities)
            EncounterEntityEditWidget(
              entity: e,
              onDelete: (EncounterEntity entity) => onEntityDeleted(entity),
            ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text('\u{1F9CC} Ajouter une créature'),
                onPressed: () async {
                  var selectedCreatureId = await showDialog(
                    context: context,
                    builder: (BuildContext context) => const CreaturePickerDialog(),
                  );
                  if(selectedCreatureId == null) return;

                  var entity = EncounterEntity(id: 'creature:$selectedCreatureId');
                  setState(() {
                    widget.encounter.entities.add(entity);
                  });
                },
              ),
              const SizedBox(width: 16.0),
              ElevatedButton(
                child: const Text('\u{1F9D9} Ajouter un PNJ'),
                onPressed: () async {
                  var selectedNpcId = await showDialog(
                    context: context,
                    builder: (BuildContext context) => const NPCPickerDialog()
                  );
                  if(selectedNpcId == null) return;

                  var entity = EncounterEntity(id: 'npc:$selectedNpcId');
                  setState(() {
                    widget.encounter.entities.add(entity);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EncounterEntityEditWidget extends StatefulWidget {
  EncounterEntityEditWidget({
    super.key,
    required this.entity,
    required this.onDelete,
  })
    : name = EncounterEntityFactory.instance.getModel(entity.id)!.displayName(),
      unique = EncounterEntityFactory.instance.getModel(entity.id)!.isUnique();

  final String name;
  final bool unique;
  final EncounterEntity entity;
  final Function(EncounterEntity) onDelete;

  @override
  State<EncounterEntityEditWidget> createState() => _EncounterEntityEditWidgetState();
}

class _EncounterEntityEditWidgetState extends State<EncounterEntityEditWidget> {
  RangeValues? _currentRange;
  int _displayRangeMax = 10;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    _currentRange ??= RangeValues(widget.entity.min.toDouble(), widget.entity.max.toDouble());

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: theme.textTheme.headlineSmall,
                ),
                if(!widget.unique)
                  Row(
                    children: [
                      SizedBox(width: 24, child: Align(alignment: Alignment.centerRight, child: Text(widget.entity.min.toString()))),
                      RangeSlider(
                        values: _currentRange!,
                        min: 1,
                        max: _displayRangeMax.toDouble(),
                        divisions: _displayRangeMax - 1,
                        onChanged: (RangeValues range) {
                          setState(() {
                            _currentRange = range;
                            widget.entity.min = range.start.round().toInt();
                            widget.entity.max = range.end.round().toInt();
                          });
                        },
                        onChangeEnd: (RangeValues range) {
                          setState(() {
                            _displayRangeMax = (1 + _currentRange!.end.round().toInt() ~/ 10) * 10;
                          });
                        }
                      ),
                      SizedBox(width: 24, child: Text(widget.entity.max.toString())),
                    ],
                  ),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                widget.onDelete(widget.entity);
              },
            ),
          ],
        ),
      ),
    );
  }
}