import 'package:flutter/material.dart';

import '../../../../classes/magic.dart';
import '../../../../classes/magic_user.dart';
import '../../widget_group_container.dart';
import '../base/single_skill_widget.dart';

class EntityDisplayMagicSkillsWidget extends StatelessWidget {
  const EntityDisplayMagicSkillsWidget({ super.key, required this.entity });

  final MagicUser entity;

  @override
  Widget build(BuildContext context) {
    return WidgetGroupContainer(
      child: Column(
        spacing: 12.0,
        children: [
          SingleSkillWidget(
            name: 'Instinctive',
            value: entity.magic.skills.get(MagicSkill.instinctive),
          ),
          SingleSkillWidget(
            name: 'Invocatoire',
            value: entity.magic.skills.get(MagicSkill.invocatoire),
          ),
          SingleSkillWidget(
            name: 'Sorcellerie',
            value: entity.magic.skills.get(MagicSkill.sorcellerie),
          ),
          SingleSkillWidget(
            name: 'Réserve',
            value: entity.magicPool,
          ),
        ]
      )
    );
  }
}