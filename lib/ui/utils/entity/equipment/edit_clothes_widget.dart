import 'package:flutter/material.dart';

import '../../../../classes/entity_base.dart';
import '../../../../classes/equipment/cloth.dart';
import '../../../../classes/equipment/equipment.dart';
import '../../widget_group_container.dart';
import 'cloth_equip_widget.dart';
import 'cloth_picker_dialog.dart';

class EntityEditClothesWidget extends StatelessWidget {
  const EntityEditClothesWidget({
    super.key,
    required this.entity,
  });

  final EntityBase entity;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Vêtements',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      child: ListenableBuilder(
        listenable: entity.equipment,
        builder: (BuildContext context, _) {
          return _ClothesWidget(
            entity: entity,
          );
        }
      ),
    );
  }
}

class _ClothesWidget extends StatelessWidget {
  const _ClothesWidget({ required this.entity });

  final EntityBase entity;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var widgets = <Widget>[];

    for(var eq in entity.equipment) {
      if(eq is! Cloth) continue;

      widgets.add(
        ValueListenableBuilder(
          valueListenable: eq.equipedOnNotifier,
          builder: (BuildContext context, EquipableItemSlot? value, _) {
            return ClothEquipWidget(
              entity: entity,
              cloth: eq,
            );
          }
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
            label: const Text('Nouveau vêtement'),
            onPressed: () async {
              Cloth? cloth = await showDialog(
                context: context,
                builder: (BuildContext context) => const ClothPickerDialog(),
              );
              if(cloth == null) return;

              entity.equipment.add(cloth);
            },
          ),
        ),
      ],
    );
  }
}