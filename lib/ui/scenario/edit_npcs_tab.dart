import 'package:flutter/material.dart';
import 'package:prophecy_compagnon_mj/ui/utils/npc_display_widget.dart';

import '../../classes/non_player_character.dart';
import '../utils/npc_edit_widget.dart';
import '../utils/npc_list_widget.dart';
import '../utils/single_line_input_dialog.dart';
import '../../text_utils.dart';

class ScenarioEditNPCsPage extends StatefulWidget {
  const ScenarioEditNPCsPage({
    super.key,
    required this.npcs,
    required this.scenarioName,
  });

  final List<NonPlayerCharacter> npcs;
  final String scenarioName;

  @override
  State<ScenarioEditNPCsPage> createState() => _ScenarioEditNPCsPageState();
}

class _ScenarioEditNPCsPageState extends State<ScenarioEditNPCsPage> {
  NonPlayerCharacter? _selected;
  final GlobalKey<FormState> _newNPCNameKey = GlobalKey<FormState>();
  String? _newNPCName;
  bool _editing = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Widget mainArea;
    if(_editing == true) {
      mainArea = Container(
        color: theme.colorScheme.surfaceContainerHighest,
        child: NPCEditWidget(
          npc: _selected,
          name: _newNPCName,
          category: NPCCategory.scenario,
          subCategory: NPCSubCategory(
              title: widget.scenarioName,
              categories: [ NPCCategory.scenario ]
          ),
          onEditDone: (NonPlayerCharacter? npc) {
            if(_newNPCName != null) {
              _newNPCName = null;
            }

            setState(() {
              if(npc != null) {
                widget.npcs.add(npc);
                _selected = npc;
              }
              _editing = false;
            });
          },
        ),
      );
    }
    else {
      Widget leftZone;
      if(_selected == null) {
        leftZone = const Center(child: Text('Selectionner un PNJ'));
      }
      else {
        leftZone = NPCDisplayWidget(
          npc: _selected!,
          onEditRequested: () {
            setState(() {
              _editing = true;
            });
          },
          onCloneEditRequested: (NonPlayerCharacter clone) {
            setState(() {
              _selected = clone;
              _editing = true;
            });
          },
          onDelete: () {
            setState(() {
              NonPlayerCharacter.deleteLocalModel(_selected!.id);
              _selected = null;
            });
          },
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
                          title: 'Nom du PNJ',
                          formKey: _newNPCNameKey,
                          hintText: 'Nom',
                        ),
                      );
                      if(!context.mounted) return;
                      if(name == null) return;

                      var id = sentenceToCamelCase(transliterateFrenchToAscii(name));
                      var model = NonPlayerCharacter.get(id);
                      if(model != null) {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('PNJ existant'),
                            content: const Text('Un PNJ avec ce nom (ou un nom similaire) existe déjà'),
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
                        _newNPCName = name;
                        _editing = true;
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Nouveau PNJ'),
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: NPCListWidget(
                      category: NPCCategory.scenario,
                      subCategory: NPCSubCategory(
                        title: widget.scenarioName,
                        categories: [ NPCCategory.scenario ],
                      ),
                      selected: _selected,
                      onSelected: (NonPlayerCharacter model) {
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
              color: theme.colorScheme.surfaceContainerHighest,
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