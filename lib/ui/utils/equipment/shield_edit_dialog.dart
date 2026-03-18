import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prophecy_compagnon_mj/classes/equipment/equipment.dart';
import 'package:uuid/uuid.dart';

import '../../../classes/entity/abilities.dart';
import '../../../classes/entity/base.dart';
import '../../../classes/equipment/enums.dart';
import '../../../classes/object_source.dart';
import '../../../classes/equipment/shield.dart';
import '../attribute_based_calculator_edit_widget.dart';
import 'equipment_requirements_edit_widget.dart';
import 'scarcity_edit_widget.dart';
import 'special_capabilities_edit_widget.dart';

class ShieldEditDialog extends StatefulWidget {
  const ShieldEditDialog({
    super.key,
    this.shield,
  });

  final ShieldModel? shield;

  @override
  State<ShieldEditDialog> createState() => _ShieldEditDialogState();
}

class _ShieldEditDialogState extends State<ShieldEditDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  bool unique = false;
  TextEditingController weightController = TextEditingController();
  TextEditingController dcController = TextEditingController();
  TextEditingController tcController = TextEditingController();
  EquipmentScarcity? villageScarcity;
  int? villagePrice;
  EquipmentScarcity? cityScarcity;
  int? cityPrice;
  bool supportsMetal = false;
  Map<Ability, int> requirements = <Ability, int>{};
  TextEditingController protectionController = TextEditingController();
  TextEditingController penaltyController = TextEditingController();
  AttributeBasedCalculator damage = AttributeBasedCalculator(static: 0.0);
  TextEditingController descriptionController = TextEditingController();
  List<EquipmentSpecialCapability> special = <EquipmentSpecialCapability>[];

  @override
  void initState() {
    super.initState();

    if(widget.shield != null) {
      nameController.text = widget.shield!.name;
      unique = widget.shield!.unique;
      weightController.text = widget.shield!.weight.toStringAsFixed(2);
      dcController.text = widget.shield!.creationDifficulty.toString();
      tcController.text = widget.shield!.creationTime.toString();
      villageScarcity = widget.shield!.villageAvailability.scarcity;
      villagePrice = widget.shield!.villageAvailability.price;
      cityScarcity = widget.shield!.cityAvailability.scarcity;
      cityPrice = widget.shield!.cityAvailability.price;
      supportsMetal = widget.shield!.supportsMetal;
      requirements = widget.shield!.requirements;
      protectionController.text = widget.shield!.protection.toString();
      penaltyController.text = (-widget.shield!.penalty).toString();
      damage = widget.shield!.damage;
      descriptionController.text = widget.shield!.description;
      special = widget.shield!.special;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Éditer le bouclier'),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 12.0,
                          children: [
                            TextFormField(
                              controller: protectionController,
                              decoration: InputDecoration(
                                labelText: 'Protection',
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
                            TextFormField(
                              controller: penaltyController,
                              decoration: InputDecoration(
                                labelText: 'Pénalité',
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
                          ],
                        ),
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
          child: const Text('OK'),
          onPressed: () async {
            if(!formKey.currentState!.validate()) return;

            if(widget.shield == null) {
              var shield = ShieldModel(
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
                requirements: requirements,
                protection: int.parse(protectionController.text),
                penalty: -int.parse(penaltyController.text),
                damage: damage,
                supportsMetal: supportsMetal,
                special: special,
              );

              Navigator.of(context).pop(shield);
            }
            else {
              widget.shield!.name = nameController.text;
              widget.shield!.unique = unique;
              widget.shield!.description = descriptionController.text;
              widget.shield!.weight = double.parse(weightController.text);
              widget.shield!.creationDifficulty = int.parse(dcController.text);
              widget.shield!.creationTime = int.parse(tcController.text);
              widget.shield!.villageAvailability = EquipmentAvailability(
                scarcity: villageScarcity!,
                price: villagePrice!
              );
              widget.shield!.cityAvailability = EquipmentAvailability(
                scarcity: cityScarcity!,
                price: cityPrice!,
              );
              widget.shield!.requirements = requirements;
              widget.shield!.protection = int.parse(protectionController.text);
              widget.shield!.penalty = -int.parse(penaltyController.text);
              widget.shield!.damage = damage;
              widget.shield!.supportsMetal = supportsMetal;
              widget.shield!.special = special;

              Navigator.of(context).pop(widget.shield!);
            }
          },
        )
      ],
    );
  }
}