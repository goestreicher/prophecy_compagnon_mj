import 'package:flutter/material.dart';

import '../../../../classes/caste/base.dart';
import '../../../../classes/human_character.dart';
import 'disadvantage_select_widget.dart';

class DisadvantagePickerDialog extends StatefulWidget {
  const DisadvantagePickerDialog({ super.key, this.includeReservedForCaste });

  final Caste? includeReservedForCaste;

  @override
  State<DisadvantagePickerDialog> createState() => _DisadvantagePickerDialogState();
}

class _DisadvantagePickerDialogState extends State<DisadvantagePickerDialog> {
  CharacterDisadvantage? selected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Sélectionner le désavantage'),
      content: SizedBox(
        width: 800,
        height: 500,
        child: DisadvantageSelectWidget(
          includeReservedForCaste: widget.includeReservedForCaste,
          onSelected: (CharacterDisadvantage? d) {
            setState(() {
              selected = d;
            });
          },
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: selected == null ? null : () {
            Navigator.of(context).pop(selected!);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          child: const Text('OK'),
        ),
      ],
    );
  }
}