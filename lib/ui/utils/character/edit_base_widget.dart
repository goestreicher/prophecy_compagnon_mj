import 'dart:async';

import 'package:flutter/material.dart';

import '../../../classes/character/base.dart';
import '../../../classes/human_character.dart';
import 'base/edit_abilities_widget.dart';
import 'base/edit_attributes_widget.dart';
import 'base/edit_caste_widget.dart';
import 'base/edit_general_widget.dart';
import 'base/edit_injuries_widget.dart';
import 'base/edit_secondary_attributes_widget.dart';
import 'base/edit_skill_group_container.dart';
import 'base/edit_tendencies_widget.dart';
import 'change_stream.dart';

class CharacterEditBaseWidget extends StatelessWidget {
  const CharacterEditBaseWidget({
    super.key,
    required this.character,
    required this.changeStreamController,
  });

  final HumanCharacter character;
  final StreamController<CharacterChange> changeStreamController;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.0,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            Expanded(
              flex: 2,
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
                              changeStreamController: changeStreamController,
                            ),
                            CharacterEditInjuriesWidget(
                              character: character,
                              changeStreamController: changeStreamController,
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
            Expanded(
              child: Column(
                spacing: 12.0,
                children: [
                  CharacterEditAbilitiesWidget(
                    character: character,
                    changeStreamController: changeStreamController
                  ),
                  Row(
                    spacing: 16.0,
                    children: [
                      Expanded(
                        child: CharacterEditAttributesWidget(
                          character: character,
                          changeStreamController: changeStreamController
                        ),
                      ),
                      Expanded(
                        child: CharacterEditSecondaryAttributesWidget(
                          character: character,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(),
        Wrap(
          spacing: 20.0,
          runSpacing: 12.0,
          children: [
            CharacterEditSkillGroupContainer(
              character: character,
              changeStreamController: changeStreamController,
              attribute: Attribute.physique,
            ),
            CharacterEditSkillGroupContainer(
              character: character,
              changeStreamController: changeStreamController,
              attribute: Attribute.mental,
            ),
            CharacterEditSkillGroupContainer(
              character: character,
              changeStreamController: changeStreamController,
              attribute: Attribute.manuel,
            ),
            CharacterEditSkillGroupContainer(
              character: character,
              changeStreamController: changeStreamController,
              attribute: Attribute.social,
            ),
          ],
        ),
      ],
    );
  }
}