import 'package:flutter/material.dart';

import '../../../../classes/equipment/armor.dart';
import '../../../../classes/equipment/cloth.dart';
import '../../../../classes/equipment/shield.dart';
import '../../../../classes/equipment/weapon.dart';

class WeaponInfoWidget extends StatelessWidget {
  const WeaponInfoWidget({ super.key, required this.weapon });

  final Weapon weapon;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    String damage;
    if((weapon.model as WeaponModel).damage.static != null && (weapon.model as WeaponModel).damage.static! > 0) {
      damage = (weapon.model as WeaponModel).damage.static.toString();
    }
    else {
      var ability = (weapon.model as WeaponModel).damage.ability!.short;
      var buffer = StringBuffer((weapon.model as WeaponModel).damage.multiply > 1
          ? '($ability x ${(weapon.model as WeaponModel).damage.multiply})'
          : ability);
      if((weapon.model as WeaponModel).damage.add > 0) {
        buffer.write(' + ${(weapon.model as WeaponModel).damage.add}');
      }
      if((weapon.model as WeaponModel).damage.dice > 0) {
        buffer.write(' + ${(weapon.model as WeaponModel).damage.dice}D10');
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
          'Pénalité ${(shield.model as ShieldModel).penalty}',
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
          'Pénalite ${(armor.model as ArmorModel).penalty}',
          style: theme.textTheme.bodySmall,
        ),
        Text(
          (armor.model as ArmorModel).type.title,
          style: theme.textTheme.bodySmall,
        )
      ],
    );
  }
}

class ClothInfoWidget extends StatelessWidget {
  const ClothInfoWidget({ super.key, required this.cloth });

  final Cloth cloth;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          cloth.name,
          style: theme.textTheme.titleMedium,
        ),
        Text(
          (cloth.model as ClothModel).slot.title,
          style: theme.textTheme.bodySmall,
        )
      ],
    );
  }
}