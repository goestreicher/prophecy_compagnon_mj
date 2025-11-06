import 'package:flutter/material.dart';

import '../../../../classes/entity/skill_family.dart';
import '../../../../classes/entity/skill_instance.dart';
import '../../../../classes/entity_base.dart';
import '../../widget_group_container.dart';
import 'single_skill_widget.dart';

class EntityDisplaySkillFamilyWidget extends StatelessWidget {
  const EntityDisplaySkillFamilyWidget({
    super.key,
    required this.entity,
    required this.family,
  });

  final EntityBase entity;
  final SkillFamily family;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var skillWidgets = <Widget>[];

    for(var skill in entity.skills.forFamily(family)) {
      skillWidgets.add(
        SkillDisplayWidget(skill: skill),
      );
    }

    return WidgetGroupContainer(
      title: Text(
        family.title,
        style: theme.textTheme.bodyMedium!.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        )
      ),
      child: Align(
        alignment: AlignmentGeometry.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8.0,
          children: [
            ...skillWidgets,
          ],
        ),
      )
    );
  }
}

class SkillDisplayWidget extends StatelessWidget {
  const SkillDisplayWidget({
    super.key,
    required this.skill
  });

  final SkillInstance skill;

  @override
  Widget build(BuildContext context) {
    var skillWidget = SingleSkillWidget(
      name: skill.title,
      value: skill.value,
      description: skill.skill.description,
    );

    var specializedSkills = <Widget>[];
    for(var sp in skill.specializations) {
      specializedSkills.add(
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: SingleSkillWidget(
            name: sp.skill.name,
            value: sp.value,
            description: sp.skill.description,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        skillWidget,
        ...specializedSkills,
      ],
    );
  }
}