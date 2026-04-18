import 'package:flutter/material.dart';

import '../../../classes/entity/attributes.dart';
import '../../../classes/human_character.dart';
import '../../../classes/player_character.dart';
import '../entity/base/edit_abilities_widget.dart';
import '../entity/base/edit_attributes_widget.dart';
import '../entity/base/edit_injuries_widget.dart';
import '../entity/base/edit_skill_group_container.dart';
import 'base/edit_caste_widget.dart';
import 'base/edit_experience_widget.dart';
import 'base/edit_general_widget.dart';
import 'base/edit_secondary_attributes_widget.dart';
import 'base/edit_tendencies_widget.dart';

class CharacterEditBaseWidget extends StatelessWidget {
  const CharacterEditBaseWidget({
    super.key,
    required this.character,
  });

  final HumanCharacter character;

  Widget _twoColumnsLayout() {
    return Column(
      spacing: 12.0,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            Expanded(
              flex: 3,
              child: CharacterEditGeneralWidget(
                character: character,
              ),
            ),
            Expanded(
              flex: 1,
              child: CharacterEditCasteWidget(
                character: character,
              ),
            ),
          ],
        ),
        Row(
          spacing: 16.0,
          children: [
            Expanded(
              child: EntityEditAbilitiesWidget(
                entity: character,
              ),
            ),
            Expanded(
              child: EntityEditAttributesWidget(
                  entity: character,
              ),
            ),
            Expanded(
              child: CharacterEditSecondaryAttributesWidget(
                character: character,
              ),
            ),
          ],
        ),
        Row(
          spacing: 16.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: EntityEditInjuriesWidget(
                entity: character,
              ),
            ),
            if(character is PlayerCharacter)
              Expanded(
                child: PlayerCharacterEditExperienceWidget(
                  character: character as PlayerCharacter,
                ),
              ),
          ],
        ),
        CharacterEditTendenciesWidget(
          character: character,
        ),
      ],
    );
  }

  Widget _threeColumnsLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.0,
      children: [
        Expanded(
          child: Column(
            spacing: 12.0,
            children: [
              CharacterEditGeneralWidget(
                character: character,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.0,
                children: [
                  Expanded(
                    child: Column(
                      spacing: 12.0,
                      children: [
                        CharacterEditCasteWidget(
                          character: character,
                        ),
                        EntityEditInjuriesWidget(
                          entity: character,
                        ),
                      ],
                    ),
                  ),
                  CharacterEditTendenciesWidget(
                    character: character,
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          width: 220,
          child: Column(
            spacing: 12.0,
            children: [
              EntityEditAbilitiesWidget(
                entity: character,
              ),
              Row(
                spacing: 16.0,
                children: [
                  Expanded(
                    child: EntityEditAttributesWidget(
                      entity: character,
                    ),
                  ),
                  Expanded(
                    child: CharacterEditSecondaryAttributesWidget(
                      character: character,
                    ),
                  ),
                ],
              ),
              if(character is PlayerCharacter)
                PlayerCharacterEditExperienceWidget(
                  character: character as PlayerCharacter,
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Widget topWidget;

        if(constraints.maxWidth < 850) {
          topWidget = _twoColumnsLayout();
        }
        else {
          topWidget = _threeColumnsLayout();
        }

        return topWidget;
      }
    );
  }
}