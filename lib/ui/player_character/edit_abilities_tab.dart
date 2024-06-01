import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../classes/human_character.dart';
import '../../classes/character/base.dart';

class EditAbilitiesTab extends StatelessWidget {
  EditAbilitiesTab({ super.key, required this.character });

  final HumanCharacter character;

  final Map<Ability, TextEditingController> _abilityControllers = {};
  final Map<Attribute, TextEditingController> _attributeControllers = {};
  final TextEditingController _initiativeController = TextEditingController();
  final TextEditingController _luckController = TextEditingController();
  final TextEditingController _proficiencyController = TextEditingController();

  void _updateInitiative() {
    int? coo = int.tryParse(_abilityControllers[Ability.coordination]!.text);
    int? per = int.tryParse(_abilityControllers[Ability.perception]!.text);
    if(coo == null || per == null) return;
    if(coo < 1 || coo > 30 || per < 1 || per > 30) return;

    int sum = coo + per;
    int init = 1;
    if(sum > 5 && sum < 10) {
      init = 2;
    }
    else if(sum > 9 && sum < 14) {
      init = 3;
    }
    else if(sum > 13 && sum < 17) {
      init = 4;
    }
    else if(sum > 16) {
      init = 5;
    }
    _initiativeController.text = init.toString();
  }

