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
    required this.onChanged,
    this.onSaved,
  });

  final Map<Attribute, int> attributes;
  final int minValue;
  final int maxValue;
  final void Function(Attribute, int) onChanged;
  final void Function(Attribute, int)? onSaved;

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];

    for(var attribute in attributes.keys) {
      widgets.add(
        CharacterDigitInputWidget(
          initialValue: attributes[attribute]!,
          minValue: minValue,
          maxValue: maxValue,
          onChanged: (int value) {
            onChanged(attribute, value);
          },
          onSaved: (int value) {
            onSaved?.call(attribute, value);
          },
          label: '${attribute.title.substring(0, 3).toUpperCase()}${attribute.title.substring(3)}',
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 12.0,
      children: [
        ...widgets
      ],
    );
  }
}