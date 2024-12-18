import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../classes/calendar.dart';
import '../../classes/character/injury.dart';
import '../../classes/human_character.dart';
import '../../classes/player_character.dart';
import '../../classes/character/base.dart';
import '../utils/ability_list_edit_widget.dart';
import '../utils/attribute_list_edit_widget.dart';
import '../utils/character_digit_input_widget.dart';
import '../utils/advantage_picker_dialog.dart';
import '../utils/caste_privilege_picker_dialog.dart';
import '../utils/disadvantage_picker_dialog.dart';
import '../utils/illustration_edit_widget.dart';
import '../utils/interdict_picker_dialog.dart';
import '../utils/tendencies_edit_widget.dart';

class EditBaseTab extends StatefulWidget {
  const EditBaseTab({ super.key, required this.character });

  final PlayerCharacter character;

  @override
  State<EditBaseTab> createState() => _EditBaseTabState();
}

class _EditBaseTabState extends State<EditBaseTab> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 400,
                    maxWidth: 500,
                  ),
                  child: Column(
                    children: [
                      _GeneralInformationEditWidget(
                        character: widget.character,
                      ),
                      const SizedBox(height: 16.0),
                      _CasteEditWidget(
                        character: widget.character
                      ),
                      const SizedBox(height: 16.0),
                      _DisadvantagesEditWidget(
                        character: widget.character
                      ),
                      const SizedBox(height: 16.0),
                      _AdvantagesEditWidget(
                          character: widget.character
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24.0),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 400,
                    maxWidth: 500,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _AbilitiesEditWidget(
                              character: widget.character,
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Expanded(
                            flex: 1,
                            child: _AttributesEditWidget(
                              character: widget.character,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      _SecondaryAttributesEditWidget(
                          character: widget.character
                      ),
                      const SizedBox(height: 16.0),
                      _TendenciesEditWidget(
                        character: widget.character,
                      ),
                      const SizedBox(height: 16.0),
                      _InjuriesEditWidget(
                        character: widget.character,
                      ),
                      const SizedBox(height: 16.0),
                      _IllustrationEditWidget(
                        character: widget.character
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}

class _GeneralInformationEditWidget extends StatefulWidget {
  const _GeneralInformationEditWidget({ required this.character });

  final PlayerCharacter character;

  @override
  State<_GeneralInformationEditWidget> createState() => _GeneralInformationEditWidgetState();
}

class _GeneralInformationEditWidgetState extends State<_GeneralInformationEditWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _playerController = TextEditingController();
  final TextEditingController _augureController = TextEditingController();
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.character.name;
    _ageController.text = widget.character.age.toString();
    _heightController.text = widget.character.height.toStringAsFixed(2);
    _weightController.text = widget.character.weight.toStringAsFixed(2);
    _playerController.text = widget.character.player;
    _descriptionController.text = widget.character.description;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
          margin: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        label: Text('Nom'),
                        border: OutlineInputBorder(),
                        isCollapsed: true,
                        contentPadding: EdgeInsets.all(12.0),
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (String? value) {
                        widget.character.name = _nameController.text;
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _playerController,
                      decoration: const InputDecoration(
                        label: Text('Joueur'),
                        border: OutlineInputBorder(),
                        isCollapsed: true,
                        contentPadding: EdgeInsets.all(12.0),
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (String? value) {
                        widget.character.player = _playerController.text;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(
                        label: Text('Âge'),
                        border: OutlineInputBorder(),
                        isCollapsed: true,
                        contentPadding: EdgeInsets.all(12.0),
                        error: null,
                        errorText: null,
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
                      onChanged: (String? value) {
                        if(value == null) return;

                        var v = int.tryParse(value);
                        if(v == null) return;

                        widget.character.age = v;
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextFormField(
                      controller: _heightController,
                      decoration: const InputDecoration(
                        label: Text('Taille (m)'),
                        border: OutlineInputBorder(),
                        isCollapsed: true,
                        contentPadding: EdgeInsets.all(12.0),
                        error: null,
                        errorText: null,
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
                      onChanged: (String? value) {
                        if(value == null) return;

                        var v = double.tryParse(value);
                        if(v == null) return;

                        widget.character.height = v;
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      decoration: const InputDecoration(
                        label: Text('Poids (kg)'),
                        border: OutlineInputBorder(),
                        isCollapsed: true,
                        contentPadding: EdgeInsets.all(12.0),
                        error: null,
                        errorText: null,
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
                      onChanged: (String? value) {
                        if(value == null) return;

                        var v = double.tryParse(value);
                        if(v == null) return;

                        widget.character.weight = v;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  DropdownMenu<Augure>(
                    enabled: false,
                    controller: _augureController,
                    requestFocusOnTap: true,
                    label: const Text('Augure'),
                    textStyle: theme.textTheme.bodySmall,
                    inputDecorationTheme: const InputDecorationTheme(
                      border: OutlineInputBorder(),
                      isCollapsed: true,
                      constraints: BoxConstraints(maxHeight: 36.0),
                      contentPadding: EdgeInsets.all(12.0),
                    ),
                    initialSelection: widget.character.augure,
                    dropdownMenuEntries: Augure.values
                        .map((Augure augure) => DropdownMenuEntry<Augure>(
                              value: augure,
                              label: augure.title
                          ))
                        .toList(),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: DropdownMenu<OriginCountry>(
                      controller: _originController,
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
                      initialSelection: widget.character.origin,
                      onSelected: (OriginCountry? country) {
                        if(country == null) return;
                        setState(() {
                          widget.character.origin = country;
                        });
                      },
                      dropdownMenuEntries:
                        OriginCountry.values.map<DropdownMenuEntry<OriginCountry>>((OriginCountry country) {
                          return DropdownMenuEntry<OriginCountry>(
                            value: country,
                            label: country.title
                          );
                        }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                minLines: 5,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Description / Background'),
                ),
                style: theme.textTheme.bodySmall,
                onChanged: (String? value) {
                  widget.character.description = value ?? '';
                }
              )
            ],
          ),
        ),
        Positioned(
          top: 3,
          left: 8,
          child: Container(
            color: theme.colorScheme.surfaceBright,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Général',
              style: theme.textTheme.bodyMedium!.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              )
            )
          )
        )
      ],
    );
  }
}

class _AbilitiesEditWidget extends StatelessWidget {
  const _AbilitiesEditWidget({ required this.character });

  final PlayerCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
          margin: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: AbilityListEditWidget(
            abilities: character.abilities,
            minValue: 1,
            maxValue: 15,
            onAbilityChanged: (Ability ability, int value) {
              character.setAbility(ability, value);
            },
          ),
        ),
        Positioned(
            top: 3,
            left: 8,
            child: Container(
                color: theme.colorScheme.surfaceBright,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                    'Caractéristiques',
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    )
                )
            )
        )
      ],
    );
  }
}

class _AttributesEditWidget extends StatelessWidget {
  const _AttributesEditWidget({ required this.character });

  final PlayerCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
          margin: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: AttributeListEditWidget(
            attributes: character.attributes,
            onAttributeChanged: (Attribute attribute, int value) {
              character.setAttribute(attribute, value);
            },
          )
        ),
        Positioned(
          top: 3,
          left: 8,
          child: Container(
              color: theme.colorScheme.surfaceBright,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                  'Attributs',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  )
              )
          )
        ),
      ],
    );
  }
}

