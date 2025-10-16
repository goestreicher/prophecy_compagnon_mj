import 'package:flutter/material.dart';

import '../../../../classes/entity_base.dart';
import '../../../../classes/equipment.dart';
import '../../../../classes/weapon.dart';
import 'equipment_info_widgets.dart';

class WeaponEquipWidget extends StatelessWidget {
  const WeaponEquipWidget({
    super.key,
    required this.entity,
    required this.weapon,
    this.allowDelete = true,
  });

  final EntityBase entity;
  final Weapon weapon;
  final bool allowDelete;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    // TODO: manage the weapons with a handiness of zero
    //    Requires changes in SupportsEquipableItem.equip & Co

    var leading = <Widget>[];
    if(allowDelete) {
      leading.add(
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            entity.unequip(weapon);
            entity.equipment.remove(weapon);
          },
        )
      );
      leading.add(const SizedBox(width: 12.0));
    }

    return Card(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            for(var w in leading)
              w,
            WeaponInfoWidget(weapon: weapon),
            const Spacer(),
            if(!entity.meetsEquipableRequirements(weapon))
              Text(
                'Pré-requis\n${entity.unmetEquipableRequirementsDescription(weapon)}',
                textAlign: TextAlign.right,
                style: theme.textTheme.bodySmall,
              ),
            const SizedBox(width: 8.0),
            SegmentedButton<EquipableItemTarget>(
              segments: [
                if(weapon.handiness == 1)
                  ButtonSegment<EquipableItemTarget>(
                    value: EquipableItemTarget.weakHand,
                    tooltip: 'Main faible',
                    icon: Transform.flip(flipX: true, child: const Icon(Icons.back_hand_outlined)),
                  ),
                if(weapon.handiness == 2)
                  ButtonSegment<EquipableItemTarget>(
                    value: EquipableItemTarget.bothHands,
                    tooltip: 'Deux mains',
                    icon: Row(
                      children: [
                        Transform.flip(flipX: true, child: const Icon(Icons.back_hand_outlined)),
                        const Icon(Icons.back_hand_outlined),
                      ],
                    ),
                  ),
                if(weapon.handiness == 1)
                  ButtonSegment<EquipableItemTarget>(
                    enabled: weapon.handiness == 1,
                    value: EquipableItemTarget.dominantHand,
                    tooltip: 'Main forte',
                    icon: const Icon(Icons.back_hand_outlined),
                  ),
              ],
              selected: weapon.equipedOn == EquipableItemTarget.none
                  ? {}
                  : <EquipableItemTarget>{weapon.equipedOn},
              emptySelectionAllowed: true,
              showSelectedIcon: false,
              onSelectionChanged:
                !entity.meetsEquipableRequirements(weapon)
                  ? null
                  : (Set<EquipableItemTarget> selection) {
                      if(selection.isEmpty) {
                        entity.unequip(weapon);
                      }
                      else {
                        entity.replaceEquiped(
                          weapon,
                          target: selection.first
                        );
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}