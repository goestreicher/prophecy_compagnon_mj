import 'dart:async';

import 'package:flutter/material.dart';

import '../../../classes/human_character.dart';
import 'change_stream.dart';
import 'equipment/edit_armor_widget.dart';
import 'equipment/edit_weapons_widget.dart';

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
        CharacterEditWeaponsWidget(
          character: character,
          changeStreamController: changeStreamController,
        ),
        CharacterEditArmorWidget(
          character: character,
          changeStreamController: changeStreamController,
        ),
      ],
    );
  }
}