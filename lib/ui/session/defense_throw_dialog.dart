import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../classes/dice.dart';
import '../../classes/entity_base.dart';
import '../../classes/character/base.dart';
import '../../classes/character/skill.dart';

class DefenseThrowDialog extends StatefulWidget {
  const DefenseThrowDialog({
    super.key,
    required this.attacker,
    required this.defender,
    this.text,
    attribute,
    required this.skill,
    required this.difficulty,
    this.specialization,
  })
    : attribute = attribute ?? Attribute.physique;

  final EntityBase attacker;
  final EntityBase defender;
  final String? text;
  final Attribute attribute;
  final Skill skill;
  final String? specialization;
  final int difficulty;

  @override
  State<DefenseThrowDialog> createState() => _DefenseThrowDialogState();
}

class _DefenseThrowDialogState extends State<DefenseThrowDialog> {
  TextEditingController resultController = TextEditingController();
  DiceThrowResultType result = DiceThrowResultType.fail;
  TextEditingController nrController = TextEditingController();

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

    var description = '${widget.attribute.title} + ${widget.skill.title}';
    if(widget.specialization != null) {
      description += ' (${widget.specialization})';
    }
    subtitleWidgets.add(Text(description));

    return AlertDialog(
      title: const Text("Résolution d'attaque - Jet de défense"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Attaquant : ${widget.attacker.name} / Défenseur : ${widget.defender.name}'),
          const SizedBox(height: 8.0),
          ...subtitleWidgets,
          Text('Difficulté: ${widget.difficulty.toString()}'),
          const SizedBox(height: 8.0),
          Row(
            children: [
              const Text(
                'Résultat',
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: DropdownMenu(
                  controller: resultController,
                  requestFocusOnTap: true,
                  onSelected: (DiceThrowResultType? r) {
                    if(r == null) return;
                    setState(() {
                      result = r;
                    });
                  },
                  dropdownMenuEntries: DiceThrowResultType.values
                      .map((DiceThrowResultType t) => DropdownMenuEntry(
                      value: t,
                      label: t.title))
                      .toList(),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: TextFormField(
                  controller: nrController,
                  enabled: result == DiceThrowResultType.pass || result == DiceThrowResultType.criticalPass,
                  decoration: const InputDecoration(
                    label: Text('# NR'),
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
              )
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
                      if(resultController.text.isEmpty) return;

                      var nr = int.tryParse(nrController.text) ?? 0;
                      var throwResult = DiceThrowResult(type: result, nrCount: nr);

                      Navigator.of(context).pop(throwResult);
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
