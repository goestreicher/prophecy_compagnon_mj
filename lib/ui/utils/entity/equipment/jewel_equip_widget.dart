import 'package:flutter/material.dart';

import '../../../../classes/entity_base.dart';
import '../../../../classes/equipment/equipment.dart';
import '../../../../classes/equipment/jewel.dart';
import 'equipment_info_widgets.dart';

class JewelEquipWidget extends StatelessWidget {
  const JewelEquipWidget({
    super.key,
    required this.entity,
    required this.jewel,
    this.allowDelete = true,
  });

  final EntityBase entity;
  final Jewel jewel;
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
              entity.unequip(jewel);
              entity.equipment.remove(jewel);
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
            JewelInfoWidget(jewel: jewel),
            const Spacer(),
            Column(
              children: [
                Switch(
                  value: entity.isEquiped(jewel),
                  onChanged: (bool value) {
                    if(value) {
                      entity.replaceEquiped(
                        item: jewel,
                        target: (jewel.model as EquipableItemModel).slot,
                      );
                    }
                    else if(!value && entity.isEquiped(jewel)) {
                      entity.unequip(jewel);
                    }
                  },
                ),
                Text(
                  entity.isEquiped(jewel) ? 'Déséquiper' : 'Équiper',
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