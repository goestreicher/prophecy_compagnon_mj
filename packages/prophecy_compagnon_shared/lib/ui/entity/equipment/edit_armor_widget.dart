import 'package:flutter/material.dart';
import 'package:prophecy_compagnon_shared/classes/entity/abilities.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/armor.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/enums.dart';
import 'package:prophecy_compagnon_shared/ui/entity/equipment/armor_equip_widget.dart';
import 'package:prophecy_compagnon_shared/ui/entity/equipment/armor_picker_dialog.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class EntityEditArmorWidget extends StatelessWidget {
  const EntityEditArmorWidget({
    super.key,
    required this.entity,
    this.showUnequipable = true,
    this.showStored = true,
    this.allowCreate = true,
    this.allowDelete = true,
  });

  final EntityBase entity;
  final bool showUnequipable;
  final bool showStored;
  final bool allowCreate;
  final bool allowDelete;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Armures',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      child: ListenableBuilder(
        listenable: entity.equipment,
        builder: (BuildContext context, _) {
          return _ArmorsWidget(
            entity: entity,
            showUnequipable: showUnequipable,
            showStored: showStored,
            allowCreate: allowCreate,
            allowDelete: allowDelete,
          );
        }
      ),
    );
  }
}

class _ArmorsWidget extends StatelessWidget {
  const _ArmorsWidget({
    required this.entity,
    this.showUnequipable = true,
    this.showStored = true,
    this.allowCreate = true,
    this.allowDelete = true,
  });

  final EntityBase entity;
  final bool showUnequipable;
  final bool showStored;
  final bool allowCreate;
  final bool allowDelete;

  bool canDisplay(Armor a) =>
      (showUnequipable || entity.meetsEquipableRequirements(a))
      && (showStored || !a.inStore);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var widgets = <Widget>[];

    for(var eq in entity.equipment) {
      if(eq is! Armor) continue;
      if(!canDisplay(eq)) continue;

      widgets.add(
        StreamBuilder(
          stream: entity.abilities.streamController.stream,
          builder: (BuildContext context, AsyncSnapshot<AbilityStreamChange> snapshot) {
            // Here use a ValueKey for this widget watching only abilities of interest
            // abilities of interest: force, resistance
            return ValueListenableBuilder(
              valueListenable: eq.equipedOnNotifier,
              builder: (BuildContext context, EquipableItemSlot? value, _) {
                return ArmorEquipWidget(
                  entity: entity,
                  armor: eq,
                  allowDelete: allowDelete,
                );
              }
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
              label: const Text('Nouvelle armure'),
              onPressed: () async {
                Armor? a = await showDialog(
                  context: context,
                  builder: (BuildContext context) => const ArmorPickerDialog(),
                );
                if(a == null) return;

                entity.equipment.add(a);
              },
            ),
          ),
      ],
    );
  }
}