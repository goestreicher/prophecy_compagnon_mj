import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../classes/armor.dart';
import '../../classes/character/base.dart';
import '../../classes/character/injury.dart';
import '../../classes/character/skill.dart';
import '../../classes/combat.dart';
import '../../classes/creature.dart';
import '../../classes/equipment.dart';
import '../../classes/object_source.dart';
import '../../classes/shield.dart';
import '../../classes/weapon.dart';
import '../utils/ability_list_edit_widget.dart';
import '../utils/armor_picker_dialog.dart';
import '../utils/attribute_list_edit_widget.dart';
import '../utils/character_digit_input_widget.dart';
import '../utils/dropdown_menu_form_field.dart';
import '../utils/error_feedback.dart';
import '../utils/full_page_loading.dart';
import '../utils/injuries_edit_widget.dart';
import '../utils/shield_picker_dialog.dart';
import '../utils/skill_picker_dialog.dart';
import '../utils/weapon_picker_dialog.dart';
import '../../text_utils.dart';

class CreatureEditWidget extends StatefulWidget {
  const CreatureEditWidget({
    super.key,
    required this.name,
    this.creature,
    this.creatureId,
    this.source,
    required this.onEditDone,
  });

  final String name;
  final CreatureModel? creature;
  final String? creatureId;
  final ObjectSource? source;
  final void Function(CreatureModel?) onEditDone;

  @override
  State<CreatureEditWidget> createState() => _CreatureEditWidgetState();
}

class _CreatureEditWidgetState extends State<CreatureEditWidget> {
  Future<CreatureModel?>? creatureFuture;
  bool _unique = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _categoryController = TextEditingController();
  String? _createCategoryName;
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
      name: widget.name,
      unique: _unique,
      category: _category!,
      source: widget.source ?? ObjectSource.local,
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

  bool _applyChanges(CreatureModel creature) {
    creature.unique = _unique;
    creature.category = _category!;
    creature.size = _sizeController.text;
    creature.mapSize = double.parse(_mapSizeController.text);
    creature.weight = _weightController.text;
    creature.biome = _biomeController.text;
    for(var a in _abilities.keys) {
      creature.abilities[a] = _abilities[a]!;
    }
    for(var a in _attributes.keys) {
      creature.attributes[a] = _attributes[a]!;
    }
    creature.initiative = _initiative;
    creature.naturalArmor = _armor;
    creature.naturalArmorDescription = _armorDescriptionController.text;
    creature.skills.clear();
    for(var s in _skills) {
      creature.skills.add(SkillInstance.fromJson(s.toJson()));
    }
    creature.naturalWeapons.clear();
    for(var nw in _naturalWeapons) {
      creature.naturalWeapons.add(NaturalWeaponModel.fromJson(nw.toJson()));
    }
    creature.injuries.clear();
    for(var level in _injuries) {
      creature.injuries.add(InjuryLevel.fromJson(level.toJson()));
    }
    creature.equipment.clear();
    for(var e in _equipment) {
      creature.equipment.add(e.type());
    }
    creature.specialCapability = _specialCapabilityController.text;
    creature.description = _descriptionController.text;

    return true;
  }

