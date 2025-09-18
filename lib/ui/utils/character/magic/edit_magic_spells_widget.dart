import 'package:flutter/material.dart';

import '../../../../classes/human_character.dart';
import '../../../../classes/magic.dart';
import '../../widget_group_container.dart';
import 'display_sphere_magic_spells_widget.dart';
import 'spell_picker_dialog.dart';

class CharacterEditMagicSpellsWidget extends StatefulWidget {
  const CharacterEditMagicSpellsWidget({
    super.key,
    required this.character,
  });

  final HumanCharacter character;

  @override
  State<CharacterEditMagicSpellsWidget> createState() => _CharacterEditMagicSpellsWidgetState();
}

class _CharacterEditMagicSpellsWidgetState extends State<CharacterEditMagicSpellsWidget> {
  final Map<MagicSphere, List<MagicSpell>> spells = <MagicSphere, List<MagicSpell>>{};

  @override
  void initState() {
    super.initState();
    updateSpellsList();
  }

  void updateSpellsList() {
    for(var sphere in MagicSphere.values) {
      var spells = widget.character.spells(sphere);
      if(spells.isNotEmpty) {
        this.spells[sphere] = spells;
      }
      else if(spells.isEmpty && this.spells.containsKey(sphere)) {
        this.spells.remove(sphere);
      }
    }
  }
  
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12.0,
        children: [
          for(var sphere in spells.keys)
            DisplaySphereMagicSpellsWidget(
              sphere: sphere,
              spells: spells[sphere]!,
              onDelete: (String name) {
                setState(() {
                  widget.character.deleteSpellByName(name);
                  updateSpellsList();
                });
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
                setState(() {
                  widget.character.addSpell(result);
                  updateSpellsList();
                });
              },
            ),
          )
        ],
      )
    );
  }
}