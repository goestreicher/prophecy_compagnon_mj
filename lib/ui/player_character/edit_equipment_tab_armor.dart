import 'package:flutter/material.dart';

import '../../classes/entity_base.dart';
import '../../classes/equipment.dart';
import '../../classes/armor.dart';
import '../utils/character/equipment/armor_picker_dialog.dart';

class ArmorListWidget extends StatefulWidget {
  const ArmorListWidget({
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
  State<ArmorListWidget> createState() => _ArmorListWidgetState();
}

class _ArmorListWidgetState extends State<ArmorListWidget> {
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
            label: const Text('Nouvelle armure'),
            onPressed: () async {
              String? armorId = await showDialog(
                context: context,
                builder: (BuildContext context) => const ArmorPickerDialog(),
              );
              if(armorId == null) return;
              ArmorModel? model = ArmorModel.get(armorId);
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
                  'Armures',
                  style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12.0),
                for(var eq in widget.character.equipment)
                  if(eq is Armor && (widget.character.meetsEquipableRequirements(eq) || widget.showUnequipable))
                    ArmorEditWidget(
                      character: widget.character,
                      armor: eq,
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

class ArmorEditWidget extends StatefulWidget {
  const ArmorEditWidget({
    super.key,
    required this.character,
    required this.armor,
    required this.onEquipedStateChanged,
    this.allowDelete = true,
  });

  final EntityBase character;
  final Armor armor;
  final VoidCallback onEquipedStateChanged;
  final bool allowDelete;

  @override
  State<ArmorEditWidget> createState() => _ArmorEditWidgetState();
}

class _ArmorEditWidgetState extends State<ArmorEditWidget> {
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
                widget.character.removeEquipment(widget.armor);
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
                  widget.armor.name(),
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  'Protection ${widget.armor.protection()}',
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  'Pénalite ${widget.armor.model.penalty}',
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  widget.armor.model.type.title,
                  style: theme.textTheme.bodySmall,
                )
              ],
            ),
            const Spacer(),
            if(!widget.character.meetsEquipableRequirements(widget.armor))
              Text(
                'Pré-requis\n${widget.character.unmetEquipableRequirementsDescription(widget.armor)}',
                textAlign: TextAlign.right,
                style: theme.textTheme.bodySmall,
              ),
            const SizedBox(width: 8.0),
            Column(
              children: [
                Switch(
                  value: widget.character.isEquiped(widget.armor),
                  onChanged: !widget.character.meetsEquipableRequirements(widget.armor)
                      ? null
                      : (bool value) {
                    if(value) {
                      widget.character.replaceEquiped(widget.armor, target: EquipableItemTarget.body);
                      widget.onEquipedStateChanged();
                    }
                    else if(!value && widget.character.isEquiped(widget.armor)) {
                      widget.character.unequip(widget.armor);
                      widget.onEquipedStateChanged();
                    }
                  },
                ),
                Text(
                  widget.character.isEquiped(widget.armor) ? 'Déséquiper' : 'Équiper',
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