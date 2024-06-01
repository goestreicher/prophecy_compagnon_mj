import 'package:flutter/material.dart';

import '../../classes/shield.dart';

class ShieldPickerDialog extends StatefulWidget {
  const ShieldPickerDialog({ super.key });

  @override
  State<ShieldPickerDialog> createState() => _ShieldPickerDialogState();
}

class _ShieldPickerDialogState extends State<ShieldPickerDialog> {
  final TextEditingController _controller = TextEditingController();
  final Map<String, String> _shields = <String, String>{};
  String? _shieldId;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    for(var id in ShieldModel.ids()) {
      _shields[id] = ShieldModel.get(id)!.name;
    }

    return AlertDialog(
      title: const Text('Sélectionner le bouclier'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownMenu(
            controller: _controller,
            requestFocusOnTap: true,
            label: const Text('Bouclier'),
            expandedInsets: EdgeInsets.zero,
            dropdownMenuEntries:
            _shields.keys.map((String id) => DropdownMenuEntry(value: id, label: _shields[id]!)).toList(),
            onSelected: (String? id) {
              _shieldId = id;
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
                      if(_shieldId == null) return;
                      Navigator.of(context).pop(_shieldId);
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