class _SecondaryAttributesEditWidget extends StatefulWidget {
  const _SecondaryAttributesEditWidget({ required this.character });

  final PlayerCharacter character;

  @override
  State<_SecondaryAttributesEditWidget> createState() => _SecondaryAttributesEditWidgetState();
}

class _SecondaryAttributesEditWidgetState extends State<_SecondaryAttributesEditWidget> {
  final TextEditingController _initiativeController = TextEditingController();
  final TextEditingController _luckController = TextEditingController();
  final TextEditingController _proficiencyController = TextEditingController();
  final TextEditingController _renownController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initiativeController.text = widget.character.initiative.toString();
    _luckController.text = widget.character.luck.toString();
    _proficiencyController.text = widget.character.proficiency.toString();
    _renownController.text = widget.character.renown.toString();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Stack(
      children: [
        Container(
            padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
            margin: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: CharacterDigitInputWidget(
                    initialValue: widget.character.initiative,
                    maxValue: 6,
                    onChanged: (int value) {
                      widget.character.initiative = value;
                    },
                    label: 'INItiative',
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: CharacterDigitInputWidget(
                    initialValue: widget.character.luck,
                    minValue: 0,
                    maxValue: 5,
                    onChanged: (int value) {
                      widget.character.luck = value;
                    },
                    label: 'CHAnce',
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: CharacterDigitInputWidget(
                    initialValue: widget.character.proficiency,
                    minValue: 0,
                    maxValue: 5,
                    onChanged: (int value) {
                      widget.character.proficiency = value;
                    },
                    label: 'MAÎtrise',
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: CharacterDigitInputWidget(
                    initialValue: widget.character.renown,
                    minValue: 0,
                    maxValue: 10,
                    onChanged: (int value) {
                      widget.character.renown = value;
                    },
                    label: 'Renommée',
                  ),
                ),
              ],
            )
        ),
        Positioned(
          top: 3,
          left: 8,
          child: Container(
            color: theme.colorScheme.surfaceBright,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Attributs secondaires',
              style: theme.textTheme.bodyMedium!.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              )
            )
          )
        ),
      ],
    );
  }
}

