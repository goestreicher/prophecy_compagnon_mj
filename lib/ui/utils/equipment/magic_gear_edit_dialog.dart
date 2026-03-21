import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../../../classes/equipment/enums.dart';
import '../../../classes/equipment/equipment.dart';
import '../../../classes/equipment/magic_gear.dart';
import '../../../classes/object_source.dart';
import 'scarcity_edit_widget.dart';
import 'special_capabilities_edit_widget.dart';

class MagicGearEditDialog extends StatefulWidget {
  const MagicGearEditDialog({ super.key, this.item });

  final MagicGearModel? item;

  @override
  State<MagicGearEditDialog> createState() => _MagicGearEditDialogState();
}

class _MagicGearEditDialogState extends State<MagicGearEditDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  bool unique = true;
  TextEditingController weightController = TextEditingController();
  TextEditingController dcController = TextEditingController();
  TextEditingController tcController = TextEditingController();
  EquipmentScarcity? villageScarcity;
  int? villagePrice;
  EquipmentScarcity? cityScarcity;
  int? cityPrice;
  bool supportsMetal = false;
  TextEditingController descriptionController = TextEditingController();
  EquipmentQuality? intrinsicResistance;
  List<EquipmentSpecialCapability> special = <EquipmentSpecialCapability>[];

  @override
  void initState() {
    super.initState();

    if(widget.item != null) {
      nameController.text = widget.item!.name;
      unique = widget.item!.unique;
      weightController.text = widget.item!.weight.toStringAsFixed(2);
      dcController.text = widget.item!.creationDifficulty.toString();
      tcController.text = widget.item!.creationTime.toString();
      villageScarcity = widget.item!.villageAvailability.scarcity;
      villagePrice = widget.item!.villageAvailability.price;
      cityScarcity = widget.item!.cityAvailability.scarcity;
      cityPrice = widget.item!.cityAvailability.price;
      supportsMetal = widget.item!.supportsMetal;
      descriptionController.text = widget.item!.description;
      intrinsicResistance = widget.item!.intrinsicResistance;
      special = widget.item!.special;
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text("Éditer l'objet"),
      content: SizedBox(
        width: 800,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
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
                            if(v) {
                              dcController.text = 0.toString();
                              tcController.text = 0.toString();
                              villageScarcity = EquipmentScarcity.introuvable;
                              villagePrice = 0;
                              cityScarcity = EquipmentScarcity.introuvable;
                              cityPrice = 0;
                            }
                            else {
                              dcController.clear();
                              tcController.clear();
                              villageScarcity = null;
                              villagePrice = null;
                              cityScarcity = null;
                              cityPrice = null;
                              intrinsicResistance = null;
                            }
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
                        child: TextFormField(
                          controller: weightController,
                          decoration: InputDecoration(
                            labelText: 'Poids',
                            suffixText: 'kg',
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
                    ],
                  ),
                  Row(
                    spacing: 12.0,
                    children: [
                      Expanded(
                        child: TextFormField(
                          enabled: !unique,
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
                          enabled: !unique,
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
                      if(!unique)
                        SizedBox(
                          width: 220,
                          child: Row(
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
                              Expanded(
                                child: Text(
                                  'Peut être fabriqué avec différents métaux',
                                  style: theme.textTheme.bodySmall,
                                  softWrap: true,
                                ),
                              )
                            ],
                          ),
                        ),
                      if(unique)
                        Expanded(
                          child:
                          DropdownMenuFormField<EquipmentQuality>(
                            initialSelection: intrinsicResistance,
                            requestFocusOnTap: true,
                            label: const Text('Résistance'),
                            inputDecorationTheme: const InputDecorationTheme(
                              border: OutlineInputBorder(),
                            ),
                            expandedInsets: EdgeInsets.zero,
                            dropdownMenuEntries: EquipmentQuality.values
                                .map((EquipmentQuality s) => DropdownMenuEntry(value: s, label: s.title))
                                .toList(),
                            validator: (EquipmentQuality? s) {
                              if(s == null) return 'Valeur manquante';
                              return null;
                            },
                            onSelected: (EquipmentQuality? s) {
                              if(s == null) return;
                              intrinsicResistance = s;
                            },
                          ),
                        )
                    ],
                  ),
                  if(!unique)
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

            if(widget.item == null) {
              var shield = MagicGearModel(
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
                intrinsicResistance: intrinsicResistance,
                special: special,
              );

              Navigator.of(context).pop(shield);
            }
            else {
              widget.item!.name = nameController.text;
              widget.item!.unique = unique;
              widget.item!.description = descriptionController.text;
              widget.item!.weight = double.parse(weightController.text);
              widget.item!.creationDifficulty = int.parse(dcController.text);
              widget.item!.creationTime = int.parse(tcController.text);
              widget.item!.villageAvailability = EquipmentAvailability(
                scarcity: villageScarcity!,
                price: villagePrice!
              );
              widget.item!.cityAvailability = EquipmentAvailability(
                scarcity: cityScarcity!,
                price: cityPrice!,
              );
              widget.item!.intrinsicResistance = intrinsicResistance;
              widget.item!.special = special;

              Navigator.of(context).pop(widget.item!);
            }
          },
        )
      ],
    );
  }
}