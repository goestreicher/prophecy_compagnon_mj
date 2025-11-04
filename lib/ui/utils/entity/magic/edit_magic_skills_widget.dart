import 'package:flutter/material.dart';
import 'package:prophecy_compagnon_mj/ui/utils/widget_group_container.dart';

import '../../../../classes/magic.dart';
import '../../../../classes/magic_user.dart';
import '../../num_input_widget.dart';

class EntityEditMagicSkillsWidget extends StatelessWidget {
  const EntityEditMagicSkillsWidget({
    super.key,
    required this.entity,
  });

  final MagicUser entity;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Compétences magiques',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        spacing: 16.0,
        children: [
          _EditMagicSkillWidget(
            name: 'Magie instinctive',
            initialValue: entity.magic.skills.get(MagicSkill.instinctive),
            onChanged: (int value) {
              entity.magic.skills.set(MagicSkill.instinctive, value);
            },
          ),
          _EditMagicSkillWidget(
            name: 'Magie invocatoire',
            initialValue: entity.magic.skills.get(MagicSkill.invocatoire),
            onChanged: (int value) {
              entity.magic.skills.set(MagicSkill.invocatoire, value);
            },
          ),
          _EditMagicSkillWidget(
            name: 'Sorcellerie',
            initialValue: entity.magic.skills.get(MagicSkill.sorcellerie),
            onChanged: (int value) {
              entity.magic.skills.set(MagicSkill.sorcellerie, value);
            },
          ),
          StreamBuilder(
            stream: entity.abilities.streamController.stream,
            builder: (BuildContext context, _) {
              return _EditMagicSkillWidget(
                name: 'Réserve de magie',
                initialValue: entity.magicPool,
                minValue: entity.abilities.volonte,
                maxValue: 99,
                onChanged: (int value) {
                  entity.magicPool = value;
                },
              );
            }
          ),
        ],
      )
    );
  }
}

class _EditMagicSkillWidget extends StatelessWidget {
  const _EditMagicSkillWidget({
    required this.name,
    required this.initialValue,
    this.minValue = 0,
    this.maxValue = 15,
    required this.onChanged,
  });

  final String name;
  final int initialValue;
  final int minValue;
  final int maxValue;
  final void Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8.0,
      children: [
        Text(
          name,
          style: theme.textTheme.bodySmall,
        ),
        SizedBox(
          width: 80.0,
          child: NumIntInputWidget(
            key: UniqueKey(),
            initialValue: initialValue,
            minValue: minValue,
            maxValue: maxValue,
            onChanged: (int v) => onChanged(v),
          ),
        ),
      ],
    );
  }
}