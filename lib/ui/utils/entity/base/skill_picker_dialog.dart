import 'package:flutter/material.dart';

import '../../../../classes/caste/base.dart';
import '../../../../classes/entity/skill.dart';
import '../../../../classes/entity/skill_family.dart';
import '../../../../classes/entity/skill_instance.dart';
import '../../../../classes/entity/specialized_skill.dart';

class SkillPickerDialog extends StatefulWidget {
  SkillPickerDialog({
    super.key,
    required this.family,
    this.excluded = const <Skill>[],
    this.includeReservedCaste,
  })
    : _skillList = Skill.fromFamily(family, forCaste: includeReservedCaste)
          .where((Skill s) => s.requireConcreteImplementation || !excluded.contains(s)).toList();

  final SkillFamily family;
  final List<Skill> excluded;
  final Caste? includeReservedCaste;
  final List<Skill> _skillList;

  @override
  State<SkillPickerDialog> createState() => _SkillPickerDialogState();
}

class _SkillPickerDialogState extends State<SkillPickerDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController skillController = TextEditingController();
  final TextEditingController implementationController = TextEditingController();
  
  Skill? currentSkill;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Sélectionner la compétence'),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            if(!formKey.currentState!.validate()) return;

            var instance = SkillInstance(
              skill: currentSkill!,
              value: 1,
              implementation: implementationController.text,
            );

            Navigator.of(context).pop(instance);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          child: const Text('OK'),
        )
      ],
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 12.0,
              children: [
                DropdownMenuFormField(
                  controller: skillController,
                  requestFocusOnTap: true,
                  label: const Text('Compétence'),
                  expandedInsets: EdgeInsets.zero,
                  dropdownMenuEntries:
                    widget._skillList
                        .where((Skill s) => s.canInstantiate)
                        .map<DropdownMenuEntry<Skill>>((Skill s) {
                          return DropdownMenuEntry(
                            value: s,
                            label: s.title,
                            leadingIcon: s.reservedCastes.isEmpty
                              ? null
                              : Icon(Icons.lock_outline)
                          );
                        }).toList(),
                  onSelected: (Skill? s) => setState(() => currentSkill = s),
                  validator: (Skill? s) {
                    if(s == null) return 'Valeur obligatoire';
                    return null;
                  },
                ),
                if(currentSkill != null && currentSkill!.requireConcreteImplementation)
                  TextFormField(
                    controller: implementationController,
                    decoration: const InputDecoration(
                      labelText: 'Nom de la compétence',
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if(value == null || value.isEmpty) {
                        return 'Valeur obligatoire';
                      }
                      return null;
                    },
                  ),
                if(currentSkill != null && currentSkill!.description.isNotEmpty)
                  Text(currentSkill!.description),
              ],
            ),
          ),
        ),
      )
    );
  }
}

class SpecializedSkillPickerDialogResult {
  SpecializedSkillPickerDialogResult({
    required this.selectedSkill,
    required this.specializedSkill,
  });

  final SkillInstance selectedSkill;
  final SpecializedSkill specializedSkill;
}

class SpecializedSkillPickerDialog extends StatefulWidget {
  const SpecializedSkillPickerDialog({
    super.key,
    required this.skills,
    this.excluded = const <SpecializedSkill>[],
    this.reservedPrefix,
  });

  @override
  State<SpecializedSkillPickerDialog> createState() => SpecializedSkillPickerDialogState();

  final List<SkillInstance> skills;
  final List<SpecializedSkill> excluded;
  final String? reservedPrefix;
}

class SpecializedSkillPickerDialogState extends State<SpecializedSkillPickerDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _skillController = TextEditingController();
  SkillInstance? _currentSkill;
  final TextEditingController _specializedSkillController = TextEditingController();
  List<SpecializedSkill> _specializedSkills = <SpecializedSkill>[];
  SpecializedSkill? _currentSpecializedSkill;
  bool _reserved = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Sélectionner la spécialisation'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownMenu(
              controller: _skillController,
              requestFocusOnTap: true,
              label: const Text('Compétence'),
              expandedInsets: EdgeInsets.zero,
              dropdownMenuEntries:
                widget.skills.map<DropdownMenuEntry<SkillInstance>>((SkillInstance i) {
                  return DropdownMenuEntry(value: i, label: i.title);
                }).toList(),
              onSelected: (SkillInstance? i) {
                _currentSkill = i;
                setState(() {
                  if(_currentSkill == null) {
                    _specializedSkills.clear();
                    _specializedSkillController.clear();
                  }
                  else {
                    // TODO: for skills that require an implementation,
                    // this will return specializations that don't match
                    // the selected implementation.
                    _specializedSkills = SpecializedSkill
                        .withParent(_currentSkill!.skill)
                        .where((SpecializedSkill s) => !s.reserved)
                        .toList()
                        ..sort((a, b) => a.name.compareTo(b.name));
                  }
                });
              },
            ),
            const SizedBox(height: 12.0),
            DropdownMenu(
              controller: _specializedSkillController,
              requestFocusOnTap: true,
              label: const Text('Spécialisation'),
              expandedInsets: EdgeInsets.zero,
              dropdownMenuEntries:
                _specializedSkills
                    .map((SpecializedSkill s) => DropdownMenuEntry(value: s, label: s.name))
                    .toList(),
              onSelected: (SpecializedSkill? s) {
                _currentSpecializedSkill = s;
              }
            ),
            const SizedBox(height: 12.0),
            SwitchListTile(
              value: _reserved,
              title: const Text('Réservée'),
              secondary: _reserved ?
                const Icon(Icons.lock) :
                const Icon(Icons.lock_open),
              onChanged: widget.reservedPrefix == null ? null : (bool value) {
                setState(() {
                  _reserved = value;
                });
              },
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Annuler'),
                    ),
                    const SizedBox(width: 12.0),
                    ElevatedButton(
                      onPressed: () {
                        if(_currentSkill == null) return;
                        if(_specializedSkillController.text.isEmpty) return;

                        SpecializedSkill skill;
                        if(_currentSpecializedSkill != null) {
                          skill = _currentSpecializedSkill!;
                        }
                        else {
                          skill = SpecializedSkill.create(
                            parent: _currentSkill!.skill,
                            name: _specializedSkillController.text,
                            reserved: _reserved,
                            reservedPrefix: widget.reservedPrefix,
                          );
                        }

                        Navigator.of(context).pop(
                          SpecializedSkillPickerDialogResult(
                            selectedSkill: _currentSkill!,
                            specializedSkill: skill,
                          )
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                      ),
                      child: const Text('OK'),
                    )
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}