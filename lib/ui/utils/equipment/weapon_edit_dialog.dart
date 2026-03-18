import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../../../classes/combat.dart';
import '../../../classes/entity/abilities.dart';
import '../../../classes/entity/base.dart';
import '../../../classes/entity/skill.dart';
import '../../../classes/entity/specialized_skill.dart';
import '../../../classes/equipment/enums.dart';
import '../../../classes/equipment/equipment.dart';
import '../../../classes/object_source.dart';
import '../../../classes/equipment/weapon.dart';
import '../attribute_based_calculator_edit_widget.dart';
import '../num_input_widget.dart';
import '../widget_group_container.dart';
import 'equipment_requirements_edit_widget.dart';
import 'scarcity_edit_widget.dart';
import 'special_capabilities_edit_widget.dart';

class WeaponEditDialog extends StatefulWidget {
  const WeaponEditDialog({
    super.key,
    required this.skill,
    this.weapon,
  });

  final Skill skill;
  final WeaponModel? weapon;

  @override
  State<WeaponEditDialog> createState() => _WeaponEditDialogState();
}

class _WeaponEditDialogState extends State<WeaponEditDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  bool unique = false;
  int? hands;
  SpecializedSkill? specializedSkill;
  bool createSpecializedSkill = false;
  TextEditingController weightController = TextEditingController();
  TextEditingController dcController = TextEditingController();
  TextEditingController tcController = TextEditingController();
  EquipmentScarcity? villageScarcity;
  int? villagePrice;
  EquipmentScarcity? cityScarcity;
  int? cityPrice;
  bool supportsMetal = false;
  Map<Ability, int> requirements = <Ability, int>{};
  Map<WeaponRange, int> initiatives = <WeaponRange, int>{};
  AttributeBasedCalculator damage = AttributeBasedCalculator(static: 0.0);
  AttributeBasedCalculator rangeEffective = AttributeBasedCalculator(static: 0.0);
  AttributeBasedCalculator rangeMax = AttributeBasedCalculator(static: 0.0);
  TextEditingController descriptionController = TextEditingController();
  List<EquipmentSpecialCapability> special = <EquipmentSpecialCapability>[];

  @override
  void initState() {
    super.initState();

    if(widget.weapon != null) {
      nameController.text = widget.weapon!.name;
      unique = widget.weapon!.unique;
      hands = widget.weapon!.handiness;
      specializedSkill = widget.weapon!.skill;
      weightController.text = widget.weapon!.weight.toStringAsFixed(2);
      dcController.text = widget.weapon!.creationDifficulty.toString();
      tcController.text = widget.weapon!.creationTime.toString();
      villageScarcity = widget.weapon!.villageAvailability.scarcity;
      villagePrice = widget.weapon!.villageAvailability.price;
      cityScarcity = widget.weapon!.cityAvailability.scarcity;
      cityPrice = widget.weapon!.cityAvailability.price;
      supportsMetal = widget.weapon!.supportsMetal;
      requirements = widget.weapon!.requirements;
      initiatives = widget.weapon!.initiative;
      damage = widget.weapon!.damage;
      rangeEffective = widget.weapon!.rangeEffective;
      rangeMax = widget.weapon!.rangeMax;
      descriptionController.text = widget.weapon!.description;
      special = List.from(widget.weapon!.special);
    }
    else {
      for(var r in WeaponModel.weaponRangesForSkill(widget.skill)) {
        initiatives[r] = 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text("Éditer l'arme"),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 500,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 16.0,
                children: [
                  Row(
                    spacing: 8.0,
                    children: [
                      Text('Unique'),
                      Switch(
                        value: unique,
                        onChanged: (bool v) {
                          setState(() {
                            unique = v;
                          });
                        },
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Nom',
                            border: OutlineInputBorder(),
                          ),
                          validator: (String? value) {
                            if(value == null || value.isEmpty) {
                              return 'Valeur manquante';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: DropdownMenuFormField<int>(
                          initialSelection: hands,
                          requestFocusOnTap: true,
                          label: const Text('Mains'),
                          inputDecorationTheme: const InputDecorationTheme(
                            border: OutlineInputBorder(),
                          ),
                          expandedInsets: EdgeInsets.zero,
                          dropdownMenuEntries: [0, 1, 2]
                              .map((int h) => DropdownMenuEntry(value: h, label: h.toString()))
                              .toList(),
                          validator: (int? h) {
                            if(h == null) return 'Valeur manquante';
                            return null;
                          },
                          onSelected: (int? h) {
                            hands = h;
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 12.0,
                    children: [
                      Expanded(
                        child: DropdownMenuFormField<SpecializedSkill>(
                          enabled: !createSpecializedSkill,
                          initialSelection: specializedSkill,
                          requestFocusOnTap: true,
                          label: const Text('Spécialisation de combat'),
                          inputDecorationTheme: const InputDecorationTheme(
                            border: OutlineInputBorder(),
                          ),
                          expandedInsets: EdgeInsets.zero,
                          dropdownMenuEntries: SpecializedSkill.withParent(widget.skill)
                              .map((SpecializedSkill s) => DropdownMenuEntry(
                                value: s,
                                label: s.name
                              ))
                              .toList(),
                          validator: (SpecializedSkill? s) {
                            if(createSpecializedSkill) return null;
                            if(s == null) return 'Valeur manquante';
                            return null;
                          },
                          onSelected: (SpecializedSkill? s) {
                            specializedSkill = s;
                          },
                        ),
                      ),
                      Switch(
                        value: createSpecializedSkill,
                        onChanged: (bool v) {
                          setState(() {
                            createSpecializedSkill = v;
                          });
                        }
                      ),
                      Text(
                        'Créer une\nspécialisation',
                        style: theme.textTheme.bodySmall,
                      )
                    ],
                  ),
                  Row(
                    spacing: 12.0,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: weightController,
                          decoration: InputDecoration(
                            labelText: 'Poids (kg)',
                            border: OutlineInputBorder(),
                          ),
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
                      Expanded(
                        child: TextFormField(
                          controller: dcController,
                          decoration: InputDecoration(
                            labelText: 'Difficulté de création',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (String? value) {
                            if(value == null || value.isEmpty) return 'Valeur manquante';
                            int? input = int.tryParse(value);
                            if(input == null) return 'Pas un nombre';
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: tcController,
                          decoration: InputDecoration(
                            labelText: 'Temps de création',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (String? value) {
                            if(value == null || value.isEmpty) return 'Valeur manquante';
                            int? input = int.tryParse(value);
                            if(input == null) return 'Pas un nombre';
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 4.0,
                    children: [
                      Switch(
                        value: supportsMetal,
                        onChanged: (bool v) {
                          setState(() {
                            supportsMetal = v;
                          });
                        },
                      ),
                      Text('Peut être fabriqué avec différents métaux'),
                    ],
                  ),
                  Row(
                    spacing: 12.0,
                    children: [
                      Expanded(
                        child: ScarcityEditWidget(
                          type: 'Rareté (villages)',
                          onScarcityChanged: (EquipmentScarcity s) =>
                          villageScarcity = s,
                          onPriceChanged: (int p) => villagePrice = p,
                          scarcity: villageScarcity,
                          price: villagePrice,
                        ),
                      ),
                      Expanded(
                        child: ScarcityEditWidget(
                          type: 'Rareté (villes)',
                          onScarcityChanged: (EquipmentScarcity s) =>
                          cityScarcity = s,
                          onPriceChanged: (int p) => cityPrice = p,
                          scarcity: cityScarcity,
                          price: cityPrice,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12.0,
                    children: [
                      EquipmentRequirementsEditWidget(
                        onChanged: (Map<Ability, int> reqs) {
                          requirements = reqs;
                        },
                        requirements: requirements,
                      ),
                      _WeaponEditInitiativesWidget(
                        skill: widget.skill,
                        initiatives: widget.weapon?.initiative,
                        onInitiativeChanged: (WeaponRange r, int v) {
                          setState(() {
                            initiatives[r] = v;
                          });
                        },
                        onInitiativeRemoved: (WeaponRange r) {
                          setState(() {
                            initiatives.remove(r);
                          });
                        }
                      ),
                    ],
                  ),
                  AttributeBasedCalculatorEditWidget(
                    title: 'Dégats',
                    onChanged: (AttributeBasedCalculator d) {
                      damage = d;
                    },
                    calculator: damage,
                  ),
                  AttributeBasedCalculatorEditWidget(
                    title: 'Portée effective (m)',
                    onChanged: (AttributeBasedCalculator r) {
                      rangeEffective = r;
                    },
                    calculator: rangeEffective,
                    staticType: AttributeBasedCalculatorStaticType.double,
                  ),
                  AttributeBasedCalculatorEditWidget(
                    title: 'Portée max (m)',
                    onChanged: (AttributeBasedCalculator r) {
                      rangeMax = r;
                    },
                    calculator: rangeMax,
                    staticType: AttributeBasedCalculatorStaticType.double,
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    minLines: 5,
                    maxLines: 5,
                  ),
                  EquipmentSpecialCapabilitiesEditWidget(
                    special: special,
                    onChanged: (List<EquipmentSpecialCapability> c) {
                      special = c;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Annuler'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          onPressed: initiatives.isEmpty ? null : () async {
            if(!formKey.currentState!.validate()) return;

            if(createSpecializedSkill) {
              specializedSkill = SpecializedSkill.create(
                parent: widget.skill,
                name: nameController.text,
              );
            }

            if(widget.weapon == null) {
              var weapon = WeaponModel(
                uuid: const Uuid().v4().toString(),
                name: nameController.text,
                unique: unique,
                source: ObjectSource.local,
                description: descriptionController.text,
                weight: double.parse(weightController.text),
                creationDifficulty: int.parse(dcController.text),
                creationTime: int.parse(tcController.text),
                villageAvailability: EquipmentAvailability(
                  scarcity: villageScarcity!,
                  price: villagePrice!
                ),
                cityAvailability: EquipmentAvailability(
                  scarcity: cityScarcity!,
                  price: cityPrice!,
                ),
                skill: specializedSkill!,
                slot: EquipableItemSlot.hands,
                handiness: hands!,
                requirements: requirements,
                initiative: initiatives,
                damage: damage,
                rangeEffective: rangeEffective,
                rangeMax: rangeMax,
                supportsMetal: supportsMetal,
                special: special,
              );

              Navigator.of(context).pop(weapon);
            }
            else {
              widget.weapon!.name = nameController.text;
              widget.weapon!.unique = unique;
              widget.weapon!.skill = specializedSkill!;
              widget.weapon!.description = descriptionController.text;
              widget.weapon!.weight = double.parse(weightController.text);
              widget.weapon!.creationDifficulty = int.parse(dcController.text);
              widget.weapon!.creationTime = int.parse(tcController.text);
              widget.weapon!.villageAvailability = EquipmentAvailability(
                scarcity: villageScarcity!,
                price: villagePrice!
              );
              widget.weapon!.cityAvailability = EquipmentAvailability(
                scarcity: cityScarcity!,
                price: cityPrice!,
              );
              widget.weapon!.handiness = hands!;
              widget.weapon!.requirements = requirements;
              widget.weapon!.initiative = initiatives;
              widget.weapon!.damage = damage;
              widget.weapon!.rangeEffective = rangeEffective;
              widget.weapon!.rangeMax = rangeMax;
              widget.weapon!.supportsMetal = supportsMetal;
              widget.weapon!.special = special;

              Navigator.of(context).pop(widget.weapon!);
            }
          },
          child: const Text('OK'),
        )
      ],
    );
  }
}

class _WeaponEditInitiativesWidget extends StatelessWidget {
  const _WeaponEditInitiativesWidget({
    required this.skill,
    required this.onInitiativeChanged,
    required this.onInitiativeRemoved,
    this.initiatives,
  });
  
  final Skill skill;
  final void Function(WeaponRange, int) onInitiativeChanged;
  final void Function(WeaponRange) onInitiativeRemoved;
  final Map<WeaponRange, int>? initiatives;
  
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    
    var showContactInitiative = WeaponModel.weaponRangesForSkill(skill)
        .contains(WeaponRange.contact);
    var showMeleeInitiative = WeaponModel.weaponRangesForSkill(skill)
        .contains(WeaponRange.melee);
    var showDistanceInitiative = WeaponModel.weaponRangesForSkill(skill)
        .contains(WeaponRange.distance);
    var showRangedInitiative = WeaponModel.weaponRangesForSkill(skill)
        .contains(WeaponRange.ranged);

    return WidgetGroupContainer(
      title: Text(
          'Initiatives',
          style: theme.textTheme.bodySmall!.copyWith(
            color: Colors.black87,
          )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.0,
        children: [
          if(showContactInitiative)
            _EditInitiativeWidget(
              range: WeaponRange.contact,
              onEnabledChanged: (bool v) {
                if(!v) {
                  onInitiativeRemoved(WeaponRange.contact);
                }
                else {
                  onInitiativeChanged(WeaponRange.contact, 0);
                }
              },
              onInitiativeChanged: (int v) {
                onInitiativeChanged(WeaponRange.contact, v);
              },
              enabled: initiatives?.containsKey(WeaponRange.contact),
              initiative: initiatives?[WeaponRange.contact],
            ),
          if(showMeleeInitiative)
            _EditInitiativeWidget(
              range: WeaponRange.melee,
              onEnabledChanged: (bool v) {
                if(!v) {
                  onInitiativeRemoved(WeaponRange.melee);
                }
                else {
                  onInitiativeChanged(WeaponRange.melee, 0);
                }
              },
              onInitiativeChanged: (int v) {
                onInitiativeChanged(WeaponRange.melee, v);
              },
              enabled: initiatives?.containsKey(WeaponRange.melee),
              initiative: initiatives?[WeaponRange.melee],
            ),
          if(showDistanceInitiative)
            _EditInitiativeWidget(
              range: WeaponRange.distance,
              onEnabledChanged: (bool v) {
                if(!v) {
                  onInitiativeRemoved(WeaponRange.distance);
                }
                else {
                  onInitiativeChanged(WeaponRange.distance, 0);
                }
              },
              onInitiativeChanged: (int v) {
                onInitiativeChanged(WeaponRange.distance, v);
              },
              enabled: initiatives?.containsKey(WeaponRange.distance),
              initiative: initiatives?[WeaponRange.distance],
            ),
          if(showRangedInitiative)
            _EditInitiativeWidget(
              range: WeaponRange.ranged,
              onEnabledChanged: (bool v) {
                if(!v) {
                  onInitiativeRemoved(WeaponRange.ranged);
                }
                else {
                  onInitiativeChanged(WeaponRange.ranged, 0);
                }
              },
              onInitiativeChanged: (int v) {
                onInitiativeChanged(WeaponRange.ranged, v);
              },
              enabled: initiatives?.containsKey(WeaponRange.ranged),
              initiative: initiatives?[WeaponRange.ranged],
            ),
        ],
      )
    );
  }
}

class _EditInitiativeWidget extends StatefulWidget {
  const _EditInitiativeWidget({
    required this.range,
    required this.onEnabledChanged,
    required this.onInitiativeChanged,
    this.enabled,
    this.initiative,
  });

  final WeaponRange range;
  final void Function(bool) onEnabledChanged;
  final void Function(int) onInitiativeChanged;
  final bool? enabled;
  final int? initiative;

  @override
  State<_EditInitiativeWidget> createState() => _EditInitiativeWidgetState();
}

class _EditInitiativeWidgetState extends State<_EditInitiativeWidget> {
  late bool enabled;

  @override
  void initState() {
    super.initState();

    enabled = widget.enabled ?? true;
  }
  
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      spacing: 12.0,
      children: [
        Switch(
          value: enabled,
          onChanged: (bool v) {
            setState(() {
              enabled = v;
            });
            widget.onEnabledChanged(v);
          },
        ),
        SizedBox(
          width: 90,
          child: Text(
            widget.range.title,
            style: theme.textTheme.bodySmall,
          ),
        ),
        SizedBox(
          width: 70,
          child: NumIntInputWidget(
            enabled: enabled,
            label: 'Initiative',
            initialValue: widget.initiative ?? 0,
            minValue: -20,
            maxValue: 20,
            onChanged: (int value) => widget.onInitiativeChanged(value),
          ),
        ),
      ],
    );
  }
}