import 'package:flutter/material.dart';

import '../../../../classes/armor.dart';

class ArmorPickerDialog extends StatefulWidget {
  const ArmorPickerDialog({ super.key });

  @override
  State<ArmorPickerDialog> createState() => _ArmorPickerDialogState();
}

class _ArmorPickerDialogState extends State<ArmorPickerDialog> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _armorController = TextEditingController();
  List<ArmorModel> _armors = <ArmorModel>[];
  String? _armorId;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text("Sélectionner l'armure"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownMenu(
            controller: _typeController,
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
              _armorController.clear();
              setState(() {
                _armorId = null;
                _armors = armors;
              });
            },
          ),
          const SizedBox(height: 16.0),
          DropdownMenu(
            controller: _armorController,
            requestFocusOnTap: true,
            label: const Text('Armure'),
            expandedInsets: EdgeInsets.zero,
            dropdownMenuEntries:
            _armors.map((ArmorModel a) => DropdownMenuEntry(value: a, label: a.name)).toList(),
            onSelected: (ArmorModel? a) {
              if(a == null) return;
              _armorId = a.id;
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
                      if(_armorController.text.isEmpty) return;
                      if(_armorId == null) return;
                      Navigator.of(context).pop(_armorId);
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