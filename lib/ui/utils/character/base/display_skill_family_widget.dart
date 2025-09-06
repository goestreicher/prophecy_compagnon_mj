import 'package:flutter/material.dart';

import '../../../../classes/character/skill.dart';
import '../../../../classes/entity_base.dart';
import '../widget_group_container.dart';

class CharacterDisplaySkillFamilyWidget extends StatelessWidget {
  const CharacterDisplaySkillFamilyWidget({
    super.key,
    required this.character,
    required this.family,
  });

  final EntityBase character;
  final SkillFamily family;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var skillWidgets = <Widget>[];

    for(var skill in character.skillsForFamily(family)) {
      skillWidgets.add(
        SkillDisplayWidget(character: character, skill: skill.skill),
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
      skillWidget = Text(skill.title);
    }
    else {
      skillWidget = _SingleSkillWidget(name: skill.title, value: character.skill(skill));
    }

    var specializedSkills = <Widget>[];
    for(var sp in character.allSpecializedSkills(skill)) {
      specializedSkills.add(
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: _SingleSkillWidget(name: sp.title, value: character.specializedSkill(sp)),
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

class _SingleSkillWidget extends StatelessWidget {
  const _SingleSkillWidget({ required this.name, required this.value });

  final String name;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(name),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black12),
              )
            ),
          )
        ),
        Text(value.toString()),
      ],
    );
  }
}