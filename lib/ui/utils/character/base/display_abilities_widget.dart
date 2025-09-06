import 'package:flutter/material.dart';

import '../../../../classes/character/base.dart';
import '../../../../classes/entity_base.dart';
import '../widget_group_container.dart';
import 'attribute_display_widget.dart';

class CharacterDisplayAbilitiesWidget extends StatelessWidget {
  const CharacterDisplayAbilitiesWidget({ super.key, required this.character });

  final EntityBase character;

  @override
  Widget build(BuildContext context) {
    return WidgetGroupContainer(
      child: Row(
        spacing: 12.0,
        children: [
          Expanded(
            child: Column(
              spacing: 8.0,
              children: [
                AttributeDisplayWidget(name: 'FOR', value: character.ability(Ability.force)),
                AttributeDisplayWidget(name: 'INT', value: character.ability(Ability.intelligence)),
                AttributeDisplayWidget(name: 'COO', value: character.ability(Ability.coordination)),
                AttributeDisplayWidget(name: 'PRÉ', value: character.ability(Ability.presence)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              spacing: 8.0,
              children: [
                AttributeDisplayWidget(name: 'RÉS', value: character.ability(Ability.resistance)),
                AttributeDisplayWidget(name: 'VOL', value: character.ability(Ability.volonte)),
                AttributeDisplayWidget(name: 'PER', value: character.ability(Ability.perception)),
                AttributeDisplayWidget(name: 'EMP', value: character.ability(Ability.empathie)),
              ],
            ),
          ),
        ],
      )
    );
  }
}