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
    required this.scenarioName,
    required this.onCreatureCommitted,
  });

  final List<CreatureModel> creatures;
  final String scenarioName;
  final void Function() onCreatureCommitted;

  @override
  State<ScenarioEditCreaturesPage> createState() => _ScenarioEditCreaturesPageState();
}

class _ScenarioEditCreaturesPageState extends State<ScenarioEditCreaturesPage> {
  late List<CreatureModelSummary> creatureSummaries;
  String? _newCreatureName;
  String? _selectedId;
  CreatureModel? _selectedModel;
  bool _editing = false;
  final GlobalKey<FormState> _newCreatureNameKey = GlobalKey<FormState>();

  void _startEditing(CreatureModel model) {
    setState(() {
      _newCreatureName = model.name;
      _selectedId = model.id;
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
          creatureId: _selectedId,
          creature: _selectedModel,
          source: ObjectSource(type: ObjectSourceType.scenario, name: widget.scenarioName),
          onEditDone: (CreatureModel? creature) {
            setState(() {
              if(creature != null) {
                if(widget.creatures.indexWhere((CreatureModel m) => m.id == creature.id) == -1) {
                  creatureSummaries.add(creature.summary);
                  widget.creatures.add(creature);
                }
                _newCreatureName = null;
                _selectedId = creature.id;
                _selectedModel = null;
              }
              widget.onCreatureCommitted();
              _editing = false;
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

                setState(() {
                  _selectedId = null;
                  _newCreatureName = name;
                  _editing = true;
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Nouvelle créature'),
            ),
            const SizedBox(height: 12.0),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 800),
                child: CreaturesListWidget(
                  creatures: creatureSummaries,
                  initialSelection: _selectedId,
                  onEditRequested: (int index) async {
                    var model = await CreatureModel.get(creatureSummaries[index].id);
                    if(model == null) return;
                    _startEditing(model);
                  },
                  onCloneRequested: (int index, String newName) async {
                    var model = await CreatureModel.get(creatureSummaries[index].id);
                    if(model == null) return;

                    CreatureModel clone = model.clone(newName);
                    clone.source = ObjectSource.local;

                    _startEditing(clone);
                  },
                  onDeleteRequested: (int index) async {
                    try {
                      await CreatureModel.deleteLocalModel(creatureSummaries[index].id);
                      setState(() {
                        _selectedId = null;
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
            ),
          ],
        ),
      );
    }

    return mainArea;
  }
}