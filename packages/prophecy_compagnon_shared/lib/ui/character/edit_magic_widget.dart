import 'package:flutter/material.dart';
import 'package:prophecy_compagnon_shared/classes/human_character.dart';
import 'package:prophecy_compagnon_shared/ui/entity/magic/edit_magic_skills_widget.dart';
import 'package:prophecy_compagnon_shared/ui/entity/magic/edit_magic_spells_widget.dart';
import 'package:prophecy_compagnon_shared/ui/entity/magic/edit_magic_spheres_widget.dart';

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