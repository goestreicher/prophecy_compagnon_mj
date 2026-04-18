import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../classes/player_character.dart';
import '../../utils/markdown_display_widget.dart';
import 'enums.dart';
import 'finalize.dart';
import 'model.dart';
import 'step_data.dart';

class PlayerCharacterWizardStepDataNames extends PlayerCharacterWizardStepData {
  PlayerCharacterWizardStepDataNames({
    this.characterName,
    this.characterAge,
    this.characterHeight,
    this.characterWeight,
    this.playerName,
    this.privilegedExperience,
  })
    : currentCharacterName = characterName,
      currentCharacterAge = characterAge,
      currentCharacterHeight = characterHeight,
      currentCharacterWeight = characterWeight,
      currentPlayerName = playerName,
      currentPrivilegesExperience = privilegedExperience,
      super(title: 'Finalisation');

  String? characterName;
  String? currentCharacterName;
  int? characterAge;
  int? currentCharacterAge;
  double? characterHeight;
  double? currentCharacterHeight;
  double? characterWeight;
  double? currentCharacterWeight;
  String? playerName;
  String? currentPlayerName;
  PlayerCharacterPrivilegedExperience? privilegedExperience;
  PlayerCharacterPrivilegedExperience? currentPrivilegesExperience;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget overviewWidget(BuildContext context) {
    return SizedBox.shrink();
  }

  @override
  List<Widget> stepWidget(BuildContext context) {
    var theme = Theme.of(context);
    var model = context.read<PlayerCharacterWizardModel>();

    return [
      sliverWrap(
        [
          Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 32.0,
              children: [
                Text(
                  "Voici venue l'étape la plus difficile du processus de création : choisir un nom pour votre nouveau personnage.\nIci vous devez aussi choisir l'optique de progression préférée de votre personnage, qui influera sur son gain de Points d'Expérience.",
                ),
                _NamesWidget(
                  character: currentCharacterName,
                  onCharacterChanged: (String v) {
                    currentCharacterName = v;
                    changed = changed || currentCharacterName != characterName;
                  },
                  age: currentCharacterAge,
                  onAgeChanged: (int v) {
                    currentCharacterAge = v;
                    changed = changed || currentCharacterAge != characterAge;
                  },
                  height: currentCharacterHeight,
                  onHeightChanged: (double v) {
                    currentCharacterHeight = v;
                    changed = changed || currentCharacterHeight != characterHeight;
                  },
                  weight: currentCharacterWeight,
                  onWeightChanged: (double v) {
                    currentCharacterWeight = v;
                    changed = changed || currentCharacterWeight != characterWeight;
                  },
                  player: currentPlayerName,
                  onPlayerChanged: (String v) {
                    currentPlayerName = v;
                    changed = changed || currentPlayerName != playerName;
                  },
                  experience: privilegedExperience,
                  onExperienceChanged: (PlayerCharacterPrivilegedExperience v) {
                    currentPrivilegesExperience = v;
                    changed = changed || currentPrivilegesExperience != privilegedExperience;
                  },
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  onPressed: () async {
                    validateAndDownload(model, context);
                  },
                  label: const Text('Télécharger'),
                  icon: Icon(Icons.download),
                ),
                MarkdownDisplayWidget(
                  data: model.description,
                ),
              ],
            ),
          )
        ]
      )
    ];
  }

  void validateAndDownload(PlayerCharacterWizardModel model, BuildContext context) async {
    if(!validate(model, context)) return;
    save(model);

    var pc = playerCharacterWizardFinalize(model);
    var jsonFull = pc.toJson();
    var jsonStr = json.encode(jsonFull);
    await FilePicker.platform.saveFile(
      fileName: 'pc_${pc.uuid}.json',
      bytes: utf8.encode(jsonStr),
    );
  }

  @override
  bool validate(PlayerCharacterWizardModel model, BuildContext context) =>
      formKey.currentState!.validate();

  @override
  void init(PlayerCharacterWizardModel model) {
  }

  @override
  void reset(PlayerCharacterWizardModel model) {
    characterName = currentCharacterName = null;
    model.characterName = null;

    characterAge = currentCharacterAge = null;
    model.characterAge = 25;

    characterHeight = currentCharacterHeight = null;
    model.characterHeight = 1.7;

    characterWeight = currentCharacterWeight = null;
    model.characterHeight = 60.0;

    playerName = currentPlayerName = null;
    model.playerName = null;

    privilegedExperience = currentPrivilegesExperience = null;
    model.privilegedExperience = null;
  }

  @override
  void clear() {
    currentCharacterName = characterName;
    currentCharacterAge = characterAge;
    currentCharacterHeight = characterHeight;
    currentCharacterWeight = characterWeight;
    currentPlayerName = playerName;
    currentPrivilegesExperience = privilegedExperience;
  }

  @override
  void save(PlayerCharacterWizardModel model) {
    characterName = currentCharacterName;
    model.characterName = currentCharacterName;

    characterAge = currentCharacterAge;
    if(characterAge != null) model.characterAge = characterAge!;

    characterHeight = currentCharacterHeight;
    if(characterHeight != null) model.characterHeight = characterHeight!;

    characterWeight = currentCharacterWeight;
    if(characterWeight != null) model.characterWeight = characterWeight!;

    playerName = currentPlayerName;
    model.playerName = playerName;

    privilegedExperience = currentPrivilegesExperience;
    model.privilegedExperience = privilegedExperience;
  }
}

