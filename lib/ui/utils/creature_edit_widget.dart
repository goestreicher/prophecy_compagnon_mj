import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../classes/armor.dart';
import '../../classes/character/base.dart';
import '../../classes/character/injury.dart';
import '../../classes/character/skill.dart';
import '../../classes/creature.dart';
import '../../classes/equipment.dart';
import '../../classes/shield.dart';
import '../../classes/weapon.dart';
import '../utils/ability_list_edit_widget.dart';
import '../utils/armor_picker_dialog.dart';
import '../utils/attribute_list_edit_widget.dart';
import '../utils/character_digit_input_widget.dart';
import '../utils/dropdown_menu_form_field.dart';
import '../utils/error_feedback.dart';
import '../utils/injuries_edit_widget.dart';
import '../utils/shield_picker_dialog.dart';
import '../utils/skill_picker_dialog.dart';
import '../utils/weapon_picker_dialog.dart';
import '../../text_utils.dart';

class CreatureEditWidget extends StatefulWidget {
  const CreatureEditWidget({
    super.key,
    this.creature,
    this.name,
    this.source,
    required this.onEditDone,
  });

  final CreatureModel? creature;
  final String? name;
  final String? source;
  final void Function(CreatureModel?) onEditDone;

  @override
  State<CreatureEditWidget> createState() => _CreatureEditWidgetState();
}

class _CreatureEditWidgetState extends State<CreatureEditWidget> {
  late final String _name;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _categoryController = TextEditingController();
  CreatureCategory? _category;
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _biomeController = TextEditingController();
  final TextEditingController _mapSizeController = TextEditingController();
  Map<Ability, int> _abilities = <Ability, int>{};
  Map<Attribute, int> _attributes = <Attribute, int>{};
  int _initiative = 0;
  int _armor = 0;
  final TextEditingController _armorDescriptionController = TextEditingController();
  final List<SkillInstance> _skills = <SkillInstance>[];
  final List<NaturalWeaponModel> _naturalWeapons = <NaturalWeaponModel>[];
  final List<InjuryLevel> _injuries = <InjuryLevel>[
    InjuryLevel(
      rank: 0,
      title: 'Blessé',
      start: 0,
      end: 20,
      malus: 0,
      capacity: 3,
    ),
    InjuryLevel(
      rank: 1,
      title: 'Mort',
      start: 20,
      end: -1,
      malus: 0,
      capacity: 1,
    ),
  ];
  final List<Equipment> _equipment = <Equipment>[];
  final TextEditingController _specialCapabilityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  CreatureModel? _createCreature() {
    return CreatureModel(
      name: _name,
      category: _category!,
      source: widget.source ?? CreatureModel.localCreatureSource,
      description: _descriptionController.text,
      biome: _biomeController.text,
      size: _sizeController.text,
      weight: _weightController.text,
      mapSize: double.parse(_mapSizeController.text),
      abilities: _abilities,
      attributes: _attributes,
      initiative: _initiative,
      naturalArmor: _armor,
      naturalArmorDescription: _armorDescriptionController.text,
      injuries: _injuries,
      skills: _skills,
      equipment: _equipment.map((Equipment e) => e.type()).toList(),
      naturalWeapons: _naturalWeapons,
      specialCapability: _specialCapabilityController.text,
    );
  }

  bool _saveCreature() {
    widget.creature!.category = _category!;
    widget.creature!.size = _sizeController.text;
    widget.creature!.mapSize = double.parse(_mapSizeController.text);
    widget.creature!.weight = _weightController.text;
    widget.creature!.biome = _biomeController.text;
    for(var a in _abilities.keys) {
      widget.creature!.abilities[a] = _abilities[a]!;
    }
    for(var a in _attributes.keys) {
      widget.creature!.attributes[a] = _attributes[a]!;
    }
    widget.creature!.initiative = _initiative;
    widget.creature!.naturalArmor = _armor;
    widget.creature!.naturalArmorDescription = _armorDescriptionController.text;
    widget.creature!.skills.clear();
    for(var s in _skills) {
      widget.creature!.skills.add(SkillInstance.fromJson(s.toJson()));
    }
    widget.creature!.naturalWeapons.clear();
    for(var nw in _naturalWeapons) {
      widget.creature!.naturalWeapons.add(NaturalWeaponModel.fromJson(nw.toJson()));
    }
    widget.creature!.injuries.clear();
    for(var level in _injuries) {
      widget.creature!.injuries.add(InjuryLevel.fromJson(level.toJson()));
    }
    widget.creature!.equipment.clear();
    for(var e in _equipment) {
      widget.creature!.equipment.add(e.type());
    }
    widget.creature!.specialCapability = _specialCapabilityController.text;
    widget.creature!.description = _descriptionController.text;

    return true;
  }

