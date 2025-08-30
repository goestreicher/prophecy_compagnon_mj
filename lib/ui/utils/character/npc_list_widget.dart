import 'package:flutter/material.dart';

import '../../../classes/non_player_character.dart';
import '../../../classes/object_source.dart';
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
  final void Function(String) onEditRequested;
  final void Function(String) onCloneRequested;
  final void Function(String) onDeleteRequested;
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
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 800,
            ),
            child: GestureDetector(
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
                                onEdit: () => widget.onEditRequested(widget.npcs[index].id),
                                onClone: () => widget.onCloneRequested(widget.npcs[index].id),
                                onDelete: () => widget.onDeleteRequested(widget.npcs[index].id),
                                restrictModificationToSourceTypes: widget.restrictModificationToSourceTypes,
                              ),
                            ],
                          ),
                        if(selected == widget.npcs[index].id)
                          NPCDisplayWidget(
                            id: selected!,
                            onEditRequested: () => widget.onEditRequested(widget.npcs[index].id),
                            onCloneRequested: () => widget.onCloneRequested(widget.npcs[index].id),
                            onDeleteRequested: () => widget.onDeleteRequested(widget.npcs[index].id),
                            restrictModificationToSourceTypes: widget.restrictModificationToSourceTypes,
                          )
                      ],
                    ),
                  )
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}