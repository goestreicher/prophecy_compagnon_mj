import 'package:flutter/material.dart';

import '../../classes/entity_base.dart';
import '../../classes/equipment.dart';
import '../../classes/weapon.dart';

enum EquipHands {
  dominant,
  weak,
  both
}

class WeaponEquipWidget extends StatefulWidget {
  WeaponEquipWidget({
    super.key,
    required this.character,
    required this.weapon,
    required this.onEquipedStateChanged,
    this.allowDelete = true,
  }) {
    if(weapon.model.damage.static > 0) {
      damage = weapon.model.damage.static.toString();
    }
    else {
      var buffer = StringBuffer(weapon.model.damage.multiply > 1
          ? '(FOR x ${weapon.model.damage.multiply})'
          : 'FOR');
      if(weapon.model.damage.add > 0) {
        buffer.write(' + ${weapon.model.damage.add}');
      }
      if(weapon.model.damage.dice > 0) {
        buffer.write(' + ${weapon.model.damage.dice}D10');
      }
      damage = buffer.toString();
    }
  }

  final EntityBase character;
  final Weapon weapon;
  late final String damage;
  final VoidCallback onEquipedStateChanged;
  final bool allowDelete;

  @override
  State<WeaponEquipWidget> createState() => _WeaponEquipWidgetState();
}

class _WeaponEquipWidgetState extends State<WeaponEquipWidget> {
  EquipHands? _selected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    if(widget.weapon.handiness == 2) {
      if(widget.character.dominantHandEquiped == widget.weapon) {
        _selected = EquipHands.both;
      }
      else {
        _selected = null;
      }
    }
    else if(widget.weapon.handiness == 1) {
      if(widget.character.dominantHandEquiped == widget.weapon) {
        _selected = EquipHands.dominant;
      } else if(widget.character.weakHandEquiped == widget.weapon) {
        _selected = EquipHands.weak;
      } else {
        _selected = null;
      }
    }
    // TODO: manage the weapons with a handiness of zero
    //    Requires changes in SupportsEquipableItem.equip & Co

    var leading = <Widget>[];
    if(widget.allowDelete) {
      leading.add(
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            setState(() {
              widget.character.removeEquipment(widget.weapon);
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
                  '\u{2694} ${widget.weapon.name()}',
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  'Dégats ${widget.damage}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            const Spacer(),
            if(!widget.character.meetsEquipableRequirements(widget.weapon))
              Text(
                'Pré-requis\n${widget.character.unmetEquipableRequirementsDescription(widget.weapon)}',
                textAlign: TextAlign.right,
                style: theme.textTheme.bodySmall,
              ),
            const SizedBox(width: 8.0),
            SegmentedButton<EquipHands>(
              segments: [
                if(widget.weapon.handiness == 1)
                  ButtonSegment<EquipHands>(
                    value: EquipHands.weak,
                    tooltip: 'Main faible',
                    icon: Transform.flip(flipX: true, child: const Icon(Icons.back_hand_outlined)),
                  ),
                if(widget.weapon.handiness == 2)
                  ButtonSegment<EquipHands>(
                    value: EquipHands.both,
                    tooltip: 'Deux mains',
                    icon: Row(
                      children: [
                        Transform.flip(flipX: true, child: const Icon(Icons.back_hand_outlined)),
                        const Icon(Icons.back_hand_outlined),
                      ],
                    ),
                  ),
                if(widget.weapon.handiness == 1)
                  ButtonSegment<EquipHands>(
                    enabled: widget.weapon.handiness == 1,
                    value: EquipHands.dominant,
                    tooltip: 'Main forte',
                    icon: const Icon(Icons.back_hand_outlined),
                  ),
              ],
              selected: _selected == null ? {} : <EquipHands>{_selected!},
              emptySelectionAllowed: true,
              showSelectedIcon: false,
              onSelectionChanged: !widget.character.meetsEquipableRequirements(widget.weapon)
                  ? null
                  : (Set<EquipHands> selection) {
                if(selection.isEmpty) {
                  _selected = null;
                  widget.character.unequip(widget.weapon);
                  widget.onEquipedStateChanged();
                }
                else {
                  var target = EquipableItemTarget.none;
                  if(selection.first == EquipHands.both) {
                    target = EquipableItemTarget.bothHands;
                  }
                  else if(selection.first == EquipHands.dominant) {
                    target = EquipableItemTarget.dominantHand;
                  }
                  else if(selection.first == EquipHands.weak) {
                    target = EquipableItemTarget.weakHand;
                  }
                  widget.character.replaceEquiped(widget.weapon, target: target);
                  widget.onEquipedStateChanged();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}