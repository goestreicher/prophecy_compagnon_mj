import 'package:flutter/material.dart';

import '../../../../classes/entity_base.dart';
import '../../../../classes/equipment.dart';
import '../../../../classes/shield.dart';
import 'equipment_info_widgets.dart';

class ShieldEquipWidget extends StatefulWidget {
  const ShieldEquipWidget({
    super.key,
    required this.entity,
    required this.shield,
    required this.onEquipedStateChanged,
    this.allowDelete = true,
  });

  final EntityBase entity;
  final Shield shield;
  final VoidCallback onEquipedStateChanged;
  final bool allowDelete;

  @override
  State<ShieldEquipWidget> createState() => _ShieldEquipWidgetState();
}

class _ShieldEquipWidgetState extends State<ShieldEquipWidget> {
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
              widget.entity.removeEquipment(widget.shield);
              widget.onEquipedStateChanged();
            });
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
      child:
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            for(var w in leading)
              w,
            ShieldInfoWidget(shield: widget.shield),
            const Spacer(),
            if(!widget.entity.meetsEquipableRequirements(widget.shield))
              Text(
                'Pré-requis\n${widget.entity.unmetEquipableRequirementsDescription(widget.shield)}',
                textAlign: TextAlign.right,
                style: theme.textTheme.bodySmall,
              ),
            const SizedBox(width: 8.0),
            Column(
              children: [
                Switch(
                  value: widget.entity.isEquiped(widget.shield),
                  onChanged: !widget.entity.meetsEquipableRequirements(widget.shield)
                      ? null
                      : (bool value) {
                    if(value) {
                      widget.entity.replaceEquiped(widget.shield, target: EquipableItemTarget.weakHand);
                      widget.onEquipedStateChanged();
                    }
                    else if(!value && widget.entity.isEquiped(widget.shield)) {
                      widget.entity.unequip(widget.shield);
                      widget.onEquipedStateChanged();
                    }
                  },
                ),
                Text(
                  widget.entity.isEquiped(widget.shield) ? 'Déséquiper' : 'Équiper',
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