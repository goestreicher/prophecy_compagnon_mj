import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../classes/character/base.dart';
import '../../../../classes/human_character.dart';
import '../../dismissible_dialog.dart';
import '../../widget_group_container.dart';
import '../change_stream.dart';
import 'interdict_picker_dialog.dart';

class CharacterEditCasteInterdictsWidget extends StatefulWidget {
  const CharacterEditCasteInterdictsWidget({
    super.key,
    required this.character,
    required this.changeStreamController,
  });

  final HumanCharacter character;
  final StreamController<CharacterChange> changeStreamController;

  @override
  State<CharacterEditCasteInterdictsWidget> createState() => _CharacterEditCasteInterdictsWidgetState();
}

class _CharacterEditCasteInterdictsWidgetState extends State<CharacterEditCasteInterdictsWidget> {
  late Caste lastCaste;
  late Career? lastCareer;

  @override
  void initState() {
    super.initState();

    lastCaste = widget.character.caste;
    lastCareer = widget.character.career;

    widget.changeStreamController.stream.listen((CharacterChange change) {
      if(change.item == CharacterChangeItem.caste) {
        if(change.value == null) return;

        var v = change.value as Caste;
        if(v != lastCaste) {
          setState(() {
            lastCaste = v;
            widget.character.interdicts.clear();
          });
        }
      }
      else if(change.item == CharacterChangeItem.career) {
        var v = change.value as Career?;
        if(v != lastCareer) {
          setState(() {
            lastCareer = v;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var widgets = <Widget>[];

    for(var i in widget.character.interdicts) {
      widgets.add(
        _InterdictWidget(
          title: i.title,
          description: i.description,
          onDeleted: () => setState(() {
            widget.character.interdicts.remove(i);
          }),
        )
      );
    }

    if(lastCareer != null && lastCareer!.interdict != null) {
      widgets.add(
        _InterdictWidget(
          title: '${lastCareer!.interdict!.title} (carrière)',
          description: lastCareer!.interdict!.description,
        )
      );
    }

    return WidgetGroupContainer(
      title: Text(
        'Interdits',
        style: theme.textTheme.bodySmall
      ),
      child: Column(
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
                    defaultCaste: widget.character.caste != Caste.sansCaste
                      ? widget.character.caste
                      : null,
                  ),
                );
                if(!context.mounted) return;
                if(result == null) return;

                setState(() {
                  widget.character.interdicts.add(result);
                });
              },
              child: const Text('Nouvel interdit'),
            ),
          )
        ],
      )
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