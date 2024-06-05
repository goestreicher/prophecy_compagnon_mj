import 'package:flutter/material.dart';

import '../../classes/magic.dart';
import '../../classes/player_character.dart';
import '../utils/character_digit_input_widget.dart';
import '../utils/spell_picker_dialog.dart';

class EditMagicTab extends StatelessWidget {
  const EditMagicTab({ super.key, required this.character });

  final PlayerCharacter character;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 250,
                        maxWidth: 250,
                      ),
                      child: _MagicSkillsEditWidget(character: character),
                    ),
                    const SizedBox(width: 24.0),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 520.0,
                        maxWidth: 600.0,
                      ),
                      child: _MagicSpheresEditWidget(character: character),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 794.0,
                    maxWidth: 874.0,
                  ),
                  child: _MagicSpellsEditWidget(character: character)
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}

class _MagicSkillsEditWidget extends StatelessWidget {
  const _MagicSkillsEditWidget({ required this.character });

  final PlayerCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Stack(
      children: [
        Container(
            padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
            margin: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'Réserve de magie',
                      style: theme.textTheme.bodySmall,
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 96.0,
                      child: CharacterDigitInputWidget(
                        initialValue: character.magicPool,
                        minValue: 0,
                        maxValue: 30,
                        onChanged: (int value) {
                          character.magicPool = value;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Text(
                      'Magie instinctive',
                      style: theme.textTheme.bodySmall,
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 96.0,
                      child: CharacterDigitInputWidget(
                        initialValue: character.magicSkill(MagicSkill.instinctive),
                        minValue: 0,
                        maxValue: 30,
                        onChanged: (int value) {
                          character.setMagicSkill(MagicSkill.instinctive, value);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Text(
                      'Magie invocatoire',
                      style: theme.textTheme.bodySmall,
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 96.0,
                      child: CharacterDigitInputWidget(
                        initialValue: character.magicSkill(MagicSkill.invocatoire),
                        minValue: 0,
                        maxValue: 30,
                        onChanged: (int value) {
                          character.setMagicSkill(MagicSkill.invocatoire, value);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Text(
                      'Sorcellerie',
                      style: theme.textTheme.bodySmall,
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 96.0,
                      child: CharacterDigitInputWidget(
                        initialValue: character.magicSkill(MagicSkill.sorcellerie),
                        minValue: 0,
                        maxValue: 30,
                        onChanged: (int value) {
                          character.setMagicSkill(MagicSkill.sorcellerie, value);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            )
        ),
        Positioned(
          top: 3,
          left: 8,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Compétences magiques',
              style: theme.textTheme.bodyMedium!.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              )
            )
          )
        ),
      ],
    );
  }
}

class _MagicSpheresEditWidget extends StatelessWidget {
  const _MagicSpheresEditWidget({ required this.character });

  final PlayerCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Stack(
      children: [
        Container(
            padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
            margin: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(child: _MagicSphereInputWidget(character: character, sphere: MagicSphere.pierre)),
                    const SizedBox(width: 8.0),
                    Expanded(child: _MagicSphereInputWidget(character: character, sphere: MagicSphere.feu)),
                    const SizedBox(width: 8.0),
                    Expanded(child: _MagicSphereInputWidget(character: character, sphere: MagicSphere.oceans)),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Expanded(child: _MagicSphereInputWidget(character: character, sphere: MagicSphere.metal)),
                    const SizedBox(width: 8.0),
                    Expanded(child: _MagicSphereInputWidget(character: character, sphere: MagicSphere.nature)),
                    const SizedBox(width: 8.0),
                    Expanded(child: _MagicSphereInputWidget(character: character, sphere: MagicSphere.reves)),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Expanded(child: _MagicSphereInputWidget(character: character, sphere: MagicSphere.cite)),
                    const SizedBox(width: 8.0),
                    Expanded(child: _MagicSphereInputWidget(character: character, sphere: MagicSphere.vents)),
                    const SizedBox(width: 8.0),
                    Expanded(child: _MagicSphereInputWidget(character: character, sphere: MagicSphere.ombre)),
                  ],
                ),
              ],
            )
        ),
        Positioned(
          top: 3,
          left: 8,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Sphères de magie',
              style: theme.textTheme.bodyMedium!.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              )
            )
          )
        ),
      ],
    );
  }
}

class _MagicSphereInputWidget extends StatefulWidget {
  const _MagicSphereInputWidget({ required this.character, required this.sphere });

  final PlayerCharacter character;
  final MagicSphere sphere;