class _CasteEditWidget extends StatefulWidget {
  const _CasteEditWidget({ required this.character });

  final PlayerCharacter character;

  @override
  State<_CasteEditWidget> createState() => _CasteEditWidgetState();
}

class _CasteEditWidgetState extends State<_CasteEditWidget> {
  final TextEditingController _casteController = TextEditingController();
  final TextEditingController _casteStatusController = TextEditingController();
  final TextEditingController _careerController = TextEditingController();
  final Map<CasteStatus, String> _casteStatusLabels = <CasteStatus, String>{};

  void _updateCasteStatusLabels() {
    _casteStatusLabels.clear();
    if(widget.character.caste == Caste.sansCaste) {
      _casteStatusLabels[CasteStatus.none] = Caste.statusName(Caste.sansCaste, CasteStatus.none);
    }
    else {
      for(var status in CasteStatus.values) {
        _casteStatusLabels[status] = Caste.statusName(widget.character.caste, status);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _updateCasteStatusLabels();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
          margin: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownMenu<Caste>(
                      controller: _casteController,
                      requestFocusOnTap: true,
                      label: const Text('Caste'),
                      expandedInsets: EdgeInsets.zero,
                      textStyle: theme.textTheme.bodySmall,
                      inputDecorationTheme: const InputDecorationTheme(
                        border: OutlineInputBorder(),
                        isCollapsed: true,
                        constraints: BoxConstraints(maxHeight: 36.0),
                        contentPadding: EdgeInsets.all(12.0),
                      ),
                      initialSelection: widget.character.caste,
                      onSelected: (Caste? caste) {
                        if(caste == null) return;
                        setState(() {
                          widget.character.caste = caste;
                          widget.character.interdicts.clear();
                          widget.character.castePrivileges.clear();
                          widget.character.career = null;
                          _updateCasteStatusLabels();
                          _casteStatusController.text = Caste.statusName(caste, widget.character.casteStatus);
                          _careerController.clear();
                        });
                      },
                      dropdownMenuEntries:
                        Caste.values.map<DropdownMenuEntry<Caste>>((Caste caste) {
                          return DropdownMenuEntry<Caste>(
                            value: caste,
                            label: caste.title,
                          );
                        }).toList(),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: DropdownMenu(
                      controller: _casteStatusController,
                      requestFocusOnTap: true,
                      label: const Text('Statut'),
                      expandedInsets: EdgeInsets.zero,
                      textStyle: theme.textTheme.bodySmall,
                      inputDecorationTheme: const InputDecorationTheme(
                        border: OutlineInputBorder(),
                        isCollapsed: true,
                        constraints: BoxConstraints(maxHeight: 36.0),
                        contentPadding: EdgeInsets.all(12.0),
                      ),
                      initialSelection: widget.character.casteStatus,
                      onSelected: (CasteStatus? status) {
                        if(status == null) return;
                        setState(() {
                          widget.character.casteStatus = status;
                        });
                      },
                      dropdownMenuEntries:
                        _casteStatusLabels.keys.map<DropdownMenuEntry<CasteStatus>>((CasteStatus status) {
                          return DropdownMenuEntry<CasteStatus>(
                            value: status,
                            label: _casteStatusLabels[status]!,
                          );
                        }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              _InterdictEditWidget(character: widget.character),
              const SizedBox(height: 16.0),
              _CastePrivilegeEditWidget(character: widget.character),
              const SizedBox(height: 16.0),
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
                    margin: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(Caste.benefits(widget.character.caste, widget.character.casteStatus).isEmpty)
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Pas de bénéfices',
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        for(var b in Caste.benefits(widget.character.caste, widget.character.casteStatus))
                          SizedBox(
                            width: double.infinity,
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 2.0),
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(
                                b,
                                style: theme.textTheme.bodySmall,
                                softWrap: true,
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 3,
                    left: 8,
                    child: Container(
                      color: theme.colorScheme.surfaceBright,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Bénéfices',
                        style: theme.textTheme.bodySmall!.copyWith(
                          color: Colors.black87,
                        )
                      )
                    )
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
                    margin: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(Caste.techniques(widget.character.caste, widget.character.casteStatus).isEmpty)
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Pas de techniques',
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        for(var t in Caste.techniques(widget.character.caste, widget.character.casteStatus))
                          SizedBox(
                            width: double.infinity,
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 2.0),
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(
                                t,
                                style: theme.textTheme.bodySmall,
                                softWrap: true,
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                  Positioned(
                      top: 3,
                      left: 8,
                      child: Container(
                          color: theme.colorScheme.surfaceBright,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                              'Techniques',
                              style: theme.textTheme.bodySmall!.copyWith(
                                color: Colors.black87,
                              )
                          )
                      )
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
                    margin: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownMenu(
                          controller: _careerController,
                          enabled: widget.character.casteStatus.index > 1,
                          requestFocusOnTap: true,
                          expandedInsets: EdgeInsets.zero,
                          textStyle: theme.textTheme.bodySmall,
                          inputDecorationTheme: const InputDecorationTheme(
                            border: OutlineInputBorder(),
                            isCollapsed: true,
                            constraints: BoxConstraints(maxHeight: 36.0),
                            contentPadding: EdgeInsets.all(12.0),
                          ),
                          initialSelection: widget.character.career,
                          onSelected: (Career? career) {
                            if(career == null) return;
                            setState(() {
                              widget.character.career = career;
                            });
                          },
                          leadingIcon: InkWell(
                            onTap: widget.character.career == null ? null : () {
                              setState(() {
                                widget.character.career = null;
                                _careerController.clear();
                              });
                            },
                            child: Opacity(
                              opacity: widget.character.career == null ? 0.4 : 1.0,
                              child: const Icon(
                                Icons.cancel,
                                size: 16.0,
                              ),
                            )
                          ),
                          dropdownMenuEntries: Career.values
                            .where((Career c) => c.caste == widget.character.caste)
                            .map((Career c) => DropdownMenuEntry(value: c, label: c.title))
                            .toList(),
                        ),
                        const SizedBox(height: 12.0),
                        RichText(
                          text: TextSpan(
                            text: 'Interdit : ',
                            style: theme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: widget.character.career?.interdict ?? "Aucun",
                                style: const TextStyle(fontWeight: FontWeight.normal),
                              )
                            ]
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        RichText(
                          text: TextSpan(
                              text: 'Bénéfice : ',
                              style: theme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text: widget.character.career?.benefit ?? "Aucun",
                                  style: const TextStyle(fontWeight: FontWeight.normal),
                                )
                              ]
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      top: 3,
                      left: 8,
                      child: Container(
                          color: theme.colorScheme.surfaceBright,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                              'Carrière',
                              style: theme.textTheme.bodySmall!.copyWith(
                                color: Colors.black87,
                              )
                          )
                      )
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 3,
          left: 8,
          child: Container(
            color: theme.colorScheme.surfaceBright,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Caste',
              style: theme.textTheme.bodyMedium!.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              )
            )
          )
        ),
      ]
    );
  }
}

