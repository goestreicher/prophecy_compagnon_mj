import 'package:flutter/material.dart';

import '../../classes/equipment/equipment.dart';
import '../../classes/object_source.dart';
import '../utils/equipment/list_filter.dart';
import '../utils/equipment/list_widget.dart';

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