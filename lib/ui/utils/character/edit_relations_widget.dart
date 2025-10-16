import 'package:flutter/material.dart';

import '../../../classes/human_character.dart';
import 'relations/edit_caste_details_widget.dart';
import 'relations/edit_draconic_link_widget.dart';

class CharacterEditRelationsWidget extends StatelessWidget {
  const CharacterEditRelationsWidget({
    super.key,
    required this.character,
  });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.0,
      children: [
        Expanded(
          child: CharacterEditCasteDetailsWidget(
            character: character,
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