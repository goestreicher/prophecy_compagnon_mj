import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../classes/character/base.dart';
import '../../../../classes/human_character.dart';
import '../../dismissible_dialog.dart';
import '../../widget_group_container.dart';
import '../change_stream.dart';
import 'caste_privilege_picker_dialog.dart';

class CharacterEditCastePrivilegesWidget extends StatefulWidget {
  const CharacterEditCastePrivilegesWidget({
    super.key,
    required this.character,
    required this.changeStreamController,
  });

  final HumanCharacter character;
  final StreamController<CharacterChange> changeStreamController;

  @override
  State<CharacterEditCastePrivilegesWidget> createState() => _CharacterEditCastePrivilegesWidgetState();
}

class _CharacterEditCastePrivilegesWidgetState extends State<CharacterEditCastePrivilegesWidget> {
  late Caste lastCaste;

  @override
  void initState() {
    super.initState();

    lastCaste = widget.character.caste;

    widget.changeStreamController.stream.listen((CharacterChange change) {
      if(change.value == null) return;

      if(change.item == CharacterChangeItem.caste) {
        var v = change.value as Caste;
        if(v != lastCaste) {
          setState(() {
            lastCaste = v;
            widget.character.castePrivileges.clear();
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var widgets = <Widget>[];

    for(var p in widget.character.castePrivileges) {
      widgets.add(
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    widget.character.castePrivileges.remove(p);
                  });
                },
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${p.privilege.title} (${p.privilege.cost})',
                      style: theme.textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      )
                    ),
                    if(p.description != null)
                      Text(
                        p.description!,
                        style: theme.textTheme.bodySmall,
                      )
                  ],
                ),
              ),
              if(p.privilege.description.isNotEmpty)
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
                        title: p.privilege.title,
                        content: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: 400,
                            maxWidth: 400,
                            maxHeight: 400,
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              p.privilege.description,
                            ),
                          )
                        )
                      )
                    );
                  },
                ),
            ],
          ),
        )
      );
    }

    return WidgetGroupContainer(
      title: Text(
        'Privilèges',
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
                var result = await showDialog<CharacterCastePrivilege>(
                  context: context,
                  builder: (BuildContext context) => CastePrivilegePickerDialog(
                    defaultCaste: widget.character.caste != Caste.sansCaste
                      ? widget.character.caste
                      : null,
                  ),
                );
                if(!context.mounted) return;
                if(result == null) return;

                setState(() {
                  widget.character.castePrivileges.add(result);
                });
              },
              child: const Text('Nouveau privilège'),
            ),
          )
        ],
      )
    );
  }
}