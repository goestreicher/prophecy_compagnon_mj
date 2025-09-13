import 'package:flutter/material.dart';

import '../../../../classes/creature.dart';
import '../../widget_group_container.dart';

class CreatureDisplaySecondaryAttributes extends StatelessWidget {
  const CreatureDisplaySecondaryAttributes({ super.key, required this.creature });

  final Creature creature;

  @override
  Widget build(BuildContext context) {
    var armorValue = '${creature.naturalArmor.toString()}${creature.naturalArmorDescription.isEmpty ? "" : " (${creature.naturalArmorDescription})"}';

    return WidgetGroupContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8.0,
        children: [
          _SecondaryAttributeEntryWidget(
            title: 'Initiative',
            value: creature.initiative.toString()
          ),
          _SecondaryAttributeEntryWidget(
            title: 'Armure naturelle',
            value: armorValue,
          ),
        ],
      )
    );
  }
}

class _SecondaryAttributeEntryWidget extends StatelessWidget {
  const _SecondaryAttributeEntryWidget({ required this.title, required this.value });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value,
            style: theme.textTheme.bodyMedium,
          )
        ]
      )
    );
  }
}