import 'package:flutter/material.dart';

import '../../../../classes/caste/base.dart';
import '../../../../classes/caste/career.dart';
import '../../../../classes/human_character.dart';

class CharacterEditCasteCareerWidget extends StatelessWidget {
  const CharacterEditCasteCareerWidget({
    super.key,
    required this.character,
  });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var careerController = TextEditingController();

    return ValueListenableBuilder(
      valueListenable: character.caste.statusNotifier,
      builder: (BuildContext context, CasteStatus value, _) {
        return ValueListenableBuilder(
          valueListenable: character.caste.careerNotifier,
          builder: (BuildContext context, Career? value, _) {
            return DropdownMenu(
              controller: careerController,
              enabled: character.caste.status.index > 1,
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
              initialSelection: value,
              onSelected: (Career? career) {
                if(career == null) return;
                character.caste.career = career;
              },
              leadingIcon: InkWell(
                onTap: character.caste.career == null ? null : () {
                  character.caste.career = null;
                  careerController.clear();
                },
                child: Opacity(
                  opacity: character.caste.career == null ? 0.4 : 1.0,
                  child: const Icon(
                    Icons.cancel,
                    size: 16.0,
                  ),
                )
              ),
              dropdownMenuEntries: Career.values
                .where((Career c) => c.caste == character.caste.caste)
                .map((Career c) => DropdownMenuEntry(value: c, label: c.title))
                .toList(),
            );
          }
        );
      }
    );
  }
}