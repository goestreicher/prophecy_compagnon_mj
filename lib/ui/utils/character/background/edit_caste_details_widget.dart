import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../classes/human_character.dart';
import '../change_stream.dart';
import '../widget_group_container.dart';
import 'edit_caste_career_widget.dart';
import 'edit_caste_privileges_widget.dart';
import 'edit_caste_interdicts_widget.dart';
import 'view_caste_benefits_widget.dart';
import 'view_caste_techniques_widget.dart';

class CharacterEditCasteDetailsWidget extends StatelessWidget {
  const CharacterEditCasteDetailsWidget({
    super.key,
    required this.character,
    required this.changeStreamController,
  });

  final HumanCharacter character;
  final StreamController<CharacterChange> changeStreamController;

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
            changeStreamController: changeStreamController,
          ),
          CharacterEditCasteInterdictsWidget(
            character: character,
            changeStreamController: changeStreamController,
          ),
          CharacterEditCastePrivilegesWidget(
            character: character,
            changeStreamController: changeStreamController,
          ),
          CharacterViewCasteTechniquesWidget(
            character: character,
            changeStreamController: changeStreamController,
          ),
          CharacterViewCasteBenefitsWidget(
            character: character,
            changeStreamController: changeStreamController,
          ),
        ],
      ),
    );
  }
}