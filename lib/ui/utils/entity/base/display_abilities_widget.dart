import 'package:flutter/material.dart';

import '../../../../classes/entity_base.dart';
import '../../widget_group_container.dart';
import 'attribute_display_widget.dart';

class EntityDisplayAbilitiesWidget extends StatelessWidget {
  const EntityDisplayAbilitiesWidget({ super.key, required this.entity });

  final EntityBase entity;

  @override
  Widget build(BuildContext context) {
    return WidgetGroupContainer(
      child: Row(
        spacing: 12.0,
        children: [
          Expanded(
            child: Column(
              spacing: 8.0,
              children: [
                AttributeDisplayWidget(name: 'FOR', value: entity.abilities.force),
                AttributeDisplayWidget(name: 'INT', value: entity.abilities.intelligence),
                AttributeDisplayWidget(name: 'COO', value: entity.abilities.coordination),
                AttributeDisplayWidget(name: 'PRÉ', value: entity.abilities.presence),
              ],
            ),
          ),
          Expanded(
            child: Column(
              spacing: 8.0,
              children: [
                AttributeDisplayWidget(name: 'RÉS', value: entity.abilities.resistance),
                AttributeDisplayWidget(name: 'VOL', value: entity.abilities.volonte),
                AttributeDisplayWidget(name: 'PER', value: entity.abilities.perception),
                AttributeDisplayWidget(name: 'EMP', value: entity.abilities.empathie),
              ],
            ),
          ),
        ],
      )
    );
  }
}