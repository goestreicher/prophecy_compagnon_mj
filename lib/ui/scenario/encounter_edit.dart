import 'package:flutter/material.dart';

import '../../classes/creature.dart';
import '../../classes/scenario_encounter.dart';
import '../../classes/encounter_entity_factory.dart';
import 'creature_picker_dialog.dart';
import 'npc_picker_dialog.dart';

class EncounterEditWidget extends StatefulWidget {
  const EncounterEditWidget({
    super.key,
    required this.encounter,
    this.forScenario,
  });

  final ScenarioEncounter encounter;
  final String? forScenario;

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
                  var selected = await showDialog<CreatureSummary>(
                    context: context,
                    builder: (BuildContext context) => const CreaturePickerDialog(),
                  );
                  if(selected == null) return;

                  var entity = EncounterEntity(id: 'creature:${selected.id}');
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
                    builder: (BuildContext context) => NPCPickerDialog()
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
  const EncounterEntityEditWidget({
    super.key,
    required this.entity,
    required this.onDelete,
  });

  final EncounterEntity entity;
  final Function(EncounterEntity) onDelete;

  @override
  State<EncounterEntityEditWidget> createState() => _EncounterEntityEditWidgetState();
}

class _EncounterEntityEditWidgetState extends State<EncounterEntityEditWidget> {
  late Future<EncounterEntityModel?> modelFuture;
  late RangeValues _currentRange;
  int _displayRangeMax = 10;

  @override
  void initState() {
    super.initState();
    modelFuture = EncounterEntityFactory.instance.getModel(widget.entity.id);
    _currentRange = RangeValues(widget.entity.min.toDouble(), widget.entity.max.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder(
          future: modelFuture,
          builder: (BuildContext context, AsyncSnapshot<EncounterEntityModel?> snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if(snapshot.hasError) {
              return Text(
                "Erreur de chargement pour l'ID ${widget.entity.id}",
                style: theme.textTheme.bodySmall,
              );
            }

            if(snapshot.data == null) {
              return Text(
                "Impossible de trouver l'entité ${widget.entity.id}",
                style: theme.textTheme.bodySmall,
              );
            }

            var model = snapshot.data!;

            return Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.displayName(),
                      style: theme.textTheme.headlineSmall,
                    ),
                    if(!model.isUnique())
                      Row(
                        children: [
                          SizedBox(width: 24, child: Align(alignment: Alignment.centerRight, child: Text(widget.entity.min.toString()))),
                          RangeSlider(
                            values: _currentRange,
                            min: 1,
                            max: _displayRangeMax.toDouble(),
                            divisions: _displayRangeMax - 1,
                            onChanged: (RangeValues range) {
                              setState(() {
                                _currentRange = range;
                              });
                            },
                            onChangeEnd: (RangeValues range) {
                              setState(() {
                                widget.entity.min = range.start.round().toInt();
                                widget.entity.max = range.end.round().toInt();
                                _displayRangeMax = (1 + _currentRange.end.round().toInt() ~/ 10) * 10;
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
            );
          }
        ),
      ),
    );
  }
}