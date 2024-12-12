import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../classes/armor.dart';
import '../../classes/character/base.dart';
import '../../classes/character/injury.dart';
import '../../classes/character/skill.dart';
import '../../classes/equipment.dart';
import '../../classes/human_character.dart';
import '../../classes/magic.dart';
import '../../classes/non_player_character.dart';
import '../../classes/shield.dart';
import '../../classes/weapon.dart';
import '../utils/ability_list_edit_widget.dart';
import '../utils/advantage_picker_dialog.dart';
import '../utils/armor_picker_dialog.dart';
import '../utils/attribute_list_edit_widget.dart';
import '../utils/caste_privilege_picker_dialog.dart';
import '../utils/disadvantage_picker_dialog.dart';
import '../utils/dropdown_menu_form_field.dart';
import '../utils/error_feedback.dart';
import '../utils/character_digit_input_widget.dart';
import '../utils/injuries_edit_widget.dart';
import '../utils/interdict_picker_dialog.dart';
import '../utils/magic_sphere_edit_widget.dart';
import '../utils/shield_picker_dialog.dart';
import '../utils/skill_picker_dialog.dart';
import '../utils/spell_picker_dialog.dart';
import '../utils/tendencies_edit_widget.dart';
import '../utils/weapon_picker_dialog.dart';

class NPCEditWidget extends StatefulWidget {
  const NPCEditWidget({
    super.key,
    required this.name,
    this.npc,
    this.npcId,
    this.category,
    this.subCategory,
    required this.onEditDone,
  });

  final String name;
  final NonPlayerCharacter? npc;
  final String? npcId;
  final NPCCategory? category;
  final NPCSubCategory? subCategory;
  final void Function(NonPlayerCharacter?) onEditDone;

  @override
  State<NPCEditWidget> createState() => _NPCEditWidgetState();
}

class _NPCEditWidgetState extends State<NPCEditWidget> {
  late final String _name;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _categoryController = TextEditingController();
  NPCCategory? _category;
  final List<NPCSubCategory> _validSubCategories = <NPCSubCategory>[];
  final TextEditingController _subCategoryController = TextEditingController();
  NPCSubCategory? _subCategory;
  bool _unique = false;
  final TextEditingController _casteController = TextEditingController();
  Caste _caste = Caste.sansCaste;
  final TextEditingController _casteStatusController = TextEditingController();
  CasteStatus _casteStatus = CasteStatus.none;
  final Map<CasteStatus, String> _casteStatusLabels = <CasteStatus, String>{};
  Map<Ability, int> _abilities = <Ability, int>{};
  Map<Attribute, int> _attributes = <Attribute, int>{};
  CharacterTendencies _tendencies = CharacterTendencies.empty();
  int _initiative = 0;
  int _luck = 0;
  int _proficiency = 0;
  int _renown = 0;
  final List<Interdict> _interdicts = <Interdict>[];
  final List<CastePrivilege> _castePrivileges = <CastePrivilege>[];
  final List<CharacterDisadvantage> _disadvantages = <CharacterDisadvantage>[];
  final List<CharacterAdvantage> _advantages = <CharacterAdvantage>[];
  final List<SkillInstance> _skills = <SkillInstance>[];
  bool _useHumanInjuryManager = false;
  final List<InjuryLevel> _injuries = <InjuryLevel>[
    InjuryLevel(
      rank: 0,
      title: 'Blessé',
      start: 0,
      end: 40,
      malus: 0,
      capacity: 3,
    ),
    InjuryLevel(
      rank: 1,
      title: 'Mort',
      start: 40,
      end: -1,
      malus: 0,
      capacity: 1,
    ),
  ];
  final List<Equipment> _equipment = <Equipment>[];
  final Map<MagicSkill, int> _magicSkills = Map.fromEntries(
      MagicSkill.values.map((MagicSkill s) => MapEntry(s, 0))
  );
  int _magicPool = 0;
  final Map<MagicSphere, int> _magicSphereSkills = Map.fromEntries(
      MagicSphere.values.map((MagicSphere s) => MapEntry(s, 0))
  );
  final Map<MagicSphere, int> _magicSpherePools = Map.fromEntries(
      MagicSphere.values.map((MagicSphere s) => MapEntry(s, 0))
  );
  final Map<MagicSphere, List<MagicSpell>> _magicSpells = <MagicSphere, List<MagicSpell>>{};
  final TextEditingController _descriptionController = TextEditingController();

