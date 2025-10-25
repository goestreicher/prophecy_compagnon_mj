import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../classes/non_player_character.dart';
import '../../../classes/object_source.dart';

class NPCActionButtons extends StatelessWidget {
  const NPCActionButtons({
    super.key,
    required this.npc,
    required this.onEdit,
    required this.onClone,
    required this.onDelete,
    this.restrictModificationToSourceTypes,
    this.highlight = false,
  });

  final NonPlayerCharacterSummary npc;
  final void Function() onEdit;
  final void Function() onClone;
  final void Function() onDelete;
  final List<ObjectSourceType>? restrictModificationToSourceTypes;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    bool canModify = true;
    String? canModifyMessage;

    if(!npc.location.type.canWrite) {
      canModify = false;
      canModifyMessage = 'Modification impossible (PNJ en lecture seule)';
    }
    else if(restrictModificationToSourceTypes != null && !restrictModificationToSourceTypes!.contains(npc.source.type)) {
      canModify = false;
      canModifyMessage = 'Modification impossible depuis cette page';
    }

    return IconButtonTheme(
      data: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: highlight ? theme.colorScheme.onPrimary : null,
        )
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: !canModify
                ? canModifyMessage!
                : 'Modifier',
            onPressed: !canModify
                ? null
                : () => onEdit(),
          ),
          IconButton(
            icon: const Icon(Icons.content_copy_outlined),
            tooltip: 'Cloner',
            onPressed: () => onClone(),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: !canModify
                ? canModifyMessage!
                : 'Supprimer',
            onPressed: !canModify
                ? null
                : () => onDelete(),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Télécharger (JSON)',
            onPressed: () async {
              var model = await NonPlayerCharacter.get(npc.id);
              var jsonStr = json.encode(model!.toJson());
              await FilePicker.platform.saveFile(
                fileName: 'pnj-${npc.id}.json',
                bytes: utf8.encode(jsonStr),
              );
            },
          ),
        ],
      ),
    );
  }
}

class NPCListWidget extends StatelessWidget {
  const NPCListWidget({
    super.key,
    required this.npcs,
    this.selected,
    required this.onSelected,
    required this.onEditRequested,
    required this.onCloneRequested,
    required this.onDeleteRequested,
    this.restrictModificationToSourceTypes,
  });

  final List<NonPlayerCharacterSummary> npcs;
  final String? selected;
  final void Function(String?) onSelected;
  final void Function(String) onEditRequested;
  final void Function(String) onCloneRequested;
  final void Function(String) onDeleteRequested;
  final List<ObjectSourceType>? restrictModificationToSourceTypes;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return ListView.builder(
      itemCount: npcs.length,
      itemBuilder: (BuildContext context, int index) {
        var isSelected = npcs[index].id == selected;

        return Center(
          child: GestureDetector(
            onTap: () {
              onSelected(isSelected ? null : npcs[index].id);
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Card(
                color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surfaceContainerLow,
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          npcs[index].name,
                          style: theme.textTheme.bodyMedium!.copyWith(
                            fontWeight: isSelected
                                ? null
                                : FontWeight.bold,
                            color: isSelected
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      NPCActionButtons(
                        npc: npcs[index],
                        highlight: isSelected,
                        onEdit: () => onEditRequested(npcs[index].id),
                        onClone: () => onCloneRequested(npcs[index].id),
                        onDelete: () => onDeleteRequested(npcs[index].id),
                        restrictModificationToSourceTypes: restrictModificationToSourceTypes,
                      ),
                    ],
                  ),
                )
              ),
            ),
          ),
        );
      }
    );
  }
}