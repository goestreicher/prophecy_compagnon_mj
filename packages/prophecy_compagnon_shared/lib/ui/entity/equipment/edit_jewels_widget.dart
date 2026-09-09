import 'package:flutter/material.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/enums.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/jewel.dart';
import 'package:prophecy_compagnon_shared/ui/entity/equipment/jewel_equip_widget.dart';
import 'package:prophecy_compagnon_shared/ui/entity/equipment/jewel_picker_dialog.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class EntityEditJewelsWidget extends StatelessWidget {
  const EntityEditJewelsWidget({
    super.key,
    required this.entity,
    this.showStored = true,
    this.allowCreate = true,
    this.allowDelete = true,
  });

  final EntityBase entity;
  final bool showStored;
  final bool allowCreate;
  final bool allowDelete;

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
            showStored: showStored,
            allowCreate: allowCreate,
            allowDelete: allowDelete,
          );
        }
      ),
    );
  }
}

class _JewelsWidget extends StatelessWidget {
  const _JewelsWidget({
    required this.entity,
    this.showStored = true,
    this.allowCreate = true,
    this.allowDelete = true,
  });

  final EntityBase entity;
  final bool showStored;
  final bool allowCreate;
  final bool allowDelete;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var widgets = <Widget>[];

    for(var eq in entity.equipment) {
      if(eq is! Jewel) continue;
      if(eq.inStore && !showStored) continue;

      widgets.add(
        ValueListenableBuilder(
          valueListenable: eq.equipedOnNotifier,
          builder: (BuildContext context, EquipableItemSlot? value, _) {
            return JewelEquipWidget(
              entity: entity,
              jewel: eq,
              allowDelete: allowDelete,
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
        if(allowCreate)
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