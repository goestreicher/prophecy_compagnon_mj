import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../classes/character/base.dart';
import '../../../../classes/human_character.dart';
import 'attribute_list_edit_widget.dart';
import '../change_stream.dart';
import '../widget_group_container.dart';

class CharacterEditAttributesWidget extends StatelessWidget {
  const CharacterEditAttributesWidget({
    super.key,
    required this.character,
    required this.changeStreamController,
  });

  final HumanCharacter character;
  final StreamController<CharacterChange> changeStreamController;

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
        attributes: character.attributes,
        onChanged: (Attribute a, int v) {
          character.setAttribute(a, v);
          changeStreamController.add(
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