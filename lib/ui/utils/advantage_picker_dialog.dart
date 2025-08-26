import 'package:flutter/material.dart';

import '../../classes/character/base.dart';
import '../../classes/human_character.dart';

class AdvantagePickerDialog extends StatefulWidget {
  const AdvantagePickerDialog({ super.key, this.includeReservedForCaste });

  final Caste? includeReservedForCaste;

  @override
  State<AdvantagePickerDialog> createState() => _AdvantagePickerDialogState();
}

class _AdvantagePickerDialogState extends State<AdvantagePickerDialog> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _advantageController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  AdvantageType? _type;
  final List<Advantage> _forType = <Advantage>[];
  Advantage? _advantage;
  final List<int> _costs = <int>[];

  void _updateForCurrentType() {
    setState(() {
      _forType.clear();
    });

    if(_type == null) return;

    setState(() {
      _forType.addAll(
          Advantage.values.where((Advantage d) => 
              (d.type == _type)
              && (
                  d.reservedCastes.isEmpty
                  || widget.includeReservedForCaste == null
                  || d.reservedCastes.contains(widget.includeReservedForCaste)
              )
          )
      );
    });
  }

  void _updateCosts() {
    setState(() {
      _costs.clear();
    });

    if(_advantage == null) return;

    setState(() {
      _costs.addAll(_advantage!.cost);
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
        title: const Text('Sélectionner le désavantage'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownMenu(
                controller: _typeController,
                initialSelection: _type,
                label: const Text('Type'),
                requestFocusOnTap: true,
                expandedInsets: EdgeInsets.zero,
                onSelected: (AdvantageType? t) {
                  _advantageController.clear();
                  _costController.clear();
                  setState(() {
                    _type = t;
                  });
                  _updateForCurrentType();
                },
                dropdownMenuEntries: AdvantageType.values
                  .map(
                        (AdvantageType t) => DropdownMenuEntry(value: t, label: t.title)
                  ).toList()
            ),
            const SizedBox(height: 16.0),
            DropdownMenu(
                controller: _advantageController,
                label: const Text('Avantage'),
                requestFocusOnTap: true,
                expandedInsets: EdgeInsets.zero,
                onSelected: (Advantage? a) {
                  _costController.clear();
                  setState(() {
                    _advantage = a;
                  });
                  _updateCosts();
                },
                dropdownMenuEntries: _forType.map(
                    (Advantage a) => DropdownMenuEntry(
                      value: a,
                      label: a.title,
                    )
                  ).toList()
            ),
            const SizedBox(height: 16.0),
            DropdownMenu(
              controller: _costController,
              label: const Text('Coût'),
              requestFocusOnTap: true,
              expandedInsets: EdgeInsets.zero,
              dropdownMenuEntries: _costs.map(
                  (int c) => DropdownMenuEntry(value: c, label: c.toString())
                ).toList(),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _detailsController,
              minLines: 2,
              maxLines: 2,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Détails',
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
                        if(_type == null) return;
                        if(_advantage == null) return;
                        if(_costController.text.isEmpty) return;

                        var ret = CharacterAdvantage(
                          advantage: _advantage!,
                          cost: int.parse(_costController.text),
                          details: _detailsController.text
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
        )
    );
  }
}