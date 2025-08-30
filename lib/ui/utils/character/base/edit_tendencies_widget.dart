import 'package:flutter/material.dart';

import '../../../../classes/human_character.dart';
import '../../tendencies_edit_widget.dart';

class CharacterEditTendenciesWidget extends StatelessWidget {
  const CharacterEditTendenciesWidget({
    super.key,
    required this.character,
  });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    return TendenciesEditWidget(
      tendencies: character.tendencies,
      showCircles: true,
    );
  }
}