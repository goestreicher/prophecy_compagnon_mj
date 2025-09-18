import 'package:flutter/material.dart';

import '../../../../classes/character/base.dart';
import '../../../../classes/human_character.dart';

class DisadvantagePickerDialog extends StatefulWidget {
  const DisadvantagePickerDialog({ super.key, this.includeReservedForCaste });

  final Caste? includeReservedForCaste;

  @override
  State<DisadvantagePickerDialog> createState() => _DisadvantagePickerDialogState();
}

class _DisadvantagePickerDialogState extends State<DisadvantagePickerDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController disadvantageController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  
  DisadvantageType? type;
  final List<Disadvantage> forType = <Disadvantage>[];
  Disadvantage? disadvantage;
  final List<int> costs = <int>[];

  void updateForCurrentType() {
    setState(() {
      forType.clear();
    });

    if(type == null) return;

    setState(() {
      forType.addAll(
        Disadvantage.values.where((Disadvantage d) =>
            (d.type == type)
            && (
                d.reservedCastes.isEmpty
                || widget.includeReservedForCaste == null
                || d.reservedCastes.contains(widget.includeReservedForCaste)
            )
        )
      );
    });
  }

  void updateCosts() {
    setState(() {
      costs.clear();
    });

    if(disadvantage == null) return;

    setState(() {
      costs.addAll(disadvantage!.cost);
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Sélectionner le désavantage'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.0,
                children: [
                  SizedBox(
                    width: 300,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 16.0,
                      children: [
                        DropdownMenu(
                          controller: typeController,
                          initialSelection: type,
                          label: const Text('Type'),
                          requestFocusOnTap: true,
                          expandedInsets: EdgeInsets.zero,
                          onSelected: (DisadvantageType? t) {
                            disadvantageController.clear();
                            costController.clear();
                            setState(() {
                              disadvantage = null;
                              type = t;
                            });
                            updateForCurrentType();
                          },
                          dropdownMenuEntries: DisadvantageType.values
                            .map(
                              (DisadvantageType t) => DropdownMenuEntry(value: t, label: t.title)
                            ).toList()
                        ),
                        DropdownMenuFormField(
                          controller: disadvantageController,
                          label: const Text('Désavantage'),
                          requestFocusOnTap: true,
                          expandedInsets: EdgeInsets.zero,
                          onSelected: (Disadvantage? d) {
                            costController.clear();
                            setState(() {
                              disadvantage = d;
                            });
                            updateCosts();
                          },
                          dropdownMenuEntries: forType.map(
                              (Disadvantage d) => DropdownMenuEntry(
                                value: d,
                                label: d.title,
                              )
                            ).toList(),
                          validator: (Disadvantage? d) {
                            if(disadvantage == null) return 'Valeur obligatoire';
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.disabled,
                        ),
                        DropdownMenuFormField(
                          controller: costController,
                          label: const Text('Coût'),
                          requestFocusOnTap: true,
                          expandedInsets: EdgeInsets.zero,
                          dropdownMenuEntries: costs.map(
                              (int c) => DropdownMenuEntry(value: c, label: c.toString())
                            ).toList(),
                          validator: (int? c) {
                            if(disadvantage == null) return null;
                            if(costController.text.isEmpty) return 'Valeur obligatoire';
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.disabled,
                        ),
                        TextFormField(
                          controller: detailsController,
                          minLines: 2,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Détails',
                          ),
                          validator: (String? d) {
                            if(disadvantage == null) return null;
                            if(disadvantage!.requireDetails && detailsController.text.isEmpty) return 'Valeur obligatoire';
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.disabled,
                        ),
                      ],
                    ),
                  ),
                  if(disadvantage != null && disadvantage!.description.isNotEmpty)
                    SingleChildScrollView(
                      child: UnconstrainedBox(
                        child: Container(
                          padding: EdgeInsets.only(right: 16.0),
                          width: 300,
                          child: Text(
                            disadvantage!.description,
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
                    onPressed: () {
                      if(!formKey.currentState!.validate()) return;

                      var ret = CharacterDisadvantage(
                        disadvantage: disadvantage!,
                        cost: int.parse(costController.text),
                        details: detailsController.text,
                      );
                      Navigator.of(context).pop(ret);
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
      )
    );
  }
}