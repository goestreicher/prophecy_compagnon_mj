import 'package:flutter/material.dart';

import '../../../../classes/character/base.dart';
import '../../../../classes/human_character.dart';
import '../../widget_group_container.dart';

class CharacterDisplayCasteDetailsWidget extends StatelessWidget {
  const CharacterDisplayCasteDetailsWidget({ super.key, required this.character });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var interdictsWidgets = <Widget>[];
    for(var i in character.interdicts) {
      interdictsWidgets.add(_CasteInfoWidget(title: i.title));
    }

    var privilegesWidgets = <Widget>[];
    for(var p in character.castePrivileges) {
      privilegesWidgets.add(_CasteInfoWidget(title: p.privilege.title));
    }

    var benefitsWidgets = <Widget>[];
    for(var b in Caste.benefits(character.caste, character.casteStatus)) {
      benefitsWidgets.add(_CasteInfoWidget(title: b));
    }

    var techniquesWidgets = <Widget>[];
    for(var t in Caste.techniques(character.caste, character.casteStatus)) {
      techniquesWidgets.add(_CasteInfoWidget(title: t));
    }

    if(character.career != null) {
      if(character.career!.interdict != null) {
        interdictsWidgets.add(
          _CasteInfoWidget(
            title: '${character.career!.interdict!} (carrière)'
          )
        );
      }

      benefitsWidgets.add(
        _CasteInfoWidget(
          title: '${character.career!.benefit} (carrière)'
        )
      );
    }

    return WidgetGroupContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.0,
        children: [
          Row(
            spacing: 8.0,
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  'Interdits',
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Wrap(
                  spacing: 4.0,
                  runSpacing: 4.0,
                  children: interdictsWidgets,
                ),
              ),
            ],
          ),
          Row(
            spacing: 8.0,
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  'Privilèges',
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Wrap(
                  spacing: 4.0,
                  runSpacing: 4.0,
                  children: privilegesWidgets,
                ),
              ),
            ],
          ),
          Row(
            spacing: 8.0,
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  'Techniques',
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Wrap(
                  spacing: 4.0,
                  runSpacing: 4.0,
                  children: techniquesWidgets,
                ),
              ),
            ],
          ),
          Row(
            spacing: 8.0,
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  'Bénéfices',
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Wrap(
                  spacing: 4.0,
                  runSpacing: 4.0,
                  children: benefitsWidgets,
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}

class _CasteInfoWidget extends StatelessWidget {
  const _CasteInfoWidget({ required this.title });

  final String title;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: theme.canvasColor,
        boxShadow: [BoxShadow(
          color: theme.colorScheme.primaryContainer,//.withValues(alpha: 0.8),
          blurRadius: 1,
          offset: Offset(0, 1),
        )]
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: theme.textTheme.bodySmall
        ),
      )
    );
  }
}