  void _updateSubCategories() {
    _validSubCategories.clear();
    if(_category == null) return;
    _validSubCategories.addAll(
        NPCSubCategory.subCategoriesForCategory(_category!)
            .where((NPCSubCategory s) => s.categories.contains(_category))
    );
  }

  void _updateCasteStatusLabels() {
    _casteStatusLabels.clear();
    if(_caste == Caste.sansCaste) {
      _casteStatusLabels[CasteStatus.none] = Caste.statusName(Caste.sansCaste, CasteStatus.none);
    }
    else {
      for(var status in CasteStatus.values) {
        _casteStatusLabels[status] = Caste.statusName(_caste, status);
      }
    }
  }

  NonPlayerCharacter? _createNPC() {
    var ret = NonPlayerCharacter.create(
      name: _name,
      category: _category!,
      subCategory: _subCategory!,
      unique: _unique,
      useHumanInjuryManager: _useHumanInjuryManager,
      caste: _caste,
      casteStatus: _casteStatus,
      description: _descriptionController.text,
      tendencies: _tendencies,
      initiative: _initiative,
      luck: _luck,
      proficiency: _proficiency,
      renown: _renown,
      interdicts: _interdicts,
      castePrivileges: _castePrivileges,
      disadvantages: _disadvantages,
      advantages: _advantages,
    );

    _abilities.forEach((a, v) => ret.setAbility(a, v));
    _attributes.forEach((a, v) => ret.setAttribute(a, v));
    if(_useHumanInjuryManager) {
      ret.injuries = fullCharacterDefaultInjuries(ret, null);
    } else {
      ret.injuries = InjuryManager(levels: _injuries);
    }
    for(var s in _skills) {
      ret.skills.add(SkillInstance.fromJson(s.toJson()));
    }
    for(var eq in _equipment) {
      ret.addEquipment(eq);
    }
    for(var s in _magicSkills.keys) {
      ret.setMagicSkill(s, _magicSkills[s]!);
    }
    ret.magicPool = _magicPool;
    for(var s in MagicSphere.values) {
      ret.setMagicSphere(s, _magicSphereSkills[s]!);
      ret.setMagicSpherePool(s, _magicSpherePools[s]!);
    }
    for(var s in _magicSpells.keys) {
      for(var spell in _magicSpells[s]!) {
        ret.addSpell(spell);
      }
    }

    return ret;
  }

  bool _saveNPC() {
    widget.npc!.category = _category!;
    widget.npc!.subCategory = _subCategory!;
    widget.npc!.unique = _unique;
    widget.npc!.caste = _caste;
    widget.npc!.casteStatus = _casteStatus;
    widget.npc!.description = _descriptionController.text;
    for(var a in _abilities.keys) {
      widget.npc!.abilities[a] = _abilities[a]!;
    }
    for(var a in _attributes.keys) {
      widget.npc!.attributes[a] = _attributes[a]!;
    }
    widget.npc!.tendencies = _tendencies;
    widget.npc!.initiative = _initiative;
    widget.npc!.luck = _luck;
    widget.npc!.proficiency = _proficiency;
    widget.npc!.renown = _renown;
    widget.npc!.interdicts = _interdicts;
    widget.npc!.castePrivileges = _castePrivileges;
    widget.npc!.disadvantages = _disadvantages;
    widget.npc!.advantages = _advantages;
    widget.npc!.skills.clear();
    for(var s in _skills) {
      widget.npc!.skills.add(SkillInstance.fromJson(s.toJson()));
    }
    widget.npc!.useHumanInjuryManager = _useHumanInjuryManager;
    if(_useHumanInjuryManager) {
      widget.npc!.injuries = fullCharacterDefaultInjuries(widget.npc!, null);
    } else {
      widget.npc!.injuries = InjuryManager(levels: _injuries);
    }
    widget.npc!.equipment.clear();
    for(var e in _equipment) {
      widget.npc!.equipment.add(e);
    }
    for(var s in _magicSkills.keys) {
      widget.npc!.setMagicSkill(s, _magicSkills[s]!);
    }
    widget.npc!.magicPool = _magicPool;
    for(var s in MagicSphere.values) {
      widget.npc!.setMagicSphere(s, _magicSphereSkills[s]!);
      widget.npc!.setMagicSpherePool(s, _magicSpherePools[s]!);
    }
    widget.npc!.magicSpells.clear();
    for(var s in _magicSpells.keys) {
      for(var spell in _magicSpells[s]!) {
        widget.npc!.addSpell(spell);
      }
    }

    return true;
  }

