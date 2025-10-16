import 'package:flutter/material.dart';

import '../../../classes/human_character.dart';
import '../entity/magic/edit_magic_skills_widget.dart';
import '../entity/magic/edit_magic_spells_widget.dart';
import '../entity/magic/edit_magic_spheres_widget.dart';

class CharacterEditMagicWidget extends StatelessWidget {
  const CharacterEditMagicWidget({
    super.key,
    required this.character,
  });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.0,
      children: [
        EntityEditMagicSkillsWidget(
          entity: character,
        ),
        EntityEditMagicSpheresWidget(
          entity: character,
        ),
        EntityEditMagicSpellsWidget(
          entity: character,
        ),
      ],
    );
  }
}