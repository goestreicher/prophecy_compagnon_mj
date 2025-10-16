import 'package:flutter/material.dart';

import '../../../../classes/caste/base.dart';
import '../../../../classes/human_character.dart';
import '../../dismissible_dialog.dart';
import '../../widget_group_container.dart';

class CharacterViewCasteTechniquesWidget extends StatelessWidget {
  const CharacterViewCasteTechniquesWidget({
    super.key,
    required this.character,
  });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Techniques de Caste',
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
              return _CasteTechniquesWidget(character: character);
            }
          );
        }
      )
    );
  }
}

class _CasteTechniquesWidget extends StatelessWidget {
  const _CasteTechniquesWidget({ required this.character });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var widgets = <Widget>[];

    for(var t in Caste.techniques(character.caste.caste, character.caste.status)) {
      widgets.add(_CasteTechniqueWidget(technique: t.title, description: t.description,));
    }

    if(widgets.isEmpty) {
      widgets.add(
        SizedBox(
          width: double.infinity,
          child: Text(
            'Pas de techniques',
            style: theme.textTheme.bodyMedium!.copyWith(
              fontStyle: FontStyle.italic,
            ),
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

class _CasteTechniqueWidget extends StatelessWidget {
  const _CasteTechniqueWidget({ required this.technique, this.description });

  final String technique;
  final String? description;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  technique,
                  style: theme.textTheme.bodySmall,
                  softWrap: true,
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
                    title: technique,
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
    );
  }
}