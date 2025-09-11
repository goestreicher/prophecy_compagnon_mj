import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../classes/character/base.dart';
import '../../../../classes/entity_base.dart';
import '../../character/change_stream.dart';
import '../../widget_group_container.dart';
import 'ability_list_edit_widget.dart';

class EntityEditAbilitiesWidget extends StatelessWidget {
  const EntityEditAbilitiesWidget({
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
        'Caractéristiques',
        style: theme.textTheme.bodyMedium!.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        )
      ),
      child: AbilityListEditWidget(
        abilities: entity.abilities,
        minValue: minValue,
        maxValue: maxValue,
        onChanged: (Ability a, int v) {
          entity.setAbility(a, v);
          changeStreamController?.add(
            CharacterChange(
              item: CharacterChangeItem.ability,
              value: CharacterAbilityChangeValue(ability: a, value: v),
            ),
          );
        },
      ),
    );
  }
}