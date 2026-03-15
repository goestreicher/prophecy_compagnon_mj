import 'package:flutter/material.dart';

import '../../../../classes/equipment/cloth.dart';
import '../../../../classes/equipment/equipment.dart';

class ClothPickerDialog extends StatefulWidget {
  const ClothPickerDialog({ super.key });

  @override
  State<ClothPickerDialog> createState() => _ClothPickerDialogState();
}

class _ClothPickerDialogState extends State<ClothPickerDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  EquipableItemSlot? slot;
  List<ClothModel> clothes = <ClothModel>[];
  ClothModel? model;
  EquipmentQuality quality = EquipmentQuality.normal;

  void loadClothes() {
    clothes.clear();
    if(slot != null) {
      for(var cid in ClothModel.idsByBodyPart(slot!)) {
        var c = ClothModel.get(cid);
        if(c == null) continue;
        clothes.add(c);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choisir le vêtement'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12.0,
          children: [
            DropdownMenuFormField<EquipableItemSlot>(
              requestFocusOnTap: true,
              label: const Text('Emplacement'),
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
              ),
              expandedInsets: EdgeInsets.zero,
              dropdownMenuEntries: ClothModel.supportedBodyParts()
                .map((EquipableItemSlot s) => DropdownMenuEntry(value: s, label: s.title))
                .toList(),
              validator: (EquipableItemSlot? l) {
                if(l == null) return 'Valeur manquante';
                return null;
              },
              onSelected: (EquipableItemSlot? l) {
                setState(() {
                  slot = l;
                  loadClothes();
                });
              },
            ),
            DropdownMenuFormField<ClothModel>(
              requestFocusOnTap: true,
              label: const Text('Vêtement'),
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
              ),
              expandedInsets: EdgeInsets.zero,
              dropdownMenuEntries: clothes
                  .map((ClothModel c) => DropdownMenuEntry(value: c, label: c.name))
                  .toList(),
              validator: (ClothModel? c) {
                if(c == null) return 'Valeur manquante';
                return null;
              },
              onSelected: (ClothModel? c) {
                model = c;
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

            var cloth = Cloth.create(model: model!, quality: quality);
            Navigator.of(context).pop(cloth);
          },
        )
      ],
    );
  }
}