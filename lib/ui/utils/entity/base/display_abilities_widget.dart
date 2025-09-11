import 'package:flutter/material.dart';

import '../../../../classes/character/base.dart';
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
                AttributeDisplayWidget(name: 'FOR', value: entity.ability(Ability.force)),
                AttributeDisplayWidget(name: 'INT', value: entity.ability(Ability.intelligence)),
                AttributeDisplayWidget(name: 'COO', value: entity.ability(Ability.coordination)),
                AttributeDisplayWidget(name: 'PRÉ', value: entity.ability(Ability.presence)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              spacing: 8.0,
              children: [
                AttributeDisplayWidget(name: 'RÉS', value: entity.ability(Ability.resistance)),
                AttributeDisplayWidget(name: 'VOL', value: entity.ability(Ability.volonte)),
                AttributeDisplayWidget(name: 'PER', value: entity.ability(Ability.perception)),
                AttributeDisplayWidget(name: 'EMP', value: entity.ability(Ability.empathie)),
              ],
            ),
          ),
        ],
      )
    );
  }
}