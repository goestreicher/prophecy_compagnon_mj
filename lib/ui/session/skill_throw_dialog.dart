import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../classes/dice.dart';
import '../../classes/entity/attributes.dart';
import '../../classes/entity/skill.dart';

class SkillThrowDialog extends StatefulWidget {
  const SkillThrowDialog({
    super.key,
    this.title,
    this.text,
    required this.attribute,
    required this.skill,
    required this.difficulty,
    this.specialization,
  });

  final String? title;
  final String? text;
  final Attribute attribute;
  final Skill skill;
  final String? specialization;
  final int difficulty;

  @override
  State<SkillThrowDialog> createState() => _SkillThrowDialogState();
}

class _SkillThrowDialogState extends State<SkillThrowDialog> {
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

    var description = '${widget.attribute.title} + ${widget.skill.name}';
    if(widget.specialization != null) {
      description += ' (${widget.specialization})';
    }
    subtitleWidgets.add(Text(description));

    return AlertDialog(
      title: Text(widget.title ?? 'Jet de compétence'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...subtitleWidgets,
          const SizedBox(height: 8.0),
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