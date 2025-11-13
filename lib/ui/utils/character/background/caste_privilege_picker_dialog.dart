import 'package:flutter/material.dart';

import '../../../../classes/caste/base.dart';
import '../../../../classes/caste/character_caste.dart';
import '../../../../classes/caste/privileges.dart';

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
  final TextEditingController costController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Set<CastePrivilege> assignedPrivileges = <CastePrivilege>{};
  Caste? currentCaste;
  final List<CastePrivilege> privilegesForCurrentCaste = <CastePrivilege>[];
  CastePrivilege? privilege;
  final List<int> costs = <int>[];
  int? cost;
  String? currentDescription;

  void updateForCurrentCaste() {
    privilege = null;
    cost = null;
    privilegesForCurrentCaste.clear();
    privilegeController.clear();
    if(currentCaste == null) return;
    privilegesForCurrentCaste.addAll(
      CastePrivilege.values.where(
        (CastePrivilege p) => (p.caste == currentCaste || p.caste == Caste.sansCaste) && (p.unique == false || !assignedPrivileges.contains(p))
      )
    );
  }

  void updateCosts() {
    setState(() {
      costs.clear();
    });

    if(privilege == null) return;

    setState(() {
      costs.addAll(privilege!.cost);
      if(costs.length == 1) cost = costs[0];
    });
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
            IntrinsicHeight(
              child: Row(
                spacing: 16.0,
                children: [
                  SizedBox(
                    width: 300,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 16.0,
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
                        DropdownMenu(
                          controller: privilegeController,
                          label: const Text('Privilège'),
                          requestFocusOnTap: true,
                          expandedInsets: EdgeInsets.zero,
                          onSelected: (CastePrivilege? i) {
                            costController.clear();
                            setState(() {
                              privilege = i;
                              cost = null;
                            });
                            updateCosts();
                          },
                          dropdownMenuEntries: privilegesForCurrentCaste
                            .map((CastePrivilege p) => DropdownMenuEntry(value: p, label: p.title))
                            .toList(),
                        ),
                        DropdownMenuFormField(
                          initialSelection: cost,
                          controller: costController,
                          label: const Text('Coût'),
                          requestFocusOnTap: true,
                          expandedInsets: EdgeInsets.zero,
                          dropdownMenuEntries: costs.map(
                              (int c) => DropdownMenuEntry(value: c, label: c.toString())
                            ).toList(),
                          onSelected: (int? v) {
                            setState(() {
                              cost = v;
                            });
                          },
                          validator: (int? c) {
                            if(privilege == null) return null;
                            if(costController.text.isEmpty) return 'Valeur obligatoire';
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.disabled,
                        ),
                        if(privilege != null && privilege!.requireDetails)
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
                      ],
                    ),
                  ),
                  if(privilege != null && privilege!.description.isNotEmpty)
                    SingleChildScrollView(
                      child: UnconstrainedBox(
                        child: Container(
                          padding: EdgeInsets.only(right: 16.0),
                          width: 300,
                          child: Text(
                            privilege!.description,
                          ),
                        ),
                      ),
                    ),
                ],
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
                    onPressed: privilege == null || (privilege!.requireDetails && descriptionController.text.isEmpty)
                        ? null
                        : () {
                      var priv = CharacterCastePrivilege(privilege: privilege!);
                      if(privilege!.requireDetails) {
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