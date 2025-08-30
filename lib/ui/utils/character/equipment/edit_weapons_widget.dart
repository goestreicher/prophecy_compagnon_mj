import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../classes/character/base.dart';
import '../../../../classes/human_character.dart';
import '../../../../classes/shield.dart';
import '../../../../classes/weapon.dart';
import 'shield_equip_widget.dart';
import 'shield_picker_dialog.dart';
import 'weapon_picker_dialog.dart';
import '../change_stream.dart';
import 'weapon_equip_widget.dart';
import '../widget_group_container.dart';

class CharacterEditWeaponsWidget extends StatefulWidget {
  const CharacterEditWeaponsWidget({
    super.key,
    required this.character,
    required this.changeStreamController,
    this.showUnequipable = true,
  });

  final HumanCharacter character;
  final StreamController<CharacterChange> changeStreamController;
  final bool showUnequipable;

  @override
  State<CharacterEditWeaponsWidget> createState() => _CharacterEditWeaponsWidgetState();
}

class _CharacterEditWeaponsWidgetState extends State<CharacterEditWeaponsWidget> {
  Set<Ability> abilitiesToWatch = {
    Ability.force,
    Ability.coordination,
    Ability.perception,
  };

  @override
  void initState() {
    super.initState();

    widget.changeStreamController.stream.listen((CharacterChange change) {
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


    for(var eq in widget.character.equipment) {
      if (eq is Weapon && (widget.character.meetsEquipableRequirements(eq) || widget.showUnequipable)) {
        widgets.add(
          WeaponEquipWidget(
            character: widget.character,
            weapon: eq,
            onEquipedStateChanged: () => setState(() {}),
          )
        );
      }
    }

    for(var eq in widget.character.equipment) {
      if (eq is Shield && (widget.character.meetsEquipableRequirements(eq) || widget.showUnequipable)) {
        widgets.add(
          ShieldEquipWidget(
            character: widget.character,
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
                    widget.character.addEquipment(model.instantiate());
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
                    widget.character.addEquipment(model.instantiate());
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