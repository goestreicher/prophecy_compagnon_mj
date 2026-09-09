import 'package:flutter/material.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/cloth.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/enums.dart';
import 'package:prophecy_compagnon_shared/ui/entity/equipment/cloth_equip_widget.dart';
import 'package:prophecy_compagnon_shared/ui/entity/equipment/cloth_picker_dialog.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class EntityEditClothesWidget extends StatelessWidget {
  const EntityEditClothesWidget({
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
            showStored: showStored,
            allowCreate: allowCreate,
            allowDelete: allowDelete,
          );
        }
      ),
    );
  }
}

class _ClothesWidget extends StatelessWidget {
  const _ClothesWidget({
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
      if(eq is! Cloth) continue;
      if(eq.inStore && !showStored) continue;

      widgets.add(
        ValueListenableBuilder(
          valueListenable: eq.equipedOnNotifier,
          builder: (BuildContext context, EquipableItemSlot? value, _) {
            return ClothEquipWidget(
              entity: entity,
              cloth: eq,
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