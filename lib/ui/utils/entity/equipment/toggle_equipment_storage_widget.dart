import 'package:flutter/material.dart';

import '../../../../classes/entity_base.dart';
import '../../../../classes/equipment/equipment.dart';

class ToggleEquipmentStorageWidget extends StatefulWidget {
  const ToggleEquipmentStorageWidget({
    super.key,
    required this.entity,
    required this.equipment,
    this.carriedWidget,
  });

  final EntityBase entity;
  final Equipment equipment;
  final Widget? carriedWidget;

  @override
  State<ToggleEquipmentStorageWidget> createState() => _ToggleEquipmentStorageWidgetState();
}

class _ToggleEquipmentStorageWidgetState extends State<ToggleEquipmentStorageWidget> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      spacing: 8.0,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if(widget.carriedWidget != null && !widget.equipment.inStore)
          widget.carriedWidget!,
        Column(
          children: [
            Switch(
              value: !widget.equipment.inStore,
              onChanged: (bool value) {
                setState(() {
                  if(value) {
                    widget.entity.unstoreEquipment(widget.equipment);
                  }
                  else {
                    widget.entity.storeEquipment(widget.equipment);
                  }
                });
              },
            ),
            Text(
              widget.equipment.inStore
                ? 'Stocké'
                : 'Porté',
              style: theme.textTheme.bodySmall,
            )
          ],
        ),
      ],
    );
  }
}