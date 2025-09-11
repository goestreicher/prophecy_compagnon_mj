import 'package:flutter/material.dart';

import '../../../../classes/human_character.dart';
import '../../character_digit_input_widget.dart';
import '../../widget_group_container.dart';

class CharacterEditSecondaryAttributesWidget extends StatelessWidget {
  const CharacterEditSecondaryAttributesWidget({
    super.key,
    required this.character,
  });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    return WidgetGroupContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.0,
        children: [
          CharacterDigitInputWidget(
            initialValue: character.initiative,
            maxValue: 6,
            onChanged: (int value) {
              character.initiative = value;
            },
            label: 'INItiative',
          ),
          CharacterDigitInputWidget(
            initialValue: character.luck,
            minValue: 0,
            maxValue: 10,
            onChanged: (int value) {
              character.luck = value;
            },
            label: 'CHAnce',
          ),
          CharacterDigitInputWidget(
            initialValue: character.proficiency,
            minValue: 0,
            maxValue: 10,
            onChanged: (int value) {
              character.proficiency = value;
            },
            label: 'MAÎtrise',
          ),
          CharacterDigitInputWidget(
            initialValue: character.renown,
            minValue: 0,
            maxValue: 10,
            onChanged: (int value) {
              character.renown = value;
            },
            label: 'Renommée',
          ),
        ],
      ),
    );
  }
}