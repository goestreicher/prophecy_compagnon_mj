import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../classes/character/base.dart';
import '../../../../classes/entity_base.dart';
import '../../character/change_stream.dart';
import '../../widget_group_container.dart';
import 'attribute_list_edit_widget.dart';

class EntityEditAttributesWidget extends StatelessWidget {
  const EntityEditAttributesWidget({
    super.key,
    required this.entity,
    this.changeStreamController,
    this.minValue = 1,
    this.maxValue = 15,
  });

  final EntityBase entity;
  final StreamController<CharacterChange>? changeStreamController;
  final int minValue;
  final int maxValue;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Attributs',
        style: theme.textTheme.bodyMedium!.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        )
      ),
      child: AttributeListEditWidget(
        attributes: entity.attributes,
        minValue: minValue,
        maxValue: maxValue,
        onChanged: (Attribute a, int v) {
          entity.setAttribute(a, v);
          changeStreamController?.add(
            CharacterChange(
              item: CharacterChangeItem.attribute,
              value: CharacterAttributeChangeValue(attribute: a, value: v),
            )
          );
        },
      ),
    );
  }
}