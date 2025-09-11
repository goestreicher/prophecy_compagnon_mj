import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../classes/character/base.dart';
import '../../../../classes/entity_base.dart';
import '../../../../classes/shield.dart';
import '../../../../classes/weapon.dart';
import '../../character/change_stream.dart';
import '../../widget_group_container.dart';
import 'shield_equip_widget.dart';
import 'shield_picker_dialog.dart';
import 'weapon_equip_widget.dart';
import 'weapon_picker_dialog.dart';

class EntityEditWeaponsWidget extends StatefulWidget {
  const EntityEditWeaponsWidget({
    super.key,
    required this.entity,
    this.changeStreamController,
    this.showUnequipable = true,
  });

  final EntityBase entity;
  final StreamController<CharacterChange>? changeStreamController;
  final bool showUnequipable;

  @override
  State<EntityEditWeaponsWidget> createState() => _EntityEditWeaponsWidgetState();
}

class _EntityEditWeaponsWidgetState extends State<EntityEditWeaponsWidget> {
  Set<Ability> abilitiesToWatch = {
    Ability.force,
    Ability.coordination,
    Ability.perception,
  };

  @override
  void initState() {
    super.initState();

    widget.changeStreamController?.stream.listen((CharacterChange change) {
      if(change.value == null) return;

      if(
          change.item == CharacterChangeItem.ability
          && abilitiesToWatch.contains((change.value as CharacterAbilityChangeValue).ability)
      ) {
        setState(() {
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var widgets = <Widget>[];


    for(var eq in widget.entity.equipment) {
      if (eq is Weapon && (widget.entity.meetsEquipableRequirements(eq) || widget.showUnequipable)) {
        widgets.add(
          WeaponEquipWidget(
            entity: widget.entity,
            weapon: eq,
            onEquipedStateChanged: () => setState(() {}),
          )
        );
      }
      else if (eq is Shield && (widget.entity.meetsEquipableRequirements(eq) || widget.showUnequipable)) {
        widgets.add(
          ShieldEquipWidget(
            entity: widget.entity,
            shield: eq,
            onEquipedStateChanged: () => setState(() {}),
          )
        );
      }
    }

    return WidgetGroupContainer(
      title: Text(
        'Armes & Boucliers',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        )
      ),
      child: Column(
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

                  setState(() {
                    widget.entity.addEquipment(model.instantiate());
                  });
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

                  setState(() {
                    widget.entity.addEquipment(model.instantiate());
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}