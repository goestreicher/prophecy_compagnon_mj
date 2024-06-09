import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../classes/entity_base.dart';
import '../../classes/character/skill.dart';
import '../utils/skill_picker_dialog.dart';

class EditSkillsTab extends StatelessWidget {
  const EditSkillsTab({ super.key, required this.character });

  final EntityBase character;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 600,
            maxWidth: 750,
          ),
          child: Container(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SkillFamilyEditWidget(character: character, family: SkillFamily.combat),
                const SizedBox(height: 8.0),
                SkillFamilyEditWidget(character: character, family: SkillFamily.mouvement),
                const SizedBox(height: 8.0),
                SkillFamilyEditWidget(character: character, family: SkillFamily.theorie),
                const SizedBox(height: 8.0),
                SkillFamilyEditWidget(character: character, family: SkillFamily.pratique),
                const SizedBox(height: 8.0),
                SkillFamilyEditWidget(character: character, family: SkillFamily.technique),
                const SizedBox(height: 8.0),
                SkillFamilyEditWidget(character: character, family: SkillFamily.manipulation),
                const SizedBox(height: 8.0),
                SkillFamilyEditWidget(character: character, family: SkillFamily.communication),
                const SizedBox(height: 8.0),
                SkillFamilyEditWidget(character: character, family: SkillFamily.influence),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SkillFamilyEditWidget extends StatefulWidget {
  const SkillFamilyEditWidget({
    super.key,
    required this.character,
    required this.family,
  });

  final EntityBase character;
  final SkillFamily family;

  @override
  State<SkillFamilyEditWidget> createState() => _SkillFamilyEditWidgetState();
}

class _SkillFamilyEditWidgetState extends State<SkillFamilyEditWidget> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Text(
          widget.family.title,
          style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        initiallyExpanded: widget.character.skillsForFamily(widget.family).isNotEmpty,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        childrenPadding: const EdgeInsets.only(bottom: 4.0),
        children: [
          for(var s in widget.character.skillsForFamily(widget.family))
            SkillEditWidget(
              character: widget.character,
              skill: s.skill,
              onDeleteSkill: () {
                setState(() {
                  widget.character.deleteSkill(s.skill);
                });
              },
              onDeleteSpecialization: (SpecializedSkill sp) {
                setState(() {
                  widget.character.deleteSpecializedSkill(sp);
                });
              },
            ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.add,
                  size: 16.0,
                ),
                style: ElevatedButton.styleFrom(
                  textStyle: theme.textTheme.bodySmall,
                ),
                label: const Text('Nouvelle compétence'),
                onPressed: () async {
                  Skill? skill = await showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                      SkillPickerDialog(
                        family: widget.family,
                        excluded: widget.character
                            .skillsForFamily(widget.family)
                            .map((SkillInstance s) => s.skill)
                            .toList(),
                      )
                  );
                  if(skill == null) return;
                  setState(() {
                    widget.character.setSkill(skill, 1);
                  });
                },
              ),
              const SizedBox(width: 12.0),
              ElevatedButton.icon(
                icon: const Icon(
                  Symbols.target,
                  size: 16.0,
                ),
                style: ElevatedButton.styleFrom(
                  textStyle: theme.textTheme.bodySmall,
                ),
                label: const Text('Nouvelle spécialisation'),
                onPressed: () async {
                  SpecializedSkill? skill = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        var characterSkills = widget.character
                            .skillsForFamily(widget.family)
                            .map((SkillInstance s) => s.skill)
                            .toList();
                        return SpecializedSkillPickerDialog(
                          skills: Skill.fromFamily(widget.family)
                              .where((Skill s) => s.requireSpecialization || characterSkills.contains(s))
                              .toList(),
                        );
                      }
                  );
                  if(skill == null) return;
                  setState(() {
                    if(skill.parent.requireSpecialization) {
                      widget.character.setSkill(skill.parent, 0);
                    }
                    widget.character.setSpecializedSkill(skill, widget.character.skill(skill.parent));
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

class SkillEditWidget extends StatelessWidget {
  SkillEditWidget({
    super.key,
    required this.character,
    required this.skill,
    required this.onDeleteSkill,
    required this.onDeleteSpecialization,
  });

  final EntityBase character;
  final Skill skill;
  final void Function() onDeleteSkill;
  final void Function(SpecializedSkill) onDeleteSpecialization;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    _controller.text = character.skill(skill).toString();

    return Padding(
      padding: const EdgeInsets.only(
          left: 32.0,
          top: 4.0,
          bottom: 4.0,
          right: 32.0
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 12.0,
            top: 4.0,
            bottom: 8.0,
            right: 24.0,
          ),
          child: Column(
            children: [
              Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        onDeleteSkill();
                      },
                    ),
                    Text(
                      skill.title,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const Spacer(),
                    if(!skill.requireSpecialization)
                      IconButton(
                        icon: const Icon(Icons.remove),
                        style: IconButton.styleFrom(
                          minimumSize: const Size.square(28.0),
                          maximumSize: const Size.square(28.0),
                          iconSize: 12.0,
                        ),
                        onPressed: () {
                          if(_controller.text.isEmpty) return;
                          int? input = int.tryParse(_controller.text);
                          if(input == null) return;
                          if(input > 1) {
                            character.setSkill(skill, input - 1);
                            _controller.text = (input - 1).toString();
                          }
                        },
                      ),
                    if(!skill.requireSpecialization)
                      SizedBox(
                          width: 32.0,
                          child: TextFormField(
                            controller: _controller,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (String? value) {
                              if(value == null || value.isEmpty) return 'Valeur manquante';
                              int? input = int.tryParse(value);
                              if(input == null) return 'Pas un nombre';
                              if(input < 0) return 'Nombre >= 0';
                              if(input > 30) return 'Vraiment ?';
                              return null;
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            onChanged: (String? value) {
                              if(value == null || value.isEmpty) return;
                              character.setSkill(skill, int.parse(value));
                            },
                            onSaved: (String? value) {
                              if(value == null || value.isEmpty) return;
                              character.setSkill(skill, int.parse(value));
                            },
                          )
                      ),
                    if(!skill.requireSpecialization)
                      IconButton(
                        icon: const Icon(Icons.add),
                        style: IconButton.styleFrom(
                          minimumSize: const Size.square(28.0),
                          maximumSize: const Size.square(28.0),
                          iconSize: 12.0,
                        ),
                        onPressed: () {
                          if(_controller.text.isEmpty) return;
                          int? input = int.tryParse(_controller.text);
                          if(input == null) return;
                          if(input < 30) {
                            character.setSkill(skill, input + 1);
                            _controller.text = (input + 1).toString();
                          }
                        },
                      ),
                    const SizedBox(width: 8.0),
                  ]
              ),
              for(var sp in character.allSpecializedSkills(skill))
                SpecializedSkillEditWidget(
                  character: character,
                  skill: sp,
                  onDelete: () {
                    onDeleteSpecialization(sp);
                  }
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SpecializedSkillEditWidget extends StatelessWidget {
  SpecializedSkillEditWidget({
    super.key,
    required this.character,
    required this.skill,
    required this.onDelete,
  });

  final EntityBase character;
  final SpecializedSkill skill;
  final void Function() onDelete;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    _controller.text = character.specializedSkill(skill).toString();

    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        top: 8.0,
        bottom: 4.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 12.0,
            top: 4.0,
            bottom: 8.0,
          ),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    onDelete();
                  },
                ),
                Text(
                  skill.title,
                  style: theme.textTheme.bodyMedium,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.remove),
                  style: IconButton.styleFrom(
                    minimumSize: const Size.square(28.0),
                    maximumSize: const Size.square(28.0),
                    iconSize: 12.0,
                  ),
                  onPressed: () {
                    if(_controller.text.isEmpty) return;
                    int? input = int.tryParse(_controller.text);
                    if(input == null) return;
                    if(input > 1) {
                      character.setSpecializedSkill(skill, input - 1);
                      _controller.text = (input - 1).toString();
                    }
                  },
                ),
                SizedBox(
                    width: 32.0,
                    child: TextFormField(
                      controller: _controller,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (String? value) {
                        if(value == null || value.isEmpty) return 'Valeur manquante';
                        int? input = int.tryParse(value);
                        if(input == null) return 'Pas un nombre';
                        if(input < 0) return 'Nombre >= 0';
                        if(input > 30) return 'Vraiment ?';
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (String? value) {
                        if(value == null || value.isEmpty) return;
                        character.setSpecializedSkill(skill, int.parse(value));
                      },
                      onSaved: (String? value) {
                        if(value == null || value.isEmpty) return;
                        character.setSpecializedSkill(skill, int.parse(value));
                      },
                    )
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    minimumSize: const Size.square(28.0),
                    maximumSize: const Size.square(28.0),
                    iconSize: 12.0,
                  ),
                  onPressed: () {
                    if(_controller.text.isEmpty) return;
                    int? input = int.tryParse(_controller.text);
                    if(input == null) return;
                    if(input < 30) {
                      character.setSpecializedSkill(skill, input + 1);
                      _controller.text = (input + 1).toString();
                    }
                  },
                ),
                const SizedBox(width: 8.0),
              ]
          ),
        ),
      ),
    );
  }
}