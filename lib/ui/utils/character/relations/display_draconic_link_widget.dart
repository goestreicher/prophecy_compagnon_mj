import 'package:flutter/material.dart';

import '../../../../classes/draconic_link.dart';
import '../../../../classes/human_character.dart';
import '../../dismissible_dialog.dart';
import '../../widget_group_container.dart';

class CharacterDisplayDraconicLinkWidget extends StatelessWidget {
  const CharacterDisplayDraconicLinkWidget({ super.key, required this.character });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      child: Column(
        spacing: 12.0,
        children: [
          Row(
            spacing: 16.0,
            children: [
              Expanded(
                child: _DraconicLinkHeaderDetail(
                  title: 'Niveau',
                  value: character.draconicLink.progress.title,
                ),
              ),
              Expanded(
                child: _DraconicLinkHeaderDetail(
                  title: 'Dragon',
                  value: character.draconicLink.dragon,
                ),
              ),
              Expanded(
                child: _DraconicLinkHeaderDetail(
                  title: 'Sphère',
                  value: character.draconicLink.sphere.title,
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
                  'Faveurs',
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Wrap(
                  spacing: 4.0,
                  runSpacing: 4.0,
                  children: [
                    for(var f in DraconicLink.favors(progress: character.draconicLink.progress, sphere: character.draconicLink.sphere))
                      _DraconicFavorInfoWidget(title: f.title, description: f.description)
                  ],
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}

class _DraconicLinkHeaderDetail extends StatelessWidget {
  const _DraconicLinkHeaderDetail({ required this.title, required this.value });

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

class _DraconicFavorInfoWidget extends StatelessWidget {
  const _DraconicFavorInfoWidget({
    required this.title,
    required this.description
  });

  final String title;
  final String description;

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
        padding: EdgeInsets.fromLTRB(8.0, 8.0, 4.0, 8.0),
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
                  ],
                ),
              ),
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
                            description,
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