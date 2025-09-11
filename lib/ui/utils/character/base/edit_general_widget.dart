import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../classes/calendar.dart';
import '../../../../classes/human_character.dart';
import '../../../../classes/object_location.dart';
import '../../../../classes/place.dart';
import '../../../../classes/player_character.dart';
import '../../widget_group_container.dart';

class CharacterEditGeneralWidget extends StatefulWidget {
  const CharacterEditGeneralWidget({
    super.key,
    required this.character,
  });

  final HumanCharacter character;

  @override
  State<CharacterEditGeneralWidget> createState() => _CharacterEditGeneralWidgetState();
}

class _CharacterEditGeneralWidgetState extends State<CharacterEditGeneralWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController playerController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController augureController = TextEditingController();
  final TextEditingController originController = TextEditingController();

  @override
  void initState() {
    super.initState();

    nameController.text = widget.character.name;
    if(widget.character is PlayerCharacter) {
      playerController.text = (widget.character as PlayerCharacter).player;
    }
    ageController.text = widget.character.age.toString();
    heightController.text = widget.character.height.toStringAsFixed(2);
    weightController.text = widget.character.weight.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Général',
        style: theme.textTheme.bodyMedium!.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 12.0,
        children: [
          if(widget.character is PlayerCharacter)
            Row(
              spacing: 12.0,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: playerController,
                    decoration: const InputDecoration(
                      label: Text('Joueur'),
                      border: OutlineInputBorder(),
                      isCollapsed: true,
                      contentPadding: EdgeInsets.all(12.0),
                      // error: null,
                      // errorText: null,
                    ),
                    style: theme.textTheme.bodySmall,
                    validator: (String? value) {
                      if(value == null || value.isEmpty) {
                        return 'Valeur manquante';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (String? value) => widget.character.name = nameController.text,
                  ),
                ),
                Expanded(
                  child: DropdownMenuFormField<Augure>(
                    controller: augureController,
                    enabled: false,
                    initialSelection: (widget.character as PlayerCharacter).augure,
                    requestFocusOnTap: true,
                    label: const Text('Augure'),
                    expandedInsets: EdgeInsets.zero,
                    textStyle: theme.textTheme.bodySmall,
                    inputDecorationTheme: const InputDecorationTheme(
                      border: OutlineInputBorder(),
                      isCollapsed: true,
                      constraints: BoxConstraints(maxHeight: 36.0),
                      contentPadding: EdgeInsets.all(12.0),
                    ),
                    dropdownMenuEntries: Augure.values
                        .map(
                            (Augure augure) => DropdownMenuEntry<Augure>(
                            value: augure,
                            label: augure.title
                        )
                    )
                        .toList(),
                    validator: (Augure? augure) {
                      if(augure == null) {
                        return 'Valeur manquante';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSelected: (Augure? augure) {
                      if(augure == null) return;
                      // If at some point I decide that the augure can be changed
                      //(widget.character as PlayerCharacter).augure = augure;
                    },
                  ),
                ),
              ],
            ),
          Row(
            spacing: 12.0,
            children: [
              Expanded(
                child: TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    label: Text('Nom'),
                    border: OutlineInputBorder(),
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(12.0),
                  ),
                  style: theme.textTheme.bodySmall,
                  validator: (String? value) {
                    if(value == null || value.isEmpty) {
                      return 'Valeur manquante';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (String? value) => widget.character.name = nameController.text,
                ),
              ),
              Expanded(
                child: DropdownMenuFormField<Place>(
                  controller: originController,
                  initialSelection: widget.character.origin,
                  requestFocusOnTap: true,
                  label: const Text("Pays d'origine"),
                  expandedInsets: EdgeInsets.zero,
                  textStyle: theme.textTheme.bodySmall,
                  inputDecorationTheme: const InputDecorationTheme(
                    border: OutlineInputBorder(),
                    isCollapsed: true,
                    constraints: BoxConstraints(maxHeight: 36.0),
                    contentPadding: EdgeInsets.all(12.0),
                  ),
                  dropdownMenuEntries: Place.withParent('kor')
                    .where((Place p) => p.location.type == ObjectLocationType.assets)
                    .map((Place p) => DropdownMenuEntry(value: p, label: p.name))
                    .toList(),
                  validator: (Place? place) {
                    if(place == null) {
                      return 'Valeur manquante';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onSelected: (Place? place) {
                    if(place == null) return;
                    widget.character.origin = place;
                  },
                ),
              ),
            ],
          ),
          Row(
            spacing: 8.0,
            children: [
              Expanded(
                child: TextFormField(
                  controller: ageController,
                  decoration: const InputDecoration(
                    label: Text('Âge'),
                    border: OutlineInputBorder(),
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(12.0),
                    // error: null,
                    // errorText: null,
                  ),
                  style: theme.textTheme.bodySmall,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (String? value) {
                    if(value == null || value.isEmpty) return 'Valeur manquante';
                    int? input = int.tryParse(value);
                    if(input == null) return 'Pas un nombre';
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (String? value) => widget.character.age = int.parse(value!),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: heightController,
                  decoration: const InputDecoration(
                    label: Text('Taille (m)'),
                    border: OutlineInputBorder(),
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(12.0),
                    // error: null,
                    // errorText: null,
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
                  onChanged: (String? value) => widget.character.height = double.parse(value!),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: weightController,
                  decoration: const InputDecoration(
                    label: Text('Poids (kg)'),
                    border: OutlineInputBorder(),
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(12.0),
                    // error: null,
                    // errorText: null,
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
                  onChanged: (String? value) => widget.character.weight = double.parse(value!),
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}