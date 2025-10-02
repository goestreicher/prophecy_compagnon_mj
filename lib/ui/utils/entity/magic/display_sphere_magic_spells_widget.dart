import 'package:flutter/material.dart';

import '../../../../classes/magic.dart';
import 'display_magic_spell_widget.dart';

class DisplaySphereMagicSpellsWidget extends StatelessWidget {
  const DisplaySphereMagicSpellsWidget({
    super.key,
    required this.sphere,
    required this.spells,
    this.onDelete,
  });

  final MagicSphere sphere;
  final List<MagicSpell> spells;
  final void Function(String)? onDelete;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
        for(var spell in spells)
          DisplayMagicSpellWidget(
            spell: spell,
            onDelete: onDelete == null ? null : () => onDelete?.call(spell.name),
          )
      ],
    );
  }
}