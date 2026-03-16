import 'package:flutter/material.dart';

import '../../../../classes/equipment/equipment.dart';
import '../../../../classes/equipment/misc_gear.dart';

class MiscGearPickerDialog extends StatefulWidget {
  const MiscGearPickerDialog({ super.key });

  @override
  State<MiscGearPickerDialog> createState() => _MiscGearPickerDialogState();
}

class _MiscGearPickerDialogState extends State<MiscGearPickerDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<MiscGearModel> items = <MiscGearModel>[];
  MiscGearModel? model;
  TextEditingController aliasController = TextEditingController();
  EquipmentQuality quality = EquipmentQuality.normal;
  
  @override
  void initState() {
    super.initState();
    
    for(var mgid in MiscGearModel.ids()) {
      var item = MiscGearModel.get(mgid);
      if(item == null) continue;
      items.add(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Choisir l'équipement"),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16.0,
          children: [
            DropdownMenuFormField<MiscGearModel>(
              requestFocusOnTap: true,
              label: const Text('Équipement'),
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
              ),
              expandedInsets: EdgeInsets.zero,
              dropdownMenuEntries: items
                .map((MiscGearModel mg) => DropdownMenuEntry(value: mg, label: mg.name))
                .toList(),
              validator: (MiscGearModel? mg) {
                if(mg == null) return 'Valeur manquante';
                return null;
              },
              onSelected: (MiscGearModel? mg) {
                model = mg;
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

            var mg = MiscGear.create(
              model: model!,
              alias: aliasController.text.isEmpty ? null : aliasController.text,
              quality: quality,
            );
            Navigator.of(context).pop(mg);
          },
        )
      ],
    );
  }
}