import 'package:flutter/material.dart';

import '../../../../classes/human_character.dart';
import '../../../../classes/magic.dart';
import '../../widget_group_container.dart';

class CharacterDisplayMagicSpheresWidget extends StatelessWidget {
  const CharacterDisplayMagicSpheresWidget({ super.key, required this.character });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    return WidgetGroupContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for(var i=0; i<3; ++i)
            Row(
              children: [
                for(var j=0; j<3; ++j)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      child: _MagicSphereDisplayWidget(
                        sphere: MagicSphere.values[j+i*3],
                        value: character.magicSphere(MagicSphere.values[j+i*3]),
                        pool: character.magicSpherePool(MagicSphere.values[j+i*3]),
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _MagicSphereDisplayWidget extends StatelessWidget {
  const _MagicSphereDisplayWidget({ required this.sphere, required this.value, required this.pool });

  final MagicSphere sphere;
  final int value;
  final int pool;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        spacing: 12.0,
        children: [
          Column(
            spacing: 8.0,
            children: [
              SizedBox(
                width: 32,
                height: 48,
                child: Image.asset(
                  'assets/images/magic/sphere-${sphere.name}-icon.png',
                ),
              ),
              Text(
                sphere.title,
                style: theme.textTheme.bodySmall,
              )
            ],
          ),
          Expanded(
            child: Column(
              children: [
                _SingleSkillWidget(name: 'Niveau', value: value),
                _SingleSkillWidget(name: 'Réserve', value: pool),
              ],
            ),
          )
        ],
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