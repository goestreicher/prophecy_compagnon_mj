import 'package:flutter/material.dart';

import '../../../../classes/magic.dart';
import '../../../../classes/magic_spell.dart';
import '../../../../classes/magic_user.dart';
import '../../widget_group_container.dart';
import 'display_sphere_magic_spells_widget.dart';
import 'spell_picker_dialog.dart';

class EntityEditMagicSpellsWidget extends StatelessWidget {
  const EntityEditMagicSpellsWidget({
    super.key,
    required this.entity,
  });

  final MagicUser entity;
  
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Sorts connus',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      child: ListenableBuilder(
        listenable: entity.magic.spells,
        builder: (BuildContext context, _) {
          var spells = <MagicSphere, List<MagicSpell>>{};

          for(var sphere in MagicSphere.values) {
            var sphereSpells = entity.magic.spells.forSphere(sphere);
            if(sphereSpells.isNotEmpty) {
              spells[sphere] = sphereSpells.toList();
            }
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12.0,
            children: [
              for(var sphere in spells.keys)
                DisplaySphereMagicSpellsWidget(
                  sphere: sphere,
                  spells: spells[sphere]!,
                  onDelete: (String name) {
                    entity.magic.spells.removeByName(name);
                  },
                ),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.add,
                    size: 16.0,
                  ),
                  style: ElevatedButton.styleFrom(
                    textStyle: theme.textTheme.bodySmall,
                  ),
                  label: const Text('Nouveau sort'),
                  onPressed: () async {
                    var result = await showDialog<MagicSpell>(
                      context: context,
                      builder: (BuildContext context) => const MagicSpellPickerDialog(),
                    );
                    if(result == null) return;
                    entity.magic.spells.add(result);
                  },
                ),
              )
            ],
          );
        }
      )
    );
  }
}