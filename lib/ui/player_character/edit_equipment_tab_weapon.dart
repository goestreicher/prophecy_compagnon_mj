import 'package:flutter/material.dart';

import '../../classes/entity_base.dart';
import '../../classes/equipment.dart';
import '../../classes/shield.dart';
import '../../classes/weapon.dart';
import '../utils/entity/equipment/shield_picker_dialog.dart';
import '../utils/entity/equipment/weapon_picker_dialog.dart';

enum EquipHands { dominant, weak, both }

class WeaponListWidget extends StatefulWidget {
  const WeaponListWidget({
    super.key,
    required this.character,
    this.allowDelete = true,
    this.showUnequipable = true,
    this.allowCreate = true,
  });

  final EntityBase character;
  final bool allowDelete;
  final bool showUnequipable;
  final bool allowCreate;

  @override
  State<WeaponListWidget> createState() => _WeaponListWidgetState();
}

class _WeaponListWidgetState extends State<WeaponListWidget> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var trailing = <Widget>[];
    if(widget.allowCreate) {
      trailing.add(const SizedBox(height: 12.0));
      trailing.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
              setState(() {
                widget.character.addEquipment(model.instantiate());
              });
            },
          ),
          const SizedBox(width: 16.0),
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
              setState(() {
                widget.character.addEquipment(model.instantiate());
              });
            },
          ),
        ],
      ));
    }

    return Card(
        color: theme.colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Text(
                  'Armes & Boucliers',
                  style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12.0),
                for(var eq in widget.character.equipment)
                  if(eq is Weapon && (widget.character.meetsEquipableRequirements(eq) || widget.showUnequipable))
                    WeaponEditWidget(
                      character: widget.character,
                      weapon: eq,
                      onEquipedStateChanged: () => setState(() {}),
                      allowDelete: widget.allowDelete,
                    ),
                for(var eq in widget.character.equipment)
                  if(eq is Shield && (widget.character.meetsEquipableRequirements(eq) || widget.showUnequipable))
                    ShieldEditWidget(
                      character: widget.character,
                      shield: eq,
                      onEquipedStateChanged: () => setState(() {}),
                      allowDelete: widget.allowDelete,
                    ),
                for(var w in trailing)
                  w,
              ]
          ),
        )
    );
  }
}

class WeaponEditWidget extends StatefulWidget {
  WeaponEditWidget({
    super.key,
    required this.character,
    required this.weapon,
    required this.onEquipedStateChanged,
    this.allowDelete = true,
  }) {
    if(weapon.model.damage.static != null && weapon.model.damage.static! > 0) {
      damage = weapon.model.damage.static.toString();
    }
    else {
      var ability = weapon.model.damage.ability!.short;
      var buffer = StringBuffer(weapon.model.damage.multiply > 1
          ? '($ability x ${weapon.model.damage.multiply})'
          : ability);
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
  State<WeaponEditWidget> createState() => _WeaponEditWidgetState();
}

class _WeaponEditWidgetState extends State<WeaponEditWidget> {
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
                  '\u{2694} ${widget.weapon.name}',
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

class ShieldEditWidget extends StatefulWidget {
  const ShieldEditWidget({
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
  State<ShieldEditWidget> createState() => _ShieldEditWidgetState();
}

class _ShieldEditWidgetState extends State<ShieldEditWidget> {
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
                  '\u{1F6E1} ${widget.shield.name}',
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