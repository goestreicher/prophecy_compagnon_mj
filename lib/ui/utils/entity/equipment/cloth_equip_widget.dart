import 'package:flutter/material.dart';

import '../../../../classes/entity_base.dart';
import '../../../../classes/equipment/cloth.dart';
import '../../../../classes/equipment/equipment.dart';
import 'equipment_info_widgets.dart';
import 'toggle_equipment_storage_widget.dart';

class ClothEquipWidget extends StatelessWidget {
  const ClothEquipWidget({
    super.key,
    required this.entity,
    required this.cloth,
    this.allowDelete = true,
  });

  final EntityBase entity;
  final Cloth cloth;
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
            entity.unequip(cloth);
            entity.equipment.remove(cloth);
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
            ClothInfoWidget(cloth: cloth),
            const Spacer(),
            ToggleEquipmentStorageWidget(
              entity: entity,
              equipment: cloth,
              carriedWidget: Column(
                children: [
                  Switch(
                    value: entity.isEquiped(cloth),
                    onChanged: (bool value) {
                      if(value) {
                        entity.replaceEquiped(
                          item: cloth,
                          target: (cloth.model as EquipableItemModel).slot,
                        );
                      }
                      else if(!value && entity.isEquiped(cloth)) {
                        entity.unequip(cloth);
                      }
                    },
                  ),
                  Text(
                    entity.isEquiped(cloth) ? 'Déséquiper' : 'Équiper',
                    style: theme.textTheme.bodySmall,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}