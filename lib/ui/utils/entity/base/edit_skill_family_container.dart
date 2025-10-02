import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:prophecy_compagnon_mj/ui/utils/entity/base/skill_picker_dialog.dart';

import '../../../../classes/character/skill.dart';
import '../../../../classes/entity_base.dart';
import '../../character/change_stream.dart';
import '../../num_input_widget.dart';
import '../../widget_group_container.dart';

class EntityEditSkillFamilyContainer extends StatefulWidget {
  const EntityEditSkillFamilyContainer({
    super.key,
    required this.entity,
    required this.family,
    this.changeStreamController,
  });

  final EntityBase entity;
  final StreamController<CharacterChange>? changeStreamController;
  final SkillFamily family;

  @override
  State<EntityEditSkillFamilyContainer> createState() => _EntityEditSkillFamilyContainerState();
}

class _EntityEditSkillFamilyContainerState extends State<EntityEditSkillFamilyContainer> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var skillWidgets = <Widget>[];
    for(var s in widget.entity.skillsForFamily(widget.family)) {
      skillWidgets.add(
        SkillEditWidget(
          character: widget.entity,
          skill: s.skill,
          onChanged: (int value) {
            // TODO
          },
          onDeleted: () {
            setState(() {
              widget.entity.deleteSkill(s.skill);
            });
          },
          onSpecializationChanged: (SpecializedSkill sp, int value) {
            // TODO
          },
          onSpecializationDeleted: (SpecializedSkill sp) {
            setState(() {
              widget.entity.deleteSpecializedSkill(sp);
            });
          },
        )
      );
    }

    skillWidgets.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8.0,
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
                      excluded: widget.entity
                          .skillsForFamily(widget.family)
                          .map((SkillInstance s) => s.skill)
                          .toList(),
                    )
              );
              if(skill == null) return;

              setState(() {
                widget.entity.setSkill(skill, 0);
              });
            },
          ),
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
                    var characterSkills = widget.entity
                        .skillsForFamily(widget.family)
                        .map((SkillInstance s) => s.skill)
                        .toList();
                    return SpecializedSkillPickerDialog(
                      skills: Skill.fromFamily(widget.family)
                          .where((Skill s) => s.requireSpecialization || characterSkills.contains(s))
                          .toList()
                        ..sort((Skill a, Skill b) => a.title.compareTo(b.title)),
                    );
                  }
              );
              if(skill == null) return;

              setState(() {
                if(skill.parent.requireSpecialization) {
                  widget.entity.setSkill(skill.parent, 0);
                }
                widget.entity.setSpecializedSkill(skill, widget.entity.skill(skill.parent));
              });
            },
          ),
        ],
      )
    );

    return WidgetGroupContainer(
      title: Text(
        widget.family.title,
        style: theme.textTheme.bodyMedium!.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8.0,
        children: [
          ...skillWidgets,
        ],
      )
    );
  }
}

class SkillEditWidget extends StatelessWidget {
  SkillEditWidget({
    super.key,
    required this.character,
    required this.skill,
    required this.onChanged,
    required this.onDeleted,
    required this.onSpecializationChanged,
    required this.onSpecializationDeleted,
  });

  final EntityBase character;
  final Skill skill;
  final void Function(int) onChanged;
  final void Function() onDeleted;
  final void Function(SpecializedSkill, int) onSpecializationChanged;
  final void Function(SpecializedSkill) onSpecializationDeleted;

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    _controller.text = character.skill(skill).toString();

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
          top: 4.0,
          bottom: 4.0,
          right: 16.0,
        ),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    onDeleted();
                  },
                ),
                Text(
                  skill.title,
                  style: theme.textTheme.bodySmall,
                ),
                Spacer(),
                if(!skill.requireSpecialization)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SizedBox(
                      width: 80,
                      child: NumIntInputWidget(
                        initialValue: character.skill(skill),
                        onChanged: (int value) => onChanged(value),
                        onSaved: (int value) => character.setSkill(skill, value),
                      ),
                    ),
                  ),
              ]
            ),
            for(var sp in character.allSpecializedSkills(skill))
              SpecializedSkillEditWidget(
                  character: character,
                  skill: sp,
                  onChanged: (int value) => onSpecializationChanged(sp, value),
                  onDeleted: () => onSpecializationDeleted(sp),
              ),
          ],
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
    required this.onChanged,
    required this.onDeleted,
  });

  final EntityBase character;
  final SpecializedSkill skill;
  final void Function(int) onChanged;
  final void Function() onDeleted;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    _controller.text = character.specializedSkill(skill).toString();

    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        top: 4.0,
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
            right: 8.0,
            bottom: 4.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  onDeleted();
                },
              ),
              Text(
                skill.title,
                style: theme.textTheme.bodySmall,
              ),
              const Spacer(),
              SizedBox(
                width: 80,
                child: NumIntInputWidget(
                  initialValue: character.specializedSkill(skill),
                  onChanged: (int value) {
                    onChanged(value);
                  },
                  onSaved: (int value) {
                    character.setSpecializedSkill(skill, value);
                  },
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}