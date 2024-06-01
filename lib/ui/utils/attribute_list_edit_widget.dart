import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../classes/character/base.dart';
import 'character_digit_input_widget.dart';

class AttributeListEditWidget extends StatelessWidget {
  const AttributeListEditWidget({
    super.key,
    required this.attributes,
    this.minValue = 1,
    this.maxValue = 15,
    required this.onAttributeChanged,
  });

  final Map<Attribute, int> attributes;
  final int minValue;
  final int maxValue;
  final void Function(Attribute, int) onAttributeChanged;

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];

    for(var attribute in attributes.keys) {
      if(widgets.isNotEmpty) {
        widgets.add(const SizedBox(height: 16.0));
      }

      widgets.add(
        Flexible(
          fit: FlexFit.loose,
          child: CharacterDigitInputWidget(
            initialValue: attributes[attribute]!,
            minValue: minValue,
            maxValue: maxValue,
            onChanged: (int value) {
              onAttributeChanged(attribute, value);
            },
            label: '${attribute.title.substring(0, 3).toUpperCase()}${attribute.title.substring(3)}',
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ...widgets
      ],
    );
  }
}