  @override
  Widget build(BuildContext context) {
    for(var a in Ability.values) {
      _abilityControllers[a] = TextEditingController();
      _abilityControllers[a]!.text = character.ability(a).toString();
    }

    for(var a in Attribute.values) {
      _attributeControllers[a] = TextEditingController();
      _attributeControllers[a]!.text = character.attribute(a).toString();
    }

    _initiativeController.text = character.initiative.toString();
    _luckController.text = character.luck.toString();
    _proficiencyController.text = character.proficiency.toString();

    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _abilityControllers[Ability.force],
                          decoration: const InputDecoration(
                            label: Text('FORce'),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (String? value) {
                            if(value == null || value.isEmpty) return 'Valeur manquante';
                            int? input = int.tryParse(value);
                            if(input == null) return 'Pas un nombre';
                            if(input < 1) return 'Nombre > 0';
                            if(input > 30) return 'Vraiment ?';
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onSaved: (String? value) {
                            character.setAbility(Ability.force, int.parse(value!));
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _abilityControllers[Ability.intelligence],
                          decoration: const InputDecoration(
                            label: Text('INTelligence'),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (String? value) {
                            if(value == null || value.isEmpty) return 'Valeur manquante';
                            int? input = int.tryParse(value);
                            if(input == null) return 'Pas un nombre';
                            if(input < 1) return 'Nombre > 0';
                            if(input > 30) return 'Vraiment ?';
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onSaved: (String? value) {
                            character.setAbility(Ability.intelligence, int.parse(value!));
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _abilityControllers[Ability.coordination],
                          decoration: const InputDecoration(
                            label: Text('COOrdination'),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (String? value) {
                            if(value == null || value.isEmpty) return 'Valeur manquante';
                            int? input = int.tryParse(value);
                            if(input == null) return 'Pas un nombre';
                            if(input < 1) return 'Nombre > 0';
                            if(input > 30) return 'Vraiment ?';
                            return null;
                          },
                          onChanged: (String? v) => _updateInitiative(),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onSaved: (String? value) {
                            character.setAbility(Ability.coordination, int.parse(value!));
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _abilityControllers[Ability.presence],
                          decoration: const InputDecoration(
                            label: Text('PRÉsence'),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (String? value) {
                            if(value == null || value.isEmpty) return 'Valeur manquante';
                            int? input = int.tryParse(value);
                            if(input == null) return 'Pas un nombre';
                            if(input < 1) return 'Nombre > 0';
                            if(input > 30) return 'Vraiment ?';
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onSaved: (String? value) {
                            character.setAbility(Ability.presence, int.parse(value!));
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                      child: Column(
                          children: [
                            TextFormField(
                              controller: _abilityControllers[Ability.resistance],
                              decoration: const InputDecoration(
                                label: Text('RÉSistance'),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (String? value) {
                                if(value == null || value.isEmpty) return 'Valeur manquante';
                                int? input = int.tryParse(value);
                                if(input == null) return 'Pas un nombre';
                                if(input < 1) return 'Nombre > 0';
                                if(input > 30) return 'Vraiment ?';
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              onSaved: (String? value) {
                                character.setAbility(Ability.resistance, int.parse(value!));
                              },
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              controller: _abilityControllers[Ability.volonte],
                              decoration: const InputDecoration(
                                label: Text('VOLonté'),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (String? value) {
                                if(value == null || value.isEmpty) return 'Valeur manquante';
                                int? input = int.tryParse(value);
                                if(input == null) return 'Pas un nombre';
                                if(input < 1) return 'Nombre > 0';
                                if(input > 30) return 'Vraiment ?';
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              onSaved: (String? value) {
                                character.setAbility(Ability.volonte, int.parse(value!));
                              },
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              controller: _abilityControllers[Ability.perception],
                              decoration: const InputDecoration(
                                label: Text('PERception'),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (String? value) {
                                if(value == null || value.isEmpty) return 'Valeur manquante';
                                int? input = int.tryParse(value);
                                if(input == null) return 'Pas un nombre';
                                if(input < 1) return 'Nombre > 0';
                                if(input > 30) return 'Vraiment ?';
                                return null;
                              },
                              onChanged: (String? v) => _updateInitiative(),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              onSaved: (String? value) {
                                character.setAbility(Ability.perception, int.parse(value!));
                              },
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              controller: _abilityControllers[Ability.empathie],
                              decoration: const InputDecoration(
                                label: Text('EMPathie'),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (String? value) {
                                if(value == null || value.isEmpty) return 'Valeur manquante';
                                int? input = int.tryParse(value);
                                if(input == null) return 'Pas un nombre';
                                if(input < 1) return 'Nombre > 0';
                                if(input > 30) return 'Vraiment ?';
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              onSaved: (String? value) {
                                character.setAbility(Ability.empathie, int.parse(value!));
                              },
                            ),
                          ]
                      )
                  ),
                  const VerticalDivider(
                    width: 32,
                    thickness: 1,
                    indent: 4,
                    endIndent: 4,
                    color: Colors.grey,
                  ),
                  Expanded(
                      child: Column(
                          children: [
                            TextFormField(
                              controller: _attributeControllers[Attribute.physique],
                              decoration: const InputDecoration(
                                label: Text('PHYsique'),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (String? value) {
                                if(value == null || value.isEmpty) return 'Valeur manquante';
                                int? input = int.tryParse(value);
                                if(input == null) return 'Pas un nombre';
                                if(input < 0) return 'Nombre positif demandé';
                                if(input > 30) return 'Vraiment ?';
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              onSaved: (String? value) {
                                character.setAttribute(Attribute.physique, int.parse(value!));
                              },
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              controller: _attributeControllers[Attribute.mental],
                              decoration: const InputDecoration(
                                label: Text('MENtal'),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (String? value) {
                                if(value == null || value.isEmpty) return 'Valeur manquante';
                                int? input = int.tryParse(value);
                                if(input == null) return 'Pas un nombre';
                                if(input < 0) return 'Nombre positif demandé';
                                if(input > 30) return 'Vraiment ?';
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              onSaved: (String? value) {
                                character.setAttribute(Attribute.mental, int.parse(value!));
                              },
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              controller: _attributeControllers[Attribute.manuel],
                              decoration: const InputDecoration(
                                label: Text('MANuel'),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (String? value) {
                                if(value == null || value.isEmpty) return 'Valeur manquante';
                                int? input = int.tryParse(value);
                                if(input == null) return 'Pas un nombre';
                                if(input < 0) return 'Nombre positif demandé';
                                if(input > 30) return 'Vraiment ?';
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              onSaved: (String? value) {
                                character.setAttribute(Attribute.manuel, int.parse(value!));
                              },
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              controller: _attributeControllers[Attribute.social],
                              decoration: const InputDecoration(
                                label: Text('SOCial'),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (String? value) {
                                if(value == null || value.isEmpty) return 'Valeur manquante';
                                int? input = int.tryParse(value);
                                if(input == null) return 'Pas un nombre';
                                if(input < 0) return 'Nombre positif demandé';
                                if(input > 30) return 'Vraiment ?';
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              onSaved: (String? value) {
                                character.setAttribute(Attribute.social, int.parse(value!));
                              },
                            ),
                          ]
                      )
                  ),
                ],
              ),
            ),
            const Divider(
              height: 32,
              thickness: 1,
              indent: 4,
              endIndent: 4,
              color: Colors.grey,
            ),
            Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _initiativeController,
                      decoration: const InputDecoration(
                        label: Text('INItiative'),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (String? value) {
                        if(value == null || value.isEmpty) return 'Valeur manquante';
                        int? input = int.tryParse(value);
                        if(input == null) return 'Pas un nombre';
                        if(input < 1) return 'Nombre > 0';
                        if(input > 30) return 'Vraiment ?';
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (String? value) {
                        character.initiative = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      controller: _luckController,
                      decoration: const InputDecoration(
                        label: Text('CHAnce'),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (String? value) {
                        if(value == null || value.isEmpty) return 'Valeur manquante';
                        int? input = int.tryParse(value);
                        if(input == null) return 'Pas un nombre';
                        if(input < 0) return 'Nombre positif demandé';
                        if(input > 10) return 'Vraiment ?';

                        int? peer = int.tryParse(_proficiencyController.text);
                        if(peer != null && peer >= 0 && peer < 11) {
                          if(input + peer > 10) return 'MAÎ + CHA <= 10';
                        }

                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (String? value) {
                        character.luck = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      controller: _proficiencyController,
                      decoration: const InputDecoration(
                        label: Text('MAÎtrise'),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (String? value) {
                        if(value == null || value.isEmpty) return 'Valeur manquante';
                        int? input = int.tryParse(value);
                        if(input == null) return 'Pas un nombre';
                        if(input < 0) return 'Nombre positif demandé';
                        if(input > 10) return 'Vraiment ?';

                        int? peer = int.tryParse(_luckController.text);
                        if(peer != null && peer >= 0 && peer < 11) {
                          if(input + peer > 10) return 'MAÎ + CHA <= 10';
                        }

                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (String? value) {
                        character.proficiency = int.parse(value!);
                      },
                    ),
                  ),
                ]
            )
          ],
        )
    );
  }
}