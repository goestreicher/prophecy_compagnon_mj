import 'package:flutter/material.dart';

import '../../../../classes/entity/skill.dart';
import '../../../../classes/entity/skill_family.dart';
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
        SkillDisplayWidget(character: entity, skill: skill.skill),
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
  const SkillDisplayWidget({ super.key, required this.character, required this.skill });

  final EntityBase character;
  final Skill skill;

  @override
  Widget build(BuildContext context) {
    Widget skillWidget;
    if(skill.requireSpecialization) {
      skillWidget = Text(skill.name);
    }
    else {
      skillWidget = SingleSkillWidget(name: skill.name, value: character.skills.skill(skill)!.value);
    }

    var specializedSkills = <Widget>[];
    for(var sp in character.skills.skill(skill)!.specializations) {
      specializedSkills.add(
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: SingleSkillWidget(name: sp.skill.name, value: sp.value),
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