import 'package:flutter/material.dart';

import '../../classes/character/base.dart';

class InterdictPickerDialog extends StatefulWidget {
  const InterdictPickerDialog({ super.key, this.defaultCaste });

  final Caste? defaultCaste;

  @override
  State<InterdictPickerDialog> createState() => _InterdictPickerDialogState();
}

class _InterdictPickerDialogState extends State<InterdictPickerDialog> {
  final TextEditingController _casteController = TextEditingController();
  final TextEditingController _interdictController = TextEditingController();

  Caste? _currentCaste;
  final List<Interdict> _interdictsForCurrentCaste = <Interdict>[];
  Interdict? _interdict;

  void _updateForCurrentCaste() {
    _interdict = null;
    _interdictsForCurrentCaste.clear();
    _interdictController.clear();
    if(_currentCaste == null) return;
    _interdictsForCurrentCaste.addAll(
      Interdict.values.where((Interdict i) => i.caste == _currentCaste)
    );
  }

  @override
  void initState() {
    super.initState();
    _currentCaste = widget.defaultCaste;
    _updateForCurrentCaste();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
        title: const Text("Sélectionner l'interdit"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownMenu(
              controller: _casteController,
              initialSelection: _currentCaste,
              label: const Text('Caste'),
              requestFocusOnTap: true,
              expandedInsets: EdgeInsets.zero,
              onSelected: (Caste? caste) {
                setState(() {
                  _currentCaste = caste;
                  _updateForCurrentCaste();
                });
              },
              dropdownMenuEntries: Caste.values
                .where((Caste c) => c != Caste.sansCaste)
                .map((Caste c) => DropdownMenuEntry(value: c, label: c.title))
                .toList(),
            ),
            const SizedBox(height: 16.0),
            DropdownMenu(
              controller: _interdictController,
              label: const Text('Interdit'),
              requestFocusOnTap: true,
              expandedInsets: EdgeInsets.zero,
              onSelected: (Interdict? i) {
                _interdict = i;
              },
              dropdownMenuEntries: _interdictsForCurrentCaste
                .map((Interdict i) => DropdownMenuEntry(value: i, label: i.title))
                .toList(),
            ),
            const SizedBox(height: 16.0),
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
                        if(_interdict == null) return;
                        Navigator.of(context).pop(_interdict);
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