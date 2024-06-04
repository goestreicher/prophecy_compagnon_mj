import 'package:flutter/material.dart';

import '../../classes/character/base.dart';
import 'character_digit_input_widget.dart';

class AbilityListEditWidget extends StatelessWidget {
  const AbilityListEditWidget({
    super.key,
    required this.abilities,
    this.minValue = 1,
    this.maxValue = 15,
    required this.onAbilityChanged,
  });

  final Map<Ability, int> abilities;
  final int minValue;
  final int maxValue;
  final void Function(Ability, int) onAbilityChanged;

  @override
  Widget build(BuildContext context) {
    var widgetRows = <Widget>[];

    for(var i = 0; (i+4) < Ability.values.length; ++i) {
      if(widgetRows.isNotEmpty) {
        widgetRows.add(const SizedBox(height: 16.0));
      }

      var currentRow = <Widget>[
        Expanded(
          child: CharacterDigitInputWidget(
            initialValue: abilities[Ability.values[i]] ?? 0,
            minValue: minValue,
            maxValue: maxValue,
            onChanged: (int value) {
              onAbilityChanged(Ability.values[i], value);
            },
            label: '${Ability.values[i].title.substring(0, 3).toUpperCase()}${Ability.values[i].title.substring(3)}',
          ),
        ),
      ];

      if(i + 4 < Ability.values.length) {
        currentRow.add(const SizedBox(width: 8.0));
        currentRow.add(
          Expanded(
            child: CharacterDigitInputWidget(
              initialValue: abilities[Ability.values[i+4]] ?? 0,
              minValue: minValue,
              maxValue: maxValue,
              onChanged: (int value) {
                onAbilityChanged(Ability.values[i+4], value);
              },
              label: '${Ability.values[i+4].title.substring(0, 3).toUpperCase()}${Ability.values[i+4].title.substring(3)}',
            ),
          ),
        );
      }

      widgetRows.add(
        Row(
          children: [
            ...currentRow,
          ],
        )
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ...widgetRows
      ],
    );
  }
}