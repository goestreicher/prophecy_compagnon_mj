import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../classes/character/base.dart';
import '../../../../classes/human_character.dart';
import 'ability_list_edit_widget.dart';
import '../change_stream.dart';
import '../widget_group_container.dart';

class CharacterEditAbilitiesWidget extends StatelessWidget {
  const CharacterEditAbilitiesWidget({
    super.key,
    required this.character,
    required this.changeStreamController,
  });

  final HumanCharacter character;
  final StreamController<CharacterChange> changeStreamController;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Caractéristiques',
        style: theme.textTheme.bodyMedium!.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        )
      ),
      child: AbilityListEditWidget(
        abilities: character.abilities,
        minValue: 1,
        maxValue: 15,
        onChanged: (Ability a, int v) {
          character.setAbility(a, v);
          changeStreamController.add(
            CharacterChange(
              item: CharacterChangeItem.ability,
              value: CharacterAbilityChangeValue(ability: a, value: v),
            ),
          );
        },
      ),
    );
  }
}