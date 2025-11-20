import 'package:flutter/material.dart';

import '../../../../classes/armor.dart';
import '../../../../classes/shield.dart';
import '../../../../classes/weapon.dart';

class WeaponInfoWidget extends StatelessWidget {
  const WeaponInfoWidget({ super.key, required this.weapon });

  final Weapon weapon;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    String damage;
    if(weapon.model.damage.static != null && weapon.model.damage.static! > 0) {
      damage = weapon.model.damage.static.toString();
    }
    else {
      var ability = weapon.model.damage.ability!.short;
      var buffer = StringBuffer(weapon.model.damage.multiply > 1
          ? '($ability x ${weapon.model.damage.multiply})'
          : ability);
      if(weapon.model.damage.add > 0) {
        buffer.write(' + ${weapon.model.damage.add}');
      }
      if(weapon.model.damage.dice > 0) {
        buffer.write(' + ${weapon.model.damage.dice}D10');
      }
      damage = buffer.toString();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '\u{2694} ${weapon.name}',
          style: theme.textTheme.titleMedium,
        ),
        Text(
          'Dégats $damage',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class ShieldInfoWidget extends StatelessWidget {
  const ShieldInfoWidget({ super.key, required this.shield });
  
  final Shield shield;
  
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '\u{1F6E1} ${shield.name}',
          style: theme.textTheme.titleMedium,
        ),
        Text(
          'Protection ${shield.protection()}',
          style: theme.textTheme.bodyMedium,
        ),
        Text(
          'Pénalité ${shield.model.penalty}',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class ArmorInfoWidget extends StatelessWidget {
  const ArmorInfoWidget({ super.key, required this.armor });

  final Armor armor;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '\u{1FA96} ${armor.name}',
          style: theme.textTheme.titleMedium,
        ),
        Text(
          'Protection ${armor.protection()}',
          style: theme.textTheme.bodyMedium,
        ),
        Text(
          'Pénalite ${armor.model.penalty}',
          style: theme.textTheme.bodySmall,
        ),
        Text(
          armor.model.type.title,
          style: theme.textTheme.bodySmall,
        )
      ],
    );
  }
}