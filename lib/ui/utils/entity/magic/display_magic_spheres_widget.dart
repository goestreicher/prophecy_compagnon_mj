import 'package:flutter/material.dart';

import '../../../../classes/magic.dart';
import '../../../../classes/magic_user.dart';
import '../../widget_group_container.dart';
import '../base/single_skill_widget.dart';

class EntityDisplayMagicSpheresWidget extends StatelessWidget {
  const EntityDisplayMagicSpheresWidget({ super.key, required this.entity });

  final MagicUser entity;

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
                        value: entity.magic.spheres.get(MagicSphere.values[j+i*3]),
                        pool: entity.magic.pools.get(MagicSphere.values[j+i*3]),
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
                SingleSkillWidget(name: 'Niveau', value: value),
                SingleSkillWidget(name: 'Réserve', value: pool),
              ],
            ),
          )
        ],
      )
    );
  }
}