import 'dart:async';

import 'package:flutter/material.dart';

import '../../../classes/human_character.dart';
import '../entity/equipment/edit_armor_widget.dart';
import '../entity/equipment/edit_weapons_widget.dart';
import 'change_stream.dart';

class CharacterEditEquipmentWidget extends StatelessWidget {
  const CharacterEditEquipmentWidget({
    super.key,
    required this.character,
    required this.changeStreamController,
  });

  final HumanCharacter character;
  final StreamController<CharacterChange> changeStreamController;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.0,
      children: [
        EntityEditWeaponsWidget(
          entity: character,
          changeStreamController: changeStreamController,
        ),
        EntityEditArmorWidget(
          entity: character,
          changeStreamController: changeStreamController,
        ),
      ],
    );
  }
}