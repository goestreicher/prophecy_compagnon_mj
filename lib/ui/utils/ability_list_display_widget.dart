import 'package:flutter/material.dart';

import '../../classes/character/base.dart';

class AbilityListDisplayWidget extends StatelessWidget {
  const AbilityListDisplayWidget({ super.key, required this.abilities });

  final Map<Ability, int> abilities;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black87),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        child: SizedBox(
          width: 120,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'FOR',
                          style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Text(
                          abilities[Ability.force]!.toString(),
                          style: theme.textTheme.bodyLarge,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'INT',
                          style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Text(
                          abilities[Ability.intelligence]!.toString(),
                          style: theme.textTheme.bodyLarge,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'COO',
                          style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Text(
                          abilities[Ability.coordination]!.toString(),
                          style: theme.textTheme.bodyLarge,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'PRÉ',
                          style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Text(
                          abilities[Ability.presence]!.toString(),
                          style: theme.textTheme.bodyLarge,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'RÉS',
                          style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Text(
                          abilities[Ability.resistance]!.toString(),
                          style: theme.textTheme.bodyLarge,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'VOL',
                          style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Text(
                          abilities[Ability.volonte]!.toString(),
                          style: theme.textTheme.bodyLarge,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'PER',
                          style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Text(
                          abilities[Ability.perception]!.toString(),
                          style: theme.textTheme.bodyLarge,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'EMP',
                          style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Text(
                          abilities[Ability.empathie]!.toString(),
                          style: theme.textTheme.bodyLarge,
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}