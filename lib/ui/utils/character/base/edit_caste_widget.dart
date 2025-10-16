import 'package:flutter/material.dart';

import '../../../../classes/caste/base.dart';
import '../../../../classes/human_character.dart';
import '../../widget_group_container.dart';

class CharacterEditCasteWidget extends StatelessWidget {
  const CharacterEditCasteWidget({
    super.key,
    required this.character,
  });

  final HumanCharacter character;

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
            initialSelection: character.caste.caste,
            onSelected: (Caste? caste) {
              if(caste == null) return;
              if(caste != character.caste.caste) character.caste.career = null;
              character.caste.caste = caste;
            },
            dropdownMenuEntries: Caste.values
              .map((Caste caste) => DropdownMenuEntry(value: caste, label: caste.title))
              .toList(),
          ),
          ValueListenableBuilder(
            valueListenable: character.caste.casteNotifier,
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
                initialSelection: character.caste.status,
                onSelected: (CasteStatus? status) {
                  if(status == null) return;
                  character.caste.status = status;
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