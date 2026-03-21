import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../../../classes/equipment/enums.dart';
import '../../../classes/equipment/jewel.dart';
import '../../../classes/equipment/equipment.dart';
import '../../../classes/object_source.dart';
import 'scarcity_edit_widget.dart';
import 'special_capabilities_edit_widget.dart';

class JewelEditDialog extends StatefulWidget {
  const JewelEditDialog({
    super.key,
    required this.type,
    this.jewel,
  });

  final EquipableItemSlot type;
  final JewelModel? jewel;

  @override
  State<JewelEditDialog> createState() => _JewelEditDialogState();
}

class _JewelEditDialogState extends State<JewelEditDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  bool unique = false;
  TextEditingController weightController = TextEditingController();
  TextEditingController dcController = TextEditingController();
  TextEditingController tcController = TextEditingController();
  bool supportsMetal = true;
  EquipmentScarcity? villageScarcity;
  int? villagePrice;
  EquipmentScarcity? cityScarcity;
  int? cityPrice;
  EquipableItemLayer layer = EquipableItemLayer.normal;
  TextEditingController descriptionController = TextEditingController();
  EquipmentQuality? intrinsicResistance;
  List<EquipmentSpecialCapability> special = <EquipmentSpecialCapability>[];

  @override
  void initState() {
    super.initState();

    if(widget.jewel != null) {
      nameController.text = widget.jewel!.name;
      unique = widget.jewel!.unique;
      weightController.text = widget.jewel!.weight.toStringAsFixed(2);
      dcController.text = widget.jewel!.creationDifficulty.toString();
      tcController.text = widget.jewel!.creationTime.toString();
      villageScarcity = widget.jewel!.villageAvailability.scarcity;
      villagePrice = widget.jewel!.villageAvailability.price;
      cityScarcity = widget.jewel!.cityAvailability.scarcity;
      cityPrice = widget.jewel!.cityAvailability.price;
      supportsMetal = widget.jewel!.supportsMetal;
      layer = widget.jewel!.layer;
      descriptionController.text = widget.jewel!.description;
      intrinsicResistance = widget.jewel!.intrinsicResistance;
      special = List.from(widget.jewel!.special);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text("Éditer le bijou"),
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
                  Row(
                    spacing: 8.0,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: EquipmentSpecialCapabilitiesEditWidget(
                          special: special,
                          onChanged: (List<EquipmentSpecialCapability> c) {
                            special = c;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: DropdownMenuFormField<EquipableItemLayer>(
                          initialSelection: layer,
                          requestFocusOnTap: true,
                          label: const Text('Couche'),
                          inputDecorationTheme: const InputDecorationTheme(
                            border: OutlineInputBorder(),
                          ),
                          expandedInsets: EdgeInsets.zero,
                          dropdownMenuEntries: EquipableItemLayer.values
                              .map((EquipableItemLayer l) => DropdownMenuEntry(value: l, label: l.title))
                              .toList(),
                          validator: (EquipableItemLayer? l) {
                            if(l == null) return 'Valeur manquante';
                            return null;
                          },
                          onSelected: (EquipableItemLayer? l) {
                            if(l == null) return;
                            layer = l;
                          },
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
      actions: [
        TextButton(
          child: const Text('Annuler'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: const Text('OK'),
          onPressed: () async {
            if(!formKey.currentState!.validate()) return;

            if(widget.jewel == null) {
              var jewel = JewelModel(
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
                slot: widget.type,
                layer: layer,
                supportsMetal: supportsMetal,
                intrinsicResistance: intrinsicResistance,
                special: special,
              );

              Navigator.of(context).pop(jewel);
            }
            else {
              widget.jewel!.name = nameController.text;
              widget.jewel!.unique = unique;
              widget.jewel!.description = descriptionController.text;
              widget.jewel!.weight = double.parse(weightController.text);
              widget.jewel!.creationDifficulty = int.parse(dcController.text);
              widget.jewel!.creationTime = int.parse(tcController.text);
              widget.jewel!.villageAvailability = EquipmentAvailability(
                scarcity: villageScarcity!,
                price: villagePrice!
              );
              widget.jewel!.cityAvailability = EquipmentAvailability(
                scarcity: cityScarcity!,
                price: cityPrice!,
              );
              widget.jewel!.layer = layer;
              widget.jewel!.supportsMetal = supportsMetal;
              widget.jewel!.intrinsicResistance = intrinsicResistance;
              widget.jewel!.special = special;

              Navigator.of(context).pop(widget.jewel!);
            }
          },
        )
      ],
    );
  }
}