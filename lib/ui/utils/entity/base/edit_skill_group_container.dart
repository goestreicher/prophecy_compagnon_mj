import 'package:flutter/material.dart';

import '../../../../classes/entity/attributes.dart';
import '../../../../classes/entity/skill_family.dart';
import '../../../../classes/entity_base.dart';
import '../../widget_group_container.dart';
import 'edit_skill_family_container.dart';

class EntityEditSkillGroupContainer extends StatelessWidget {
  const EntityEditSkillGroupContainer({
    super.key,
    required this.entity,
    required this.attribute,
  });

  final EntityBase entity;
  final Attribute attribute;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var familyWidgets = SkillFamily.values
      .where((SkillFamily f) => f.defaultAttribute == attribute)
      .map(
        (SkillFamily f) => ListenableBuilder(
          listenable: entity.skills.families[f]!,
          builder: (BuildContext context, _) {
            return EntityEditSkillFamilyContainer(
              entity: entity,
              family: f,
            );
          }
        )
      ).toList();

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 450,
      ),
      child: WidgetGroupContainer(
        title: StreamBuilder<AttributeStreamChange>(
          stream: entity.attributes.streamController.stream,
          builder: (BuildContext context, AsyncSnapshot<AttributeStreamChange> snapshot) {
            return Text(
              '${attribute.name} : ${entity.attributes.attribute(attribute)}',
              style: theme.textTheme.titleLarge!.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              )
            );
          }
        ),
        child: Column(
          spacing: 20.0,
          children: familyWidgets,
        )
      ),
    );
  }
}