  @override void initState() {
    super.initState();

    _category = widget.category;
    if(widget.category != null) {
      _categoryController.text = widget.category!.title;
    }
    _subCategory = widget.subCategory;
    if(widget.subCategory != null) {
      _subCategoryController.text = widget.subCategory!.title;
    }

    if(widget.npc != null) {
      _name = widget.npc!.name;
      _category = widget.npc!.category;
      _subCategory = widget.npc!.subCategory;
      _updateSubCategories();
      _unique = widget.npc!.unique;
      _caste = widget.npc!.caste;
      _casteStatus = widget.npc!.casteStatus;
      _updateCasteStatusLabels();
      for(var a in Ability.values) {
        _abilities[a] = widget.npc!.abilities[a]!;
      }
      for(var a in Attribute.values) {
        _attributes[a] = widget.npc!.attributes[a]!;
      }
      _initiative = widget.npc!.initiative;
      _luck = widget.npc!.luck;
      _proficiency = widget.npc!.proficiency;
      _renown = widget.npc!.renown;
      _tendencies = CharacterTendencies.fromJson(
          json.decode(json.encode(widget.npc!.tendencies.toJson()))
      );
      _interdicts.addAll(widget.npc!.interdicts);
      _castePrivileges.addAll(widget.npc!.castePrivileges);
      _disadvantages.addAll(widget.npc!.disadvantages);
      _advantages.addAll(widget.npc!.advantages);
      for(var s in widget.npc!.skills) {
        _skills.add(SkillInstance.fromJson(s.toJson()));
      }
      _skills.sort((a, b) => a.skill.title.compareTo(b.skill.title));
      _useHumanInjuryManager = widget.npc!.useHumanInjuryManager;
      if(!_useHumanInjuryManager) {
        _injuries.clear();
        for (var level in widget.npc!.injuries.levels()) {
          _injuries.add(InjuryLevel.fromJson(level.toJson()));
        }
        _injuries.sort((InjuryLevel a, InjuryLevel b) => a.start - b.start);
      }
      for(var e in widget.npc!.equipment) {
        var eq = EquipmentFactory.instance.forgeEquipment(e.type());
        if(eq != null ) {
          _equipment.add(eq);
        }
      }
      for(var s in MagicSkill.values) {
        _magicSkills[s] = widget.npc!.magicSkill(s);
      }
      _magicPool = widget.npc!.magicPool;
      _magicSpells.clear();
      for(var s in MagicSphere.values) {
        _magicSphereSkills[s] = widget.npc!.magicSphere(s);
        _magicSpherePools[s] = widget.npc!.magicSpherePool(s);
        var spells = widget.npc!.spells(s);
        if(spells.isNotEmpty) {
          _magicSpells[s] = spells;
        }
      }
      _descriptionController.text = widget.npc!.description;
    }
    else {
      _name = widget.name;
      _abilities = Map.fromEntries(Ability.values.map((a) => MapEntry(a, 0)));
      _attributes = Map.fromEntries(Attribute.values.map((a) => MapEntry(a, 0)));
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var subCategoryDropdownMenuEntries = <DropdownMenuEntry<NPCSubCategory>>[];
    if(widget.subCategory != null) {
      subCategoryDropdownMenuEntries.add(
          DropdownMenuEntry(
              value: widget.subCategory!,
              label: widget.subCategory!.title
          )
      );
    }
    else if(_category != null) {
      subCategoryDropdownMenuEntries.addAll(
          NPCSubCategory.subCategoriesForCategory(_category!)
              .where((NPCSubCategory s) => s.categories.contains(_category))
              .map((NPCSubCategory s) => DropdownMenuEntry(value: s, label: s.title))
      );
    }

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
                padding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 12.0),
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
                            child: DropdownMenuFormField(
                              controller: _categoryController,
                              initialSelection: _category,
                              enabled: widget.category == null,
                              requestFocusOnTap: true,
                              label: const Text('Catégorie'),
                              textStyle: theme.textTheme.bodySmall,
                              expandedInsets: EdgeInsets.zero,
                              inputDecorationTheme: InputDecorationTheme(
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.all(12.0),
                                labelStyle: theme.textTheme.labelSmall,
                              ),
                              dropdownMenuEntries: NPCCategory.values
                                  .where((NPCCategory c) => c != NPCCategory.scenario)
                                  .map((NPCCategory c) => DropdownMenuEntry(value: c, label: c.title))
                                  .toList(),
                              onSelected: (NPCCategory? category) {
                                setState(() {
                                  _category = category;
                                  _subCategory = null;
                                  _subCategoryController.clear();
                                  _updateSubCategories();
                                });
                              },
                              validator: (NPCCategory? value) {
                                if(value == null) {
                                  return 'Valeur manquante';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: DropdownMenuFormField(
                              controller: _subCategoryController,
                              initialSelection: _subCategory,
                              enabled: widget.subCategory == null,
                              requestFocusOnTap: true,
                              label: const Text('Sous-catégorie'),
                              textStyle: theme.textTheme.bodySmall,
                              expandedInsets: EdgeInsets.zero,
                              inputDecorationTheme: InputDecorationTheme(
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.all(12.0),
                                labelStyle: theme.textTheme.labelSmall,
                              ),
                              dropdownMenuEntries: subCategoryDropdownMenuEntries,
                              onSelected: (NPCSubCategory? subCategory) {
                                setState(() {
                                  _subCategory = subCategory;
                                });
                              },
                              validator: (NPCSubCategory? value) {
                                if(value == null) {
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
                      const SizedBox(height: 12.0),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownMenuFormField(
                              controller: _casteController,
                              initialSelection: widget.npc?.caste,
                              requestFocusOnTap: true,
                              label: const Text('Caste'),
                              textStyle: theme.textTheme.bodySmall,
                              expandedInsets: EdgeInsets.zero,
                              inputDecorationTheme: InputDecorationTheme(
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.all(12.0),
                                labelStyle: theme.textTheme.labelSmall,
                              ),
                              dropdownMenuEntries: Caste.values
                                  .map((Caste c) => DropdownMenuEntry(value: c, label: c.title))
                                  .toList(),
                              onSelected: (Caste? caste) {
                                if(caste == null) return;
                                setState(() {
                                  _caste = caste;
                                  _updateCasteStatusLabels();
                                  _casteStatusController.text = Caste.statusName(_caste, _casteStatus);
                                });
                              },
                              validator: (Caste? value) {
                                if(value == null) {
                                  return 'Valeur manquante';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: DropdownMenuFormField(
                              controller: _casteStatusController,
                              initialSelection: widget.npc?.casteStatus,
                              requestFocusOnTap: true,
                              label: const Text('Statut de Caste'),
                              textStyle: theme.textTheme.bodySmall,
                              expandedInsets: EdgeInsets.zero,
                              inputDecorationTheme: InputDecorationTheme(
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.all(12.0),
                                labelStyle: theme.textTheme.labelSmall,
                              ),
                              dropdownMenuEntries: _casteStatusLabels.keys
                                  .map((CasteStatus s) => DropdownMenuEntry(value: s, label: _casteStatusLabels[s]!))
                                  .toList(),
                              onSelected: (CasteStatus? status) {
                                if(status == null) return;
                                setState(() {
                                  _casteStatus = status;
                                });
                              },
                              validator: (CasteStatus? value) {
                                if(value == null) {
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black87),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: TendenciesEditWidget(
                              tendencies: _tendencies,
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: 120,
                            child: Column(
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
                                const SizedBox(height: 12.0),
                                SizedBox(
                                  width: 120,
                                  child: CharacterDigitInputWidget(
                                      initialValue: _luck,
                                      label: 'Chance',
                                      minValue: 0,
                                      maxValue: 6,
                                      onChanged: (int value) {
                                        _luck = value;
                                      }
                                  ),
                                ),
                                const SizedBox(height: 12.0),
                                SizedBox(
                                  width: 120,
                                  child: CharacterDigitInputWidget(
                                      initialValue: _proficiency,
                                      label: 'Maîtrise',
                                      minValue: 0,
                                      maxValue: 6,
                                      onChanged: (int value) {
                                        _proficiency = value;
                                      }
                                  ),
                                ),
                                const SizedBox(height: 12.0),
                                SizedBox(
                                  width: 120,
                                  child: CharacterDigitInputWidget(
                                      initialValue: _renown,
                                      label: 'Renommée',
                                      minValue: 0,
                                      maxValue: 10,
                                      onChanged: (int value) {
                                        _renown = value;
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Interdits',
                                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                              ),
                              for(var i in _interdicts)
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      iconSize: 20,
                                      onPressed: () {
                                        setState(() {
                                          _interdicts.remove(i);
                                        });
                                      },
                                    ),
                                    SizedBox(width: 200, child: Text('${i.title} (${i.caste.title})')),
                                  ],
                                ),
                              const SizedBox(height: 16.0),
                              ElevatedButton.icon(
                                icon: const Icon(
                                  Icons.add,
                                  size: 16.0,
                                ),
                                style: ElevatedButton.styleFrom(
                                  textStyle: theme.textTheme.bodySmall,
                                ),
                                label: const Text('Nouvel interdit'),
                                onPressed: () async {
                                  var result = await showDialog<Interdict>(
                                    context: context,
                                    builder: (BuildContext context) => InterdictPickerDialog(
                                      defaultCaste: _caste != Caste.sansCaste ?
                                      _caste :
                                      null,
                                    ),
                                  );
                                  if(!context.mounted) return;
                                  if(result == null) return;
                                  setState(() {
                                    _interdicts.add(result);
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(width: 8.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Privilèges',
                                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                              ),
                              for(var p in _castePrivileges)
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      iconSize: 20,
                                      onPressed: () {
                                        setState(() {
                                          _castePrivileges.remove(p);
                                        });
                                      },
                                    ),
                                    SizedBox(width: 200, child: Text('${p.title} (${p.cost})')),
                                  ],
                                ),
                              const SizedBox(height: 16.0),
                              ElevatedButton.icon(
                                icon: const Icon(
                                  Icons.add,
                                  size: 16.0,
                                ),
                                style: ElevatedButton.styleFrom(
                                  textStyle: theme.textTheme.bodySmall,
                                ),
                                label: const Text('Nouveau privilège'),
                                onPressed: () async {
                                  var result = await showDialog<CastePrivilege>(
                                    context: context,
                                    builder: (BuildContext context) => CastePrivilegePickerDialog(
                                      defaultCaste: _caste != Caste.sansCaste ?
                                      _caste :
                                      null,
                                    ),
                                  );
                                  if(!context.mounted) return;
                                  if(result == null) return;
                                  setState(() {
                                    _castePrivileges.add(result);
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Désavantages',
                                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                              ),
                              for(var d in _disadvantages)
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      iconSize: 20,
                                      onPressed: () {
                                        setState(() {
                                          _disadvantages.remove(d);
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${d.disadvantage.title} (${d.cost})'),
                                          if(d.details.isNotEmpty)
                                            SizedBox(
                                              width: 140,
                                              child: Text(
                                                d.details,
                                                style: theme.textTheme.bodySmall,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 16.0),
                              ElevatedButton.icon(
                                icon: const Icon(
                                  Icons.add,
                                  size: 16.0,
                                ),
                                style: ElevatedButton.styleFrom(
                                  textStyle: theme.textTheme.bodySmall,
                                ),
                                label: const Text('Nouveau désavantage'),
                                onPressed: () async {
                                  var result = await showDialog<CharacterDisadvantage>(
                                    context: context,
                                    builder: (BuildContext context) => const DisadvantagePickerDialog(),
                                  );
                                  if(!context.mounted) return;
                                  if(result == null) return;

                                  setState(() {
                                    _disadvantages.add(result);
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(width: 8.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Avantages',
                                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                              ),
                              for(var a in _advantages)
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      iconSize: 20,
                                      onPressed: () {
                                        setState(() {
                                          _advantages.remove(a);
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${a.advantage.title} (${a.cost})'),
                                          if(a.details.isNotEmpty)
                                            SizedBox(
                                              width: 140,
                                              child: Text(
                                                a.details,
                                                style: theme.textTheme.bodySmall,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 16.0),
                              ElevatedButton.icon(
                                icon: const Icon(
                                  Icons.add,
                                  size: 16.0,
                                ),
                                style: ElevatedButton.styleFrom(
                                  textStyle: theme.textTheme.bodySmall,
                                ),
                                label: const Text('Nouvel avantage'),
                                onPressed: () async {
                                  var result = await showDialog<CharacterAdvantage>(
                                    context: context,
                                    builder: (BuildContext context) => const AdvantagePickerDialog(),
                                  );
                                  if(!context.mounted) return;
                                  if(result == null) return;

                                  setState(() {
                                    _advantages.add(result);
                                  });
                                },
                              ),
                            ],
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
                              SpecializedSkill? skill = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      SpecializedSkillPickerDialog(
                                        skills: Skill.values
                                            .where((Skill s) => s.requireSpecialization || _skills.any((SkillInstance si) => s == si.skill))
                                            .toList()
                                            ..sort((Skill a, Skill b) => a.title.compareTo(b.title)),
                                      )
                              );
                              if(skill == null) return;

                              var parentSkillFound = false;
                              for(var s in _skills) {
                                if(s.skill == skill.parent) {
                                  parentSkillFound = true;
                                  setState(() {
                                    s.specializations[skill] = 0;
                                  });
                                }
                              }
                              if(!parentSkillFound) {
                                var parent = SkillInstance(skill: skill.parent, value: 0);
                                parent.specializations[skill] = 0;
                                setState(() {
                                  _skills.add(parent);
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Seuils de blessure',
                        style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        children: [
                          Switch(
                            value: _useHumanInjuryManager,
                            onChanged: (bool value) {
                              setState(() {
                                _useHumanInjuryManager = value;
                              });
                            },
                          ),
                          const Text('Utiliser les seuils de blessure complets'),
                        ],
                      ),
                      if(!_useHumanInjuryManager)
                        const SizedBox(height: 12.0),
                      if(!_useHumanInjuryManager)
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
                        'Magie',
                        style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        children: [
                          Expanded(
                            child: CharacterDigitInputWidget(
                              label: 'Instinctive',
                              initialValue: _magicSkills[MagicSkill.instinctive]!,
                              minValue: 0,
                              maxValue: 30,
                              onChanged: (int value) {
                                setState(() {
                                  _magicSkills[MagicSkill.instinctive] = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: CharacterDigitInputWidget(
                              label: 'Invocatoire',
                              initialValue: _magicSkills[MagicSkill.invocatoire]!,
                              minValue: 0,
                              maxValue: 30,
                              onChanged: (int value) {
                                setState(() {
                                  _magicSkills[MagicSkill.invocatoire] = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: CharacterDigitInputWidget(
                              label: 'Sorcellerie',
                              initialValue: _magicSkills[MagicSkill.sorcellerie]!,
                              minValue: 0,
                              maxValue: 30,
                              onChanged: (int value) {
                                setState(() {
                                  _magicSkills[MagicSkill.sorcellerie] = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: CharacterDigitInputWidget(
                              label: 'Réserve',
                              initialValue: _magicPool,
                              minValue: 0,
                              maxValue: 30,
                              onChanged: (int value) {
                                setState(() {
                                  _magicPool = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          for(var i = 0; i < 3; ++i)
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 24, 0),
                              child: Column(
                                children: [
                                  for(var j = 0; j < 3; ++j)
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                                      child: MagicSphereEditWidget(
                                        sphere: MagicSphere.values[i+j*3],
                                        value: _magicSphereSkills[MagicSphere.values[i+j*3]]!,
                                        pool: _magicSpherePools[MagicSphere.values[i+j*3]]!,
                                        onValueChanged: (int value) {
                                          setState(() {
                                            _magicSphereSkills[MagicSphere.values[i+j*3]] = value;
                                          });
                                        },
                                        onPoolChanged: (int value) {
                                          setState(() {
                                            _magicSpherePools[MagicSphere.values[i+j*3]] = value;
                                          });
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Sorts',
                        style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      for(var sphere in MagicSphere.values.where((MagicSphere s) => _magicSpells.containsKey(s)))
                        for(var spell in _magicSpells[sphere]!..sort((a, b) => a.name.compareTo(b.name)))
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete),
                                iconSize: 20,
                                onPressed: () {
                                  setState(() {
                                    _magicSpells[sphere]!.remove(spell);
                                  });
                                },
                              ),
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Image.asset('assets/images/magic/sphere-${sphere.name}-icon.png'),
                              ),
                              const SizedBox(width: 8.0),
                              Text('${spell.name} (niveau ${spell.level})'),
                            ],
                          ),
                      const SizedBox(height: 12.0),
                      ElevatedButton.icon(
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
                            if(!_magicSpells.containsKey(result.sphere)) {
                              _magicSpells[result.sphere] = <MagicSpell>[];
                            }
                            _magicSpells[result.sphere]!.add(result);
                          });
                        },
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

                      NonPlayerCharacter? npc;
                      if(widget.npc == null) {
                        npc = _createNPC();
                      }
                      else {
                        _saveNPC();
                        npc = widget.npc;
                      }

                      npc!.editable = true;
                      try {
                        await NonPlayerCharacter.saveLocalModel(npc);
                        widget.onEditDone(npc);
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