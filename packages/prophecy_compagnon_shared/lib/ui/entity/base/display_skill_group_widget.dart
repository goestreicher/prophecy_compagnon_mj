import 'package:flutter/material.dart';
import 'package:prophecy_compagnon_shared/classes/entity/attributes.dart';
import 'package:prophecy_compagnon_shared/classes/entity/skill_family.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/ui/entity/base/display_skill_family_widget.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

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