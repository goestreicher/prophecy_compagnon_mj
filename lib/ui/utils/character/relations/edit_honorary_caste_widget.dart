import 'package:flutter/material.dart';

import '../../../../classes/caste/base.dart';
import '../../../../classes/caste/character_caste.dart';
import '../../../../classes/human_character.dart';
import '../../widget_group_container.dart';

class CharacterEditHonoraryCasteWidget extends StatefulWidget {
  const CharacterEditHonoraryCasteWidget({
    super.key,
    required this.character,
  });

  final HumanCharacter character;

  @override
  State<CharacterEditHonoraryCasteWidget> createState() => _CharacterEditHonoraryCasteWidgetState();
}

class _CharacterEditHonoraryCasteWidgetState extends State<CharacterEditHonoraryCasteWidget> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
        title: Text(
          'Caste Honoraire',
          style: theme.textTheme.bodyMedium!.copyWith(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: Column(
          spacing: 16.0,
          children: [
            DropdownMenu<Caste>(
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
              initialSelection: widget.character.honoraryCaste?.caste ?? Caste.sansCaste,
              onSelected: (Caste? caste) {
                if(caste == null || caste == Caste.sansCaste) {
                  setState(() {
                    widget.character.honoraryCaste = null;
                  });
                  return;
                }
                setState(() {
                  widget.character.honoraryCaste ??= CharacterCaste.empty();
                  widget.character.honoraryCaste?.caste = caste;
                });
              },
              dropdownMenuEntries: Caste.values
                .map((Caste caste) => DropdownMenuEntry(value: caste, label: caste.title))
                .toList(),
            ),
            if(widget.character.honoraryCaste != null)
              ValueListenableBuilder(
                valueListenable: widget.character.honoraryCaste!.casteNotifier,
                builder: (BuildContext context, Caste caste, _) {
                  final Map<CasteStatus, String> casteStatusLabels = <CasteStatus, String>{};
                  if(caste == Caste.sansCaste) {
                    casteStatusLabels[CasteStatus.none] = Caste.statusName(
                        Caste.sansCaste, CasteStatus.none
                    );
                  }
                  else {
                    for(var status in CasteStatus.values) {
                      casteStatusLabels[status] = Caste.statusName(
                          caste, status
                      );
                    }
                  }

                  return DropdownMenu(
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
                    initialSelection: widget.character.honoraryCaste!.status,
                    onSelected: (CasteStatus? status) {
                      if(status == null) return;
                      widget.character.honoraryCaste!.status = status;
                    },
                    dropdownMenuEntries: casteStatusLabels.keys
                      .map((CasteStatus s) => DropdownMenuEntry(value: s, label: casteStatusLabels[s]!))
                      .toList(),
                  );
                }
              ),
          ],
        )
    );
  }
}