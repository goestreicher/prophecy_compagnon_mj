import 'package:flutter/material.dart';

import '../../../../classes/creature.dart';
import '../../widget_group_container.dart';

class CreatureEditSpecialCapabilitiesWidget extends StatelessWidget {
  const CreatureEditSpecialCapabilitiesWidget({ super.key, required this.creature });

  final Creature creature;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Capacités spéciales',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        )
      ),
      child: TextFormField(
        initialValue: creature.specialCapability,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.all(12.0),
          error: null,
          errorText: null,
          isDense: true,
        ),
        minLines: 3,
        maxLines: 3,
        style: theme.textTheme.bodySmall,
        onChanged: (String value) => creature.specialCapability = value,
      ),
    );
  }
}