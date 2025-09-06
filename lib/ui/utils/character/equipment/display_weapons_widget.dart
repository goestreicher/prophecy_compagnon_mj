import 'package:flutter/material.dart';

import '../../../../classes/human_character.dart';
import '../../../../classes/shield.dart';
import '../../../../classes/weapon.dart';
import '../widget_group_container.dart';
import 'equipment_info_widgets.dart';

class DisplayWeaponsWidget extends StatelessWidget {
  const DisplayWeaponsWidget({
    super.key,
    required this.character
  });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var widgets = <Widget>[];

    for(var eq in character.equipment) {
      if (eq is Weapon) {
        widgets.add(
          _DisplayContainerWidget(
            content: WeaponInfoWidget(weapon: eq)
          ),
        );
      }
      else if (eq is Shield) {
        widgets.add(
          _DisplayContainerWidget(
            content: ShieldInfoWidget(shield: eq)
          ),
        );
      }
    }

    return WidgetGroupContainer(
      title: Text(
        'Armes & Boucliers',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        )
      ),
      child: Align(
        alignment: AlignmentGeometry.topLeft,
        child: Wrap(
          spacing: 12.0,
          runSpacing: 8.0,
          children: widgets,
        ),
      ),
    );
  }
}

class _DisplayContainerWidget extends StatelessWidget {
  const _DisplayContainerWidget({ required this.content });

  final Widget content;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: content,
      )
    );
  }
}