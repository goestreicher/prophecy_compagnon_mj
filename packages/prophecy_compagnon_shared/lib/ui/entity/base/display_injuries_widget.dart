import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_shared/classes/entity/injury.dart';
import 'package:prophecy_compagnon_shared/ui/entity/base/injury_manager_widget.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

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