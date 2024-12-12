import 'package:flutter/material.dart';

import '../../classes/non_player_character.dart';
import '../utils/npc_display_widget.dart';
import '../utils/npc_edit_widget.dart';
import '../utils/npc_list_widget.dart';
import '../utils/single_line_input_dialog.dart';
import '../../text_utils.dart';

class ScenarioEditNPCsPage extends StatefulWidget {
  const ScenarioEditNPCsPage({
    super.key,
    required this.npcs,
    required this.scenarioName,
    required this.onNPCCommitted,
  });

  final List<NonPlayerCharacter> npcs;
  final String scenarioName;
  final void Function() onNPCCommitted;

  @override
  State<ScenarioEditNPCsPage> createState() => _ScenarioEditNPCsPageState();
}

class _ScenarioEditNPCsPageState extends State<ScenarioEditNPCsPage> {
  late List<NonPlayerCharacterSummary> npcSummaries;
  String? _selectedId;
  NonPlayerCharacter? _selectedNPC;
  final GlobalKey<FormState> _newNPCNameKey = GlobalKey<FormState>();
  String? _newNPCName;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    npcSummaries = [for(var npc in widget.npcs) npc.summary];
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Widget mainArea;
    if(_editing == true && _newNPCName != null) {
      mainArea = Container(
        color: theme.colorScheme.surfaceContainerHighest,
        child: NPCEditWidget(
          npcId: _selectedId,
          npc: _selectedNPC,
          name: _newNPCName!,
          category: NPCCategory.scenario,
          subCategory: NPCSubCategory(
              title: widget.scenarioName,
              categories: [ NPCCategory.scenario ]
          ),
          onEditDone: (NonPlayerCharacter? npc) {
            setState(() {
              if(npc != null) {
                if(npcSummaries.indexWhere((NonPlayerCharacterSummary s) => s.id == npc.id) == -1) {
                  npcSummaries.add(npc.summary);
                  widget.npcs.add(npc);
                }
                _newNPCName = null;
                _selectedId = npc.id;
                _selectedNPC = npc;
                widget.onNPCCommitted();
              }
              _editing = false;
            });
          },
        ),
      );
    }
    else {
      Widget leftZone;
      if(_selectedId == null) {
        leftZone = const Center(child: Text('Selectionner un PNJ'));
      }
      else {
        leftZone = NPCDisplayWidget(
          id: _selectedId!,
          onEditRequested: (NonPlayerCharacter npc) {
            setState(() {
              _newNPCName = npc.name;
              _selectedId = npc.id;
              _selectedNPC = npc;
              _editing = true;
            });
          },
          onDelete: () {
            setState(() {
              widget.onNPCCommitted();
              NonPlayerCharacter.deleteLocalModel(_selectedId!);
              widget.npcs.removeWhere((NonPlayerCharacter pc) => pc.id == _selectedId);
              npcSummaries.removeWhere((NonPlayerCharacterSummary pc) => pc.id == _selectedId);
              _selectedId = null;
              _selectedNPC = null;
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
                      var model = await NonPlayerCharacter.get(id);
                      if(!context.mounted) return;
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
                        _selectedId = null;
                        _selectedNPC = null;
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
                      npcs: npcSummaries,
                      selected: _selectedId,
                      onSelected: (String id) {
                        setState(() {
                          _selectedId = id;
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