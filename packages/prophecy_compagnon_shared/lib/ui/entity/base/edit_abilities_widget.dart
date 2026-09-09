import 'package:flutter/material.dart';
import 'package:prophecy_compagnon_shared/classes/entity/abilities.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/ui/entity/base/ability_list_edit_widget.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class EntityEditAbilitiesWidget extends StatelessWidget {
  const EntityEditAbilitiesWidget({
    super.key,
    required this.entity,
    this.minValue = 0,
    this.maxValue = 15,
  });

  final EntityBase entity;
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
        abilities: entity.abilities.all,
        minValue: minValue,
        maxValue: maxValue,
        onChanged: (Ability a, int v) => entity.abilities.setAbility(a, v),
      ),
    );
  }
}