import 'package:flutter/material.dart';

import '../../../../classes/character/base.dart';
import '../../num_input_widget.dart';

class AbilityListEditWidget extends StatelessWidget {
  const AbilityListEditWidget({
    super.key,
    required this.abilities,
    this.minValue = 1,
    this.maxValue = 15,
    required this.onChanged,
    this.onSaved,
  });

  final Map<Ability, int> abilities;
  final int minValue;
  final int maxValue;
  final void Function(Ability, int) onChanged;
  final void Function(Ability, int)? onSaved;

  @override
  Widget build(BuildContext context) {
    var widgetRows = <Widget>[];

    for(var i = 0; (i+4) < Ability.values.length; ++i) {
      var currentRow = <Widget>[
        Expanded(
          child: NumIntInputWidget(
            initialValue: abilities[Ability.values[i]] ?? 0,
            minValue: minValue,
            maxValue: maxValue,
            onChanged: (int value) {
              onChanged(Ability.values[i], value);
            },
            onSaved: (int value) {
              onSaved?.call(Ability.values[i], value);
            },
            label: '${Ability.values[i].title.substring(0, 3).toUpperCase()}${Ability.values[i].title.substring(3)}',
          ),
        ),
      ];

      if(i + 4 < Ability.values.length) {
        currentRow.add(
          Expanded(
            child: NumIntInputWidget(
              initialValue: abilities[Ability.values[i+4]] ?? 0,
              minValue: minValue,
              maxValue: maxValue,
              onChanged: (int value) {
                onChanged(Ability.values[i+4], value);
              },
              onSaved: (int value) {
                onSaved?.call(Ability.values[i+4], value);
              },
              label: '${Ability.values[i+4].title.substring(0, 3).toUpperCase()}${Ability.values[i+4].title.substring(3)}',
            ),
          ),
        );
      }

      widgetRows.add(
        Row(
          spacing: 8.0,
          children: [
            ...currentRow,
          ],
        )
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 12.0,
      children: [
        ...widgetRows
      ],
    );
  }
}