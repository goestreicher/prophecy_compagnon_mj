import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../classes/character/base.dart';
import '../../../../classes/human_character.dart';
import '../../widget_group_container.dart';
import '../change_stream.dart';

class CharacterEditCasteWidget extends StatefulWidget {
  const CharacterEditCasteWidget({
    super.key,
    required this.character,
    required this.changeStreamController,
  });

  final HumanCharacter character;
  final StreamController<CharacterChange> changeStreamController;

  @override
  State<CharacterEditCasteWidget> createState() => _CharacterEditCasteWidgetState();
}

class _CharacterEditCasteWidgetState extends State<CharacterEditCasteWidget> {
  final TextEditingController casteController = TextEditingController();
  final TextEditingController casteStatusController = TextEditingController();
  final Map<CasteStatus, String> casteStatusLabels = <CasteStatus, String>{};

  @override
  void initState() {
    super.initState();

    updateCasteStatusLabels();
  }

  void updateCasteStatusLabels() {
    casteStatusLabels.clear();
    if(widget.character.caste == Caste.sansCaste) {
      casteStatusLabels[CasteStatus.none] = Caste.statusName(Caste.sansCaste, CasteStatus.none);
    }
    else {
      for(var status in CasteStatus.values) {
        casteStatusLabels[status] = Caste.statusName(widget.character.caste, status);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Caste',
        style: theme.textTheme.bodyMedium!.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        )
      ),
      child: Column(
        spacing: 12.0,
        children: [
          DropdownMenu<Caste>(
            controller: casteController,
            requestFocusOnTap: true,
            label: const Text('Caste'),
            expandedInsets: EdgeInsets.zero,
            textStyle: theme.textTheme.bodySmall,
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
              isCollapsed: true,
              constraints: BoxConstraints(maxHeight: 36.0),
              contentPadding: EdgeInsets.all(12.0),
            ),
            initialSelection: widget.character.caste,
            onSelected: (Caste? caste) {
              if(caste == null) return;

              widget.changeStreamController.add(
                CharacterChange(
                  item: CharacterChangeItem.caste,
                  value: caste,
                )
              );

              setState(() {
                widget.character.caste = caste;
                casteStatusController.text = Caste.statusName(caste, widget.character.casteStatus);
                updateCasteStatusLabels();
              });
            },
            dropdownMenuEntries: Caste.values
              .map((Caste caste) => DropdownMenuEntry(value: caste, label: caste.title))
              .toList(),
          ),
          DropdownMenu(
            controller: casteStatusController,
            requestFocusOnTap: true,
            label: const Text('Statut'),
            expandedInsets: EdgeInsets.zero,
            textStyle: theme.textTheme.bodySmall,
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
              isCollapsed: true,
              constraints: BoxConstraints(maxHeight: 36.0),
              contentPadding: EdgeInsets.all(12.0),
            ),
            initialSelection: widget.character.casteStatus,
            onSelected: (CasteStatus? status) {
              if(status == null) return;

              widget.changeStreamController.add(
                CharacterChange(
                  item: CharacterChangeItem.casteStatus,
                  value: status,
                )
              );

              setState(() {
                widget.character.casteStatus = status;
              });
            },
            dropdownMenuEntries: casteStatusLabels.keys
              .map((CasteStatus s) => DropdownMenuEntry(value: s, label: casteStatusLabels[s]!))
              .toList(),
          ),
        ],
      )
    );
  }
}