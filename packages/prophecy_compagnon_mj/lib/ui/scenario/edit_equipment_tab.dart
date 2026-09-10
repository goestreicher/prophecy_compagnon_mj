import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/equipment.dart';
import 'package:prophecy_compagnon_shared/classes/object_source.dart';
import 'package:prophecy_compagnon_shared/ui/equipment/list_filter.dart';
import 'package:prophecy_compagnon_shared/ui/equipment/list_widget.dart';

class ScenarioEditEquipmentPage extends StatelessWidget {
  const ScenarioEditEquipmentPage({
    super.key,
    required this.scenarioSource,
    required this.onEquipmentCreated,
    required this.onEquipmentModified,
    required this.onEquipmentDeleted,
  });

  final ObjectSource scenarioSource;
  final void Function(EquipmentModel) onEquipmentCreated;
  final void Function(EquipmentModel) onEquipmentModified;
  final void Function(EquipmentModel) onEquipmentDeleted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: EquipmentListWidget(
        source: scenarioSource,
        filter: EquipmentModelListFilter(
          source: scenarioSource,
        ),
        onEquipmentCreated: onEquipmentCreated,
        onEquipmentModified: onEquipmentModified,
        onEquipmentDeleted: onEquipmentDeleted,
      ),
    );
  }
}