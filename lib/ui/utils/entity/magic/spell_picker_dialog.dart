import 'package:flutter/material.dart';

import '../../../../classes/magic.dart';
import '../../../../classes/magic_spell.dart';
import 'display_magic_spell_widget.dart';

class MagicSpellPickerDialog extends StatefulWidget {
  const MagicSpellPickerDialog({ super.key });

  @override
  State<MagicSpellPickerDialog> createState() => _MagicSpellPickerDialogState();
}

class _MagicSpellPickerDialogState extends State<MagicSpellPickerDialog> {
  final TextEditingController _sphereController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _spellController = TextEditingController();

  MagicSphere? _sphere;
  int? _level;
  MagicSpell? _spell;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text("Sélectionner le sort"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16.0,
        children: [
          Row(
            spacing: 16.0,
            children: [
              SizedBox(
                width: 250,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 16.0,
                  children: [
                    DropdownMenu(
                      controller: _sphereController,
                      label: const Text('Sphère'),
                      requestFocusOnTap: true,
                      expandedInsets: EdgeInsets.zero,
                      onSelected: (MagicSphere? sphere) {
                        setState(() {
                          _sphere = sphere;
                          _spellController.clear();
                          _spell = null;
                        });
                      },
                      dropdownMenuEntries: MagicSphere.values
                        .map((MagicSphere s) => DropdownMenuEntry(value: s, label: s.title))
                        .toList(),
                    ),
                    DropdownMenu(
                      controller: _levelController,
                      label: const Text('Niveau'),
                      requestFocusOnTap: true,
                      expandedInsets: EdgeInsets.zero,
                      onSelected: (int? i) {
                        setState(() {
                          _level = i;
                          _spellController.clear();
                          _spell = null;
                        });
                      },
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(value: 1, label: "Niveau 1"),
                        DropdownMenuEntry(value: 2, label: "Niveau 2"),
                        DropdownMenuEntry(value: 3, label: "Niveau 3"),
                      ]
                    ),
                    DropdownMenu(
                      controller: _spellController,
                      label: const Text('Sort'),
                      requestFocusOnTap: true,
                      expandedInsets: EdgeInsets.zero,
                      onSelected: (MagicSpell? spell) {
                        setState(() {
                          _spell = spell;
                        });
                      },
                      dropdownMenuEntries: _sphere == null || _level == null ?
                        <DropdownMenuEntry<MagicSpell>>[] :
                        MagicSpell.filteredList(MagicSpellFilter(sphere: _sphere!, level: _level!))
                          .map((MagicSpell spell) => DropdownMenuEntry(value: spell, label: spell.name))
                          .toList(),
                    ),
                  ],
                ),
              ),
              if(_spell != null)
                SizedBox(
                  width: 600,
                  child: DisplayMagicSpellWidget(spell: _spell!)
                ),
            ],
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
                    if(_spell == null) return;
                    Navigator.of(context).pop(_spell);
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
    );
  }
}