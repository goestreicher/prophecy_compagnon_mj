import 'package:flutter/material.dart';

import '../../../../classes/caste/base.dart';
import '../../../../classes/caste/career.dart';
import '../../../../classes/human_character.dart';
import '../../widget_group_container.dart';

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

    return WidgetGroupContainer(
      title: Text(
        'Carrière',
        style: theme.textTheme.bodyMedium!.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: ValueListenableBuilder(
        valueListenable: character.caste.statusNotifier,
        builder: (BuildContext context, CasteStatus value, _) {
          return ValueListenableBuilder(
            valueListenable: character.caste.careerNotifier,
            builder: (BuildContext context, Career? value, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8.0,
                children: [
                  DropdownMenu(
                    controller: careerController,
                    enabled: character.caste.status.index > 1,
                    requestFocusOnTap: true,
                    expandedInsets: EdgeInsets.zero,
                    textStyle: theme.textTheme.bodySmall,
                    label: const Text('Carrière'),
                    inputDecorationTheme: const InputDecorationTheme(
                      border: OutlineInputBorder(),
                      isCollapsed: true,
                      constraints: BoxConstraints(maxHeight: 36.0),
                      contentPadding: EdgeInsets.all(12.0),
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
                      .where((Career c) => c.castes.contains(character.caste.caste))
                      .map((Career c) => DropdownMenuEntry(value: c, label: c.title))
                      .toList(),
                  ),
                  if(character.caste.career != null)
                    _CareerSelectionInfoWidget(
                      character: character,
                      career: character.caste.career!,
                    ),
                ],
              );
            }
          );
        }
      ),
    );
  }
}

class _CareerSelectionInfoWidget extends StatelessWidget {
  const _CareerSelectionInfoWidget({ required this.character, required this.career });
  
  final HumanCharacter character;
  final Career career;
  
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    
    return Column(
      spacing: 8.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            style: theme.textTheme.bodySmall,
            children: [
              TextSpan(
                text: "Spécialisation : ",
                style: theme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: career.specialization,
              )
            ]
          )
        ),
        Text(
          'Pré-requis',
          style: theme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
        ),
        for(var req in career.requirements)
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: Text(
              req.toDisplayString(),
              style: req.meetsRequirements(character)
                ? theme.textTheme.bodySmall
                : theme.textTheme.bodySmall!.copyWith(color: Colors.red),
            ),
          ),
      ],
    );
  }
}