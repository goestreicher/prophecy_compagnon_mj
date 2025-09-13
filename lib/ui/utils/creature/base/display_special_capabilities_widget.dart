import 'package:flutter/material.dart';

import '../../../../classes/creature.dart';
import '../../widget_group_container.dart';

class CreatureDisplaySpecialCapabilities extends StatelessWidget {
  const CreatureDisplaySpecialCapabilities({ super.key, required this.creature });

  final Creature creature;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Widget content;
    if(creature.specialCapability.isEmpty) {
      content = Text(
        'Aucune',
        style: theme.textTheme.bodySmall!.copyWith(
          fontStyle: FontStyle.italic,
        )
      );
    }
    else {
      content = Text(
        creature.specialCapability,
        style: theme.textTheme.bodySmall,
      );
    }

    return WidgetGroupContainer(
      title: Text(
        'Capacités spéciales',
        style: theme.textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.bold
        ),
      ),
      child: Align(
        alignment: AlignmentGeometry.topLeft,
        child: content,
      ),
    );
  }
}