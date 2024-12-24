import 'package:flutter/material.dart';

import '../../classes/non_player_character.dart';
import '../../classes/object_source.dart';
import 'npc_display_widget.dart';

class NPCListWidget extends StatefulWidget {
  const NPCListWidget({
    super.key,
    required this.npcs,
    this.initialSelection,
    required this.onEditRequested,
    required this.onCloneRequested,
    required this.onDeleteRequested,
    this.restrictModificationToSourceTypes,
  });

  final List<NonPlayerCharacterSummary> npcs;
  final String? initialSelection;
  final void Function(int) onEditRequested;
  final void Function(int, String) onCloneRequested;
  final void Function(int) onDeleteRequested;
  final List<ObjectSourceType>? restrictModificationToSourceTypes;

  @override
  State<NPCListWidget> createState() => _NPCListWidgetState();
}

class _NPCListWidgetState extends State<NPCListWidget> {
  String? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialSelection;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return ListView.builder(
      itemCount: widget.npcs.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              if(selected == widget.npcs[index].id) {
                selected = null;
              }
              else {
                selected = widget.npcs[index].id;
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
                    if(selected != widget.npcs[index].id)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.npcs[index].name,
                            style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.fade,
                          ),
                          NPCActionButtons(
                            npc: widget.npcs[index],
                            onEdit: () => widget.onEditRequested(index),
                            onClone: (String newName) => widget.onCloneRequested(index, newName),
                            onDelete: () => widget.onDeleteRequested(index),
                            restrictModificationToSourceTypes: widget.restrictModificationToSourceTypes,
                          ),
                        ],
                      ),
                    if(selected == widget.npcs[index].id)
                      NPCDisplayWidget(
                        id: selected!,
                        onEditRequested: (NonPlayerCharacter npc) => widget.onEditRequested(index),
                        onDelete: () => widget.onDeleteRequested(index),
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