class _NamesWidget extends StatefulWidget {
  const _NamesWidget({
    this.character,
    required this.onCharacterChanged,
    this.age,
    required this.onAgeChanged,
    this.height,
    required this.onHeightChanged,
    this.weight,
    required this.onWeightChanged,
    this.player,
    required this.onPlayerChanged,
    this.experience,
    required this.onExperienceChanged,
  });

  final String? character;
  final int? age;
  final void Function(int) onAgeChanged;
  final double? height;
  final void Function(double) onHeightChanged;
  final double? weight;
  final void Function(double) onWeightChanged;
  final void Function(String) onCharacterChanged;
  final String? player;
  final void Function(String) onPlayerChanged;
  final PlayerCharacterPrivilegedExperience? experience;
  final void Function(PlayerCharacterPrivilegedExperience) onExperienceChanged;

  @override
  State<_NamesWidget> createState() => _NamesWidgetState();
}

class _NamesWidgetState extends State<_NamesWidget> {
  PlayerCharacterPrivilegedExperience? currentExperience;

  @override
  void initState() {
    super.initState();

    currentExperience = widget.experience;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var model = context.read<PlayerCharacterWizardModel>();
    var labelWidth = 170.0;

    var effectiveAge = widget.age ?? model.characterAge;
    var minAge = 6;
    var maxAge = 99;
    switch(model.age!) {
      case PlayerCharacterWizardAge.enfant:
        minAge = 6;
        maxAge = 10;
      case PlayerCharacterWizardAge.adolescent:
        minAge = 11;
        maxAge = 15;
      case PlayerCharacterWizardAge.adulte:
        minAge = 16;
        maxAge = 40;
      case PlayerCharacterWizardAge.ancien:
        minAge = 41;
        maxAge = 50;
      case PlayerCharacterWizardAge.venerable:
        minAge = 51;
        maxAge = 99;
    }
    if(effectiveAge < minAge) effectiveAge = minAge;
    if(effectiveAge > maxAge) effectiveAge = maxAge;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.0,
      children: [
        Row(
          spacing: 12.0,
          children: [
            SizedBox(
              width: labelWidth,
              child: Text(
                "Nom du personnage",
                style: theme.textTheme.titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 350,
              child: TextFormField(
                initialValue: widget.character,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isCollapsed: true,
                  constraints: BoxConstraints(maxHeight: 36.0),
                  contentPadding: EdgeInsets.all(12.0),
                ),
                onChanged: (String? v) {
                  if(v == null) return;
                  widget.onCharacterChanged(v);
                },
                autovalidateMode: AutovalidateMode.onUserInteractionIfError,
                validator: (String? v) {
                  if(v == null || v.isEmpty) return 'Valeur manquante';
                  return null;
                },
              ),
            )
          ],
        ),
        Row(
          spacing: 12.0,
          children: [
            Text(
              'Âge',
              style: theme.textTheme.titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 96,
              child: TextFormField(
                initialValue: effectiveAge.toString(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(12.0),
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
                  if(input < minAge) return '>= $minAge';
                  if(input > maxAge) return '<= $maxAge';
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteractionIfError,
                onChanged: (String value) => widget.onAgeChanged(int.parse(value)),
              ),
            ),
            Text(
              'Taille (m)',
              style: theme.textTheme.titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 96,
              child: TextFormField(
                initialValue: (widget.height ?? model.characterHeight).toStringAsFixed(2),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(12.0),
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
                autovalidateMode: AutovalidateMode.onUserInteractionIfError,
                onChanged: (String value) => widget.onHeightChanged(double.parse(value)),
              ),
            ),
            Text(
              'Poids (kg)',
              style: theme.textTheme.titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 96,
              child: TextFormField(
                initialValue: (widget.weight ?? model.characterWeight).toStringAsFixed(2),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(12.0),
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
                autovalidateMode: AutovalidateMode.onUserInteractionIfError,
                onChanged: (String value) => widget.onWeightChanged(double.parse(value)),
              ),
            ),
          ],
        ),
        Row(
          spacing: 12.0,
          children: [
            SizedBox(
              width: labelWidth,
              child: Text(
                "Nom du joueur",
                style: theme.textTheme.titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 350,
              child: TextFormField(
                initialValue: widget.player,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isCollapsed: true,
                  constraints: BoxConstraints(maxHeight: 36.0),
                  contentPadding: EdgeInsets.all(12.0),
                ),
                onChanged: (String? v) {
                  if(v == null) return;
                  widget.onPlayerChanged(v);
                },
                autovalidateMode: AutovalidateMode.onUserInteractionIfError,
                validator: (String? v) {
                  if(v == null || v.isEmpty) return 'Valeur manquante';
                  return null;
                },
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12.0,
          children: [
            SizedBox(
              width: labelWidth,
              child: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  "Optique de progression",
                  style: theme.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              width: 350,
              child: DropdownMenuFormField<PlayerCharacterPrivilegedExperience>(
                initialSelection: widget.experience,
                requestFocusOnTap: true,
                expandedInsets: EdgeInsets.zero,
                inputDecorationTheme: const InputDecorationTheme(
                  border: OutlineInputBorder(),
                  isCollapsed: true,
                  constraints: BoxConstraints(maxHeight: 36.0),
                  contentPadding: EdgeInsets.all(12.0),
                ),
                dropdownMenuEntries: PlayerCharacterPrivilegedExperience.values
                  .map(
                    (PlayerCharacterPrivilegedExperience e) =>
                      DropdownMenuEntry(value: e, label: e.title),
                  )
                  .toList(),
                onSelected: (PlayerCharacterPrivilegedExperience? v) {
                  setState(() {
                    currentExperience = v;
                  });
                  if(v == null) return;
                  widget.onExperienceChanged(v);
                },
                autovalidateMode: AutovalidateMode.onUserInteractionIfError,
                validator: (PlayerCharacterPrivilegedExperience? v) {
                  if(v == null) return 'Valeur manquante';
                  return null;
                },
              ),
            ),
            if(currentExperience != null)
              SizedBox(
                width: 450,
                child: Text(currentExperience!.description),
              ),
          ],
        ),
      ],
    );
  }
}