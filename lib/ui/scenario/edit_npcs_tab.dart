import 'package:flutter/material.dart';

import '../../classes/non_player_character.dart';
import '../../classes/object_source.dart';
import '../utils/character/edit_widget.dart';
import '../utils/non_player_character/create_dialog.dart';
import '../utils/non_player_character/display_widget.dart';
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
  String? selected;
  NonPlayerCharacter? editNPC;
  bool creatingNewNPC = false;

  void _startEditing(NonPlayerCharacter npc) {
    widget.onEditStarted?.call();

    setState(() {
      selected = npc.id;
      editNPC = npc;
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
    if(editNPC != null) {
      mainArea = Container(
        color: theme.colorScheme.surfaceContainerHighest,
        child: CharacterEditWidget(
          character: editNPC!,
          onEditDone: (bool result) async {
            if(result) {
              var summaryIndex = npcSummaries.indexWhere((NonPlayerCharacterSummary s) => s.id == editNPC!.id);
              if(summaryIndex == -1) {
                npcSummaries.add(editNPC!.summary);
                widget.npcs.add(editNPC!);
              }
              else {
                npcSummaries[summaryIndex] = editNPC!.summary;
              }

              if(creatingNewNPC) {
                widget.onNPCCreated(editNPC!);
              }
              else {
                widget.onNPCModified(editNPC!);
              }
            }
            else {
              if(creatingNewNPC) {
                NonPlayerCharacter.removeFromCache(editNPC!.id);
                selected = null;
              }
              else {
                await NonPlayerCharacter.reloadFromStore(editNPC!.id);
              }
            }

            widget.onEditFinished?.call();
            setState(() {
              creatingNewNPC = false;
              editNPC = null;
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            Expanded(
              child: Column(
                spacing: 12.0,
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
                  Expanded(
                    child: NPCListWidget(
                      npcs: npcSummaries,
                      selected: selected,
                      onSelected: (String? id) {
                        setState(() {
                          selected = id;
                        });
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
                          if(editNPC?.id == id) editNPC = null;
                          widget.onNPCDeleted(widget.npcs[index]);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            if(selected != null)
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 8.0),
                    child: NPCDisplayWidget(
                      id: selected!,
                    ),
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