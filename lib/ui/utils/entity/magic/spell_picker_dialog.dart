import 'package:flutter/material.dart';

import '../../../../classes/magic.dart';
import '../../../../classes/magic_spell.dart';
import 'display_magic_spell_widget.dart';

class MagicSpellPickerDialog extends StatefulWidget {
  const MagicSpellPickerDialog({
    super.key,
    this.sphere,
    this.maxLevel = 3,
    this.maxComplexity,
  });

  final MagicSphere? sphere;
  final int maxLevel;
  final int? maxComplexity;

  @override
  State<MagicSpellPickerDialog> createState() => _MagicSpellPickerDialogState();
}

class _MagicSpellPickerDialogState extends State<MagicSpellPickerDialog> {
  final TextEditingController sphereController = TextEditingController();
  final TextEditingController levelController = TextEditingController();
  final TextEditingController spellController = TextEditingController();

  MagicSphere? sphere;
  int? level;
  MagicSpell? spell;
  
  @override
  void initState() {
    super.initState();
    
    sphere = widget.sphere;
  }

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
                    if(widget.sphere == null)
                      DropdownMenu(
                        controller: sphereController,
                        label: const Text('Sphère'),
                        requestFocusOnTap: true,
                        expandedInsets: EdgeInsets.zero,
                        onSelected: (MagicSphere? sphere) {
                          setState(() {
                            this.sphere = sphere;
                            spellController.clear();
                            spell = null;
                          });
                        },
                        dropdownMenuEntries: MagicSphere.values
                          .map((MagicSphere s) => DropdownMenuEntry(value: s, label: s.title))
                          .toList(),
                      ),
                    DropdownMenu(
                      controller: levelController,
                      label: const Text('Niveau'),
                      requestFocusOnTap: true,
                      expandedInsets: EdgeInsets.zero,
                      onSelected: (int? i) {
                        setState(() {
                          level = i;
                          spellController.clear();
                          spell = null;
                        });
                      },
                      dropdownMenuEntries: List.generate(
                        widget.maxLevel,
                        (int i) => DropdownMenuEntry(
                            value: i+1, label: "Niveau ${(i+1).toString()}"
                        ),
                      ),
                    ),
                    DropdownMenu(
                      controller: spellController,
                      label: const Text('Sort'),
                      requestFocusOnTap: true,
                      expandedInsets: EdgeInsets.zero,
                      onSelected: (MagicSpell? spell) {
                        setState(() {
                          this.spell = spell;
                        });
                      },
                      dropdownMenuEntries: sphere == null || level == null ?
                        <DropdownMenuEntry<MagicSpell>>[] :
                        MagicSpell.filteredList(
                            MagicSpellFilter(
                              sphere: sphere!,
                              level: level!,
                              complexity: widget.maxComplexity,
                            )
                          )
                          .map((MagicSpell spell) => DropdownMenuEntry(value: spell, label: spell.name))
                          .toList(),
                    ),
                  ],
                ),
              ),
              if(spell != null)
                SizedBox(
                  width: 600,
                  child: DisplayMagicSpellWidget(spell: spell!)
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
                    if(spell == null) return;
                    Navigator.of(context).pop(spell);
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