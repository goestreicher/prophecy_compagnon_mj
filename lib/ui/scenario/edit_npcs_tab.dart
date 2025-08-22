import 'package:flutter/material.dart';

import '../../classes/non_player_character.dart';
import '../../classes/object_source.dart';
import '../utils/npc_edit_widget.dart';
import '../utils/npc_list_widget.dart';
import '../utils/single_line_input_dialog.dart';
import '../../text_utils.dart';

class ScenarioEditNPCsPage extends StatefulWidget {
  const ScenarioEditNPCsPage({
    super.key,
    required this.npcs,
    required this.scenarioSource,
    required this.onNPCCreated,
    required this.onNPCModified,
    required this.onNPCDeleted,
  });

  final List<NonPlayerCharacter> npcs;
  final ObjectSource scenarioSource;
  final void Function(NonPlayerCharacter) onNPCCreated;
  final void Function(NonPlayerCharacter) onNPCModified;
  final void Function(NonPlayerCharacter) onNPCDeleted;

  @override
  State<ScenarioEditNPCsPage> createState() => _ScenarioEditNPCsPageState();
}

class _ScenarioEditNPCsPageState extends State<ScenarioEditNPCsPage> {
  late List<NonPlayerCharacterSummary> npcSummaries;
  NonPlayerCharacter? selectedNPC;
  final GlobalKey<FormState> newNPCNameKey = GlobalKey<FormState>();
  String? editNPCName;
  bool editing = false;
  bool creatingNewNPC = false;

  void _startEditing(NonPlayerCharacter npc) {
    setState(() {
      editNPCName = npc.name;
      selectedNPC = npc;
      editing = true;
    });
  }

  @override
  void initState() {
    super.initState();
    npcSummaries = [for(var npc in widget.npcs) npc.summary];
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Widget mainArea;
    if(editing == true && editNPCName != null) {
      mainArea = Container(
        color: theme.colorScheme.surfaceContainerHighest,
        child: NPCEditWidget(
          npc: selectedNPC,
          name: editNPCName!,
          source: widget.scenarioSource,
          onEditDone: (NonPlayerCharacter? npc) {
            setState(() {
              if(npc != null) {
                var summaryIndex = npcSummaries.indexWhere((NonPlayerCharacterSummary s) => s.id == npc.id);
                if(summaryIndex == -1) {
                  npcSummaries.add(npc.summary);
                  widget.npcs.add(npc);
                }
                else {
                  npcSummaries[summaryIndex] = npc.summary;
                }
                editNPCName = null;
                selectedNPC = npc;
                if(creatingNewNPC) {
                  widget.onNPCCreated(npc);
                }
                else {
                  widget.onNPCModified(npc);
                }
              }
              editing = false;
              creatingNewNPC = false;
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
                    title: 'Nom du PNJ',
                    formKey: newNPCNameKey,
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
                  selectedNPC = null;
                  editNPCName = name;
                  editing = true;
                  creatingNewNPC = true;
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Nouveau PNJ'),
            ),
            const SizedBox(height: 12.0),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 800),
                child: NPCListWidget(
                  npcs: npcSummaries,
                  initialSelection: selectedNPC?.id,
                  onEditRequested: (int index) async {
                    var npc = widget.npcs.firstWhere(
                      (NonPlayerCharacter n) => n.id == npcSummaries[index].id
                    );

                    creatingNewNPC = false;
                    _startEditing(npc);
                  },
                  onCloneRequested: (int index, String newName) async {
                    var npc = widget.npcs.firstWhere(
                      (NonPlayerCharacter n) => n.id == npcSummaries[index].id
                    );

                    var clone = npc.clone(newName);
                    clone.source = ObjectSource.local;

                    creatingNewNPC = true;
                    _startEditing(clone);
                  },
                  onDeleteRequested: (int index) async {
                    var npc = widget.npcs.firstWhere(
                      (NonPlayerCharacter n) => n.id == npcSummaries[index].id
                    );

                    widget.onNPCDeleted(npc);
                    setState(() {
                      npcSummaries.removeAt(index);
                      selectedNPC = null;
                    });
                  },
                ),
              ),
            ),
          ],
        )
      );
    }

    return mainArea;
  }
}