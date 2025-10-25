import 'package:flutter/material.dart';

import '../../classes/non_player_character.dart';
import '../../classes/object_source.dart';
import '../utils/character/edit_widget.dart';
import '../utils/non_player_character/create_dialog.dart';
import '../utils/non_player_character/list_widget.dart';

class ScenarioEditNPCsPage extends StatefulWidget {
  const ScenarioEditNPCsPage({
    super.key,
    required this.npcs,
    required this.scenarioSource,
    required this.onNPCCreated,
    required this.onNPCModified,
    required this.onNPCDeleted,
    this.onEditStarted,
    this.onEditFinished,
  });

  final List<NonPlayerCharacter> npcs;
  final ObjectSource scenarioSource;
  final void Function(NonPlayerCharacter) onNPCCreated;
  final void Function(NonPlayerCharacter) onNPCModified;
  final void Function(NonPlayerCharacter) onNPCDeleted;
  final void Function()? onEditStarted;
  final void Function()? onEditFinished;

  @override
  State<ScenarioEditNPCsPage> createState() => _ScenarioEditNPCsPageState();
}

class _ScenarioEditNPCsPageState extends State<ScenarioEditNPCsPage> {
  late List<NonPlayerCharacterSummary> npcSummaries;
  NonPlayerCharacter? selectedNPC;
  bool editing = false;
  bool creatingNewNPC = false;

  void _startEditing(NonPlayerCharacter npc) {
    widget.onEditStarted?.call();

    setState(() {
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
    if(editing == true && selectedNPC != null) {
      mainArea = Container(
        color: theme.colorScheme.surfaceContainerHighest,
        child: CharacterEditWidget(
          character: selectedNPC!,
          onEditDone: (bool result) async {
            if(result) {
              var summaryIndex = npcSummaries.indexWhere((NonPlayerCharacterSummary s) => s.id == selectedNPC!.id);
              if(summaryIndex == -1) {
                npcSummaries.add(selectedNPC!.summary);
                widget.npcs.add(selectedNPC!);
              }
              else {
                npcSummaries[summaryIndex] = selectedNPC!.summary;
              }

              if(creatingNewNPC) {
                widget.onNPCCreated(selectedNPC!);
              }
              else {
                widget.onNPCModified(selectedNPC!);
              }
            }
            else {
              if(creatingNewNPC) {
                NonPlayerCharacter.removeFromCache(selectedNPC!.id);
              }
              else {
                await NonPlayerCharacter.reloadFromStore(selectedNPC!.id);
              }
            }

            widget.onEditFinished?.call();
            setState(() {
              creatingNewNPC = false;
              editing = false;
            });
          }
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
                var npc = await showDialog(
                  context: context,
                  builder: (BuildContext context) => NPCCreateDialog(
                    source: ObjectSource.local,
                  ),
                );
                if(!context.mounted) return;
                if(npc == null) return;

                creatingNewNPC = true;
                _startEditing(npc);
              },
              icon: const Icon(Icons.add),
              label: const Text('Nouveau PNJ'),
            ),
            const SizedBox(height: 12.0),
            Expanded(
              child: NPCListWidget(
                npcs: npcSummaries,
                selected: selectedNPC?.id,
                onSelected: (String? id) {
                  // TODO
                },
                onEditRequested: (String id) {
                  var npc = widget.npcs.firstWhere(
                    (NonPlayerCharacter n) => n.id == id
                  );

                  creatingNewNPC = false;
                  _startEditing(npc);
                },
                onCloneRequested: (String id) async {
                  var npc = widget.npcs.firstWhere(
                    (NonPlayerCharacter n) => n.id == id
                  );

                  var clone = await showDialog<NonPlayerCharacter>(
                    context: context,
                    builder: (BuildContext context) => NPCCreateDialog(
                      source: widget.scenarioSource,
                      cloneFrom: npc,
                    ),
                  );
                  if(!context.mounted) return;
                  if(clone == null) return;

                  creatingNewNPC = true;
                  _startEditing(clone);
                },
                onDeleteRequested: (String id) {
                  var index = widget.npcs.indexWhere(
                    (NonPlayerCharacter n) => n.id == id
                  );
                  var summaryIndex = npcSummaries.indexWhere(
                      (NonPlayerCharacterSummary n) => n.id == id
                  );

                  setState(() {
                    npcSummaries.removeAt(summaryIndex);
                    if(selectedNPC?.id == id) selectedNPC = null;
                    widget.onNPCDeleted(widget.npcs[index]);
                  });
                },
              ),
            ),
          ],
        )
      );
    }

    return mainArea;
  }
}