import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../classes/armor.dart';
import '../../../../classes/character/base.dart';
import '../../../../classes/human_character.dart';
import 'armor_equip_widget.dart';
import 'armor_picker_dialog.dart';
import '../change_stream.dart';
import '../widget_group_container.dart';

class CharacterEditArmorWidget extends StatefulWidget {
  const CharacterEditArmorWidget({
    super.key,
    required this.character,
    required this.changeStreamController,
    this.showUnequipable = true,
  });

  final HumanCharacter character;
  final StreamController<CharacterChange> changeStreamController;
  final bool showUnequipable;

  @override
  State<CharacterEditArmorWidget> createState() => _CharacterEditArmorWidgetState();
}

class _CharacterEditArmorWidgetState extends State<CharacterEditArmorWidget> {
  Set<Ability> abilitiesToWatch = {
    Ability.force,
    Ability.resistance
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
      if (eq is Armor && (widget.showUnequipable || widget.character.meetsEquipableRequirements(eq))) {
        widgets.add(
          ArmorEquipWidget(
            character: widget.character,
            armor: eq,
            onEquipedStateChanged: () => setState(() {}),
          )
        );
      }
    }

    return WidgetGroupContainer(
      title: Text(
        'Armures',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.0,
        children: [
          ...widgets,
          Center(
            child: ElevatedButton.icon(
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
          ),
        ],
      )
    );
  }
}