import 'package:flutter/material.dart';
import 'package:prophecy_compagnon_shared/classes/entity/abilities.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/enums.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/equipment.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/shield.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/weapon.dart';
import 'package:prophecy_compagnon_shared/ui/entity/equipment/shield_equip_widget.dart';
import 'package:prophecy_compagnon_shared/ui/entity/equipment/shield_picker_dialog.dart';
import 'package:prophecy_compagnon_shared/ui/entity/equipment/weapon_equip_widget.dart';
import 'package:prophecy_compagnon_shared/ui/entity/equipment/weapon_picker_dialog.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class EntityEditWeaponsWidget extends StatelessWidget {
  const EntityEditWeaponsWidget({
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
            showStored: showStored,
            allowCreate: allowCreate,
            allowDelete: allowDelete,
          );
        }
      ),
    );
  }
}

class _WeaponsWidget extends StatelessWidget {
  const _WeaponsWidget({
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

  bool canDisplay(EquipableItem e) =>
      (showUnequipable || entity.meetsEquipableRequirements(e))
      && (showStored || !e.inStore);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var weapons = <Weapon>[];
    var shields = <Shield>[];
    var widgets = <Widget>[];

    for(var eq in entity.equipment) {
      if(eq is! EquipableItem) continue;
      if(!canDisplay(eq)) continue;

      if(eq is Weapon) {
        weapons.add(eq);
      }
      else if(eq is Shield) {
        shields.add(eq);
      }
    }

    for(var eq in [...weapons, ...shields]) {
      if (eq is Weapon) {
        widgets.add(
          StreamBuilder(
            stream: entity.abilities.streamController.stream,
            builder: (BuildContext context, AsyncSnapshot<AbilityStreamChange> snapshot) {
              // Here use a ValueKey for this widget watching only abilities of interest
              // abilities of interest: force, perception, coordination
              return ValueListenableBuilder(
                valueListenable: eq.equipedOnNotifier,
                builder: (BuildContext context, EquipableItemSlot? value, _) {
                  return WeaponEquipWidget(
                    entity: entity,
                    weapon: eq,
                    allowDelete: allowDelete,
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
                builder: (BuildContext context, EquipableItemSlot? value, _) {
                  return ShieldEquipWidget(
                    entity: entity,
                    shield: eq,
                    allowDelete: allowDelete,
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
        if(allowCreate)
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
                  Weapon? w = await showDialog(
                    context: context,
                    builder: (BuildContext context) => const WeaponPickerDialog(),
                  );
                  if(w == null) return;

                  entity.equipment.add(w);
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
                  Shield? s = await showDialog(
                    context: context,
                    builder: (BuildContext context) => const ShieldPickerDialog(),
                  );
                  if(s == null) return;
                  entity.equipment.add(s);
                },
              ),
            ],
          ),
      ],
    );
  }
}