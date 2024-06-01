import 'package:flutter/material.dart';

import '../../classes/player_character.dart';
import '../player_character/edit_equipment_tab_armor.dart';
import '../player_character/edit_equipment_tab_weapon.dart';

class PlayerCharacterReviewDialog extends StatefulWidget {
  const PlayerCharacterReviewDialog({ super.key, required this.characters });

  final List<PlayerCharacter> characters;

  @override
  State<PlayerCharacterReviewDialog> createState() => _PlayerCharacterReviewDialogState();
}

class _PlayerCharacterReviewDialogState extends State<PlayerCharacterReviewDialog> {
  List<PlayerCharacter> selectedCharacters = <PlayerCharacter>[];

  @override
  void initState() {
    super.initState();
    selectedCharacters.addAll(widget.characters);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: DefaultTabController(
          length: widget.characters.length,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewportConstraints) {
              var theme = Theme.of(context);

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Revue des personnages",
                      style: theme.textTheme.headlineMedium,
                    ),
                  ),
                  TabBar(
                    tabs: widget.characters.map((PlayerCharacter pc) => Tab(text: pc.name)).toList(),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.5,
                      minWidth: 300.0,
                    ),
                    child: TabBarView(
                      children:
                      widget.characters
                          .map((PlayerCharacter pc) => _PlayerCharacterReviewTab(
                            character: pc,
                            onIncludeChanged: (bool include) {
                              if(include) {
                                if(!selectedCharacters.contains(pc)) {
                                  setState(() {
                                    selectedCharacters.add(pc);
                                  });
                                }
                              }
                              else {
                                setState(() {
                                  selectedCharacters.remove(pc);
                                });
                              }
                            }
                          ))
                          .toList(),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(<PlayerCharacter>[]);
                            },
                            child: const Text('Annuler'),
                          ),
                          const SizedBox(width: 12.0),
                          ElevatedButton(
                            onPressed: selectedCharacters.isEmpty
                                ? null
                                : () {
                              Navigator.of(context).pop(selectedCharacters);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                            ),
                            child: const Text('OK'),
                          )
                        ],
                      )
                  ),
                ],
              );
            }
          ),
      ),
    );
  }
}

class _PlayerCharacterReviewTab extends StatefulWidget {
  const _PlayerCharacterReviewTab({
    required this.character,
    required this.onIncludeChanged,
  });

  final PlayerCharacter character;
  final void Function(bool) onIncludeChanged;

  @override
  State<_PlayerCharacterReviewTab> createState() => _PlayerCharacterReviewTabState();
}

class _PlayerCharacterReviewTabState extends State<_PlayerCharacterReviewTab> {
  bool pcSelected = true;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Checkbox(
                  value: pcSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      pcSelected = value!;
                    });
                    widget.onIncludeChanged(value!);
                  },
                ),
                const SizedBox(width: 8.0),
                Text(
                  'Présent',
                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            ArmorListWidget(
              character: widget.character,
              allowDelete: false,
              showUnequipable: false,
              allowCreate: false,
            ),
            WeaponListWidget(
              character: widget.character,
              allowDelete: false,
              showUnequipable: false,
              allowCreate: false,
            ),
          ],
        ),
      ),
    );
  }
}