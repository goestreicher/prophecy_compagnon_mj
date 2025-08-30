import 'package:flutter/material.dart';

import '../../classes/entity_base.dart';
import '../../classes/equipment.dart';
import '../../classes/shield.dart';

class ShieldEquipWidget extends StatefulWidget {
  const ShieldEquipWidget({
    super.key,
    required this.character,
    required this.shield,
    required this.onEquipedStateChanged,
    this.allowDelete = true,
  });

  final EntityBase character;
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
              widget.character.removeEquipment(widget.shield);
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\u{1F6E1} ${widget.shield.name()}',
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  'Protection ${widget.shield.protection()}',
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  'Pénalité ${widget.shield.model.penalty}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            const Spacer(),
            if(!widget.character.meetsEquipableRequirements(widget.shield))
              Text(
                'Pré-requis\n${widget.character.unmetEquipableRequirementsDescription(widget.shield)}',
                textAlign: TextAlign.right,
                style: theme.textTheme.bodySmall,
              ),
            const SizedBox(width: 8.0),
            Column(
              children: [
                Switch(
                  value: widget.character.isEquiped(widget.shield),
                  onChanged: !widget.character.meetsEquipableRequirements(widget.shield)
                      ? null
                      : (bool value) {
                    if(value) {
                      widget.character.replaceEquiped(widget.shield, target: EquipableItemTarget.weakHand);
                      widget.onEquipedStateChanged();
                    }
                    else if(!value && widget.character.isEquiped(widget.shield)) {
                      widget.character.unequip(widget.shield);
                      widget.onEquipedStateChanged();
                    }
                  },
                ),
                Text(
                  widget.character.isEquiped(widget.shield) ? 'Déséquiper' : 'Équiper',
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