class _InterdictEditWidget extends StatefulWidget {
  const _InterdictEditWidget({ required this.character });

  final PlayerCharacter character;

  @override
  State<_InterdictEditWidget> createState() => _InterdictEditWidgetState();
}

class _InterdictEditWidgetState extends State<_InterdictEditWidget> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
          margin: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for(var i in widget.character.interdicts)
                Card(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        IconButton(
                          style: IconButton.styleFrom(
                            iconSize: 16.0,
                          ),
                          onPressed: () {
                            setState(() {
                              widget.character.interdicts.remove(i);
                            });
                          },
                          icon: const Icon(Icons.delete),
                        ),
                        const SizedBox(width: 8.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              i.title,
                              style: theme.textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.bold,
                              )
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ),
              const SizedBox(height: 8.0),
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    textStyle: theme.textTheme.bodySmall,
                  ),
                  onPressed: () async {
                    var result = await showDialog<Interdict>(
                      context: context,
                      builder: (BuildContext context) => InterdictPickerDialog(
                        defaultCaste: widget.character.caste != Caste.sansCaste ?
                        widget.character.caste :
                        null,
                      ),
                    );
                    if(!context.mounted) return;
                    if(result == null) return;
                    setState(() {
                      widget.character.interdicts.add(result);
                    });
                  },
                  child: const Text('Nouvel interdit'),
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: 3,
          left: 8,
          child: Container(
            color: theme.colorScheme.surfaceBright,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Interdits',
              style: theme.textTheme.bodySmall!.copyWith(
                color: Colors.black87,
              )
            )
          )
        ),
      ]
    );
  }
}

