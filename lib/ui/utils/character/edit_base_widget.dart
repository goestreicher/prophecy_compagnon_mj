import 'dart:async';

import 'package:flutter/material.dart';

import '../../../classes/character/base.dart';
import '../../../classes/human_character.dart';
import '../entity/base/edit_abilities_widget.dart';
import '../entity/base/edit_attributes_widget.dart';
import '../entity/base/edit_injuries_widget.dart';
import '../entity/base/edit_skill_group_container.dart';
import 'base/edit_caste_widget.dart';
import 'base/edit_general_widget.dart';
import 'base/edit_secondary_attributes_widget.dart';
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
                changeStreamController: changeStreamController,
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
                changeStreamController: changeStreamController,
              ),
            ),
            Expanded(
              child: EntityEditAttributesWidget(
                  entity: character,
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
        Row(
          children: [
            Flexible(
              child: EntityEditInjuriesWidget(
                entity: character,
                changeStreamController: changeStreamController,
              ),
            ),
            CharacterEditTendenciesWidget(
              character: character,
            ),
          ],
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
                          changeStreamController: changeStreamController,
                        ),
                        EntityEditInjuriesWidget(
                          entity: character,
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
        SizedBox(
          width: 220,
          child: Column(
            spacing: 12.0,
            children: [
              EntityEditAbilitiesWidget(
                entity: character,
                changeStreamController: changeStreamController
              ),
              Row(
                spacing: 16.0,
                children: [
                  Expanded(
                    child: EntityEditAttributesWidget(
                      entity: character,
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

        return Column(
          spacing: 12.0,
          children: [
            topWidget,
            Divider(),
            Wrap(
              spacing: 20.0,
              runSpacing: 12.0,
              children: [
                EntityEditSkillGroupContainer(
                  entity: character,
                  changeStreamController: changeStreamController,
                  attribute: Attribute.physique,
                ),
                EntityEditSkillGroupContainer(
                  entity: character,
                  changeStreamController: changeStreamController,
                  attribute: Attribute.mental,
                ),
                EntityEditSkillGroupContainer(
                  entity: character,
                  changeStreamController: changeStreamController,
                  attribute: Attribute.manuel,
                ),
                EntityEditSkillGroupContainer(
                  entity: character,
                  changeStreamController: changeStreamController,
                  attribute: Attribute.social,
                ),
              ],
            ),
          ],
        );
      }
    );
  }
}