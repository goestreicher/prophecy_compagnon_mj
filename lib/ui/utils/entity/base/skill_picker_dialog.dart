import 'package:flutter/material.dart';
import 'package:prophecy_compagnon_mj/text_utils.dart';

import '../../../../classes/character/base.dart';
import '../../../../classes/character/skill.dart';

class FamilyAndSkillPickerDialog extends StatefulWidget {
  const FamilyAndSkillPickerDialog({
    super.key,
    this.excluded = const <Skill>[],
    this.includeReservedCaste,
  });

  final List<Skill> excluded;
  final Caste? includeReservedCaste;

  @override
  State<FamilyAndSkillPickerDialog> createState() => _FamilyAndSkillPickerDialogState();
}

class _FamilyAndSkillPickerDialogState extends State<FamilyAndSkillPickerDialog> {
  final TextEditingController _familyController = TextEditingController();
  SkillFamily? _currentFamily;
  final TextEditingController _skillController = TextEditingController();
  Skill? _currentSkill;
  final List<Skill> _skillList = <Skill>[];

  void _updateSkillsForCurrentFamily() {
    _skillList.clear();
    if(_currentFamily == null) return;
    _skillList.addAll(
      Skill.fromFamily(_currentFamily!, forCaste: widget.includeReservedCaste)
          .where((Skill s) => !widget.excluded.contains(s) && s.canInstantiate && !s.requireSpecialization)
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
        title: const Text('Sélectionner la compétence'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownMenu(
              controller: _familyController,
              requestFocusOnTap: true,
              label: const Text('Famille'),
              expandedInsets: EdgeInsets.zero,
              dropdownMenuEntries: SkillFamily.values
                  .map((SkillFamily f) => DropdownMenuEntry(value: f, label: f.title))
                  .toList(),
              onSelected: (SkillFamily? family) {
                setState(() {
                  _currentFamily = family;
                  _currentSkill = null;
                  _skillController.text = '';
                });
                _updateSkillsForCurrentFamily();
              },
            ),
            const SizedBox(height: 16.0),
            DropdownMenu(
              controller: _skillController,
              requestFocusOnTap: true,
              label: const Text('Compétence'),
              expandedInsets: EdgeInsets.zero,
              dropdownMenuEntries:
                _skillList
                    .map((Skill s) => DropdownMenuEntry(value: s, label: s.title))
                    .toList(),
              onSelected: (Skill? skill) {
                setState(() {
                  _currentSkill = skill;
                });
              }
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
                        if(_currentFamily == null) return;
                        if(_currentSkill == null) return;
                        Navigator.of(context).pop(_currentSkill);
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
        )
    );
  }
}

class SkillPickerDialog extends StatelessWidget {
  SkillPickerDialog({
    super.key,
    required this.family,
    this.excluded = const <Skill>[],
    this.includeReservedCaste,
  })
    : _skillList = Skill.fromFamily(family, forCaste: includeReservedCaste).where((Skill s) => !excluded.contains(s)).toList();

  final SkillFamily family;
  final List<Skill> excluded;
  final Caste? includeReservedCaste;
  final List<Skill> _skillList;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _skillController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Sélectionner la compétence'),
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
                _skillList
                    .where((Skill s) => s.canInstantiate && !s.requireSpecialization)
                    .map<DropdownMenuEntry<Skill>>((Skill s) {
                      return DropdownMenuEntry(value: s, label: s.title);
                    }).toList(),
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
                      if(_skillController.text.isEmpty) return;
                      Skill? skill = Skill.byTitle(_skillController.text);
                      if(skill == null) return;
                      Navigator.of(context).pop(skill);
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
      )
    );
  }
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

  final List<Skill> skills;
  final List<SpecializedSkill> excluded;
  final String? reservedPrefix;
}

class SpecializedSkillPickerDialogState extends State<SpecializedSkillPickerDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _skillController = TextEditingController();
  Skill? _currentSkill;
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
                widget.skills.map<DropdownMenuEntry<Skill>>((Skill s) {
                  return DropdownMenuEntry(value: s, label: s.title);
                }).toList(),
              onSelected: (Skill? s) {
                _currentSkill = s;
                setState(() {
                  if(_currentSkill == null) {
                    _specializedSkills.clear();
                    _specializedSkillController.clear();
                  }
                  else {
                    _specializedSkills = SpecializedSkill
                        .withParent(_currentSkill!)
                        .where((SpecializedSkill s) => !s.reserved)
                        .toList()
                        ..sort((a, b) => a.title.compareTo(b.title));
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
                    .map((SpecializedSkill s) => DropdownMenuEntry(value: s, label: s.title))
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

                        var standardizedSpecializedSkillName = sentenceToCamelCase(transliterateFrenchToAscii(_specializedSkillController.text));
                        var skillId = '${_currentSkill!.name}:$standardizedSpecializedSkillName';
                        if(widget.reservedPrefix != null && _reserved) {
                          skillId = '${widget.reservedPrefix}:$skillId';
                        }

                        SpecializedSkill skill;
                        if(_currentSpecializedSkill != null) {
                          skill = _currentSpecializedSkill!;
                        }
                        else {
                          skill = SpecializedSkill.create(
                            skillId,
                            _currentSkill!,
                            title: _specializedSkillController.text,
                            reserved: _reserved,
                          );
                        }

                        Navigator.of(context).pop(skill);
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