  @override void initState() {
    super.initState();

    if(widget.creature != null) {
      _name = widget.creature!.name;
      _category = widget.creature!.category;
      _sizeController.text = widget.creature!.size;
      _mapSizeController.text = widget.creature!.mapSize.toString();
      _weightController.text = widget.creature!.weight;
      _biomeController.text = widget.creature!.biome;
      for(var a in Ability.values) {
        _abilities[a] = widget.creature!.abilities[a]!;
      }
      for(var a in Attribute.values) {
        _attributes[a] = widget.creature!.attributes[a]!;
      }
      _initiative = widget.creature!.initiative;
      _armor = widget.creature!.naturalArmor;
      _armorDescriptionController.text = widget.creature!.naturalArmorDescription;
      for(var s in widget.creature!.skills) {
        _skills.add(SkillInstance.fromJson(s.toJson()));
      }
      _skills.sort((a, b) => a.skill.title.compareTo(b.skill.title));
      for(var nw in widget.creature!.naturalWeapons) {
        _naturalWeapons.add(NaturalWeaponModel.fromJson(nw.toJson()));
      }
      _injuries.clear();
      for(var level in widget.creature!.injuries) {
        _injuries.add(InjuryLevel.fromJson(level.toJson()));
      }
      _injuries.sort((InjuryLevel a, InjuryLevel b) => a.start - b.start);
      for(var e in widget.creature!.equipment) {
        var eq = EquipmentFactory.instance.forgeEquipment(e);
        if(eq != null ) {
          _equipment.add(eq);
        }
      }
      _specialCapabilityController.text = widget.creature!.specialCapability;
      _descriptionController.text = widget.creature!.description;
    }
    else {
      if(widget.name == null) {
        throw ArgumentError('Pas de nom fourni pour la nouvelle créature');
      }
      _name = widget.name!;
      _mapSizeController.text = '0.8';
      _abilities = Map.fromEntries(Ability.values.map((a) => MapEntry(a, 0)));
      _attributes = Map.fromEntries(Attribute.values.map((a) => MapEntry(a, 0)));
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var skillsWidgets = <Widget>[];
    for(var s in _skills) {
      var spWidgets = <Widget>[];
      for(var sp in s.specializations.keys) {
        spWidgets.add(
            Container(
              margin: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
              child: Card(
                color: theme.colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        iconSize: 16,
                        onPressed: () {
                          setState(() {
                            s.specializations.remove(sp);
                          });
                        },
                      ),
                      Text(
                        sp.title,
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(width: 8.0),
                      SizedBox(
                        width: 80,
                        child: CharacterDigitInputWidget(
                          key: UniqueKey(),
                          initialValue: s.specializations[sp]!,
                          minValue: 0,
                          onChanged: (int value) {
                            s.specializations[sp] = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
        );
      }

      skillsWidgets.add(
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        iconSize: 16,
                        onPressed: () {
                          setState(() {
                            _skills.remove(s);
                          });
                        },
                      ),
                      Text(
                        s.skill.title,
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(width: 8.0),
                      if(!s.skill.requireSpecialization)
                        SizedBox(
                          width: 80,
                          child: CharacterDigitInputWidget(
                            key: UniqueKey(),
                            initialValue: s.value,
                            minValue: 0,
                            onChanged: (int value) {
                              s.value = value;
                            },
                          ),
                        ),
                    ],
                  ),
                  if(spWidgets.isNotEmpty)
                    const SizedBox(height: 4.0),
                  ...spWidgets,
                ],
              )
            )
          )
      );
    }

    return Stack(
      children: [
        SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 700,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        _name,
                        style: theme.textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: DropdownMenuFormField(
                              controller: _categoryController,
                              initialSelection: _category,
                              requestFocusOnTap: true,
                              label: const Text('Catégorie'),
                              textStyle: theme.textTheme.bodySmall,
                              expandedInsets: EdgeInsets.zero,
                              inputDecorationTheme: InputDecorationTheme(
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.all(12.0),
                                labelStyle: theme.textTheme.labelSmall,
                              ),
                              dropdownMenuEntries: CreatureCategory.values
                                  .map((CreatureCategory c) => DropdownMenuEntry(value: c, label: c.title))
                                  .toList(),
                              onSelected: (CreatureCategory? category) {
                                setState(() {
                                  _category = category;
                                });
                              },
                              validator: (CreatureCategory? value) {
                                if(value == null) {
                                  return 'Valeur manquante';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _sizeController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                label: const Text('Taille (m)'),
                                labelStyle: theme.textTheme.labelSmall,
                              ),
                              style: theme.textTheme.bodySmall,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[.0-9]')),
                              ],
                              validator: (String? value) {
                                if(value == null || value.isEmpty) {
                                  return 'Valeur manquante';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _weightController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                label: const Text('Poids (kg)'),
                                labelStyle: theme.textTheme.labelSmall,
                              ),
                              style: theme.textTheme.bodySmall,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[.0-9]')),
                              ],
                              validator: (String? value) {
                                if(value == null || value.isEmpty) {
                                  return 'Valeur manquante';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              controller: _mapSizeController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                label: const Text('Taille sur la carte (m)'),
                                labelStyle: theme.textTheme.labelSmall,
                              ),
                              style: theme.textTheme.bodySmall,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[.0-9]')),
                              ],
                              validator: (String? value) {
                                if(value == null || value.isEmpty) return 'Valeur manquante';
                                double? input = double.tryParse(value);
                                if(input == null) return 'Pas un nombre';
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _biomeController,
                              decoration: InputDecoration(
                                label: const Text('Habitat'),
                                labelStyle: theme.textTheme.labelSmall,
                                floatingLabelStyle: theme.textTheme.labelLarge,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.all(12.0),
                                error: null,
                                errorText: null,
                              ),
                              style: theme.textTheme.bodySmall,
                              validator: (String? value) {
                                if(value == null || value.isEmpty) {
                                  return 'Valeur manquante';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Caractéristiques & Attributs',
                        style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: AbilityListEditWidget(
                                abilities: _abilities,
                                minValue: 0,
                                maxValue: 30,
                                onAbilityChanged: (Ability ability, int value) {
                                  _abilities[ability] = value;
                                }
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Expanded(
                            flex: 1,
                            child: AttributeListEditWidget(
                              attributes: _attributes,
                              minValue: 0,
                              maxValue: 30,
                              onAttributeChanged: (Attribute attribute, int value) {
                                _attributes[attribute] = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: CharacterDigitInputWidget(
                                initialValue: _initiative,
                                label: 'Initiative',
                                onChanged: (int value) {
                                  _initiative = value;
                                }
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          SizedBox(
                            width: 120,
                            child: CharacterDigitInputWidget(
                                initialValue: _armor,
                                label: 'Armure',
                                minValue: 0,
                                maxValue: 50,
                                onChanged: (int value) {
                                  _armor = value;
                                }
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                              child: TextField(
                                controller: _armorDescriptionController,
                                decoration: InputDecoration(
                                  label: const Text('Armure (description)'),
                                  labelStyle: theme.textTheme.labelSmall,
                                  floatingLabelStyle: theme.textTheme.labelLarge,
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.all(12.0),
                                  error: null,
                                  errorText: null,
                                  isDense: true,
                                ),
                                style: theme.textTheme.bodySmall,
                              )
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Compétences',
                        style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12.0),
                      ...skillsWidgets,
                      if(skillsWidgets.isNotEmpty)
                        const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(
                              Icons.add,
                              size: 16.0,
                            ),
                            style: ElevatedButton.styleFrom(
                              textStyle: theme.textTheme.bodySmall,
                            ),
                            label: const Text('Nouvelle compétence'),
                            onPressed: () async {
                              Skill? skill = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                  const FamilyAndSkillPickerDialog() // TODO: add excluded skills
                              );
                              if(skill == null) return;
                              setState(() {
                                _skills.add(SkillInstance(skill: skill, value: 0));
                                // _skills.sort((a, b) => a.skill.title.compareTo(b.skill.title));
                              });
                            },
                          ),
                          const SizedBox(width: 12.0),
                          ElevatedButton.icon(
                            icon: const Icon(
                              Symbols.target,
                              size: 16.0,
                            ),
                            style: ElevatedButton.styleFrom(
                              textStyle: theme.textTheme.bodySmall,
                            ),
                            label: const Text('Nouvelle spécialisation'),
                            onPressed: () async {
                              String creatureId;
                              if(widget.creature == null) {
                                creatureId = sentenceToCamelCase(transliterateFrenchToAscii(_name));
                              }
                              else {
                                creatureId = widget.creature!.id;
                              }

                              SpecializedSkill? skill = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      SpecializedSkillPickerDialog(
                                        skills: Skill.values
                                            .where((Skill s) => s.requireSpecialization || _skills.any((SkillInstance si) => s == si.skill))
                                            .toList()
                                            ..sort((Skill a, Skill b) => a.title.compareTo(b.title)),
                                        reservedPrefix: 'creature:$creatureId:specialized:misc',
                                      )
                              );
                              if(skill == null) return;

                              bool parentSkillFound = false;
                              for(var s in _skills) {
                                if(s.skill == skill.parent) {
                                  parentSkillFound = true;
                                  setState(() {
                                    s.specializations[skill] = 0;
                                  });
                                }
                              }
                              if(!parentSkillFound) {
                                setState(() {
                                  SkillInstance si = SkillInstance(skill: skill.parent, value: 0);
                                  si.specializations[skill] = 0;
                                  _skills.add(si);
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Armes naturelles',
                        style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      for(var nw in _naturalWeapons)
                        _NaturalWeaponEditWidget(weapon: nw),
                      const SizedBox(height: 20.0),
                      Text(
                        'Seuils de blessure',
                        style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12.0),
                      InjuriesEditWidget(injuries: _injuries),
                      const SizedBox(height: 20.0),
                      Text(
                        'Équipement',
                        style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12.0),
                      for(var eq in _equipment.whereType<Weapon>())
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete),
                              iconSize: 20,
                              onPressed: () {
                                setState(() {
                                  _equipment.remove(eq);
                                });
                              },
                            ),
                            Text(
                              '\u{2694} ${eq.name()}',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      for(var eq in _equipment.whereType<Shield>())
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete),
                              iconSize: 20,
                              onPressed: () {
                                setState(() {
                                  _equipment.remove(eq);
                                });
                              },
                            ),
                            Text(
                              '\u{1F6E1} ${eq.name()}',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      for(var eq in _equipment.whereType<Armor>())
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete),
                              iconSize: 20,
                              onPressed: () {
                                setState(() {
                                  _equipment.remove(eq);
                                });
                              },
                            ),
                            Text(
                              '\u{1F6E1} ${eq.name()}',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      if(_equipment.isNotEmpty)
                        const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(
                              Icons.add,
                              size: 16.0,
                            ),
                            style: ElevatedButton.styleFrom(
                              textStyle: theme.textTheme.bodySmall,
                            ),
                            label: const Text('Nouvelle arme'),
                            onPressed: () async {
                              var id = await showDialog(
                                context: context,
                                builder: (BuildContext context) => const WeaponPickerDialog(),
                              );
                              if(!context.mounted) return;
                              if(id == null) return;

                              var eq = EquipmentFactory.instance.forgeEquipment('weapon:$id');
                              if(eq == null) return;

                              setState(() {
                                _equipment.add(eq);
                              });
                            },
                          ),
                          const SizedBox(width: 12.0),
                          ElevatedButton.icon(
                            icon: const Icon(
                              Icons.add,
                              size: 16.0,
                            ),
                            style: ElevatedButton.styleFrom(
                              textStyle: theme.textTheme.bodySmall,
                            ),
                            label: const Text('Nouveau bouclier'),
                            onPressed: () async {
                              var id = await showDialog(
                                context: context,
                                builder: (BuildContext context) => const ShieldPickerDialog(),
                              );
                              if(!context.mounted) return;
                              if(id == null) return;

                              var eq = EquipmentFactory.instance.forgeEquipment('shield:$id');
                              if(eq == null) return;

                              setState(() {
                                _equipment.add(eq);
                              });
                            },
                          ),
                          const SizedBox(width: 12.0),
                          ElevatedButton.icon(
                            icon: const Icon(
                              Icons.add,
                              size: 16.0,
                            ),
                            style: ElevatedButton.styleFrom(
                              textStyle: theme.textTheme.bodySmall,
                            ),
                            label: const Text('Nouvelle armure'),
                            onPressed: () async {
                              var id = await showDialog(
                                context: context,
                                builder: (BuildContext context) => const ArmorPickerDialog(),
                              );
                              if(!context.mounted) return;
                              if(id == null) return;

                              var eq = EquipmentFactory.instance.forgeEquipment('armor:$id');
                              if(eq == null) return;

                              setState(() {
                                _equipment.add(eq);
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Capacité spéciale',
                        style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        children: [
                          Expanded(
                              child: TextField(
                                controller: _specialCapabilityController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.all(12.0),
                                  error: null,
                                  errorText: null,
                                ),
                                style: theme.textTheme.bodySmall,
                                minLines: 2,
                                maxLines: 2,
                              )
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Description',
                        style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _descriptionController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(12.0),
                                error: null,
                                errorText: null,
                              ),
                              style: theme.textTheme.bodySmall,
                              minLines: 10,
                              maxLines: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
            top: 8,
            right: 12,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.cancel_outlined),
                  onPressed: () {
                    widget.onEditDone(null);
                  },
                ),
                IconButton(
                    icon: const Icon(Icons.check_circle_outline),
                    onPressed: () async {
                      if(!_formKey.currentState!.validate()) return;

                      CreatureModel? model;
                      if(widget.creature == null) {
                        model = _createCreature();
                      }
                      else {
                        _saveCreature();
                        model = widget.creature;
                      }

                      model!.editable = true;
                      try {
                        await CreatureModel.saveLocalModel(model);
                        widget.onEditDone(model);
                      }
                      catch(e) {
                        if(!context.mounted) return;
                        displayErrorDialog(
                          context,
                          'Sauvegarde impossible',
                          e.toString()
                        );
                      }
                    }
                )
              ],
            )
        ),
      ],
    );
  }
}

class _NaturalWeaponEditWidget extends StatefulWidget {
  const _NaturalWeaponEditWidget({ required this.weapon });

  final NaturalWeaponModel weapon;

  @override
  State<_NaturalWeaponEditWidget> createState() => _NaturalWeaponEditWidgetState();
}

class _NaturalWeaponEditWidgetState extends State<_NaturalWeaponEditWidget> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.weapon.name;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
      child: Row(
        children: [
          SizedBox(
              width: 250,
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  label: const Text('Nom'),
                  labelStyle: theme.textTheme.labelSmall,
                  floatingLabelStyle: theme.textTheme.labelLarge,
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.all(12.0),
                  error: null,
                  errorText: null,
                  isDense: true,
                ),
                style: theme.textTheme.bodySmall,
              )
          ),
          const SizedBox(width: 8.0),
          SizedBox(
              width: 90,
              child: CharacterDigitInputWidget(
                label: 'Compétence',
                initialValue: widget.weapon.skill,
                onChanged: (int value) {
                  widget.weapon.skill = value;
                },
              )
          ),
          const SizedBox(width: 8.0),
          SizedBox(
              width: 90,
              child: CharacterDigitInputWidget(
                label: 'Dégats',
                initialValue: widget.weapon.damage,
                onChanged: (int value) {
                  widget.weapon.damage = value;
                },
              )
          ),
        ],
      ),
    );
  }
}