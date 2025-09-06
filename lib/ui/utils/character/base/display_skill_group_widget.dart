import 'package:flutter/material.dart';

import '../../../../classes/character/base.dart';
import '../../../../classes/character/skill.dart';
import '../../../../classes/entity_base.dart';
import '../widget_group_container.dart';
import 'display_skill_family_widget.dart';

class CharacterDisplaySkillGroupWidget extends StatelessWidget {
  const CharacterDisplaySkillGroupWidget({ super.key, required this.character, required this.attribute, });

  final EntityBase character;
  final Attribute attribute;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var familyWidgets = SkillFamily.values
      .where((SkillFamily f) => (f.defaultAttribute == attribute && character.skillsForFamily(f).isNotEmpty))
      .map(
            (SkillFamily f) => CharacterDisplaySkillFamilyWidget(
              character: character,
              family: f,
            )
      ).toList();

    return WidgetGroupContainer(
      title: Text(
        '${attribute.title} : ${character.attribute(attribute).toString()}',
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