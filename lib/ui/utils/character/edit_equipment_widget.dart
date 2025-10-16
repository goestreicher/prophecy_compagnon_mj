import 'package:flutter/material.dart';

import '../../../classes/human_character.dart';
import '../entity/equipment/edit_armor_widget.dart';
import '../entity/equipment/edit_weapons_widget.dart';

class CharacterEditEquipmentWidget extends StatelessWidget {
  const CharacterEditEquipmentWidget({
    super.key,
    required this.character,
  });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.0,
      children: [
        EntityEditWeaponsWidget(
          entity: character,
        ),
        EntityEditArmorWidget(
          entity: character,
        ),
      ],
    );
  }
}