import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../classes/creature.dart';
import '../../../classes/object_source.dart';
import 'list_filter.dart';

class CreatureActionButtons extends StatelessWidget {
  const CreatureActionButtons({
    super.key,
    required this.creature,
    required this.onEdit,
    required this.onClone,
    required this.onDelete,
    this.restrictModificationToSourceTypes,
    this.highlight = false,
  });

  final CreatureSummary creature;
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

    if(!creature.location.type.canWrite) {
      canModify = false;
      canModifyMessage = 'Modification impossible (créature en lecture seule)';
    }
    else if(restrictModificationToSourceTypes != null && !restrictModificationToSourceTypes!.contains(creature.source.type)) {
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
              var model = await Creature.get(creature.id);
              var jsonStr = json.encode(model!.toJson());
              await FilePicker.platform.saveFile(
                fileName: 'creature-${creature.id}.json',
                bytes: utf8.encode(jsonStr),
              );
            },
          )
        ],
      ),
    );
  }
}

class CreaturesListWidget extends StatelessWidget {
  const CreaturesListWidget({
    super.key,
    required this.creatures,
    this.filter,
    this.selected,
    required this.onSelected,
    required this.onEditRequested,
    required this.onCloneRequested,
    required this.onDeleteRequested,
    this.restrictModificationToSourceTypes,
  });

  final List<CreatureSummary> creatures;
  final CreatureListFilter? filter;
  final String? selected;
  final void Function(String?) onSelected;
  final void Function(String) onEditRequested;
  final void Function(String) onCloneRequested;
  final void Function(String) onDeleteRequested;
  final List<ObjectSourceType>? restrictModificationToSourceTypes;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var filtered = creatures.where(
        (CreatureSummary c) => filter == null || filter!.match(c)
    ).toList();

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (BuildContext context, int index) {
        var isSelected = selected == filtered[index].id;

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
                        ),
                      ),
                      CreatureActionButtons(
                        creature: filtered[index],
                        highlight: isSelected,
                        onEdit: () => onEditRequested(filtered[index].id),
                        onClone: () => onCloneRequested(filtered[index].id),
                        onDelete: () => onDeleteRequested(filtered[index].id),
                        restrictModificationToSourceTypes: restrictModificationToSourceTypes,
                      )
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