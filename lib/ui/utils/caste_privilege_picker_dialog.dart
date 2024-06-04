import 'package:flutter/material.dart';

import '../../classes/character/base.dart';

class CastePrivilegePickerDialog extends StatefulWidget {
  const CastePrivilegePickerDialog({ super.key, this.defaultCaste });

  final Caste? defaultCaste;

  @override
  State<CastePrivilegePickerDialog> createState() => _CastePrivilegePickerDialogState();
}

class _CastePrivilegePickerDialogState extends State<CastePrivilegePickerDialog> {
  final TextEditingController _casteController = TextEditingController();
  final TextEditingController _privilegeController = TextEditingController();

  Caste? _currentCaste;
  final List<CastePrivilege> _privilegesForCurrentCaste = <CastePrivilege>[];
  CastePrivilege? _privilege;

  void _updateForCurrentCaste() {
    _privilege = null;
    _privilegesForCurrentCaste.clear();
    _privilegeController.clear();
    if(_currentCaste == null) return;
    _privilegesForCurrentCaste.addAll(
      CastePrivilege.values.where((CastePrivilege p) => p.caste == _currentCaste)
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
        title: const Text('Sélectionner le privilège'),
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
              controller: _privilegeController,
              label: const Text('Privilège'),
              requestFocusOnTap: true,
              expandedInsets: EdgeInsets.zero,
              onSelected: (CastePrivilege? i) {
                _privilege = i;
              },
              dropdownMenuEntries: _privilegesForCurrentCaste
                .map((CastePrivilege p) => DropdownMenuEntry(value: p, label: p.title))
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
                        if(_privilege == null) return;
                        Navigator.of(context).pop(_privilege);
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