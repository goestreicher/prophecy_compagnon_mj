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
  String? selectedId;
  NonPlayerCharacter? selectedNPC;
  final GlobalKey<FormState> newNPCNameKey = GlobalKey<FormState>();
  String? newNPCName;
  bool editing = false;

  @override
  void initState() {
    super.initState();
    npcSummaries = [for(var npc in widget.npcs) npc.summary];
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Widget mainArea;
    if(editing == true && newNPCName != null) {
      mainArea = Container(
        color: theme.colorScheme.surfaceContainerHighest,
        child: NPCEditWidget(
          npcId: selectedId,
          npc: selectedNPC,
          name: newNPCName!,
          category: NPCCategory.scenario,
          subCategory: NPCSubCategory(
              title: widget.scenarioName,
              categories: [ NPCCategory.scenario ]
          ),
          source: ObjectSource(type: ObjectSourceType.scenario, name: widget.scenarioName),
          onEditDone: (NonPlayerCharacter? npc) {
            setState(() {
              if(npc != null) {
                if(npcSummaries.indexWhere((NonPlayerCharacterSummary s) => s.id == npc.id) == -1) {
                  npcSummaries.add(npc.summary);
                  widget.npcs.add(npc);
                }
                newNPCName = null;
                selectedId = npc.id;
                selectedNPC = npc;
                widget.onNPCCommitted();
              }
              editing = false;
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
                  selectedId = null;
                  selectedNPC = null;
                  newNPCName = name;
                  editing = true;
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
                  category: NPCCategory.scenario,
                  initialSelection: selectedId,
                  npcs: npcSummaries,
                  onEditRequested: (NonPlayerCharacter npc) {
                    setState(() {
                      newNPCName = npc.name;
                      selectedId = npc.id;
                      selectedNPC = npc;
                      editing = true;
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