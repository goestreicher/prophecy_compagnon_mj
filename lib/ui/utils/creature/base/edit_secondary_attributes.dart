import 'package:flutter/material.dart';

import '../../../../classes/creature.dart';
import '../../num_input_widget.dart';
import '../../widget_group_container.dart';

class CreatureEditSecondaryAttributes extends StatefulWidget {
  const CreatureEditSecondaryAttributes({ super.key, required this.creature });

  final Creature creature;

  @override
  State<CreatureEditSecondaryAttributes> createState() => _CreatureEditSecondaryAttributesState();
}

class _CreatureEditSecondaryAttributesState extends State<CreatureEditSecondaryAttributes> {
  final TextEditingController naturalArmorDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      child: Column(
        spacing: 12.0,
        children: [
          Row(
            spacing: 16.0,
            children: [
              Expanded(
                child: NumIntInputWidget(
                  initialValue: widget.creature.initiative,
                  maxValue: 10,
                  onChanged: (int value) {
                    widget.creature.initiative = value;
                  },
                  label: 'INItiative',
                ),
              ),
              Expanded(
                child: NumIntInputWidget(
                  initialValue: widget.creature.naturalArmor,
                  minValue: 0,
                  maxValue: 999,
                  onChanged: (int value) {
                    widget.creature.naturalArmor = value;
                  },
                  label: 'Armure',
                ),
              ),
            ],
          ),
          TextFormField(
            controller: naturalArmorDescriptionController,
            decoration: const InputDecoration(
              label: Text('Armure naturelle (description)'),
              border: OutlineInputBorder(),
              isCollapsed: true,
              contentPadding: EdgeInsets.all(12.0),
            ),
            style: theme.textTheme.bodySmall,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (String? value) => widget.creature.naturalArmorDescription = naturalArmorDescriptionController.text,
          ),
        ],
      ),
    );
  }
}