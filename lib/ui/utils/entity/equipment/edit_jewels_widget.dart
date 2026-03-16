import 'package:flutter/material.dart';

import '../../../../classes/entity_base.dart';
import '../../../../classes/equipment/equipment.dart';
import '../../../../classes/equipment/jewel.dart';
import '../../widget_group_container.dart';
import 'jewel_equip_widget.dart';
import 'jewel_picker_dialog.dart';

class EntityEditJewelsWidget extends StatelessWidget {
  const EntityEditJewelsWidget({
    super.key,
    required this.entity,
  });

  final EntityBase entity;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Bijoux',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      child: ListenableBuilder(
        listenable: entity.equipment,
        builder: (BuildContext context, _) {
          return _JewelsWidget(
            entity: entity,
          );
        }
      ),
    );
  }
}

class _JewelsWidget extends StatelessWidget {
  const _JewelsWidget({ required this.entity });

  final EntityBase entity;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var widgets = <Widget>[];

    for(var eq in entity.equipment) {
      if(eq is! Jewel) continue;

      widgets.add(
        ValueListenableBuilder(
          valueListenable: eq.equipedOnNotifier,
          builder: (BuildContext context, EquipableItemSlot? value, _) {
            return JewelEquipWidget(
              entity: entity,
              jewel: eq,
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
            label: const Text('Nouveau bijou'),
            onPressed: () async {
              Jewel? jewel = await showDialog(
                context: context,
                builder: (BuildContext context) => const JewelPickerDialog(),
              );
              if(jewel == null) return;

              entity.equipment.add(jewel);
            },
          ),
        ),
      ],
    );
  }
}