import 'package:flutter/material.dart';

import '../../../../classes/human_character.dart';
import '../../dismissible_dialog.dart';
import '../../uniform_height_wrap.dart';
import '../../widget_group_container.dart';

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
            description: d.disadvantage.description,
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
      child: UniformHeightWrap(
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
              description: a.advantage.description,
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
        child: UniformHeightWrap(
          children: widgets,
        )
    );
  }
}

class _CommonContentWidget extends StatelessWidget {
  const _CommonContentWidget({ required this.title, this.details, this.description });

  final String title;
  final String? details;
  final String? description;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: IntrinsicWidth(
          child: Row(
            spacing: 8.0,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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