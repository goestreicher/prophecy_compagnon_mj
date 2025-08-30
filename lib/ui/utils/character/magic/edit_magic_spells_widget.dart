import 'package:flutter/material.dart';

import '../../../../classes/human_character.dart';
import '../../../../classes/magic.dart';
import '../../spell_picker_dialog.dart';
import '../widget_group_container.dart';

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
            _SphereMagicSpellsEditWidget(
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

class _SphereMagicSpellsEditWidget extends StatelessWidget {
  const _SphereMagicSpellsEditWidget({
    required this.sphere,
    required this.spells,
    required this.onDelete,
  });

  final MagicSphere sphere;
  final List<MagicSpell> spells;
  final void Function(String) onDelete;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      children: [
        for(var spell in spells)
          Card(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12.0,
                    children: [
                      Text(
                        spell.name,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Wrap(
                        spacing: 12.0,
                        children: [
                          _SpellHeaderDetail(
                            title: 'Discipline',
                            value: spell.skill.title,
                          ),
                          _SpellHeaderDetail(
                            title: 'Coût',
                            value: spell.cost.toString(),
                          ),
                          _SpellHeaderDetail(
                            title: 'Difficulté',
                            value: spell.difficulty.toString(),
                          ),
                          _SpellHeaderDetail(
                            title: "Temps d'incantation",
                            value: '${spell.castingDuration.toString()} ${spell.castingDurationUnit.title}${spell.castingDuration > 1 ? "s" : ""}',
                          ),
                          _SpellHeaderDetail(
                            title: 'Complexité',
                            value: spell.complexity.toString(),
                          ),
                          _SpellHeaderDetail(
                            title: 'Clés',
                            value: spell.keys.join(', '),
                          ),
                        ],
                      ),
                      Text(
                        spell.description,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    onPressed: () {
                      onDelete(spell.name);
                    },
                    style: IconButton.styleFrom(
                      iconSize: 16.0,
                    ),
                    icon: const Icon(Icons.delete),
                  ),
                )
              ],
            )
          )
      ],
    );
  }
}

class _SpellHeaderDetail extends StatelessWidget {
  const _SpellHeaderDetail({ required this.title, required this.value });
  
  final String title;
  final String value;
  
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: theme.textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value,
            style: theme.textTheme.bodySmall,
          )
        ]
      )
    );
  }
}