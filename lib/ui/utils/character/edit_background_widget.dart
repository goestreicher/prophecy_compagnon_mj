import 'dart:async';

import 'package:flutter/material.dart';

import '../../../classes/human_character.dart';
import 'background/edit_advantages_widget.dart';
import 'background/edit_caste_details_widget.dart';
import 'background/edit_description_widget.dart';
import 'background/edit_illustration_widget.dart';
import 'change_stream.dart';

class CharacterEditBackgroundWidget extends StatelessWidget {
  const CharacterEditBackgroundWidget({
    super.key,
    required this.character,
    required this.changeStreamController,
  });

  final HumanCharacter character;
  final StreamController<CharacterChange> changeStreamController;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.0,
      children: [
        Expanded(
          child: Column(
            children: [
              CharacterEditDisadvantagesWidget(
                character: character,
                changeStreamController: changeStreamController,
              ),
              CharacterEditAdvantagesWidget(
                character: character,
                changeStreamController: changeStreamController,
              ),
              CharacterEditCasteDetailsWidget(
                character: character,
                changeStreamController: changeStreamController,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              CharacterEditDescriptionWidget(
                character: character,
              ),
              CharacterEditIllustrationWidget(
                character: character,
              ),
            ],
          ),
        ),
      ],
    );
  }
}