import 'package:flutter/material.dart';

import '../../classes/weapon.dart';

class CombatWeaponSelectionDialog extends StatefulWidget {
  const CombatWeaponSelectionDialog({ super.key, required this.weapons });

  final List<Weapon> weapons;

  @override
  State<CombatWeaponSelectionDialog> createState() => _CombatWeaponSelectionDialogState();
}

class _CombatWeaponSelectionDialogState extends State<CombatWeaponSelectionDialog> {
  final TextEditingController _controller = TextEditingController();
  Weapon? selected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text("Choix de l'arme"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownMenu(
            controller: _controller,
            requestFocusOnTap: true,
            initialSelection: widget.weapons.first,
            onSelected: (Weapon? w) => selected = w,
            dropdownMenuEntries: widget.weapons
              .map((Weapon w) => DropdownMenuEntry(value: w, label: w.model.name))
              .toList(),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if(selected == null) return;
                    Navigator.of(context).pop(selected);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  child: const Text('OK'),
                )
              ],
            )
          )
        ],
      )
    );
  }
}