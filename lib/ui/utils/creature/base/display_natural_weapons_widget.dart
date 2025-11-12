import 'package:flutter/material.dart';

import '../../../../classes/creature.dart';
import '../../widget_group_container.dart';
import 'display_natural_weapon_widget.dart';

class CreatureDisplayNaturalWeaponsWidget extends StatelessWidget {
  const CreatureDisplayNaturalWeaponsWidget({ super.key, required this.creature });

  final Creature creature;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var widgets = <Widget>[];
    if(creature.naturalWeapons.isEmpty) {
      widgets.add(Text(
        'Aucune',
        style: theme.textTheme.bodySmall!.copyWith(
          fontStyle: FontStyle.italic
        ),
      ));
    }
    else {
      for(var w in creature.naturalWeapons) {
        widgets.add(
          NaturalWeaponDisplayWidget(
            weapon: w,
          )
        );
      }
    }

    return WidgetGroupContainer(
      title: Text(
        'Armes naturelles',
        style: theme.textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.bold,
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.0,
        children: widgets,
      )
    );
  }
}