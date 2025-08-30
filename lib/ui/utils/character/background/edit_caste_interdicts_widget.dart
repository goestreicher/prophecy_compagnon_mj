import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../classes/character/base.dart';
import '../../../../classes/human_character.dart';
import '../../interdict_picker_dialog.dart';
import '../change_stream.dart';
import '../widget_group_container.dart';

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
          interdict: i.title,
          onDeleted: () => setState(() {
            widget.character.interdicts.remove(i);
          }),
        )
      );
    }

    if(lastCareer != null && lastCareer!.interdict != null) {
      widgets.add(_InterdictWidget(interdict: '${lastCareer!.interdict!} (carrière)'));
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
                var result = await showDialog<Interdict>(
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
    required this.interdict,
    this.onDeleted,
  });

  final String interdict;
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
        children: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDeleted == null
              ? null
              : () => onDeleted!(),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  interdict,
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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