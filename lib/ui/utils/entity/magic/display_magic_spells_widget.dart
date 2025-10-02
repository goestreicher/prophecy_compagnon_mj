import 'package:flutter/material.dart';

import '../../../../classes/magic.dart';
import '../../../../classes/magic_user.dart';
import '../../widget_group_container.dart';
import 'display_sphere_magic_spells_widget.dart';

class EntityDisplayMagicSpellsWidget extends StatelessWidget {
  const EntityDisplayMagicSpellsWidget({ super.key, required this.entity });

  final MagicUser entity;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var spellWidgets = <Widget>[];
    for(var sphere in MagicSphere.values) {
      var s = entity.spells(sphere);
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