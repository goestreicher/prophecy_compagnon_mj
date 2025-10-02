import 'package:flutter/material.dart';

import '../../../../classes/magic.dart';
import '../../../../classes/magic_user.dart';
import '../../widget_group_container.dart';
import 'magic_sphere_edit_widget.dart';

class EntityEditMagicSpheresWidget extends StatelessWidget {
  const EntityEditMagicSpheresWidget({
    super.key,
    required this.entity,
  });

  final MagicUser entity;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Sphères',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold
        ),
      ),
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
                      child: MagicSphereEditWidget(
                        sphere: MagicSphere.values[j+i*3],
                        value: entity.magicSphere(MagicSphere.values[j+i*3]),
                        pool: entity.magicSpherePool(MagicSphere.values[j+i*3]),
                        onValueChanged: (int value) {
                          entity.setMagicSphere(MagicSphere.values[j+i*3], value);
                        },
                        onPoolChanged: (int value) {
                          entity.setMagicSpherePool(MagicSphere.values[j+i*3], value);
                        },
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