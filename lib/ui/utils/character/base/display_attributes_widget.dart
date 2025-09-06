import 'package:flutter/material.dart';

import '../../../../classes/character/base.dart';
import '../../../../classes/entity_base.dart';
import '../widget_group_container.dart';
import 'attribute_display_widget.dart';

class CharacterDisplayAttributesWidget extends StatelessWidget {
  const CharacterDisplayAttributesWidget({ super.key, required this.character });
  
  final EntityBase character;
  
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
                AttributeDisplayWidget(name: 'PHY', value: character.attribute(Attribute.physique)),
                AttributeDisplayWidget(name: 'MEN', value: character.attribute(Attribute.mental)),
                AttributeDisplayWidget(name: 'MAN', value: character.attribute(Attribute.manuel)),
                AttributeDisplayWidget(name: 'SOC', value: character.attribute(Attribute.social)),
              ],
            ),
          ),
        ],
      )
    );
  }
}