import 'package:flutter/material.dart';

import '../../../../classes/equipment/armor.dart';
import '../../../../classes/equipment/enums.dart';

class ArmorPickerDialog extends StatefulWidget {
  const ArmorPickerDialog({ super.key });

  @override
  State<ArmorPickerDialog> createState() => _ArmorPickerDialogState();
}

class _ArmorPickerDialogState extends State<ArmorPickerDialog> {
  final TextEditingController typeController = TextEditingController();
  List<ArmorModel> armors = <ArmorModel>[];
  final TextEditingController armorController = TextEditingController();
  ArmorModel? model;
  EquipmentMetal metal = EquipmentMetal.none;
  EquipmentQuality quality = EquipmentQuality.normal;
  final TextEditingController aliasController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text("Sélectionner l'armure"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16.0,
        children: [
          DropdownMenu(
            controller: typeController,
            requestFocusOnTap: true,
            label: const Text('Type'),
            expandedInsets: EdgeInsets.zero,
            dropdownMenuEntries:
            ArmorType.values.map((ArmorType t) => DropdownMenuEntry(value: t, label: t.title)).toList(),
            onSelected: (ArmorType? t) {
              var armors = <ArmorModel>[];
              if(t != null) {
                for(var id in ArmorModel.idsByType(t)) {
                  armors.add(ArmorModel.get(id)!);
                }
              }
              armorController.clear();
              setState(() {
                model = null;
                metal = EquipmentMetal.none;
                this.armors = armors;
              });
            },
          ),
          DropdownMenu(
            controller: armorController,
            requestFocusOnTap: true,
            label: const Text('Armure'),
            expandedInsets: EdgeInsets.zero,
            dropdownMenuEntries: armors
              .map((ArmorModel a) => DropdownMenuEntry(value: a, label: a.name))
              .toList(),
            onSelected: (ArmorModel? a) {
              setState(() {
                model = a;
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

                    var armor = Armor.create(
                      model: model!,
                      alias: aliasController.text.isEmpty ? null : aliasController.text,
                      quality: quality,
                      metal: metal,
                    );

                    Navigator.of(context).pop(armor);
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