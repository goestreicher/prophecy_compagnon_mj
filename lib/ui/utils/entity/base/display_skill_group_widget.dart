import 'package:flutter/material.dart';

import '../../../../classes/entity/attributes.dart';
import '../../../../classes/entity/skill_family.dart';
import '../../../../classes/entity_base.dart';
import '../../widget_group_container.dart';
import 'display_skill_family_widget.dart';

class EntityDisplaySkillGroupWidget extends StatelessWidget {
  const EntityDisplaySkillGroupWidget({ super.key, required this.entity, required this.attribute, });

  final EntityBase entity;
  final Attribute attribute;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var familyWidgets = SkillFamily.values
      .where((SkillFamily f) => (f.defaultAttribute == attribute && entity.skills.forFamily(f).isNotEmpty))
      .map(
            (SkillFamily f) => EntityDisplaySkillFamilyWidget(
              entity: entity,
              family: f,
            )
      ).toList();

    return WidgetGroupContainer(
      title: Text(
        '${attribute.name} : ${entity.attributes.attribute(attribute).toString()}',
        style: theme.textTheme.titleMedium!.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        )
      ),
      child: Column(
        spacing: 16.0,
        children: familyWidgets,
      )
    );
  }
}