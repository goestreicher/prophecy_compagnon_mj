import 'package:flutter/material.dart';

import '../../../../classes/character/base.dart';
import '../../../../classes/human_character.dart';
import '../../../../classes/player_character.dart';
import '../widget_group_container.dart';

class CharacterDisplayGeneralWidget extends StatelessWidget {
  const CharacterDisplayGeneralWidget({ super.key, required this.character });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    return WidgetGroupContainer(
      child: Column(
        spacing: 12.0,
        children: [
          if(character is PlayerCharacter)
            Row(
              spacing: 12.0,
              children: [
                Expanded(
                  child: _GeneralWidgetHeader(title: 'Joueur', value: (character as PlayerCharacter).player),
                ),
                Expanded(
                    child: _GeneralWidgetHeader(title: 'Origine', value: (character as PlayerCharacter).augure.title)
                ),
              ],
            ),
          Row(
            spacing: 16.0,
            children: [
              Expanded(
                child: _GeneralWidgetHeader(title: 'Nom', value: character.name),
              ),
              Expanded(
                  child: _GeneralWidgetHeader(title: 'Origine', value: character.origin.name)
              ),
            ],
          ),
          Row(
            spacing: 16.0,
            children: [
              Expanded(
                child: _GeneralWidgetHeader(title: 'Caste', value: character.caste.title)
              ),
              Expanded(
                child: _GeneralWidgetHeader(title: 'Statut', value: Caste.statusName(character.caste, character.casteStatus))
              ),
              Expanded(
                child: _GeneralWidgetHeader(
                  title: 'Carrière',
                  value: character.career == null
                    ? 'Aucune'
                    : character.career!.title
                )
              ),
            ],
          ),
          Row(
            spacing: 16.0,
            children: [
              _GeneralWidgetHeader(title: 'Âge', value: character.age.toString()),
              _GeneralWidgetHeader(title: 'Taille (m)', value: character.height.toStringAsFixed(2)),
              _GeneralWidgetHeader(title: 'Poids (kg)', value: character.weight.toStringAsFixed(0)),
            ],
          )
        ],
      )
    );
  }
}

class _GeneralWidgetHeader extends StatelessWidget {
  const _GeneralWidgetHeader({ required this.title, required this.value });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value,
            style: theme.textTheme.bodyMedium,
          )
        ]
      )
    );
  }
}