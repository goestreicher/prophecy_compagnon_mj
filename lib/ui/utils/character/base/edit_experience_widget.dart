import 'package:flutter/material.dart';

import '../../../../classes/player_character.dart';
import '../../num_input_widget.dart';
import '../../widget_group_container.dart';

class PlayerCharacterEditExperienceWidget extends StatelessWidget {
  const PlayerCharacterEditExperienceWidget({
    super.key,
    required this.character,
  });
  
  final PlayerCharacter character;
  
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    
    return WidgetGroupContainer(
      title: Text(
          'Expérience',
          style: theme.textTheme.bodyMedium!.copyWith(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          )
      ),
      child: Column(
        spacing: 8,
        children: [
          DropdownMenuFormField(
            initialSelection: character.privilegedExperience,
            requestFocusOnTap: true,
            label: const Text('Optique de progression'),
            expandedInsets: EdgeInsets.zero,
            textStyle: theme.textTheme.bodySmall,
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
              isCollapsed: true,
              constraints: BoxConstraints(maxHeight: 36.0),
              contentPadding: EdgeInsets.all(12.0),
            ),
            dropdownMenuEntries: PlayerCharacterPrivilegedExperience.values
              .map(
                (PlayerCharacterPrivilegedExperience e) =>
                  DropdownMenuEntry(value: e, label: e.title),
              )
              .toList(),
            onSelected: (PlayerCharacterPrivilegedExperience? e) {
              if(e == null) return;
              character.privilegedExperience = e;
            },
            validator: (PlayerCharacterPrivilegedExperience? e) {
              if(e == null) return 'Valeur obligatoire';
              return null;
            },
          ),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: Text(
                  'Expérience',
                  style: theme.textTheme.bodySmall,
                ),
              ),
              SizedBox(
                width: 100,
                child: NumIntInputWidget(
                  initialValue: character.experience,
                  minValue: 0,
                  maxValue: 999,
                  onChanged: (int value) {
                    character.experience = value;
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}