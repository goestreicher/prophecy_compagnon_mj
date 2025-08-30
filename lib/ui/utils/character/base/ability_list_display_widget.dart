import 'package:flutter/material.dart';

import '../../../../classes/character/base.dart';

class AbilityListDisplayWidget extends StatelessWidget {
  const AbilityListDisplayWidget({ super.key, required this.abilities });

  final Map<Ability, int> abilities;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var innerGutterWidth = 4.0;
    var gutterWidth = 16.0;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black87),
        borderRadius: BorderRadius.circular(4.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FOR',
                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'INT',
                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'COO',
                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'PRÉ',
                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(width: innerGutterWidth),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                abilities[Ability.force]!.toString(),
                style: theme.textTheme.bodyLarge,
              ),
              Text(
                abilities[Ability.intelligence]!.toString(),
                style: theme.textTheme.bodyLarge,
              ),
              Text(
                abilities[Ability.coordination]!.toString(),
                style: theme.textTheme.bodyLarge,
              ),
              Text(
                abilities[Ability.presence]!.toString(),
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
          SizedBox(width: gutterWidth),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'RÉS',
                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'VOL',
                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'PER',
                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'EMP',
                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(width: innerGutterWidth),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                abilities[Ability.resistance]!.toString(),
                style: theme.textTheme.bodyLarge,
              ),
              Text(
                abilities[Ability.volonte]!.toString(),
                style: theme.textTheme.bodyLarge,
              ),
              Text(
                abilities[Ability.perception]!.toString(),
                style: theme.textTheme.bodyLarge,
              ),
              Text(
                abilities[Ability.empathie]!.toString(),
                style: theme.textTheme.bodyLarge,
              ),
            ],
          )
        ],
      ),
    );
  }
}