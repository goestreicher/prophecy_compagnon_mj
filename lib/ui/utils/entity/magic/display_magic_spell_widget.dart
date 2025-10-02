import 'package:flutter/material.dart';

import '../../../../classes/magic.dart';

class DisplayMagicSpellWidget extends StatelessWidget {
  const DisplayMagicSpellWidget({
    super.key,
    required this.spell,
    this.onDelete,
  });

  final MagicSpell spell;
  final void Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 12.0,
              children: [
                Text(
                  spell.name,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Wrap(
                  spacing: 12.0,
                  children: [
                    _SpellHeaderDetail(
                      title: 'Discipline',
                      value: spell.skill.title,
                    ),
                    _SpellHeaderDetail(
                      title: 'Coût',
                      value: spell.cost.toString(),
                    ),
                    _SpellHeaderDetail(
                      title: 'Difficulté',
                      value: spell.difficulty.toString(),
                    ),
                    _SpellHeaderDetail(
                      title: "Temps d'incantation",
                      value: '${spell.castingDuration.toString()} ${spell.castingDurationUnit.title}${spell.castingDuration > 1 ? "s" : ""}',
                    ),
                    _SpellHeaderDetail(
                      title: 'Complexité',
                      value: spell.complexity.toString(),
                    ),
                    _SpellHeaderDetail(
                      title: 'Clés',
                      value: spell.keys.join(', '),
                    ),
                  ],
                ),
                Text(
                  spell.description,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if(onDelete != null)
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                onPressed: () {
                  onDelete?.call();
                },
                style: IconButton.styleFrom(
                  iconSize: 16.0,
                ),
                icon: const Icon(Icons.delete),
              ),
            )
        ],
      )
    );
  }
}

class _SpellHeaderDetail extends StatelessWidget {
  const _SpellHeaderDetail({ required this.title, required this.value });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: theme.textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value,
            style: theme.textTheme.bodySmall,
          )
        ]
      )
    );
  }
}