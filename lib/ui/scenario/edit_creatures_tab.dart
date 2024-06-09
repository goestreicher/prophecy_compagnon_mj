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
  CreatureCategory? _category;
  CreatureModel? _selected;
  final GlobalKey<FormState> _newCreatureNameKey = GlobalKey<FormState>();
  String? _newCreatureName;
  bool _editing = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Widget mainArea;
    if(_editing == true) {
      mainArea = Container(
        color: theme.colorScheme.surfaceContainerHighest,
        child: CreatureEditWidget(
          creature: _selected,
          name: _newCreatureName,
          source: widget.scenarioName,
          onEditDone: (CreatureModel? creature) {
            setState(() {
              if(creature != null) {
                if(_newCreatureName != null) {
                  widget.creatures.add(creature);
                  _newCreatureName = null;
                }
                _selected = creature;
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
      if(_selected == null) {
        leftZone = const Center(child: Text('Selectionner une créature'));
      }
      else {
        leftZone = Column(
          children: [
            Expanded(
              child: CreatureDisplayWidget(
                creature: _selected!,
                onEditRequested: () {
                  setState(() {
                    _editing = true;
                  });
                },
                onCloneEditRequested: (CreatureModel clone) {
                  setState(() {
                    _selected = clone;
                    _editing = true;
                  });
                },
                onDelete: () {
                  setState(() {
                    widget.onCreatureCommitted();
                    CreatureModel.deleteLocalModel(_selected!.id);
                    widget.creatures.removeWhere((CreatureModel c) => c.id == _selected!.id);
                    _selected = null;
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
                      var model = CreatureModel.get(id);
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
                        _selected = null;
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
                      category: _category ?? CreatureCategory.animauxSauvages,
                      source: widget.scenarioName,
                      selected: _selected,
                      onSelected: (CreatureModel model) {
                        setState(() {
                          _selected = model;
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