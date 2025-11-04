import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:prophecy_compagnon_mj/ui/utils/entity/base/skill_picker_dialog.dart';

import '../../../../classes/entity/skill.dart';
import '../../../../classes/entity/skill_family.dart';
import '../../../../classes/entity/skill_instance.dart';
import '../../../../classes/entity/specialized_skill.dart';
import '../../../../classes/entity/specialized_skill_instance.dart';
import '../../../../classes/entity_base.dart';
import '../../num_input_widget.dart';
import '../../widget_group_container.dart';

class EntityEditSkillFamilyContainer extends StatelessWidget {
  const EntityEditSkillFamilyContainer({
    super.key,
    required this.entity,
    required this.family,
  });

  final EntityBase entity;
  final SkillFamily family;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var skillWidgets = <Widget>[];
    for(var s in entity.skills.forFamily(family)) {
      skillWidgets.add(
        ListenableBuilder(
          listenable: s,
          builder: (BuildContext context, _) {
            return SkillEditWidget(
              skill: s,
              onDeleted: () {
                entity.skills.families[family]!.del(s.skill);
              },
            );
          }
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
                    family: family,
                    excluded: entity.skills.forFamily(family)
                      .map((SkillInstance s) => s.skill)
                      .toList(),
                  )
              );
              if(skill == null) return;

              entity.skills.families[family]!.add(skill);
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
                  var characterSkills = entity.skills.forFamily(family)
                    .map((SkillInstance s) => s.skill)
                    .toList();
                  return SpecializedSkillPickerDialog(
                    skills: Skill.fromFamily(family)
                        .where((Skill s) => s.requireSpecialization || characterSkills.contains(s))
                        .toList()
                      ..sort((Skill a, Skill b) => a.name.compareTo(b.name)),
                  );
                }
              );
              if(skill == null) return;

              SkillInstance i = entity.skills.families[family]!.add(skill.parent);
              SpecializedSkillInstance si = i.addSpecialization(skill);
              si.value = i.value;
            },
          ),
        ],
      )
    );

    return WidgetGroupContainer(
      title: Text(
        family.name,
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
  const SkillEditWidget({
    super.key,
    required this.skill,
    required this.onDeleted,
  });

  final SkillInstance skill;
  final void Function() onDeleted;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
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
                Expanded(
                  child: Text(
                    skill.skill.name,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                Spacer(),
                if(!skill.skill.requireSpecialization)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SizedBox(
                      width: 80,
                      child: NumIntInputWidget(
                        initialValue: skill.value,
                        onChanged: (int value) => skill.value = value,
                      ),
                    ),
                  ),
              ]
            ),
            for(var sp in skill.specializations)
              SpecializedSkillEditWidget(
                  skill: sp,
                  onDeleted: () => skill.delSpecialization(sp.skill)
              ),
          ],
        ),
      ),
    );
  }
}

class SpecializedSkillEditWidget extends StatelessWidget {
  const SpecializedSkillEditWidget({
    super.key,
    required this.skill,
    required this.onDeleted,
  });

  final SpecializedSkillInstance skill;
  final void Function() onDeleted;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

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
                skill.skill.name,
                style: theme.textTheme.bodySmall,
              ),
              const Spacer(),
              SizedBox(
                width: 80,
                child: NumIntInputWidget(
                  initialValue: skill.value,
                  onChanged: (int value) => skill.value = value,
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}