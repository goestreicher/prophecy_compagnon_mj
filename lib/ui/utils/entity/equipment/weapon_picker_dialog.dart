import 'package:flutter/material.dart';

import '../../../../classes/entity/skill.dart';
import '../../../../classes/equipment/equipment.dart';
import '../../../../classes/equipment/weapon.dart';

class WeaponPickerDialog extends StatefulWidget {
  const WeaponPickerDialog({ super.key });

  @override
  State<WeaponPickerDialog> createState() => _WeaponPickerDialogState();
}

class _WeaponPickerDialogState extends State<WeaponPickerDialog> {
  final TextEditingController typeController = TextEditingController();
  final TextEditingController weaponController = TextEditingController();
  List<WeaponModel> weapons = <WeaponModel>[];
  WeaponModel? model;
  EquipmentMetal metal = EquipmentMetal.none;
  EquipmentQuality quality = EquipmentQuality.normal;
  final TextEditingController aliasController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text("Sélectionner l'arme"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16.0,
        children: [
          DropdownMenu(
            controller: typeController,
            requestFocusOnTap: true,
            label: const Text('Type'),
            expandedInsets: EdgeInsets.zero,
            dropdownMenuEntries: WeaponModel.weaponSkills()
              .map((Skill s) => DropdownMenuEntry(value: s, label: s.title))
              .toList(),
            onSelected: (Skill? s) {
              var weapons = <WeaponModel>[];
              if(s != null) {
                for(var id in WeaponModel.idsBySkill(s)) {
                  weapons.add(WeaponModel.get(id)!);
                }
              }
              weaponController.clear();
              setState(() {
                model = null;
                metal = EquipmentMetal.none;
                this.weapons = weapons;
              });
            },
          ),
          DropdownMenu(
            controller: weaponController,
            requestFocusOnTap: true,
            label: const Text('Arme'),
            expandedInsets: EdgeInsets.zero,
            dropdownMenuEntries: weapons
              .map((WeaponModel w) => DropdownMenuEntry(value: w, label: w.name))
              .toList(),
            onSelected: (WeaponModel? w) {
              setState(() {
                model = w;
                metal = model?.supportsMetal ?? false
                  ? EquipmentMetal.iron
                  : EquipmentMetal.none;
              });
            },
          ),
          if(model?.supportsMetal ?? false)
            DropdownMenuFormField<EquipmentMetal>(
              initialSelection: EquipmentMetal.iron,
              requestFocusOnTap: true,
              label: const Text('Métal'),
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
              ),
              expandedInsets: EdgeInsets.zero,
              dropdownMenuEntries: EquipmentMetal.values
                .map((EquipmentMetal m) => DropdownMenuEntry(value: m, label: m.title))
                .toList(),
              validator: (EquipmentMetal? m) {
                if(m == null) return 'Valeur manquante';
                return null;
              },
              onSelected: (EquipmentMetal? m) {
                if(m == null) return;
                metal = m;
              },
            ),
          DropdownMenuFormField<EquipmentQuality>(
            initialSelection: quality,
            requestFocusOnTap: true,
            label: const Text('Qualité'),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
            ),
            expandedInsets: EdgeInsets.zero,
            dropdownMenuEntries: EquipmentQuality.values
              .map((EquipmentQuality q) => DropdownMenuEntry(value: q, label: q.title))
              .toList(),
            validator: (EquipmentQuality? q) {
              if(q == null) return 'Valeur manquante';
              return null;
            },
            onSelected: (EquipmentQuality? q) {
              if(q == null) return;
              quality = q;
            },
          ),
          TextField(
            controller: aliasController,
            decoration: InputDecoration(
              labelText: 'Alias',
              border: OutlineInputBorder(),
            ),
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
                    if(model == null) return;

                    var weapon = Weapon.create(
                      model: model!,
                      alias: aliasController.text.isEmpty ? null : aliasController.text,
                      quality: quality,
                      metal: metal,
                    );

                    Navigator.of(context).pop(weapon);
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