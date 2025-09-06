import 'package:flutter/material.dart';

import '../../../../classes/human_character.dart';
import '../widget_group_container.dart';

class CharacterDisplayDisadvantagesWidget extends StatelessWidget {
  const CharacterDisplayDisadvantagesWidget({ super.key, required this.character });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var widgets = <Widget>[];
    if(character.disadvantages.isEmpty) {
      widgets.add(
        Center(
          child: Text(
            'Pas de désavantages',
            style: theme.textTheme.bodySmall,
          )
        )
      );
    }
    else {
      for(var d in character.disadvantages) {
        widgets.add(
          _CommonContentWidget(
            title: d.disadvantage.title,
            details: d.details.isNotEmpty ? d.details : null,
          )
        );
      }
    }

    return WidgetGroupContainer(
      title: Text(
        'Désavantages',
        style: theme.textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Column(
        children: widgets,
      )
    );
  }
}

class CharacterDisplayAdvantagesWidget extends StatelessWidget {
  const CharacterDisplayAdvantagesWidget({ super.key, required this.character });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var widgets = <Widget>[];
    if(character.disadvantages.isEmpty) {
      widgets.add(
        Center(
          child: Text(
            'Pas d\'avantages',
            style: theme.textTheme.bodySmall,
          )
        )
      );
    }
    else {
      for(var a in character.advantages) {
        widgets.add(
            _CommonContentWidget(
              title: a.advantage.title,
              details: a.details.isNotEmpty ? a.details : null,
            )
        );
      }
    }

    return WidgetGroupContainer(
        title: Text(
          'Avantages',
          style: theme.textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        child: Column(
          children: widgets,
        )
    );
  }
}

class _CommonContentWidget extends StatelessWidget {
  const _CommonContentWidget({ required this.title, this.details });

  final String title;
  final String? details;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      child: Align(
        alignment: AlignmentGeometry.topLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4.0,
            children: [
              Text(
                title,
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if(details != null)
                Text(
                  details!,
                  style: theme.textTheme.bodySmall,
                ),
            ],
          ),
        ),
      )
    );
  }
}