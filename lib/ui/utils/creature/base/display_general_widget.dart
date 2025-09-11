import 'package:flutter/material.dart';

import '../../../../classes/creature.dart';
import '../../widget_group_container.dart';

class CreatureDisplayGeneralWidget extends StatelessWidget {
  const CreatureDisplayGeneralWidget({ super.key, required this.creature });

  final CreatureModel creature;

  @override
  Widget build(BuildContext context) {
    return WidgetGroupContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12.0,
        children: [
          Row(
            children: [
              Expanded(child: _GeneralEntryWidget(title: 'Taille', value: creature.realSize)),
              Expanded(child: _GeneralEntryWidget(title: 'Poids', value: creature.weight.toString())),
            ],
          ),
          _GeneralEntryWidget(title: 'Habitat', value: creature.biome),
        ],
      )
    );
  }
}

class _GeneralEntryWidget extends StatelessWidget {
  const _GeneralEntryWidget({ required this.title, required this.value });

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