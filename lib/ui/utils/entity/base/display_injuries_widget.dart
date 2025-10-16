import 'package:flutter/material.dart';

import '../../../../classes/entity/injury.dart';
import '../../widget_group_container.dart';
import 'injury_manager_widget.dart';

class EntityDisplayInjuriesWidget extends StatelessWidget {
  const EntityDisplayInjuriesWidget({
    super.key,
    required this.injuries,
    this.circlesDiameter = 12.0,
  });

  final InjuryManager injuries;
  final double circlesDiameter;

  @override
  Widget build(BuildContext context) {
    return WidgetGroupContainer(
      child: EntityInjuryManagerWidget(
        manager: injuries,
        allowChanges: false,
      ),
    );
  }
}