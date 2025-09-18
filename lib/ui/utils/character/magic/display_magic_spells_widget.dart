import 'package:flutter/material.dart';

import '../../../../classes/human_character.dart';
import '../../../../classes/magic.dart';
import '../../widget_group_container.dart';
import 'display_sphere_magic_spells_widget.dart';

class CharacterDisplayMagicSpellsWidget extends StatelessWidget {
  const CharacterDisplayMagicSpellsWidget({ super.key, required this.character });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var spellWidgets = <Widget>[];
    for(var sphere in MagicSphere.values) {
      var s = character.spells(sphere);
      if(s.isNotEmpty) {
        spellWidgets.add(
          DisplaySphereMagicSpellsWidget(
            sphere: sphere,
            spells: s,
          )
        );
      }
    }

    return WidgetGroupContainer(
      title: Text(
        'Sorts connus',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Column(
        spacing: 8.0,
        children: spellWidgets,
      )
    );
  }
}