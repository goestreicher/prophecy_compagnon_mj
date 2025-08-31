import 'package:flutter/material.dart';

import '../../classes/creature.dart';
import '../../classes/object_source.dart';
import '../utils/creature_edit_widget.dart';
import '../utils/creature_list_widget.dart';
import '../utils/error_feedback.dart';
import '../utils/single_line_input_dialog.dart';
import '../../text_utils.dart';

class ScenarioEditCreaturesPage extends StatefulWidget {
  const ScenarioEditCreaturesPage({
    super.key,
    required this.creatures,
    required this.scenarioSource,
    required this.onCreatureCreated,
    required this.onCreatureModified,
    required this.onCreatureDeleted,
    this.onEditStarted,
    this.onEditFinished,
  });

  final List<CreatureModel> creatures;
  final ObjectSource scenarioSource;
  final void Function(CreatureModel) onCreatureCreated;
  final void Function(CreatureModel) onCreatureModified;
  final void Function(CreatureModel) onCreatureDeleted;
  final void Function()? onEditStarted;
  final void Function()? onEditFinished;

  @override
  State<ScenarioEditCreaturesPage> createState() => _ScenarioEditCreaturesPageState();
}

class _ScenarioEditCreaturesPageState extends State<ScenarioEditCreaturesPage> {
  final GlobalKey<FormState> _newCreatureNameKey = GlobalKey<FormState>();

  late List<CreatureModelSummary> creatureSummaries;
  String? _newCreatureName;
  CreatureModel? _selectedModel;
  bool _editing = false;
  bool creatingNewCreature = false;

  void _startEditing(CreatureModel model) {
    widget.onEditStarted?.call();

    setState(() {
      _newCreatureName = model.name;
      _selectedModel = model;
      _editing = true;
    });
  }

  @override
  void initState() {
    super.initState();
    creatureSummaries = [for(var c in widget.creatures) c.summary]
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Widget mainArea;
    if(_editing == true && _newCreatureName != null) {
      mainArea = Container(
        color: theme.colorScheme.surfaceContainerHighest,
        child: CreatureEditWidget(
          name: _newCreatureName!,
          creatureId: _selectedModel?.id,
          creature: _selectedModel,
          source: widget.scenarioSource,
          onEditDone: (CreatureModel? creature) {
            setState(() {
              if(creature != null) {
                if(widget.creatures.indexWhere((CreatureModel m) => m.id == creature.id) == -1) {
                  creatureSummaries.add(creature.summary);
                  widget.creatures.add(creature);
                }
                _newCreatureName = null;
                _selectedModel = creature;

                if(creatingNewCreature) {
                  widget.onCreatureCreated(creature);
                }
                else {
                  widget.onCreatureModified(creature);
                }
              }

              widget.onEditFinished?.call();
              _editing = false;
              creatingNewCreature = false;
            });
          },
        ),
      );
    }
    else {
      mainArea = Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
        ),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                var name = await showDialog(
                  context: context,
                  builder: (BuildContext context) => SingleLineInputDialog(
                    title: 'Nom de la créature',
                    formKey: _newCreatureNameKey,
                    hintText: 'Nom',
                  ),
                );
                if(!context.mounted) return;
                if(name == null) return;

                var id = sentenceToCamelCase(transliterateFrenchToAscii(name));
                var model = await CreatureModel.get(id);
                if(!context.mounted) return;
                if(model != null) {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Créature existante'),
                      content: const Text('Une créature avec ce nom (ou un nom similaire) existe déjà'),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  );
                  return;
                }

                widget.onEditStarted?.call();

                setState(() {
                  _selectedModel = null;
                  _newCreatureName = name;
                  _editing = true;
                  creatingNewCreature = true;
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Nouvelle créature'),
            ),
            const SizedBox(height: 12.0),
            Expanded(
              child: CreaturesListWidget(
                creatures: creatureSummaries,
                initialSelection: _selectedModel?.id,
                onEditRequested: (int index) async {
                  var model = await CreatureModel.get(creatureSummaries[index].id);
                  if(model == null) return;
                  creatingNewCreature = false;
                  _startEditing(model);
                },
                onCloneRequested: (int index, String newName) async {
                  var model = await CreatureModel.get(creatureSummaries[index].id);
                  if(model == null) return;

                  CreatureModel clone = model.clone(newName);
                  clone.source = ObjectSource.local;

                  creatingNewCreature = true;
                  _startEditing(clone);
                },
                onDeleteRequested: (int index) async {
                  try {
                    var creature = widget.creatures.firstWhere(
                      (CreatureModel c) => c.id == creatureSummaries[index].id
                    );

                    widget.onCreatureDeleted(creature);
                    setState(() {
                      creatureSummaries.removeAt(index);
                      _selectedModel = null;
                    });
                  }
                  catch(e) {
                    if(!context.mounted) return;
                    displayErrorDialog(
                      context,
                      "Suppression impossible",
                      e.toString()
                    );
                  }
                },
              ),
            ),
          ],
        ),
      );
    }

    return mainArea;
  }
}