import 'package:flutter/material.dart';

import '../../../classes/entity/fervor.dart';
import '../../../classes/entity/spirit_powers.dart';
import '../../../classes/human_character.dart';
import '../num_input_widget.dart';
import '../widget_group_container.dart';
import 'fervor/display_spirit_power_widget.dart';

class CharacterEditFervorWidget extends StatelessWidget {
  const CharacterEditFervorWidget({ super.key, required this.character });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.0,
      children: [
        WidgetGroupContainer(
          child: SizedBox(
            width: 200,
            child: Row(
              spacing: 16.0,
              children: [
                Expanded(child: Text('Ferveur')),
                SizedBox(
                  width: 80.0,
                  child: NumIntInputWidget(
                    key: UniqueKey(),
                    initialValue: character.fervor.value,
                    minValue: 0,
                    maxValue: 99,
                    onChanged: (int v) => character.fervor.value = v,
                  ),
                ),
              ],
            ),
          )
        ),
        Expanded(
          child: WidgetGroupContainer(
            child: ListenableBuilder(
              listenable: character.fervor.powers,
              builder: (BuildContext context, _) {
                return Center(
                  child: Column(
                    spacing: 12.0,
                    children: [
                      if(character.fervor.powers.isEmpty)
                        Center(
                          child: Text("Aucun pouvoir de l'esprit")
                        ),
                      for(var power in character.fervor.powers)
                        DisplaySpiritPowerWidget(
                          power: power,
                          onDelete: () => character.fervor.powers.remove(power),
                        ),
                      Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            Icons.add,
                            size: 16.0,
                          ),
                          style: ElevatedButton.styleFrom(
                            textStyle: theme.textTheme.bodySmall,
                          ),
                          label: const Text('Nouveau pouvoir'),
                          onPressed: () async {
                            var result = await showDialog<SpiritPower>(
                              context: context,
                              builder: (BuildContext context) =>
                                _SpiritPowerPickerDialog(
                                  excluded: character.fervor.powers,
                                ),
                            );
                            if(result == null) return;
                            character.fervor.powers.add(result);
                          },
                        ),
                      )
                    ],
                  ),
                );
              }
            )
          ),
        )
      ],
    );
  }
}

class _SpiritPowerPickerDialog extends StatefulWidget {
  const _SpiritPowerPickerDialog({ required this.excluded });

  final EntitySpiritPowers excluded;

  @override
  State<_SpiritPowerPickerDialog> createState() => _SpiritPowerPickerDialogState();
}

class _SpiritPowerPickerDialogState extends State<_SpiritPowerPickerDialog> {
  SpiritPower? power;
  
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text("Sélectionner le pouvoir"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16.0,
        children: [
          Row(
            spacing: 16.0,
            children: [
              SizedBox(
                width: 250,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 16.0,
                  children: [
                    DropdownMenu(
                      label: const Text('Pouvoir'),
                      requestFocusOnTap: true,
                      expandedInsets: EdgeInsets.zero,
                      onSelected: (SpiritPower? p) {
                        setState(() {
                          power = p;
                        });
                      },
                      dropdownMenuEntries: SpiritPower.values
                        .where(
                          (SpiritPower s) => !widget.excluded.contains(s)
                        )
                        .map(
                          (SpiritPower p) => DropdownMenuEntry(
                            value: p, label: p.title
                          )
                        )
                        .toList(),
                    ),
                  ],
                ),
              ),
              if(power != null)
                SizedBox(
                  width: 600,
                  child: DisplaySpiritPowerWidget(power: power!)
                ),
            ],
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
                    if(power == null) return;
                    Navigator.of(context).pop(power);
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