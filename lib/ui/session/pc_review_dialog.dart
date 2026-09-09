import 'package:flutter/material.dart';

import '../../classes/player_character.dart';
import '../utils/entity/equipment/edit_armor_widget.dart';
import '../utils/entity/equipment/edit_clothes_widget.dart';
import '../utils/entity/equipment/edit_jewels_widget.dart';
import '../utils/entity/equipment/edit_weapons_widget.dart';
import '../utils/session/messages/responses/action/pc_review_result.dart';

class PlayerCharacterReviewDialog extends StatefulWidget {
  const PlayerCharacterReviewDialog({ super.key, required this.characters });

  final List<PlayerCharacter> characters;

  @override
  State<PlayerCharacterReviewDialog> createState() => _PlayerCharacterReviewDialogState();
}

class _PlayerCharacterReviewDialogState extends State<PlayerCharacterReviewDialog> {
  PlayerCharacter? selected;
  List<PlayerCharacter> charactersPresent = <PlayerCharacter>[];
  bool saving = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Widget characterWidget;
    if(selected == null) {
      characterWidget = Center(
        child: SizedBox.expand(),
      );
    }
    else {
      if(charactersPresent.contains(selected)) {
        characterWidget = _PlayerCharacterReviewWidget(
          character: selected!,
        );
      }
      else {
        characterWidget = Center(
          child: Text(
            'Personnage absent',
          ),
        );
      }
    }

    return AlertDialog(
      title: const Text('Revue des personnages'),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        width: 900.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12.0,
          children: [
            Expanded(
              child: _PlayerCharacterReviewList(
                characters: widget.characters,
                onAdded: (PlayerCharacter p) => setState(() {
                  charactersPresent.add(p);
                }),
                onRemoved: (PlayerCharacter p) => setState(() {
                  charactersPresent.remove(p);
                }),
                onSelected: (PlayerCharacter p) => setState(() {
                  selected = p;
                }),
              ),
            ),
            Expanded(
              flex: 2,
              child: characterWidget
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: charactersPresent.isEmpty || saving ? null : () async {
            setState(() {
              saving = true;
            });
            for(var pc in charactersPresent) {
              await PlayerCharacterStore().save(pc);
            }
            setState(() {
              saving = false;
            });
            if(!context.mounted) return;

            Navigator.of(context).pop(
              SessionPlayerCharacterReviewResult(
                selected: charactersPresent,
              )
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          child: saving ? const Text('Sauvegarde') : const Text('OK'),
        ),
      ],
    );
  }
}

class _PlayerCharacterReviewList extends StatefulWidget {
  const _PlayerCharacterReviewList({
    required this.characters,
    required this.onAdded,
    required this.onRemoved,
    required this.onSelected,
  });

  final List<PlayerCharacter> characters;
  final void Function(PlayerCharacter) onAdded;
  final void Function(PlayerCharacter) onRemoved;
  final void Function(PlayerCharacter) onSelected;

  @override
  State<_PlayerCharacterReviewList> createState() => _PlayerCharacterReviewListState();
}

class _PlayerCharacterReviewListState extends State<_PlayerCharacterReviewList> {
  int? selected;
  List<String> present = <String>[];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return ListView.separated(
      itemCount: widget.characters.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          selected: selected == index,
          selectedTileColor: theme.highlightColor,
          title: Text(
            widget.characters[index].name,
            overflow: TextOverflow.ellipsis,
            style: present.contains(widget.characters[index].id)
              ? null
              : TextStyle(color: theme.disabledColor),
          ),
          trailing: Switch(
            value: present.contains(widget.characters[index].id),
            onChanged: (bool v) {
              setState(() {
                if(v && !present.contains(widget.characters[index].id)) {
                  widget.onAdded(widget.characters[index]);
                  widget.onSelected(widget.characters[index]);
                  present.add(widget.characters[index].id);
                  selected = index;
                }
                else {
                  widget.onRemoved(widget.characters[index]);
                  present.remove(widget.characters[index].id);
                }
              });
            },
          ),
          onTap: () => setState(() {
            widget.onSelected(widget.characters[index]);
            selected = index;
          }),
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(),
    );
  }
}

class _PlayerCharacterReviewWidget extends StatelessWidget {
  const _PlayerCharacterReviewWidget({
    required this.character,
  });

  final PlayerCharacter character;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 8.0, 12.0, 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8.0,
          children: [
            EntityEditWeaponsWidget(
              entity: character,
              showUnequipable: false,
              showStored: false,
              allowCreate: false,
              allowDelete: false,
            ),
            EntityEditArmorWidget(
              entity: character,
              showUnequipable: false,
              showStored: false,
              allowCreate: false,
              allowDelete: false,
            ),
            EntityEditClothesWidget(
              entity: character,
              showStored: false,
              allowCreate: false,
              allowDelete: false,
            ),
            EntityEditJewelsWidget(
              entity: character,
              showStored: false,
              allowCreate: false,
              allowDelete: false,
            ),
          ],
        ),
      ),
    );
  }
}