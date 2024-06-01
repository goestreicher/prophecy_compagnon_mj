import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../classes/entity_base.dart';

class OppositionThrowResult {
  OppositionThrowResult({ required this.attackerNr, required this.defenderNr });
  final int attackerNr;
  final int defenderNr;
}

class OppositionThrowDialog extends StatelessWidget {
  OppositionThrowDialog({
    super.key,
    required this.title,
    required this.attacker,
    required this.attackerThrowDescription,
    required this.attackerThrowDifficulty,
    required this.defender,
    required this.defenderThrowDescription,
    required this.defenderThrowDifficulty,
  });

  final String title;

  final EntityBase attacker;
  final String attackerThrowDescription;
  final int attackerThrowDifficulty;

  final EntityBase defender;
  final String defenderThrowDescription;
  final int defenderThrowDifficulty;

  final TextEditingController _attackerNrController = TextEditingController();
  final TextEditingController _defenderNrController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                attacker.name,
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4.0),
              Text(attackerThrowDescription),
              const Spacer(),
              IconButton(
                onPressed: () {
                  var curr = int.parse(_attackerNrController.text);
                  if(curr >= 0) {
                    _attackerNrController.text = (curr - 1).toString();
                  }
                },
                icon: const Icon(Icons.remove),
              ),
              SizedBox(
                width: 60.0,
                child: TextFormField(
                  controller: _attackerNrController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    label: Text('# NRs'),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (String? value) {
                    if(value == null || value.isEmpty) return 'Valeur manquante';
                    int? input = int.tryParse(value);
                    if(input == null) return 'Pas un nombre';
                    if(input < 0) return 'Nombre >= 0';
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              IconButton(
                onPressed: () {
                  var curr = int.parse(_attackerNrController.text);
                  _attackerNrController.text = (curr + 1).toString();
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                defender.name,
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4.0),
              Text(defenderThrowDescription),
              const Spacer(),
              IconButton(
                onPressed: () {
                  var curr = int.parse(_defenderNrController.text);
                  if(curr >= 0) {
                    _defenderNrController.text = (curr - 1).toString();
                  }
                },
                icon: const Icon(Icons.remove),
              ),
              SizedBox(
                width: 60.0,
                child: TextFormField(
                  controller: _defenderNrController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    label: Text('# NRs'),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (String? value) {
                    if(value == null || value.isEmpty) return 'Valeur manquante';
                    int? input = int.tryParse(value);
                    if(input == null) return 'Pas un nombre';
                    if(input < 0) return 'Nombre >= 0';
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              IconButton(
                onPressed: () {
                  var curr = int.parse(_defenderNrController.text);
                  _defenderNrController.text = (curr + 1).toString();
                },
                icon: const Icon(Icons.add),
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
                    if(_attackerNrController.text.isEmpty) return;
                    if(_defenderNrController.text.isEmpty) return;

                    var attackerNr = int.tryParse(_attackerNrController.text) ?? 0;
                    var defenderNr = int.tryParse(_defenderNrController.text) ?? 0;

                    var result = OppositionThrowResult(attackerNr: attackerNr, defenderNr: defenderNr);

                    Navigator.of(context).pop(result);
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
      )
    );
  }
}