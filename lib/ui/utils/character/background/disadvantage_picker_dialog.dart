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
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _disadvantageController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  
  DisadvantageType? _type;
  final List<Disadvantage> _forType = <Disadvantage>[];
  Disadvantage? _disadvantage;
  final List<int> _costs = <int>[];

  void _updateForCurrentType() {
    setState(() {
      _forType.clear();
    });

    if(_type == null) return;

    setState(() {
      _forType.addAll(
        Disadvantage.values.where((Disadvantage d) =>
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

    if(_disadvantage == null) return;

    setState(() {
      _costs.addAll(_disadvantage!.cost);
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
            onSelected: (DisadvantageType? t) {
              _disadvantageController.clear();
              _costController.clear();
              setState(() {
                _type = t;
              });
              _updateForCurrentType();
            },
            dropdownMenuEntries: DisadvantageType.values
              .map(
                (DisadvantageType t) => DropdownMenuEntry(value: t, label: t.title)
              ).toList()
          ),
          const SizedBox(height: 16.0),
          DropdownMenu(
            controller: _disadvantageController,
            label: const Text('Désavantage'),
            requestFocusOnTap: true,
            expandedInsets: EdgeInsets.zero,
            onSelected: (Disadvantage? d) {
              _costController.clear();
              setState(() {
                _disadvantage = d;
              });
              _updateCosts();
            },
            dropdownMenuEntries: _forType.map(
                (Disadvantage d) => DropdownMenuEntry(
                  value: d,
                  label: d.title,
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
                      if(_disadvantage == null) return;
                      if(_costController.text.isEmpty) return;

                      var ret = CharacterDisadvantage(
                        disadvantage: _disadvantage!,
                        cost: int.parse(_costController.text),
                        details: _detailsController.text,
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