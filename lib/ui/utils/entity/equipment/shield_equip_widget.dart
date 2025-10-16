import 'package:flutter/material.dart';

import '../../../../classes/entity_base.dart';
import '../../../../classes/equipment.dart';
import '../../../../classes/shield.dart';
import 'equipment_info_widgets.dart';

class ShieldEquipWidget extends StatelessWidget {
  const ShieldEquipWidget({
    super.key,
    required this.entity,
    required this.shield,
    this.allowDelete = true,
  });

  final EntityBase entity;
  final Shield shield;
  final bool allowDelete;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var leading = <Widget>[];
    if(allowDelete) {
      leading.add(
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            entity.unequip(shield);
            entity.equipment.remove(shield);
          },
        )
      );
      leading.add(const SizedBox(width: 12.0));
    }

    return Card(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0)
      ),
      child:
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            for(var w in leading)
              w,
            ShieldInfoWidget(shield: shield),
            const Spacer(),
            if(!entity.meetsEquipableRequirements(shield))
              Text(
                'Pré-requis\n${entity.unmetEquipableRequirementsDescription(shield)}',
                textAlign: TextAlign.right,
                style: theme.textTheme.bodySmall,
              ),
            const SizedBox(width: 8.0),
            Column(
              children: [
                Switch(
                  value: entity.isEquiped(shield),
                  onChanged: !entity.meetsEquipableRequirements(shield)
                      ? null
                      : (bool value) {
                    if(value) {
                      entity.replaceEquiped(
                        shield,
                        target: EquipableItemTarget.weakHand
                      );
                    }
                    else if(!value && entity.isEquiped(shield)) {
                      entity.unequip(shield);
                    }
                  },
                ),
                Text(
                  entity.isEquiped(shield) ? 'Déséquiper' : 'Équiper',
                  style: theme.textTheme.bodySmall,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}