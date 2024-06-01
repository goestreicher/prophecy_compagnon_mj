import 'package:flutter/material.dart';

import '../../classes/entity_base.dart';
import 'edit_equipment_tab_armor.dart';
import 'edit_equipment_tab_weapon.dart';

class EditEquipmentTab extends StatelessWidget {
  const EditEquipmentTab({ super.key, required this.character });

  final EntityBase character;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 600,
            maxWidth: 750,
          ),
          child: Container(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ArmorListWidget(character: character),
                WeaponListWidget(character: character),
              ]
            ),
          ),
        ),
      ),
    );
  }
}