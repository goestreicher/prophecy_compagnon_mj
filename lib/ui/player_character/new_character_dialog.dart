import 'package:flutter/material.dart';

import '../../classes/calendar.dart';
import '../../classes/player_character.dart';

class NewPlayerCharacterDialog extends StatefulWidget {
  const NewPlayerCharacterDialog({
    super.key,
    required this.formKey
  });

  @override
  State<NewPlayerCharacterDialog> createState() => _NewPlayerCharacterDialogState();

  final GlobalKey<FormState> formKey;
}

class _NewPlayerCharacterDialogState extends State<NewPlayerCharacterDialog> {
  final TextEditingController characterNameController = TextEditingController();
  final TextEditingController playerNameController = TextEditingController();

  Augure? augure;
  PlayerCharacterPrivilegedExperience? privilegedExperience;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Nouveau PJ'),
      content: Form(
        key: widget.formKey,
        child: Column(
          spacing: 12,
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
            DropdownMenuFormField(
              initialSelection: augure,
              requestFocusOnTap: true,
              label: const Text('Augure'),
              expandedInsets: EdgeInsets.zero,
              dropdownMenuEntries:
                Augure.values.map<DropdownMenuEntry<Augure>>((Augure augure) {
                  return DropdownMenuEntry<Augure>(
                      value: augure,
                      label: augure.title
                  );
                }).toList(),
              onSelected: (Augure? a) => augure = a,
              validator: (Augure? a) {
                if(a == null) return 'Valeur obligatoire';
                return null;
              },
            ),
            DropdownMenuFormField(
              initialSelection: privilegedExperience,
              requestFocusOnTap: true,
              label: const Text('Optique de progression'),
              expandedInsets: EdgeInsets.zero,
              dropdownMenuEntries: PlayerCharacterPrivilegedExperience.values
                .map(
                  (PlayerCharacterPrivilegedExperience e) =>
                    DropdownMenuEntry(value: e, label: e.title),
                )
                .toList(),
              onSelected: (PlayerCharacterPrivilegedExperience? e) =>
                privilegedExperience = e,
              validator: (PlayerCharacterPrivilegedExperience? e) {
                if(e == null) return 'Valeur obligatoire';
                return null;
              },
            ),
            Row(
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

                    PlayerCharacter char = PlayerCharacter(
                      name: characterName,
                      player: playerName,
                      augure: augure!,
                      privilegedExperience: privilegedExperience!,
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
            ),
          ],
        )
      ),
    );
  }
}
