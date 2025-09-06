import 'package:flutter/material.dart';

import '../../../../classes/entity_base.dart';
import '../widget_group_container.dart';
import 'injury_manager_widget.dart';

class CharacterDisplayInjuriesWidget extends StatelessWidget {
  const CharacterDisplayInjuriesWidget({
    super.key,
    required this.character,
    this.circlesDiameter = 12.0,
  });

  final EntityBase character;
  final double circlesDiameter;

  @override
  Widget build(BuildContext context) {
    return WidgetGroupContainer(
      child: CharacterInjuryManagerWidget(
        manager: character.injuries,
        allowChanges: false,
      ),
    );
  }
}