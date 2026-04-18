import 'package:flutter/material.dart';

import '../../../classes/entity/attributes.dart';
import '../../../classes/human_character.dart';
import '../entity/base/edit_skill_group_container.dart';

class CharacterEditSkillsWidget extends StatelessWidget {
  const CharacterEditSkillsWidget({
    super.key,
    required this.character,
  });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20.0,
      runSpacing: 12.0,
      children: [
        EntityEditSkillGroupContainer(
          entity: character,
          attribute: Attribute.physique,
        ),
        EntityEditSkillGroupContainer(
          entity: character,
          attribute: Attribute.mental,
        ),
        EntityEditSkillGroupContainer(
          entity: character,
          attribute: Attribute.manuel,
        ),
        EntityEditSkillGroupContainer(
          entity: character,
          attribute: Attribute.social,
        ),
      ],
    );
  }
}