import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../../../classes/equipment/armor.dart';
import '../../../classes/entity/abilities.dart';
import '../../../classes/equipment/enums.dart';
import '../../../classes/equipment/equipment.dart';
import '../../../classes/object_source.dart';
import 'equipment_requirements_edit_widget.dart';
import 'scarcity_edit_widget.dart';
import 'special_capabilities_edit_widget.dart';

class ArmorEditDialog extends StatefulWidget {
  const ArmorEditDialog({
    super.key,
    required this.type,
    this.armor,
  });

  final ArmorType type;
  final ArmorModel? armor;

  @override
  State<ArmorEditDialog> createState() => _ArmorEditDialogState();
}

class _ArmorEditDialogState extends State<ArmorEditDialog> {
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
  TextEditingController descriptionController = TextEditingController();
  List<EquipmentSpecialCapability> special = <EquipmentSpecialCapability>[];

  @override
  void initState() {
    super.initState();

    if(widget.armor != null) {
      nameController.text = widget.armor!.name;
      unique = widget.armor!.unique;
      weightController.text = widget.armor!.weight.toStringAsFixed(2);
      dcController.text = widget.armor!.creationDifficulty.toString();
      tcController.text = widget.armor!.creationTime.toString();
      villageScarcity = widget.armor!.villageAvailability.scarcity;
      villagePrice = widget.armor!.villageAvailability.price;
      cityScarcity = widget.armor!.cityAvailability.scarcity;
      cityPrice = widget.armor!.cityAvailability.price;
      supportsMetal = widget.armor!.supportsMetal;
      requirements = widget.armor!.requirements;
      protectionController.text = widget.armor!.protection.toString();
      penaltyController.text = (-widget.armor!.penalty).toString();
      descriptionController.text = widget.armor!.description;
      special = List.from(widget.armor!.special);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Éditer l'armure"),
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
                      Text('Peut être fabriquée avec différents métaux'),
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

            if(widget.armor == null) {
              var armor = ArmorModel(
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
                slot: EquipableItemSlot.body,
                type: widget.type,
                requirements: requirements,
                protection: int.parse(protectionController.text),
                penalty: -int.parse(penaltyController.text),
                supportsMetal: supportsMetal,
                special: special,
              );

              Navigator.of(context).pop(armor);
            }
            else {
              widget.armor!.name = nameController.text;
              widget.armor!.unique = unique;
              widget.armor!.description = descriptionController.text;
              widget.armor!.weight = double.parse(weightController.text);
              widget.armor!.creationDifficulty = int.parse(dcController.text);
              widget.armor!.creationTime = int.parse(tcController.text);
              widget.armor!.villageAvailability = EquipmentAvailability(
                  scarcity: villageScarcity!,
                  price: villagePrice!
              );
              widget.armor!.cityAvailability = EquipmentAvailability(
                scarcity: cityScarcity!,
                price: cityPrice!,
              );
              widget.armor!.requirements = requirements;
              widget.armor!.protection = int.parse(protectionController.text);
              widget.armor!.penalty = -int.parse(penaltyController.text);
              widget.armor!.supportsMetal = supportsMetal;
              widget.armor!.special = special;

              Navigator.of(context).pop(widget.armor!);
            }
          },
        )
      ],
    );
  }
}