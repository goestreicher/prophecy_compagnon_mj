import 'package:flutter/material.dart';

import '../../../../classes/human_character.dart';
import '../../../../classes/magic.dart';
import 'magic_sphere_edit_widget.dart';
import '../widget_group_container.dart';

class CharacterEditMagicSpheresWidget extends StatelessWidget {
  const CharacterEditMagicSpheresWidget({
    super.key,
    required this.character,
  });

  final HumanCharacter character;

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
                        value: character.magicSphere(MagicSphere.values[j+i*3]),
                        pool: character.magicSpherePool(MagicSphere.values[j+i*3]),
                        onValueChanged: (int value) {
                          character.setMagicSphere(MagicSphere.values[j+i*3], value);
                        },
                        onPoolChanged: (int value) {
                          character.setMagicSpherePool(MagicSphere.values[j+i*3], value);
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