  @override void initState() {
    super.initState();
    if(widget.creature != null) {
      creatureFuture = Future(() => widget.creature);
    }
    else if(widget.creatureId != null) {
      creatureFuture = CreatureModel.get(widget.creatureId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: creatureFuture,
      builder: (BuildContext context, AsyncSnapshot<CreatureModel?> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return FullPageLoadingWidget();
        }

        if(snapshot.hasError) {
          return FullPageErrorWidget(message: snapshot.error!.toString(), canPop: false);
        }

        CreatureModel? creature;
        if(snapshot.hasData && snapshot.data != null) {
          creature = snapshot.data!;
          
          _unique = creature.unique;
          _category = creature.category;
          _sizeController.text = creature.size;
          _mapSizeController.text = creature.mapSize.toString();
          _weightController.text = creature.weight;
          _biomeController.text = creature.biome;
          for(var a in Ability.values) {
            _abilities[a] = creature.abilities[a]!;
          }
          for(var a in Attribute.values) {
            _attributes[a] = creature.attributes[a]!;
          }
          _initiative = creature.initiative;
          _armor = creature.naturalArmor;
          _armorDescriptionController.text = creature.naturalArmorDescription;
          for(var s in creature.skills) {
            _skills.add(SkillInstance.fromJson(s.toJson()));
          }
          _skills.sort((a, b) => a.skill.title.compareTo(b.skill.title));
          for(var nw in creature.naturalWeapons) {
            _naturalWeapons.add(NaturalWeaponModel.fromJson(nw.toJson()));
          }
          _injuries.clear();
          for(var level in creature.injuries) {
            _injuries.add(InjuryLevel.fromJson(level.toJson()));
          }
          _injuries.sort((InjuryLevel a, InjuryLevel b) => a.start - b.start);
          for(var e in creature.equipment) {
            var eq = EquipmentFactory.instance.forgeEquipment(e);
            if(eq != null ) {
              _equipment.add(eq);
            }
          }
          _specialCapabilityController.text = creature.specialCapability;
          _descriptionController.text = creature.description;
        }
        else {
          _mapSizeController.text = '0.8';
          _abilities = Map.fromEntries(Ability.values.map((a) => MapEntry(a, 0)));
          _attributes = Map.fromEntries(Attribute.values.map((a) => MapEntry(a, 0)));
        }

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
                            widget.name,
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
                                  enableSearch: true,
                                  enableFilter: true,
                                  filterCallback: (List<DropdownMenuEntry<CreatureCategory>> entries, String filter) {
                                    if(filter.isEmpty || (_category != null && filter == _category!.title)) {
                                      return entries;
                                    }

                                    String lcFilter = filter.toLowerCase();
                                    var ret = entries
                                        .where((DropdownMenuEntry<CreatureCategory> c) =>
                                          c.label.toLowerCase().contains(lcFilter)
                                        )
                                        .toList();

                                    if(ret.isEmpty) {
                                      _createCategoryName = filter;
                                      ret.add(DropdownMenuEntry(
                                        value: CreatureCategory.createNewCreatureCategory,
                                        label: 'Créer "$filter"',
                                        leadingIcon: const Icon(Icons.add))
                                      );
                                    }

                                    return ret;
                                  },
                                  onSelected: (CreatureCategory? category) {
                                    setState(() {
                                      if(category == CreatureCategory.createNewCreatureCategory) {
                                        _category = CreatureCategory(title: _createCategoryName!);
                                      }
                                      else {
                                        _category = category;
                                      }
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
                              const SizedBox(width: 8.0),
                              const Text('Unique'),
                              Switch(
                                value: _unique,
                                onChanged: (bool value) {
                                  setState(() {
                                    _unique = value;
                                  });
                                }
                              )
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
                                      const FamilyAndSkillPickerDialog()
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
                                  if(creature == null) {
                                    creatureId = sentenceToCamelCase(transliterateFrenchToAscii(widget.name));
                                  }
                                  else {
                                    creatureId = creature.id;
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
                          const SizedBox(height: 12.0),
                          ElevatedButton.icon(
                            icon: const Icon(
                              Icons.add,
                              size: 16.0,
                            ),
                            style: ElevatedButton.styleFrom(
                              textStyle: theme.textTheme.bodySmall,
                            ),
                            label: const Text('Nouvelle arme naturelle'),
                            onPressed: () async {
                              NaturalWeaponModel? weapon = await showDialog(
                                context: context,
                                builder: (BuildContext context) => _NaturalWeaponCreateDialog(),
                              );
                              if(weapon == null) return;
                              setState(() {
                                _naturalWeapons.add(weapon);
                              });
                            },
                          ),
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
                      if(creature == null) {
                        model = _createCreature();
                      }
                      else {
                        _applyChanges(creature);
                        model = creature;
                      }

                      try {
                        await CreatureModel.saveLocalModel(model!);
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
    );
  }
}

class _NaturalWeaponCreateDialog extends StatefulWidget {
  const _NaturalWeaponCreateDialog();

  @override
  State<_NaturalWeaponCreateDialog> createState() => _NaturalWeaponCreateDialogState();
}

class _NaturalWeaponCreateDialogState extends State<_NaturalWeaponCreateDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  int skill = 0;
  int damage = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nouvelle arme naturelle'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                label: const Text('Nom'),
                border: const OutlineInputBorder(),
              ),
              validator: (String? value) {
                if(value == null || value.isEmpty) {
                  return 'Valeur manquante';
                }
                return null;
              },
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                Spacer(),
                SizedBox(
                  width: 90,
                  child: CharacterDigitInputWidget(
                    label: 'Compétence',
                    initialValue: 0,
                    minValue: 1,
                    maxValue: 30,
                    onChanged: (int value) => skill = value,
                  ),
                ),
                SizedBox(width: 12.0),
                SizedBox(
                  width: 90,
                  child: CharacterDigitInputWidget(
                    label: 'Dégats',
                    initialValue: 0,
                    minValue: 1,
                    maxValue: 9999,
                    onChanged: (int value) => damage = value,
                  ),
                ),
                Spacer(),
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () {
            if(!_formKey.currentState!.validate()) return;
            var model = NaturalWeaponModel(
              name: nameController.text,
              skill: skill,
              damage: damage,
              ranges: {WeaponRange.contact: 0.0},
            );
            Navigator.of(context).pop(model);
          },
          child: const Text('OK'),
        )
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
            child: TextFormField(
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
              validator: (String? value) {
                if(value == null || value.isEmpty) {
                  return 'Valeur manquante';
                }
                return null;
              },
            )
          ),
          const SizedBox(width: 8.0),
          SizedBox(
            width: 90,
            child: CharacterDigitInputWidget(
              label: 'Compétence',
              initialValue: widget.weapon.skill,
              minValue: 1,
              maxValue: 30,
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
              minValue: 1,
              maxValue: 9999,
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