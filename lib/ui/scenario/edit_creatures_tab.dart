import 'package:flutter/material.dart';

import '../../classes/creature.dart';
import '../utils/creature_display_widget.dart';
import '../utils/creature_edit_widget.dart';
import '../utils/creature_list_widget.dart';
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
  UniqueKey _listWidgetKey = UniqueKey();
  CreatureCategory? _category;
  String? _newCreatureName;
  String? _selectedId;
  CreatureModel? _selectedModel;
  bool _editing = false;
  final GlobalKey<FormState> _newCreatureNameKey = GlobalKey<FormState>();

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
          source: widget.scenarioName,
          onEditDone: (CreatureModel? creature) {
            setState(() {
              if(creature != null) {
                if(widget.creatures.indexWhere((CreatureModel m) => m.id == creature.id) == -1) {
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
      Widget leftZone;
      if(_selectedId == null) {
        leftZone = const Center(child: Text('Selectionner une créature'));
      }
      else {
        leftZone = Column(
          children: [
            Expanded(
              child: CreatureDisplayWidget(
                creature: _selectedId!,
                onEditRequested: (CreatureModel model) {
                  setState(() {
                    _newCreatureName = model.name;
                    _selectedId = model.id;
                    _editing = true;
                  });
                },
                onDelete: () async {
                  await CreatureModel.deleteLocalModel(_selectedId!);
                  setState(() {
                    widget.onCreatureCommitted();
                    widget.creatures.removeWhere((CreatureModel c) => c.id == _selectedId!);
                    _selectedId = null;
                    _selectedModel = null;
                    _listWidgetKey = UniqueKey();
                  });
                },
              ),
            ),
          ],
        );
      }

      mainArea = Row(
        children: [
          Expanded(
              flex: 1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16.0),
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
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: CreaturesListWidget(
                      key: _listWidgetKey,
                      category: _category ?? CreatureCategory.animauxSauvages,
                      source: widget.scenarioName,
                      selected: _selectedId,
                      onSelected: (String selectedId) {
                        setState(() {
                          _selectedId = selectedId;
                        });
                      },
                    ),
                  ),
                ],
              )
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: leftZone,
              ),
            ),
          ),
        ],
      );
    }

    return mainArea;
  }
}