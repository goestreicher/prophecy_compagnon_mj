import 'package:flutter/material.dart';

import '../../classes/character/skill.dart';
import '../../classes/weapon.dart';

class WeaponPickerDialog extends StatefulWidget {
  const WeaponPickerDialog({ super.key });

  @override
  State<WeaponPickerDialog> createState() => _WeaponPickerDialogState();
}

class _WeaponPickerDialogState extends State<WeaponPickerDialog> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _weaponController = TextEditingController();
  List<WeaponModel> _weapons = <WeaponModel>[];
  String? _weaponId;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text("Sélectionner l'arme"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownMenu(
            controller: _typeController,
            requestFocusOnTap: true,
            label: const Text('Type'),
            expandedInsets: EdgeInsets.zero,
            dropdownMenuEntries: Skill.fromFamily(SkillFamily.combat)
                // TODO: this static filtering is a bit dirty...
                .where((Skill s) => s.canInstantiate && s != Skill.bouclier)
                .map((Skill s) => DropdownMenuEntry(value: s, label: s.title))
                .toList()
                ..add(
                  DropdownMenuEntry(
                    value: Skill.armesAProjectiles,
                    label: Skill.armesAProjectiles.title
                  )
                ),
            onSelected: (Skill? s) {
              var weapons = <WeaponModel>[];
              if(s != null) {
                for(var id in WeaponModel.idsBySkill(s)) {
                  weapons.add(WeaponModel.get(id)!);
                }
              }
              _weaponController.clear();
              setState(() {
                _weaponId = null;
                _weapons = weapons;
              });
            },
          ),
          const SizedBox(height: 16.0),
          DropdownMenu(
            controller: _weaponController,
            requestFocusOnTap: true,
            label: const Text('Arme'),
            expandedInsets: EdgeInsets.zero,
            dropdownMenuEntries: _weapons
                .map((WeaponModel w) => DropdownMenuEntry(value: w, label: w.name))
                .toList(),
            onSelected: (WeaponModel? w) {
              if(w == null) return;
              _weaponId = w.id;
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
                      if(_typeController.text.isEmpty) return;
                      if(_weaponController.text.isEmpty) return;
                      if(_weaponId == null) return;
                      Navigator.of(context).pop(_weaponId);
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
    );
  }
}