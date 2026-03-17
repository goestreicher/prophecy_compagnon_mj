import 'package:flutter/material.dart';

import '../../../../classes/equipment/equipment.dart';
import '../../../../classes/equipment/jewel.dart';

class JewelPickerDialog extends StatefulWidget {
  const JewelPickerDialog({ super.key });

  @override
  State<JewelPickerDialog> createState() => _JewelPickerDialogState();
}

class _JewelPickerDialogState extends State<JewelPickerDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  EquipableItemSlot? slot;
  List<JewelModel> jewels = <JewelModel>[];
  JewelModel? model;
  EquipmentMetal metal = EquipmentMetal.none;
  TextEditingController aliasController = TextEditingController();
  EquipmentQuality quality = EquipmentQuality.normal;

  void loadJewels() {
    jewels.clear();
    if(slot != null) {
      for (var jid in JewelModel.idsByBodyPart(slot!)) {
        var j = JewelModel.get(jid);
        if (j == null) continue;
        jewels.add(j);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choisir le bijou'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16.0,
          children: [
            DropdownMenuFormField<EquipableItemSlot>(
              requestFocusOnTap: true,
              label: const Text('Emplacement'),
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
              ),
              expandedInsets: EdgeInsets.zero,
              dropdownMenuEntries: JewelModel.supportedBodyParts()
                .map((EquipableItemSlot s) => DropdownMenuEntry(value: s, label: s.title))
                .toList(),
              validator: (EquipableItemSlot? l) {
                if(l == null) return 'Valeur manquante';
                return null;
              },
              onSelected: (EquipableItemSlot? l) {
                setState(() {
                  slot = l;
                  model = null;
                  metal = EquipmentMetal.none;
                  loadJewels();
                });
              },
            ),
            DropdownMenuFormField<JewelModel>(
              requestFocusOnTap: true,
              label: const Text('Bijou'),
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
              ),
              expandedInsets: EdgeInsets.zero,
              dropdownMenuEntries: jewels
                .map((JewelModel j) => DropdownMenuEntry(value: j, label: j.name))
                .toList(),
              validator: (JewelModel? j) {
                if(j == null) return 'Valeur manquante';
                return null;
              },
              onSelected: (JewelModel? j) {
                setState(() {
                  model = j;
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
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Annuler'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: const Text('OK'),
          onPressed: () async {
            if(!formKey.currentState!.validate()) return;

            var jewel = Jewel.create(
              model: model!,
              alias: aliasController.text.isEmpty ? null : aliasController.text,
              quality: quality,
              metal: metal,
            );
            Navigator.of(context).pop(jewel);
          },
        )
      ],
    );
  }
}