class _CastePrivilegeEditWidget extends StatefulWidget {
  const _CastePrivilegeEditWidget({ required this.character });

  final PlayerCharacter character;

  @override
  State<_CastePrivilegeEditWidget> createState() => _CastePrivilegeEditWidgetState();
}

class _CastePrivilegeEditWidgetState extends State<_CastePrivilegeEditWidget> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
            margin: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for(var p in widget.character.castePrivileges)
                  Card(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          IconButton(
                            style: IconButton.styleFrom(
                              iconSize: 16.0,
                            ),
                            onPressed: () {
                              setState(() {
                                widget.character.castePrivileges.remove(p);
                              });
                            },
                            icon: const Icon(Icons.delete),
                          ),
                          const SizedBox(width: 8.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${p.title} (${p.cost})',
                                style: theme.textTheme.bodySmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                )
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ),
                const SizedBox(height: 8.0),
                Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: theme.textTheme.bodySmall,
                    ),
                    onPressed: () async {
                      var result = await showDialog<CastePrivilege>(
                        context: context,
                        builder: (BuildContext context) => CastePrivilegePickerDialog(
                          defaultCaste: widget.character.caste != Caste.sansCaste ?
                          widget.character.caste :
                          null,
                        ),
                      );
                      if(!context.mounted) return;
                      if(result == null) return;
                      setState(() {
                        widget.character.castePrivileges.add(result);
                      });
                    },
                    child: const Text('Nouveau privilège'),
                  ),
                )
              ],
            ),
          ),
          Positioned(
              top: 3,
              left: 8,
              child: Container(
                  color: theme.colorScheme.surfaceBright,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                      'Privilèges',
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: Colors.black87,
                      )
                  )
              )
          ),
        ]
    );
  }
}

