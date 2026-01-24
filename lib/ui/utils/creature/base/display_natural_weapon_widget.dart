import 'package:flutter/material.dart';

import '../../../../classes/combat.dart';
import '../../../../classes/creature.dart';

class NaturalWeaponDisplayWidget extends StatelessWidget {
  const NaturalWeaponDisplayWidget({ super.key, required this.weapon });

  final NaturalWeaponModel weapon;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var buffer = StringBuffer();
    if(weapon.damage.static != null && weapon.damage.static! > 0) {
      buffer.write(weapon.damage.static.toString());
    }
    else if(weapon.damage.ability != null) {
      var ability = weapon.damage.ability!.short;
      buffer.write(weapon.damage.multiply > 1
          ? '($ability x ${weapon.damage.multiply})'
          : ability);
      if(weapon.damage.add > 0) {
        buffer.write(' + ${weapon.damage.add}');
      }
    }
    else {
      buffer.write('0');
    }
    if(weapon.damage.dice > 0) {
      buffer.write(' + ${weapon.damage.dice}D10');
    }
    var damage = buffer.toString();

    var rangeWidgets = <Widget>[];
    for(var r in weapon.ranges.keys) {
      String spec = '${r.title} - Init. ${weapon.ranges[r]!.initiative}';

      spec += '${r != WeaponRange.ranged ? " - Distance" : " - Distance efficace"} ${weapon.ranges[r]!.effectiveDistance.toStringAsFixed(2)} m';
      if(r == WeaponRange.ranged) {
        spec += ' - Distance maximum ${weapon.ranges[r]!.maximumDistance!.toStringAsFixed(2)} m';
      }

      rangeWidgets.add(
        DefaultTextStyle(
          style: theme.textTheme.bodySmall!,
          child: Row(
            spacing: 8.0,
            children: [
              Expanded(
                child: Text(
                  spec,
                ),
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
        if(weapon.special != null)
          Text(
            weapon.special!,
            softWrap: true,
            style: theme.textTheme.bodySmall
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
                'Dégâts : $damage',
              )
            ],
          ),
        ),
        ...rangeWidgets,
      ],
    );
  }
}