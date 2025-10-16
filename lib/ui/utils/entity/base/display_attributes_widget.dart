import 'package:flutter/material.dart';

import '../../../../classes/entity_base.dart';
import '../../widget_group_container.dart';
import 'attribute_display_widget.dart';

class EntityDisplayAttributesWidget extends StatelessWidget {
  const EntityDisplayAttributesWidget({ super.key, required this.entity });
  
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
                AttributeDisplayWidget(name: 'PHY', value: entity.attributes.physique),
                AttributeDisplayWidget(name: 'MEN', value: entity.attributes.mental),
                AttributeDisplayWidget(name: 'MAN', value: entity.attributes.manuel),
                AttributeDisplayWidget(name: 'SOC', value: entity.attributes.social),
              ],
            ),
          ),
        ],
      )
    );
  }
}