class _DisadvantagesEditWidget extends StatefulWidget {
  const _DisadvantagesEditWidget({ required this.character });

  final PlayerCharacter character;

  @override
  State<_DisadvantagesEditWidget> createState() => _DisadvantagesEditWidgetState();
}

class _DisadvantagesEditWidgetState extends State<_DisadvantagesEditWidget> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
          margin: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for(var d in widget.character.disadvantages)
                Card(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        IconButton(
                          style: IconButton.styleFrom(
                            iconSize: 16.0,
                          ),
                          onPressed: () {
                            setState(() {
                              widget.character.disadvantages.remove(d);
                            });
                          },
                          icon: const Icon(Icons.delete),
                        ),
                        const SizedBox(width: 8.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${d.disadvantage.title} (${d.cost})',
                              style: theme.textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.bold,
                              )
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              d.details,
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ),
              const SizedBox(height: 8.0),
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    textStyle: theme.textTheme.bodySmall,
                  ),
                  onPressed: () async {
                    var result = await showDialog<CharacterDisadvantage>(
                      context: context,
                      builder: (BuildContext context) => const DisadvantagePickerDialog(),
                    );
                    if(!context.mounted) return;
                    if(result == null) return;

                    setState(() {
                      widget.character.disadvantages.add(result);
                    });
                  },
                  child: const Text('Nouveau désavantage'),
                ),
              )
            ],
          )
        ),
        Positioned(
            top: 3,
            left: 8,
            child: Container(
                color: theme.colorScheme.surfaceBright,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Désavantages',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  )
                )
            )
        )
      ],
    );
  }
}

class _AdvantagesEditWidget extends StatefulWidget {
  const _AdvantagesEditWidget({ required this.character });

  final PlayerCharacter character;

  @override
  State<_AdvantagesEditWidget> createState() => _AdvantagesEditWidgetState();
}

class _AdvantagesEditWidgetState extends State<_AdvantagesEditWidget> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Stack(
      children: [
        Container(
            padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
            margin: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for(var a in widget.character.advantages)
                  Card(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          IconButton(
                            style: IconButton.styleFrom(
                              iconSize: 16.0,
                            ),
                            onPressed: () {
                              setState(() {
                                widget.character.advantages.remove(a);
                              });
                            },
                            icon: const Icon(Icons.delete),
                          ),
                          const SizedBox(width: 8.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${a.advantage.title} (${a.cost})',
                                  style: theme.textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  )
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                a.details,
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ),
                const SizedBox(height: 8.0),
                Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: theme.textTheme.bodySmall,
                    ),
                    onPressed: () async {
                      var result = await showDialog<CharacterAdvantage>(
                        context: context,
                        builder: (BuildContext context) => const AdvantagePickerDialog(),
                      );
                      if(!context.mounted) return;
                      if(result == null) return;

                      setState(() {
                        widget.character.advantages.add(result);
                      });
                    },
                    child: const Text('Nouvel avantage'),
                  ),
                )
              ],
            )
        ),
        Positioned(
            top: 3,
            left: 8,
            child: Container(
                color: theme.colorScheme.surfaceBright,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                    'Avantages',
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    )
                )
            )
        )
      ],
    );
  }
}

class _TendenciesEditWidget extends StatefulWidget {
  const _TendenciesEditWidget({ required this.character });

  final PlayerCharacter character;

  @override
  State<_TendenciesEditWidget> createState() => _TendenciesEditWidgetState();
}

class _TendenciesEditWidgetState extends State<_TendenciesEditWidget> {
  final TextEditingController _dragonController = TextEditingController();
  final TextEditingController _fatalityController = TextEditingController();
  final TextEditingController _humanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dragonController.text = widget.character.tendencies.dragon.value.toString();
    _fatalityController.text = widget.character.tendencies.fatality.value.toString();
    _humanController.text = widget.character.tendencies.human.value.toString();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: [
            Container(
              width: constraints.maxWidth,
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Center(
                child: TendenciesEditWidget(
                  tendencies: widget.character.tendencies,
                  showCircles: true,
                ),
              ),
            ),
            Positioned(
              top: 3,
              left: 8,
              child: Container(
                color: theme.colorScheme.surfaceBright,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Tendances',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  )
                )
              )
            ),
          ],
        );
      }
    );
  }
}

