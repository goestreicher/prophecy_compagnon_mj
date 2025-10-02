import 'package:flutter/material.dart';

import '../../../../classes/creature.dart';

class CreatureDisplaySpecialCapability extends StatelessWidget {
  const CreatureDisplaySpecialCapability({ super.key, required this.capability });

  final CreatureSpecialCapability capability;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          capability.name,
          style: theme.textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          capability.description,
          style: theme.textTheme.bodySmall,
        )
      ],
    );
  }
}