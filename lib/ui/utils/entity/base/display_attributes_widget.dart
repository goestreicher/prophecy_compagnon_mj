import 'package:flutter/material.dart';

import '../../../../classes/character/base.dart';
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
                AttributeDisplayWidget(name: 'PHY', value: entity.attribute(Attribute.physique)),
                AttributeDisplayWidget(name: 'MEN', value: entity.attribute(Attribute.mental)),
                AttributeDisplayWidget(name: 'MAN', value: entity.attribute(Attribute.manuel)),
                AttributeDisplayWidget(name: 'SOC', value: entity.attribute(Attribute.social)),
              ],
            ),
          ),
        ],
      )
    );
  }
}