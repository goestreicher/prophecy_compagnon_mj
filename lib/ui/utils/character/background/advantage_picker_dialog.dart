import 'package:flutter/material.dart';

import '../../../../classes/caste/base.dart';
import '../../../../classes/character/advantages.dart';
import '../../../../classes/human_character.dart';

class AdvantagePickerDialog extends StatefulWidget {
  const AdvantagePickerDialog({ super.key, this.includeReservedForCaste });

  final Caste? includeReservedForCaste;

  @override
  State<AdvantagePickerDialog> createState() => _AdvantagePickerDialogState();
}

class _AdvantagePickerDialogState extends State<AdvantagePickerDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController advantageController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  AdvantageType? type;
  final List<Advantage> forType = <Advantage>[];
  Advantage? advantage;
  final List<int> costs = <int>[];

  void updateForCurrentType() {
    setState(() {
      forType.clear();
    });

    if(type == null) return;

    setState(() {
      forType.addAll(
          Advantage.values.where((Advantage d) => 
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

    if(advantage == null) return;

    setState(() {
      costs.addAll(advantage!.cost);
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
                            onSelected: (AdvantageType? t) {
                              advantageController.clear();
                              costController.clear();
                              setState(() {
                                type = t;
                              });
                              updateForCurrentType();
                            },
                            dropdownMenuEntries: AdvantageType.values
                              .map(
                                    (AdvantageType t) => DropdownMenuEntry(value: t, label: t.title)
                              ).toList()
                          ),
                          DropdownMenuFormField(
                            controller: advantageController,
                            label: const Text('Avantage'),
                            requestFocusOnTap: true,
                            expandedInsets: EdgeInsets.zero,
                            onSelected: (Advantage? a) {
                              costController.clear();
                              setState(() {
                                advantage = a;
                              });
                              updateCosts();
                            },
                            dropdownMenuEntries: forType.map(
                                (Advantage a) => DropdownMenuEntry(
                                  value: a,
                                  label: a.title,
                                )
                              ).toList(),
                            validator: (Advantage? d) {
                              if(advantage == null) return 'Valeur obligatoire';
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
                              if(advantage == null) return null;
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
                              if(advantage == null) return null;
                              if(advantage!.requireDetails && detailsController.text.isEmpty) return 'Valeur obligatoire';
                              return null;
                            },
                            autovalidateMode: AutovalidateMode.disabled,
                          ),
                        ],
                      ),
                    ),
                    if(advantage != null && advantage!.description.isNotEmpty)
                      SingleChildScrollView(
                        child: UnconstrainedBox(
                          child: Container(
                            padding: EdgeInsets.only(right: 16.0),
                            width: 300,
                            child: Text(
                              advantage!.description,
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

                        var ret = CharacterAdvantage(
                            advantage: advantage!,
                            cost: int.parse(costController.text),
                            details: detailsController.text
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