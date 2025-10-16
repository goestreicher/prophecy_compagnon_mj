import 'package:flutter/material.dart';

import '../../../../classes/armor.dart';
import '../../../../classes/entity/abilities.dart';
import '../../../../classes/entity_base.dart';
import '../../../../classes/equipment.dart';
import '../../widget_group_container.dart';
import 'armor_equip_widget.dart';
import 'armor_picker_dialog.dart';

class EntityEditArmorWidget extends StatelessWidget {
  const EntityEditArmorWidget({
    super.key,
    required this.entity,
    this.showUnequipable = true,
  });

  final EntityBase entity;
  final bool showUnequipable;

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
          );
        }
      ),
    );
  }
}

class _ArmorsWidget extends StatelessWidget {
  const _ArmorsWidget({ required this.entity, this.showUnequipable = true });

  final EntityBase entity;
  final bool showUnequipable;

  bool canDisplay(Armor a) =>
      showUnequipable
      || entity.meetsEquipableRequirements(a);

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
              builder: (BuildContext context, EquipableItemTarget value, _) {
                return ArmorEquipWidget(
                  entity: entity,
                  armor: eq,
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
              String? armorId = await showDialog(
                context: context,
                builder: (BuildContext context) => const ArmorPickerDialog(),
              );
              if(armorId == null) return;

              ArmorModel? model = ArmorModel.get(armorId);
              if(model == null) return;

              entity.equipment.add(model.instantiate());
            },
          ),
        ),
      ],
    );
  }
}