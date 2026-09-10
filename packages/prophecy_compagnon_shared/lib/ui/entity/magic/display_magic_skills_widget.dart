import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_shared/classes/magic.dart';
import 'package:prophecy_compagnon_shared/classes/magic_user.dart';
import 'package:prophecy_compagnon_shared/ui/entity/base/single_skill_widget.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

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