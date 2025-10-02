import 'package:flutter/material.dart';

import '../../../../classes/combat.dart';
import '../../../../classes/creature.dart';

class NaturalWeaponDisplayWidget extends StatelessWidget {
  const NaturalWeaponDisplayWidget({ super.key, required this.weapon });

  final NaturalWeaponModel weapon;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var rangeWidgets = <Widget>[];
    for(var r in weapon.ranges.keys) {
      rangeWidgets.add(
        DefaultTextStyle(
          style: theme.textTheme.bodySmall!,
          child: Row(
            spacing: 8.0,
            children: [
              Text(
                r.title,
              ),
              Text(
                'Init. ${weapon.ranges[r]!.initiative}',
              ),
              if(r != WeaponRange.contact)
                Text(
                    '${r != WeaponRange.ranged ? "Distance" : "Distance efficace"} ${weapon.ranges[r]!.effectiveDistance.toStringAsFixed(2)} m'
                ),
              if(r == WeaponRange.ranged)
                Text(
                    'Distance maximum ${weapon.ranges[r]!.maximumDistance!.toStringAsFixed(2)} m'
                ),
            ],
          ),
        )
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          weapon.name,
          style: theme.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        DefaultTextStyle(
          style: theme.textTheme.bodySmall!,
          child: Row(
            spacing: 8.0,
            children: [
              Text(
                'Compétence : ${weapon.skill.toString()}',
              ),
              Text(
                'Dégâts : ${weapon.damage.toString()}',
              )
            ],
          ),
        ),
        ...rangeWidgets,
      ],
    );
  }
}