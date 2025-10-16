import 'package:flutter/material.dart';

import '../../../../classes/entity/abilities.dart';
import '../../../../classes/entity_base.dart';
import '../../../../classes/equipment.dart';
import '../../../../classes/shield.dart';
import '../../../../classes/weapon.dart';
import '../../widget_group_container.dart';
import 'shield_equip_widget.dart';
import 'shield_picker_dialog.dart';
import 'weapon_equip_widget.dart';
import 'weapon_picker_dialog.dart';

class EntityEditWeaponsWidget extends StatelessWidget {
  const EntityEditWeaponsWidget({
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
        'Armes & Boucliers',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        )
      ),
      child: ListenableBuilder(
        listenable: entity.equipment,
        builder: (BuildContext context, _) {
          return _WeaponsWidget(
            entity: entity,
            showUnequipable: showUnequipable,
          );
        }
      ),
    );
  }
}

class _WeaponsWidget extends StatelessWidget {
  const _WeaponsWidget({ required this.entity, this.showUnequipable = true });

  final EntityBase entity;
  final bool showUnequipable;

  bool canDisplay(EquipableItem e) =>
      showUnequipable
      || entity.meetsEquipableRequirements(e);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var widgets = <Widget>[];

    for(var eq in entity.equipment) {
      if(eq is! EquipableItem) continue;
      if(!canDisplay(eq)) continue;

      if (eq is Weapon) {
        widgets.add(
          StreamBuilder(
            stream: entity.abilities.streamController.stream,
            builder: (BuildContext context, AsyncSnapshot<AbilityStreamChange> snapshot) {
              // Here use a ValueKey for this widget watching only abilities of interest
              // abilities of interest: force, perception, coordination
              return ValueListenableBuilder(
                valueListenable: eq.equipedOnNotifier,
                builder: (BuildContext context, EquipableItemTarget value, _) {
                  return WeaponEquipWidget(
                    entity: entity,
                    weapon: eq,
                  );
                }
              );
            }
          )
        );
      }
      else if (eq is Shield && canDisplay(eq)) {
        widgets.add(
          StreamBuilder(
            stream: entity.abilities.streamController.stream,
            builder: (BuildContext context, AsyncSnapshot<AbilityStreamChange> snapshot) {
              // Here use a ValueKey for this widget watching only abilities of interest
              // abilities of interest: force, resistance
              return ValueListenableBuilder(
                valueListenable: eq.equipedOnNotifier,
                builder: (BuildContext context, EquipableItemTarget value, _) {
                  return ShieldEquipWidget(
                    entity: entity,
                    shield: eq,
                  );
                }
              );
            }
          )
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12.0,
      children: [
        ...widgets,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16.0,
          children: [
            ElevatedButton.icon(
              icon: const Icon(
                Icons.add,
                size: 16.0,
              ),
              style: ElevatedButton.styleFrom(
                textStyle: theme.textTheme.bodySmall,
              ),
              label: const Text('Nouvelle arme'),
              onPressed: () async {
                String? weaponId = await showDialog(
                  context: context,
                  builder: (BuildContext context) => const WeaponPickerDialog(),
                );
                if(weaponId == null) return;

                WeaponModel? model = WeaponModel.get(weaponId);
                if(model == null) return;

                entity.equipment.add(model.instantiate());
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(
                Icons.add,
                size: 16.0,
              ),
              style: ElevatedButton.styleFrom(
                textStyle: theme.textTheme.bodySmall,
              ),
              label: const Text('Nouveau bouclier'),
              onPressed: () async {
                String? shieldId = await showDialog(
                  context: context,
                  builder: (BuildContext context) => const ShieldPickerDialog(),
                );
                if(shieldId == null) return;

                ShieldModel? model = ShieldModel.get(shieldId);
                if(model == null) return;

                entity.equipment.add(model.instantiate());
              },
            ),
          ],
        )
      ],
    );
  }
}