import 'package:flutter/material.dart';

import '../../../../classes/caste/base.dart';
import '../../../../classes/caste/career.dart';
import '../../../../classes/caste/interdicts.dart';
import '../../../../classes/human_character.dart';
import '../../dismissible_dialog.dart';
import '../../widget_group_container.dart';
import 'interdict_picker_dialog.dart';

class CharacterEditCasteInterdictsWidget extends StatelessWidget {
  const CharacterEditCasteInterdictsWidget({
    super.key,
    required this.character,
  });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Interdits',
        style: theme.textTheme.bodyMedium!.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: ListenableBuilder(
        listenable: character.caste.interdicts,
        builder: (BuildContext context, _) {
          return _InterdictsWidget(character: character);
        }
      )
    );
  }
}

class _InterdictsWidget extends StatelessWidget {
  const _InterdictsWidget({ required this.character });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var widgets = <Widget>[];

    for(var i in character.caste.interdicts) {
      widgets.add(
        _InterdictWidget(
          title: i.title,
          description: i.description,
          onDeleted: () => character.caste.interdicts.remove(i),
        )
      );
    }

    widgets.add(
      ValueListenableBuilder(
        valueListenable: character.caste.careerNotifier,
        builder: (BuildContext context, Career? value, _) {
          if(value == null) {
            return SizedBox.shrink();
          }
          else {
            return _InterdictWidget(
              title: '${character.caste.career!.interdict!.title} (carrière)',
              description: character.caste.career!.interdict!.description,
            );
          }
        }
      )
    );

    return Column(
      spacing: 12.0,
      children: [
        ...widgets,
        Center(
          child: TextButton(
            style: TextButton.styleFrom(
              textStyle: theme.textTheme.bodySmall,
            ),
            onPressed: () async {
              var result = await showDialog<CasteInterdict>(
                context: context,
                builder: (BuildContext context) => InterdictPickerDialog(
                  defaultCaste: character.caste.caste != Caste.sansCaste
                    ? character.caste.caste
                    : null,
                ),
              );
              if(!context.mounted) return;
              if(result == null) return;

              character.caste.interdicts.add(result);
            },
            child: const Text('Nouvel interdit'),
          ),
        )
      ],
    );
  }
}

class _InterdictWidget extends StatelessWidget {
  const _InterdictWidget({
    required this.title,
    required this.description,
    this.onDeleted,
  });

  final String title;
  final String description;
  final void Function()? onDeleted;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(4.0),
      child: Row(
        spacing: 8.0,
        children: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDeleted == null
              ? null
              : () => onDeleted!(),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
          if(description.isNotEmpty)
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
    );
  }
}