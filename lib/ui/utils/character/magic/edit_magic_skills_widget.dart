import 'package:flutter/material.dart';
import 'package:prophecy_compagnon_mj/ui/utils/widget_group_container.dart';

import '../../../../classes/character/base.dart';
import '../../../../classes/human_character.dart';
import '../../../../classes/magic.dart';
import '../../character_digit_input_widget.dart';

class CharacterEditMagicSkillsWidget extends StatelessWidget {
  const CharacterEditMagicSkillsWidget({
    super.key,
    required this.character,
  });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Compétences magiques',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        spacing: 16.0,
        children: [
          _EditMagicSkillWidget(
            name: 'Magie instinctive',
            initialValue: character.magicSkill(MagicSkill.instinctive),
            onChanged: (int value) {
              character.setMagicSkill(MagicSkill.instinctive, value);
            },
          ),
          _EditMagicSkillWidget(
            name: 'Magie invocatoire',
            initialValue: character.magicSkill(MagicSkill.invocatoire),
            onChanged: (int value) {
              character.setMagicSkill(MagicSkill.invocatoire, value);
            },
          ),
          _EditMagicSkillWidget(
            name: 'Sorcellerie',
            initialValue: character.magicSkill(MagicSkill.sorcellerie),
            onChanged: (int value) {
              character.setMagicSkill(MagicSkill.sorcellerie, value);
            },
          ),
          _EditMagicSkillWidget(
            name: 'Réserve de magie',
            initialValue: character.magicPool,
            minValue: character.ability(Ability.volonte),
            maxValue: 30,
            onChanged: (int value) {
              character.magicPool = value;
            },
          ),
        ],
      )
    );
  }
}

class _EditMagicSkillWidget extends StatelessWidget {
  const _EditMagicSkillWidget({
    required this.name,
    required this.initialValue,
    this.minValue = 0,
    this.maxValue = 15,
    required this.onChanged,
  });

  final String name;
  final int initialValue;
  final int minValue;
  final int maxValue;
  final void Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8.0,
      children: [
        Text(
          name,
          style: theme.textTheme.bodySmall,
        ),
        SizedBox(
          width: 80.0,
          child: CharacterDigitInputWidget(
            initialValue: initialValue,
            minValue: minValue,
            maxValue: maxValue,
            onChanged: (int v) => onChanged(v),
          ),
        ),
      ],
    );
  }
}