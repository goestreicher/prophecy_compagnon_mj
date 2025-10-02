import 'package:flutter/material.dart';

import '../../../../classes/magic.dart';
import '../../../../classes/magic_user.dart';
import '../../widget_group_container.dart';

class EntityDisplayMagicSkillsWidget extends StatelessWidget {
  const EntityDisplayMagicSkillsWidget({ super.key, required this.entity });

  final MagicUser entity;

  @override
  Widget build(BuildContext context) {
    return WidgetGroupContainer(
      child: Column(
        spacing: 12.0,
        children: [
          _SingleSkillWidget(
            name: 'Instinctive',
            value: entity.magicSkill(MagicSkill.instinctive),
          ),
          _SingleSkillWidget(
            name: 'Invocatoire',
            value: entity.magicSkill(MagicSkill.invocatoire),
          ),
          _SingleSkillWidget(
            name: 'Sorcellerie',
            value: entity.magicSkill(MagicSkill.sorcellerie),
          ),
          _SingleSkillWidget(
            name: 'Réserve',
            value: entity.magicPool,
          ),
        ]
      )
    );
  }
}

// TODO: factor this out
// This is taken from display_skill_family_widget.dart
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