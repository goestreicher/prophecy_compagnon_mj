import 'package:flutter/material.dart';

import '../../../../classes/armor.dart';
import '../../../../classes/entity_base.dart';
import '../../../../classes/equipment.dart';
import 'equipment_info_widgets.dart';

class ArmorEquipWidget extends StatelessWidget {
  const ArmorEquipWidget({
    super.key,
    required this.entity,
    required this.armor,
    this.allowDelete = true,
  });

  final EntityBase entity;
  final Armor armor;
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
            entity.unequip(armor);
            entity.equipment.remove(armor);
          },
        )
      );
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
          spacing: 8.0,
          children: [
            ...leading,
            ArmorInfoWidget(armor: armor),
            const Spacer(),
            if(!entity.meetsEquipableRequirements(armor))
              Text(
                'Pré-requis\n${entity.unmetEquipableRequirementsDescription(armor)}',
                textAlign: TextAlign.right,
                style: theme.textTheme.bodySmall,
              ),
            Column(
              children: [
                Switch(
                  value: entity.isEquiped(armor),
                  onChanged: !entity.meetsEquipableRequirements(armor)
                    ? null
                    : (bool value) {
                        if(value) {
                          entity.replaceEquiped(
                            armor,
                            target: EquipableItemTarget.body
                          );
                        }
                        else if(!value && entity.isEquiped(armor)) {
                          entity.unequip(armor);
                        }
                      },
                ),
                Text(
                  entity.isEquiped(armor) ? 'Déséquiper' : 'Équiper',
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