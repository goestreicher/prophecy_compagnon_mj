import 'dart:async';

import 'package:flutter/material.dart';

import '../../../classes/human_character.dart';
import 'relations/edit_caste_details_widget.dart';
import 'relations/edit_draconic_link_widget.dart';
import 'change_stream.dart';

class CharacterEditRelationsWidget extends StatelessWidget {
  const CharacterEditRelationsWidget({
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
          child: CharacterEditCasteDetailsWidget(
            character: character,
            changeStreamController: changeStreamController,
          ),
        ),
        Expanded(
          child: CharacterEditDraconicLinkWidget(
            character: character,
          ),
        ),
      ],
    );
  }
}