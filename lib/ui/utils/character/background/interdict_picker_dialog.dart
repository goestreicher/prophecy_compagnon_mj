import 'package:flutter/material.dart';

import '../../../../classes/caste/base.dart';
import '../../../../classes/caste/interdicts.dart';

class InterdictPickerDialog extends StatefulWidget {
  const InterdictPickerDialog({ super.key, this.defaultCaste });

  final Caste? defaultCaste;

  @override
  State<InterdictPickerDialog> createState() => _InterdictPickerDialogState();
}

class _InterdictPickerDialogState extends State<InterdictPickerDialog> {
  final TextEditingController casteController = TextEditingController();
  final TextEditingController interdictController = TextEditingController();

  Caste? currentCaste;
  final List<CasteInterdict> interdictsForCurrentCaste = <CasteInterdict>[];
  CasteInterdict? interdict;

  void updateForCurrentCaste() {
    interdict = null;
    interdictsForCurrentCaste.clear();
    interdictController.clear();
    if(currentCaste == null) return;
    interdictsForCurrentCaste.addAll(
      CasteInterdict.values.where((CasteInterdict i) => i.caste == currentCaste)
    );
  }

  @override
  void initState() {
    super.initState();
    currentCaste = widget.defaultCaste;
    updateForCurrentCaste();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
        title: const Text("Sélectionner l'interdit"),
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
                          controller: interdictController,
                          label: const Text('Interdit'),
                          requestFocusOnTap: true,
                          expandedInsets: EdgeInsets.zero,
                          onSelected: (CasteInterdict? i) {
                            setState(() {
                              interdict = i;
                            });
                          },
                          dropdownMenuEntries: interdictsForCurrentCaste
                            .map((CasteInterdict i) => DropdownMenuEntry(value: i, label: i.title))
                            .toList(),
                        ),
                      ],
                    ),
                  ),
                  if(interdict != null && interdict!.description.isNotEmpty)
                    SingleChildScrollView(
                      child: UnconstrainedBox(
                        child: Container(
                          padding: EdgeInsets.only(right: 16.0),
                          width: 300,
                          child: Text(
                            interdict!.description,
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
                    onPressed: interdict == null ? null : () {
                      Navigator.of(context).pop(interdict);
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