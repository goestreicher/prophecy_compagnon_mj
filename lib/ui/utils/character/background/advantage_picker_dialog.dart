import 'package:flutter/material.dart';

import '../../../../classes/caste/base.dart';
import '../../../../classes/character/advantages.dart';
import '../../../../classes/human_character.dart';
import 'advantage_select_widget.dart';

class AdvantagePickerDialog extends StatefulWidget {
  const AdvantagePickerDialog({
    super.key,
    this.types,
    this.maxCost,
    this.exclude,
    this.includeReservedForCaste,
  });

  final List<AdvantageType>? types;
  final int? maxCost;
  final List<Advantage>? exclude;
  final Caste? includeReservedForCaste;

  @override
  State<AdvantagePickerDialog> createState() => _AdvantagePickerDialogState();
}

class _AdvantagePickerDialogState extends State<AdvantagePickerDialog> {
  CharacterAdvantage? selected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text("Sélectionner l'avantage"),
      content: SizedBox(
        width: 800,
        height: 500,
        child: AdvantageSelectWidget(
          types: (widget.types ?? AdvantageType.values),
          maxCost: widget.maxCost,
          exclude: widget.exclude,
          includeReservedForCaste: widget.includeReservedForCaste,
          onSelected: (CharacterAdvantage? a) {
            setState(() {
              selected = a;
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