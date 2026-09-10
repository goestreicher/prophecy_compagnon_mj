import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_shared/classes/human_character.dart';
import 'package:prophecy_compagnon_shared/ui/character/base/tendencies_edit_widget.dart';

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