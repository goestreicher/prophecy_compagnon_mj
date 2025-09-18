import 'package:flutter/material.dart';

import '../../../../classes/character/base.dart';
import '../../../../classes/human_character.dart';
import '../../dismissible_dialog.dart';
import '../../uniform_height_wrap.dart';
import '../../widget_group_container.dart';

class CharacterDisplayCasteDetailsWidget extends StatelessWidget {
  const CharacterDisplayCasteDetailsWidget({ super.key, required this.character });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var interdictsWidgets = <Widget>[];
    for(var i in character.interdicts) {
      interdictsWidgets.add(
        _CasteInfoWidget(
          title: i.title,
          description: i.description,
        )
      );
    }

    var privilegesWidgets = <Widget>[];
    for(var p in character.castePrivileges) {
      privilegesWidgets.add(
        _CasteInfoWidget(
          title: p.privilege.title,
          details: p.description,
          description: p.privilege.description,
        )
      );
    }

    var benefitsWidgets = <Widget>[];
    for(var b in Caste.benefits(character.caste, character.casteStatus)) {
      benefitsWidgets.add(
        _CasteInfoWidget(
          title: b
        )
      );
    }

    var techniquesWidgets = <Widget>[];
    for(var t in Caste.techniques(character.caste, character.casteStatus)) {
      techniquesWidgets.add(
        _CasteInfoWidget(
          title: t.title,
          description: t.description,
        )
      );
    }

    if(character.career != null) {
      if(character.career!.interdict != null) {
        interdictsWidgets.add(
          _CasteInfoWidget(
            title: '${character.career!.interdict!.title} (carrière)'
          )
        );
      }

      benefitsWidgets.add(
        _CasteInfoWidget(
          title: '${character.career!.benefit.title} (carrière)',
          description: character.career!.benefit.description,
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
                child: UniformHeightWrap(
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
                child: UniformHeightWrap(
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
  const _CasteInfoWidget({
    required this.title,
    this.details,
    this.description
  });

  final String title;
  final String? details;
  final String? description;

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
        padding: EdgeInsets.fromLTRB(8.0, 8.0, description != null && description!.isNotEmpty ? 4.0 : 12.0, 8.0),
        child: IntrinsicWidth(
          child: Row(
            spacing: 4.0,
            children: [
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4.0,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodySmall
                    ),
                    if(details != null && details!.isNotEmpty)
                      Text(
                        details!,
                        style: theme.textTheme.bodySmall
                      ),
                  ],
                ),
              ),
              if(description != null && description!.isNotEmpty)
                IconButton(
                  style: IconButton.styleFrom(
                    iconSize: 16.0,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.info_outlined),
                  onPressed: () {
                    Navigator.of(context).push(
                      DismissibleDialog<void>(
                        title: title,
                        content: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: 400,
                            maxWidth: 400,
                            maxHeight: 400,
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              description!,
                            ),
                          )
                        )
                      )
                    );
                  },
                ),
            ],
          ),
        ),
      )
    );
  }
}