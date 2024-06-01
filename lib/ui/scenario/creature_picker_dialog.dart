import 'package:flutter/material.dart';

import '../../classes/creature.dart';

class CreaturePickerDialog extends StatefulWidget {
  const CreaturePickerDialog({ super.key });

  @override
  State<CreaturePickerDialog> createState() => CreaturePickerDialogState();
}

class CreaturePickerDialogState extends State<CreaturePickerDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _creatureController = TextEditingController();
  List<CreatureModel> _creatures = <CreatureModel>[];
  String? _selectedCreature;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Sélectionner la créature'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownMenu(
              controller: _categoryController,
              requestFocusOnTap: true,
              label: const Text('Catégorie'),
              expandedInsets: EdgeInsets.zero,
              dropdownMenuEntries:
                CreatureCategory.values.map((CreatureCategory c) =>
                  DropdownMenuEntry<CreatureCategory>(value: c, label: c.title)
                ).toList(),
              onSelected: (CreatureCategory? c) {
                  if(c == null) return;
                  setState(() {
                    _selectedCreature = null;
                    _creatures = CreatureModel.forCategory(c);
                  });
                }
            ),
            const SizedBox(height: 12.0),
            DropdownMenu(
              controller: _creatureController,
              requestFocusOnTap: true,
              label: const Text('Créature'),
              expandedInsets: EdgeInsets.zero,
              dropdownMenuEntries:
                _creatures.map((CreatureModel c) =>
                  DropdownMenuEntry<CreatureModel>(value: c, label: c.name)
                ).toList(),
              onSelected: (CreatureModel? c) {
                if(c == null) {
                  _selectedCreature = null;
                  return;
                }
                _selectedCreature = c.id;
              },
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
                        if(_categoryController.text.isEmpty) return;
                        if(_creatureController.text.isEmpty) return;
                        Navigator.of(context).pop(_selectedCreature);
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
        ),
      )
    );
  }
}