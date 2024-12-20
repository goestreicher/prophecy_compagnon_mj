import 'package:flutter/material.dart';

import '../../classes/non_player_character.dart';
import '../../classes/object_source.dart';
import 'npc_display_widget.dart';
import '../utils/error_feedback.dart';

class NPCListWidget extends StatefulWidget {
  const NPCListWidget({
    super.key,
    this.npcs,
    this.source,
    this.category,
    this.subCategory,
    this.initialSelection,
    required this.onEditRequested,
    this.restrictModificationToSourceTypes,
  });

  final List<NonPlayerCharacterSummary>? npcs;
  final String? source;
  final NPCCategory? category;
  final NPCSubCategory? subCategory;
  final String? initialSelection;
  final void Function(NonPlayerCharacter) onEditRequested;
  final List<ObjectSourceType>? restrictModificationToSourceTypes;

  @override
  State<NPCListWidget> createState() => _NPCListWidgetState();
}

class _NPCListWidgetState extends State<NPCListWidget> {
  late List<NonPlayerCharacterSummary> npcs;
  String? selected;

  void _updateNPCList() {
    if(widget.npcs != null) {
      npcs = widget.npcs!;
    }
    else if(widget.source != null) {
      // TODO: implement
      npcs = <NonPlayerCharacterSummary>[];
    }
    else if(widget.category != null) {
      npcs = NonPlayerCharacter.forCategory(widget.category!, widget.subCategory);
    }
    else {
      npcs = <NonPlayerCharacterSummary>[];
    }
    npcs.sort((a, b) => a.id.compareTo(b.id));
  }

  Future<void> _deleteModel(BuildContext context, int index) async {
    try {
      await NonPlayerCharacter.deleteLocalModel(npcs[index].id);
      setState(() {
        npcs.removeAt(index);
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
    setState(() {
      selected = null;
    });
  }

  @override
  void initState() {
    super.initState();
    selected = widget.initialSelection;
    _updateNPCList();
  }

  @override
  void didUpdateWidget(NPCListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateNPCList();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return ListView.builder(
      itemCount: npcs.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              if(selected == npcs[index].id) {
                selected = null;
              }
              else {
                selected = npcs[index].id;
              }
            });
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Card(
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if(selected != npcs[index].id)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            npcs[index].name,
                            style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.fade,
                          ),
                          NPCActionButtons(
                            npc: npcs[index],
                            onEdit: () async {
                              var npc = await NonPlayerCharacter.get(npcs[index].id);
                              widget.onEditRequested(npc!);
                            },
                            onClone: (String newName) async {
                              var npc = await NonPlayerCharacter.get(npcs[index].id);
                              var j = npc!.toJson();
                              j['name'] = newName;
                              widget.onEditRequested(NonPlayerCharacter.fromJson(j));
                            },
                            onDelete: () async {
                              await _deleteModel(context, index);
                            },
                            restrictModificationToSourceTypes: widget.restrictModificationToSourceTypes,
                          ),
                        ],
                      ),
                    if(selected == npcs[index].id)
                      NPCDisplayWidget(
                        id: selected!,
                        onEditRequested: (NonPlayerCharacter npc) =>
                          widget.onEditRequested(npc),
                        onDelete: () async {
                          await _deleteModel(context, index);
                        },
                        restrictModificationToSourceTypes: widget.restrictModificationToSourceTypes,
                      )
                  ],
                ),
              )
            ),
          ),
        );
      }
    );
  }
}