  @override
  State<_MagicSphereInputWidget> createState() => _MagicSphereInputWidgetState();
}

class _MagicSphereInputWidgetState extends State<_MagicSphereInputWidget> {
  late int value;
  late int pool;
  
  @override
  void initState() {
    super.initState();
    value = widget.character.magicSphere(widget.sphere);
    pool = widget.character.magicSpherePool(widget.sphere);
  }
  
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
          margin: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 160.0),
                child: Row(
                  children: [
                    Text(
                      'Valeur',
                      style: theme.textTheme.bodySmall,
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 80.0,
                      child: CharacterDigitInputWidget(
                        initialValue: widget.character.magicSphere(widget.sphere),
                        minValue: 0,
                        maxValue: 30,
                        onChanged: (int v) {
                          var oldValue = widget.character.magicSphere(widget.sphere);
                          var delta = v - oldValue;

                          setState(() {
                            value = v;
                            pool = pool + delta;
                          });

                          widget.character.setMagicSphere(widget.sphere, v);
                          widget.character.setMagicSpherePool(
                            widget.sphere,
                            widget.character.magicSpherePool(widget.sphere) + delta,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Text(
                    'Réserve',
                    style: theme.textTheme.bodySmall,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 80.0,
                    child: CharacterDigitInputWidget(
                      initialValue: pool,
                      minValue: value,
                      maxValue: 30,
                      onChanged: (int v) {
                        setState(() {
                          pool = v;
                        });

                        widget.character.setMagicSpherePool(widget.sphere, v);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          top: 3,
          left: 8,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              widget.sphere.title,
              style: theme.textTheme.bodySmall!.copyWith(
                color: Colors.black87,
              )
            )
          )
        ),
      ],
    );
  }
}

class _MagicSpellsEditWidget extends StatefulWidget {
  const _MagicSpellsEditWidget({ required this.character });

  final PlayerCharacter character;

  @override
  State<_MagicSpellsEditWidget> createState() => _MagicSpellsEditWidgetState();
}

class _MagicSpellsEditWidgetState extends State<_MagicSpellsEditWidget> {
  final Map<MagicSphere, List<MagicSpell>> _spells = <MagicSphere, List<MagicSpell>>{};

  void _updateSpellsList() {
    for(var sphere in MagicSphere.values) {
      var spells = widget.character.spells(sphere);
      if(spells.isNotEmpty) {
        _spells[sphere] = spells;
      }
      else if(spells.isEmpty && _spells.containsKey(sphere)) {
        _spells.remove(sphere);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _updateSpellsList();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Stack(
      children: [
        Container(
            padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
            margin: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for(var sphere in _spells.keys)
                  _SphereMagicSpellsEditWidget(
                    sphere: sphere,
                    spells: _spells[sphere]!,
                    onDelete: (String name) {
                      setState(() {
                        widget.character.deleteSpellByName(name);
                        _updateSpellsList();
                      });
                    },
                  ),
                const SizedBox(height: 8.0),
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
                        _updateSpellsList();
                      });
                    },
                  ),
                )
              ],
            )
        ),
        Positioned(
            top: 3,
            left: 8,
            child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                    'Sorts connus',
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    )
                )
            )
        ),
      ],
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
                    children: [
                      Text(
                        spell.name,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: 'Discipline : ',
                                    style: theme.textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: spell.skill.title,
                                        style: theme.textTheme.bodySmall,
                                      )
                                    ]
                                  )
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Coût : ',
                                    style: theme.textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: spell.cost.toString(),
                                        style: theme.textTheme.bodySmall,
                                      )
                                    ]
                                  )
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Difficulté : ',
                                    style: theme.textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: spell.difficulty.toString(),
                                        style: theme.textTheme.bodySmall,
                                      )
                                    ]
                                  )
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: "Temps d'incantation : ",
                                    style: theme.textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '${spell.castingDuration.toString()} ${spell.castingDurationUnit.title}${spell.castingDuration > 1 ? "s" : ""}',
                                        style: theme.textTheme.bodySmall,
                                      )
                                    ]
                                  )
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Complexité : ',
                                    style: theme.textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: spell.complexity.toString(),
                                        style: theme.textTheme.bodySmall,
                                      )
                                    ]
                                  )
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Clés : ',
                                    style: theme.textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: spell.keys.join(', '),
                                        style: theme.textTheme.bodySmall,
                                      )
                                    ]
                                  )
                                ),
                              ],
                            )
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Effets',
                                  style: theme.textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  spell.description,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            )
                          )
                        ],
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