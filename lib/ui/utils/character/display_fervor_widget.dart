import 'package:flutter/material.dart';

import '../../../classes/human_character.dart';
import '../widget_group_container.dart';
import 'fervor/display_spirit_power_widget.dart';

class CharacterDisplayFervorWidget extends StatelessWidget {
  const CharacterDisplayFervorWidget({ super.key, required this.character });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.0,
      children: [
        WidgetGroupContainer(
          child: SizedBox(
            width: 150,
            child: Row(
              spacing: 16.0,
              children: [
                Expanded(child: Text('Ferveur')),
                Text(character.fervor.value.toString()),
              ],
            ),
          ),
        ),
        Expanded(
          child: WidgetGroupContainer(
            child: Center(
              child: Column(
                spacing: 16.0,
                children: [
                  if(character.fervor.powers.isEmpty)
                    Center(
                      child: Text("Aucun pouvoir de l'esprit")
                    ),
                  for(var power in character.fervor.powers)
                    DisplaySpiritPowerWidget(
                      power: power,
                    ),
                ],
              ),
            )
          )
        ),
      ],
    );
  }
}