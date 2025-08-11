import 'package:flutter/material.dart';

import '../../classes/calendar.dart';
import '../../classes/object_location.dart';
import '../../classes/player_character.dart';

class NewPlayerCharacterDialog extends StatelessWidget {
  NewPlayerCharacterDialog({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Nouveau PJ'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              autofocus: true,
              controller: characterNameController,
              decoration: const InputDecoration(
                labelText: 'Nom du personnage',
                border: OutlineInputBorder(),
              ),
              validator: (String? value) {
                if(value == null || value.isEmpty) {
                  return 'Valeur obligatoire';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 12.0,
            ),
            TextFormField(
              controller: playerNameController,
              decoration: const InputDecoration(
                labelText: 'Nom du joueur',
                border: OutlineInputBorder(),
              ),
              validator: (String? value) {
                if(value == null || value.isEmpty) {
                  return 'Valeur obligatoire';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 12.0,
            ),
            DropdownMenu<Augure>(
              controller: augureController,
              requestFocusOnTap: true,
              label: const Text('Augure'),
              initialSelection: Augure.pierre,
              dropdownMenuEntries:
                Augure.values.map<DropdownMenuEntry<Augure>>((Augure augure) {
                  return DropdownMenuEntry<Augure>(
                      value: augure,
                      label: augure.title
                  );
                }).toList(),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Annuler'),
                    ),
                    const SizedBox(width: 12.0),
                    ElevatedButton(
                      onPressed: () {
                        var characterName = characterNameController.text;
                        var playerName = playerNameController.text;
                        var augure = Augure.byTitle(augureController.text)!;

                        PlayerCharacter char = PlayerCharacter(
                          location: ObjectLocation.memory,
                          name: characterName,
                          player: playerName,
                          augure: augure,
                        );
                        Navigator.of(context).pop(char);
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
        )
      ),
    );
  }

  final GlobalKey<FormState> formKey;
  final TextEditingController characterNameController = TextEditingController();
  final TextEditingController playerNameController = TextEditingController();
  final TextEditingController augureController = TextEditingController();
}
