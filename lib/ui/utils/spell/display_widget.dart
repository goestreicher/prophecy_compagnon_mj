import 'package:flutter/material.dart';

import '../../../classes/magic_spell.dart';

class SpellDisplayWidget extends StatelessWidget {
  const SpellDisplayWidget({ super.key, required this.id });

  final String id;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var spell = MagicSpell.get(id);

    if(spell == null) {
      return Center(
        child: Text(
          'Sort non trouvé'
        )
      );
    }

    return Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 24.0, 12.0, 12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  spell.name,
                  style: theme.textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              RichText(
                text: TextSpan(
                  text: 'Discipline : ',
                  style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: spell.skill.title,
                      style: theme.textTheme.bodyLarge,
                    )
                  ]
                )
              ),
              RichText(
                text: TextSpan(
                  text: 'Coût : ',
                  style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: spell.cost.toString(),
                      style: theme.textTheme.bodyLarge,
                    )
                  ]
                )
              ),
              RichText(
                text: TextSpan(
                  text: 'Difficulté : ',
                  style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: spell.difficulty.toString(),
                      style: theme.textTheme.bodyLarge,
                    )
                  ]
                )
              ),
              RichText(
                text: TextSpan(
                  text: "Temps d'incantation : ",
                  style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: '${spell.castingDuration.toString()} ${spell.castingDurationUnit.title}${spell.castingDuration > 1 ? "s" : ""}',
                      style: theme.textTheme.bodyLarge,
                    )
                  ]
                )
              ),
              RichText(
                text: TextSpan(
                  text: 'Complexité : ',
                  style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: spell.complexity.toString(),
                      style: theme.textTheme.bodyLarge,
                    )
                  ]
                )
              ),
              RichText(
                text: TextSpan(
                  text: 'Clés : ',
                  style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: spell.keys.join(', '),
                      style: theme.textTheme.bodyLarge,
                    )
                  ]
                )
              ),
              const SizedBox(height: 8.0),
              Text(
                'Description',
                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                spell.description,
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        )
    );
  }
}