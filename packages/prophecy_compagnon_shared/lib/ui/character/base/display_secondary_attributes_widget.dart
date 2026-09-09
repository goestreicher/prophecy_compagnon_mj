import 'package:flutter/material.dart';
import 'package:prophecy_compagnon_shared/classes/human_character.dart';
import 'package:prophecy_compagnon_shared/ui/entity/base/attribute_display_widget.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class CharacterDisplaySecondaryAttributesWidget extends StatelessWidget {
  const CharacterDisplaySecondaryAttributesWidget({ super.key, required this.character });

  final HumanCharacter character;

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
                AttributeDisplayWidget(name: 'INI', value: character.initiative),
                AttributeDisplayWidget(name: 'CHA', value: character.luck),
                AttributeDisplayWidget(name: 'MAÎ', value: character.proficiency),
                AttributeDisplayWidget(name: 'REN', value: character.renown),
              ],
            ),
          ),
        ],
      )
    );
  }
}