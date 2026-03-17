import 'package:flutter/material.dart';

import '../../../../classes/entity_base.dart';
import '../../../../classes/equipment/misc_gear.dart';
import 'equipment_info_widgets.dart';
import 'toggle_equipment_storage_widget.dart';

class MiscGearManageWidget extends StatelessWidget {
  const MiscGearManageWidget({
    super.key,
    required this.entity,
    required this.item,
    required this.quantity,
    this.onRemoved,
    this.onDecreased,
    this.onIncreased,
  });

  final EntityBase entity;
  final MiscGear item;
  final int quantity;
  final void Function()? onRemoved;
  final void Function()? onDecreased;
  final void Function()? onIncreased;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var leading = <Widget>[];
    if(onRemoved != null) {
      leading.add(
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => onRemoved!(),
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
            MiscGearInfoWidget(item: item),
            const Spacer(),
            Column(
              spacing: 4.0,
              children: [
                Row(
                  spacing: 8.0,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      iconSize: 18.0,
                      padding: const EdgeInsets.all(8.0),
                      constraints: const BoxConstraints(),
                      onPressed: onDecreased == null || quantity < 2
                        ? null
                        : () => onDecreased!.call(),
                    ),
                    Text(quantity.toString()),
                    IconButton(
                      icon: Icon(Icons.add),
                      iconSize: 18.0,
                      padding: const EdgeInsets.all(8.0),
                      constraints: const BoxConstraints(),
                      onPressed: onIncreased == null
                        ? null
                        : () => onIncreased!.call(),
                    ),
                  ]
                ),
                Text(
                  'Quantité',
                  style: theme.textTheme.bodySmall,
                )
              ],
            ),
            ToggleEquipmentStorageWidget(
              entity: entity,
              equipment: item,
            ),
          ],
        ),
      ),
    );
  }
}