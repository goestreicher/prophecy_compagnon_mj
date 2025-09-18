import 'package:flutter/material.dart';

import '../../classes/caste/base.dart';
import '../../classes/player_character.dart';

class TableCharactersListWidget extends StatelessWidget {
  const TableCharactersListWidget({
    super.key,
    required this.summaries,
    this.selected,
    required this.onCharacterSelected,
    required this.onCharacterEdited,
    required this.onCharacterDeleted,
    this.onCharacterCreationRequested,
    this.onCharacterImportRequested,
  });

  final List<PlayerCharacterSummary> summaries;
  final String? selected;
  final void Function(String?) onCharacterSelected;
  final void Function(String) onCharacterEdited;
  final void Function(String) onCharacterDeleted;
  final void Function()? onCharacterCreationRequested;
  final void Function()? onCharacterImportRequested;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    Widget? createButton;

    if(onCharacterCreationRequested != null || onCharacterImportRequested != null) {
      createButton = MenuAnchor(
        alignmentOffset: const Offset(0, 4),
        builder: (BuildContext context, MenuController controller, Widget? child) {
          return IconButton.filled(
            icon: const Icon(Icons.add),
            padding: const EdgeInsets.all(12.0),
            tooltip: 'Créer / Importer',
            onPressed: () {
              if(controller.isOpen) {
                controller.close();
              }
              else {
                controller.open();
              }
            },
          );
        },
        menuChildren: [
          MenuItemButton(
            child: const Row(
              children: [
                Icon(Icons.create),
                SizedBox(width: 4.0),
                Text('Nouveau PJ'),
              ],
            ),
            onPressed: () => onCharacterCreationRequested!(),
          ),
          MenuItemButton(
            child: const Row(
              children: [
                Icon(Icons.publish),
                SizedBox(width: 4.0),
                Text('Importer un PJ'),
              ],
            ),
            onPressed: () => onCharacterImportRequested!(),
          ),
        ],
      );
    }

    return Column(
      children: [
        if(createButton != null)
          createButton,
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: summaries.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color: selected == summaries[index].id
                  ? theme.colorScheme.surfaceContainerHighest
                  : null,
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: theme.colorScheme.surface,
                  onTap: () async {
                    if(selected == summaries[index].id) {
                      onCharacterSelected(null);
                    }
                    else {
                      onCharacterSelected(summaries[index].id);
                    }
                    // var saved = await Navigator.of(context).push(
                    //   MaterialPageRoute(builder: (context) => PlayerCharacterEditPage(id: summaries[index].id)),
                    // );
                    // if(saved != null && saved) {
                    //   onCharacterEdited(summaries[index].id);
                    // }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      spacing: 12.0,
                      children: [
                        if(summaries[index].icon != null)
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.0),
                              image: DecorationImage(
                                image: MemoryImage(
                                  summaries[index].icon!.data
                                )
                              ),
                            ),
                          ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                summaries[index].name,
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Joueur : ${summaries[index].player}',
                                style: theme.textTheme.bodySmall,
                              ),
                              Text(
                                '${summaries[index].caste.title} (${Caste.statusName(summaries[index].caste, summaries[index].casteStatus)})',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            var confirm = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Confirmer la suppression'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Supprimer ce personnage ?'),
                                    const SizedBox(height: 8.0),
                                    const Text('Cette action ne peut pas être annulée.'),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text('Annuler'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text('Supprimer'),
                                  ),
                                ]
                              )
                            );
                            if(confirm == null || !confirm) return;

                            onCharacterDeleted(summaries[index].id);
                            summaries.removeAt(index);
                          },
                        ),
                      ],
                    ),
                  ),
                )
              );
            }
          ),
        ),
      ],
    );
  }
}