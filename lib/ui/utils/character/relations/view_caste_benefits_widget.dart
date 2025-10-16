import 'package:flutter/material.dart';

import '../../../../classes/caste/base.dart';
import '../../../../classes/caste/career.dart';
import '../../../../classes/human_character.dart';
import '../../widget_group_container.dart';

class CharacterViewCasteBenefitsWidget extends StatelessWidget {
  const CharacterViewCasteBenefitsWidget({
    super.key,
    required this.character,
  });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Bénéfices de Caste',
        style: theme.textTheme.bodyMedium!.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: ValueListenableBuilder(
        valueListenable: character.caste.casteNotifier,
        builder: (BuildContext context, Caste value, _) {
          return ValueListenableBuilder(
            valueListenable: character.caste.statusNotifier,
            builder: (BuildContext context, CasteStatus status, _) {
              return _CasteBenefitsWidget(character: character);
            }
          );
        }
      )
    );
  }
}

class _CasteBenefitsWidget extends StatelessWidget {
  const _CasteBenefitsWidget({ required this.character });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var widgets = <Widget>[];

    for(var b in Caste.benefits(character.caste.caste, character.caste.status)) {
      widgets.add(_CasteBenefitWidget(benefit: b));
    }

      widgets.add(
        ValueListenableBuilder(
          valueListenable: character.caste.careerNotifier,
          builder: (BuildContext context, Career? career, _) {
            if(career == null) {
              return SizedBox.shrink();
            }
            else {
              return _CasteBenefitWidget(
                benefit:
                  'Bénéfice de carrière : ${career.benefit.title}'
                  '\n${career.benefit.description}'
              );
            }
          }
        )
      );

    if(widgets.isEmpty) {
      widgets.add(
          SizedBox(
            width: double.infinity,
            child: Text(
              'Pas de bénéfices',
              style: theme.textTheme.bodyMedium!.copyWith(
                fontStyle: FontStyle.italic,
              ),
              softWrap: true,
            ),
          )
      );
    }

    return Column(
      spacing: 12.0,
      children: widgets,
    );
  }
}

class _CasteBenefitWidget extends StatelessWidget {
  const _CasteBenefitWidget({ required this.benefit });

  final String benefit;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  benefit,
                  style: theme.textTheme.bodySmall,
                  softWrap: true,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}