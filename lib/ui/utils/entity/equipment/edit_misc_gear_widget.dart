import 'package:flutter/material.dart';

import '../../../../classes/entity_base.dart';
import '../../../../classes/equipment/misc_gear.dart';
import '../../widget_group_container.dart';
import 'misc_gear_manage_widget.dart';
import 'misc_gear_picker_dialog.dart';

class EntityEditMiscGearWidget extends StatelessWidget {
  const EntityEditMiscGearWidget({
    super.key,
    required this.entity,
  });

  final EntityBase entity;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Équipement commun',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      child: ListenableBuilder(
        listenable: entity.equipment,
        builder: (BuildContext context, _) {
          return _MiscGearWidget(
            entity: entity,
          );
        }
      ),
    );
  }
}

class _MiscGearQuantity {
  _MiscGearQuantity({ required this.item, required this.quantity });

  final MiscGear item;
  int quantity;
}

class _MiscGearWidget extends StatelessWidget {
  const _MiscGearWidget({ required this.entity });

  final EntityBase entity;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var items = <String, _MiscGearQuantity>{};
    for(var eq in entity.equipment) {
      if(eq is! MiscGear) continue;

      var k = '${eq.model.uuid}+${eq.name}+${eq.quality.name}';
      if(!items.containsKey(k)) {
        items[k] = _MiscGearQuantity(item: eq, quantity: 1);
      }
      else {
        items[k]!.quantity += 1;
      }
    }

    var widgets = <Widget>[];
    for(var eq in items.values) {
      widgets.add(
        MiscGearManageWidget(
          entity: entity,
          item: eq.item,
          quantity: eq.quantity,
          onRemoved: () {
            entity.equipment.removeWhere((e) => e.model.uuid == eq.item.model.uuid);
          },
          onDecreased: () {
            entity.equipment.remove(eq.item);
          },
          onIncreased: () {
            entity.equipment.add(
              MiscGear.create(
                model: eq.item.model,
                alias: eq.item.alias,
                quality: eq.item.quality,
              )
            );
          },
        )
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12.0,
      children: [
        ...widgets,
        Center(
          child: ElevatedButton.icon(
            icon: const Icon(
              Icons.add,
              size: 16.0,
            ),
            style: ElevatedButton.styleFrom(
              textStyle: theme.textTheme.bodySmall,
            ),
            label: const Text('Nouvel équipement'),
            onPressed: () async {
              MiscGear? item = await showDialog(
                context: context,
                builder: (BuildContext context) => const MiscGearPickerDialog(),
              );
              if(item == null) return;

              entity.equipment.add(item);
            },
          ),
        ),
      ],
    );
  }
}