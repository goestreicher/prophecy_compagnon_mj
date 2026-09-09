import 'package:flutter/material.dart';
import 'package:prophecy_compagnon_shared/classes/creature.dart';
import 'package:prophecy_compagnon_shared/ui/creature/base/display_special_capability_widget.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class CreatureDisplaySpecialCapabilities extends StatelessWidget {
  const CreatureDisplaySpecialCapabilities({ super.key, required this.creature });

  final Creature creature;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var widgets = <Widget>[];

    if(creature.specialCapabilities.isEmpty) {
      widgets.add(
        Text(
          'Aucune',
          style: theme.textTheme.bodySmall!.copyWith(
            fontStyle: FontStyle.italic,
          )
        )
      );
    }
    else {
      for(var c in creature.specialCapabilities) {
        widgets.add(
          CreatureDisplaySpecialCapability(
            capability: c,
          )
        );
      }
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4.0,
          children: widgets,
        ),
      ),
    );
  }
}