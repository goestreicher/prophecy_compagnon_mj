import 'package:flutter/material.dart';

import '../../../../classes/human_character.dart';
import '../../widget_group_container.dart';
import 'edit_caste_career_widget.dart';
import 'edit_caste_privileges_widget.dart';
import 'edit_caste_interdicts_widget.dart';
import 'view_caste_benefits_widget.dart';
import 'view_caste_techniques_widget.dart';

class CharacterEditCasteDetailsWidget extends StatelessWidget {
  const CharacterEditCasteDetailsWidget({
    super.key,
    required this.character,
  });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Caste',
        style: theme.textTheme.bodySmall!.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Column(
        spacing: 8.0,
        children: [
          CharacterEditCasteCareerWidget(
            character: character,
          ),
          CharacterEditCasteInterdictsWidget(
            character: character,
          ),
          CharacterEditCastePrivilegesWidget(
            character: character,
          ),
          CharacterViewCasteTechniquesWidget(
            character: character,
          ),
          CharacterViewCasteBenefitsWidget(
            character: character,
          ),
        ],
      ),
    );
  }
}