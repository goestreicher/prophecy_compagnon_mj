import 'package:flutter/material.dart';

import '../../../../classes/armor.dart';
import '../../../../classes/entity_base.dart';
import '../../../../classes/equipment.dart';
import 'equipment_info_widgets.dart';

class ArmorEquipWidget extends StatefulWidget {
  const ArmorEquipWidget({
    super.key,
    required this.entity,
    required this.armor,
    required this.onEquipedStateChanged,
    this.allowDelete = true,
  });

  final EntityBase entity;
  final Armor armor;
  final VoidCallback onEquipedStateChanged;
  final bool allowDelete;

  @override
  State<ArmorEquipWidget> createState() => _ArmorEquipWidgetState();
}

class _ArmorEquipWidgetState extends State<ArmorEquipWidget> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var leading = <Widget>[];
    if(widget.allowDelete) {
      leading.add(
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                widget.entity.removeEquipment(widget.armor);
                widget.onEquipedStateChanged();
              });
            },
          )
      );
    }

    return Card(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0)
      ),
      child:
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          spacing: 8.0,
          children: [
            for(var w in leading)
              w,
            ArmorInfoWidget(armor: widget.armor),
            const Spacer(),
            if(!widget.entity.meetsEquipableRequirements(widget.armor))
              Text(
                'Pré-requis\n${widget.entity.unmetEquipableRequirementsDescription(widget.armor)}',
                textAlign: TextAlign.right,
                style: theme.textTheme.bodySmall,
              ),
            Column(
              children: [
                Switch(
                  value: widget.entity.isEquiped(widget.armor),
                  onChanged: !widget.entity.meetsEquipableRequirements(widget.armor)
                      ? null
                      : (bool value) {
                    if(value) {
                      widget.entity.replaceEquiped(widget.armor, target: EquipableItemTarget.body);
                      widget.onEquipedStateChanged();
                    }
                    else if(!value && widget.entity.isEquiped(widget.armor)) {
                      widget.entity.unequip(widget.armor);
                      widget.onEquipedStateChanged();
                    }
                  },
                ),
                Text(
                  widget.entity.isEquiped(widget.armor) ? 'Déséquiper' : 'Équiper',
                  style: theme.textTheme.bodySmall,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}