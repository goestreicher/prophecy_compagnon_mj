import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../classes/non_player_character.dart';
import '../../../classes/object_source.dart';
import 'list_filter.dart';

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
    this.filter,
    this.selected,
    required this.onSelected,
    required this.onEditRequested,
    required this.onCloneRequested,
    required this.onDeleteRequested,
    this.restrictModificationToSourceTypes,
  });

  final List<NonPlayerCharacterSummary> npcs;
  final NPCListFilter? filter;
  final String? selected;
  final void Function(String?) onSelected;
  final void Function(String) onEditRequested;
  final void Function(String) onCloneRequested;
  final void Function(String) onDeleteRequested;
  final List<ObjectSourceType>? restrictModificationToSourceTypes;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var filtered = npcs.where(
        (NonPlayerCharacterSummary npc) => filter == null || filter!.match(npc)
    ).toList();

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (BuildContext context, int index) {
        var isSelected = filtered[index].id == selected;

        return Center(
          child: GestureDetector(
            onTap: () {
              onSelected(isSelected ? null : filtered[index].id);
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
                          filtered[index].name,
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
                        npc: filtered[index],
                        highlight: isSelected,
                        onEdit: () => onEditRequested(filtered[index].id),
                        onClone: () => onCloneRequested(filtered[index].id),
                        onDelete: () => onDeleteRequested(filtered[index].id),
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