class _InjuriesEditWidget extends StatefulWidget {
  const _InjuriesEditWidget({ required this.character });

  final PlayerCharacter character;

  @override
  State<_InjuriesEditWidget> createState() => _InjuriesEditWidgetState();
}

class _InjuriesEditWidgetState extends State<_InjuriesEditWidget> {
  void _characterChanged() {
    setState(() {
      // NO-OP
    });
  }

  @override
  void initState() {
    super.initState();
    widget.character.addListener(_characterChanged);
  }

  @override
  void dispose() {
    widget.character.removeListener(_characterChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    List<Widget> levelWidgets = <Widget>[];
    for(var level in widget.character.injuries.levels()) {
      levelWidgets.add(
        _InjuryLevelInputWidget(
          level: level,
          count: widget.character.injuries.count(level),
          increase: () {
            setState(() {
              widget.character.injuries.setDamage(level.start + 1);
            });
          },
          decrease: () {
            setState(() {
              widget.character.injuries.heal(level);
            });
          },
        )
      );
    }

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 8.0),
          margin: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...levelWidgets,
            ],
          )
        ),
        Positioned(
          top: 3,
          left: 8,
          child: Container(
            color: theme.colorScheme.surfaceBright,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Blessures',
              style: theme.textTheme.bodyMedium!.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              )
            )
          )
        ),
      ],
    );
  }
}

class _InjuryLevelInputWidget extends StatelessWidget {
  const _InjuryLevelInputWidget({
    required this.level,
    required this.count,
    required this.increase,
    required this.decrease,
  });

  final InjuryLevel level;
  final int count;
  final void Function() increase;
  final void Function() decrease;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    List<Widget> circles = <Widget>[];
    var colored = 0;

    for(var i = 0; i < level.capacity; ++i) {
      if(colored < count) {
        circles.add(
          Container(
            margin: const EdgeInsets.fromLTRB(1.0, 0.0, 1.0, 0.0),
            width: 12.0,
            height: 12.0,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(6.0),
            ),
          )
        );
        ++colored;
      }
      else {
        circles.add(
          Container(
            margin: const EdgeInsets.fromLTRB(1.0, 0.0, 1.0, 0.0),
            width: 12.0,
            height: 12.0,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceBright,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(6.0),
            ),
          )
        );
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 70.0,
          child: Text(
            level.title,
            style: theme.textTheme.bodySmall,
          ),
        ),
        const SizedBox(width: 8.0),
        IconButton(
          icon: const Icon(Icons.remove),
          style: IconButton.styleFrom(
            minimumSize: const Size.square(28.0),
            maximumSize: const Size.square(28.0),
            iconSize: 12.0,
          ),
          onPressed: () => decrease(),
        ),
        const SizedBox(width: 4.0),
        ...circles,
        const SizedBox(width: 4.0),
        IconButton(
          icon: const Icon(Icons.add),
          style: IconButton.styleFrom(
            minimumSize: const Size.square(28.0),
            maximumSize: const Size.square(28.0),
            iconSize: 12.0,
          ),
          onPressed: () => increase(),
        ),
      ],
    );
  }
}

class _IllustrationEditWidget extends StatelessWidget {
  const _IllustrationEditWidget({ required this.character });

  final PlayerCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 8.0),
          margin: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: IllustrationEditFormField(
            entity: character
          ),
        ),
        Positioned(
          top: 3,
          left: 8,
          child: Container(
            color: theme.colorScheme.surfaceBright,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Illustration',
              style: theme.textTheme.bodyMedium!.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              )
            )
          )
        ),
      ],
    );
  }
}