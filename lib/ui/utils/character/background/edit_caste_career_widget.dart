import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../classes/character/base.dart';
import '../../../../classes/human_character.dart';
import '../change_stream.dart';

class CharacterEditCasteCareerWidget extends StatefulWidget {
  const CharacterEditCasteCareerWidget({
    super.key,
    required this.character,
    required this.changeStreamController,
  });

  final HumanCharacter character;
  final StreamController<CharacterChange> changeStreamController;

  @override
  State<CharacterEditCasteCareerWidget> createState() => _CharacterEditCasteCareerWidgetState();
}

class _CharacterEditCasteCareerWidgetState extends State<CharacterEditCasteCareerWidget> {
  final TextEditingController careerController = TextEditingController();
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
            widget.character.career = null;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return DropdownMenu(
      controller: careerController,
      enabled: widget.character.casteStatus.index > 1,
      requestFocusOnTap: true,
      expandedInsets: EdgeInsets.zero,
      textStyle: theme.textTheme.bodySmall,
      label: const Text('Carrière'),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        // isCollapsed: true,
        // constraints: BoxConstraints(maxHeight: 36.0),
        // contentPadding: EdgeInsets.all(12.0),
      ),
      initialSelection: widget.character.career,
      onSelected: (Career? career) {
        if(career == null) return;

        widget.changeStreamController.add(
          CharacterChange(
            item: CharacterChangeItem.career,
            value: career,
          )
        );

        setState(() {
          widget.character.career = career;
        });
      },
      leadingIcon: InkWell(
        onTap: widget.character.career == null ? null : () {
          widget.changeStreamController.add(
              CharacterChange(
                item: CharacterChangeItem.career,
                value: null,
              )
          );

          setState(() {
            widget.character.career = null;
            careerController.clear();
          });
        },
        child: Opacity(
          opacity: widget.character.career == null ? 0.4 : 1.0,
          child: const Icon(
            Icons.cancel,
            size: 16.0,
          ),
        )
      ),
      dropdownMenuEntries: Career.values
        .where((Career c) => c.caste == widget.character.caste)
        .map((Career c) => DropdownMenuEntry(value: c, label: c.title))
        .toList(),
    );
  }
}