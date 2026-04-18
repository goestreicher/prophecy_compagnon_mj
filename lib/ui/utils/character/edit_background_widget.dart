import 'package:flutter/material.dart';

import '../../../classes/human_character.dart';
import '../entity/background/edit_description_widget.dart';
import '../entity/background/edit_illustration_widget.dart';
import 'background/edit_advantages_widget.dart';

class CharacterEditBackgroundWidget extends StatelessWidget {
  const CharacterEditBackgroundWidget({
    super.key,
    required this.character,
  });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.0,
      children: [
        Expanded(
          child: Column(
            children: [
              CharacterEditDisadvantagesWidget(
                character: character,
              ),
              CharacterEditAdvantagesWidget(
                character: character,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              EntityEditDescriptionWidget(
                entity: character,
              ),
              EntityEditIllustrationWidget(
                entity: character,
              ),
            ],
          ),
        ),
      ],
    );
  }
}