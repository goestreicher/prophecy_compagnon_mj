import 'package:flutter/material.dart';

import '../../classes/character/base.dart';

class CastePrivilegePickerDialog extends StatefulWidget {
  const CastePrivilegePickerDialog({
    super.key,
    this.defaultCaste,
    this.currentPrivileges = const <CharacterCastePrivilege>[],
  });

  final Caste? defaultCaste;
  final List<CharacterCastePrivilege> currentPrivileges;

  @override
  State<CastePrivilegePickerDialog> createState() => _CastePrivilegePickerDialogState();
}

class _CastePrivilegePickerDialogState extends State<CastePrivilegePickerDialog> {
  final TextEditingController casteController = TextEditingController();
  final TextEditingController privilegeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Set<CastePrivilege> assignedPrivileges = <CastePrivilege>{};
  Caste? currentCaste;
  final List<CastePrivilege> privilegesForCurrentCaste = <CastePrivilege>[];
  CastePrivilege? privilege;
  String? currentDescription;

  void updateForCurrentCaste() {
    privilege = null;
    privilegesForCurrentCaste.clear();
    privilegeController.clear();
    if(currentCaste == null) return;
    privilegesForCurrentCaste.addAll(
      CastePrivilege.values.where(
        (CastePrivilege p) => (p.caste == currentCaste) && (p.unique == false || !assignedPrivileges.contains(p))
      )
    );
  }

  @override
  void initState() {
    super.initState();
    assignedPrivileges = widget.currentPrivileges
        .map((CharacterCastePrivilege p) => p.privilege)
        .toSet();
    currentCaste = widget.defaultCaste;
    updateForCurrentCaste();
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
              controller: casteController,
              initialSelection: currentCaste,
              label: const Text('Caste'),
              requestFocusOnTap: true,
              expandedInsets: EdgeInsets.zero,
              onSelected: (Caste? caste) {
                setState(() {
                  currentCaste = caste;
                  updateForCurrentCaste();
                });
              },
              dropdownMenuEntries: Caste.values
                .where((Caste c) => c != Caste.sansCaste)
                .map((Caste c) => DropdownMenuEntry(value: c, label: c.title))
                .toList(),
            ),
            const SizedBox(height: 16.0),
            DropdownMenu(
              controller: privilegeController,
              label: const Text('Privilège'),
              requestFocusOnTap: true,
              expandedInsets: EdgeInsets.zero,
              onSelected: (CastePrivilege? i) {
                setState(() {
                  privilege = i;
                });
              },
              dropdownMenuEntries: privilegesForCurrentCaste
                .map((CastePrivilege p) => DropdownMenuEntry(value: p, label: p.title))
                .toList(),
            ),
            if(privilege != null && privilege!.requireDescription)
              const SizedBox(height: 16.0),
            if(privilege != null && privilege!.requireDescription)
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  label: Text('Description'),
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if(value == null || value.isEmpty) {
                    return 'Valeur manquante';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (String value) => setState(() {
                  currentDescription = value;
                }),
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
                    onPressed: privilege == null || (privilege!.requireDescription && descriptionController.text.isEmpty)
                      ? null
                      : () {
                      var priv = CharacterCastePrivilege(privilege: privilege!);
                      if(privilege!.requireDescription) {
                        priv.description = descriptionController.text;
                      }
                      Navigator.of(context).pop(priv);
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