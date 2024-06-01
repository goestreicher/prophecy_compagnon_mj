import 'package:flutter/material.dart';

import '../utils/dice_roll_input.dart';

class DiceRollInputDialog extends StatefulWidget {
  const DiceRollInputDialog({
    super.key,
    this.title,
    this.text,
    required this.count
  });

  final String? title;
  final String? text;
  final int count;

  @override
  State<DiceRollInputDialog> createState() => _DiceRollInputDialogState();
}

class _DiceRollInputDialogState extends State<DiceRollInputDialog> {
  late List<int> results;

  @override
  void initState() {
    super.initState();

    results = List.generate(widget.count, (index) => 0);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var subtitleWidgets = <Widget>[];

    if(widget.text != null && widget.text!.isNotEmpty) {
      subtitleWidgets.addAll([
        Text(widget.text!),
        const SizedBox(height: 8.0),
      ]);
    }

    return AlertDialog(
      title: Text(widget.title ?? 'Jet de dé'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...subtitleWidgets,
          Row(
            children: [
              for(var idx = 0; idx < widget.count; ++idx)
                DiceRollInputWidget(
                  onValueSelected: (int v) {
                    results[idx] = v;
                  }
                ),
            ],
          ),
          const SizedBox(height: 8.0),
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
                      if(!results.every((int r) => r > 0)) return;

                      Navigator.of(context).pop(results);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                    ),
                    child: const Text('OK'),
                  )
                ],
              )
          )
        ],
      ),
    );
  }
}