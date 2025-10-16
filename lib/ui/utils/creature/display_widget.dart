import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../classes/armor.dart';
import '../../../classes/creature.dart';
import '../../../classes/entity/attributes.dart';
import '../../../classes/entity/skill_family.dart';
import '../../../classes/magic.dart';
import '../../../classes/object_source.dart';
import '../../../classes/shield.dart';
import '../../../classes/weapon.dart';
import '../entity/base/display_abilities_widget.dart';
import '../entity/base/display_attributes_widget.dart';
import '../entity/base/display_injuries_widget.dart';
import '../entity/base/display_skill_group_widget.dart';
import '../entity/equipment/display_armor_widget.dart';
import '../entity/equipment/display_weapons_widget.dart';
import '../entity/magic/display_magic_skills_widget.dart';
import '../entity/magic/display_magic_spells_widget.dart';
import '../entity/magic/display_magic_spheres_widget.dart';
import '../error_feedback.dart';
import '../full_page_loading.dart';
import '../widget_group_container.dart';
import 'base/display_general_widget.dart';
import 'base/display_natural_weapons_widget.dart';
import 'base/display_secondary_attributes_widget.dart';
import 'base/display_special_capabilities_widget.dart';

class CreatureActionButtons extends StatelessWidget {
  const CreatureActionButtons({
    super.key,
    required this.creature,
    required this.onEdit,
    required this.onClone,
    required this.onDelete,
    this.restrictModificationToSourceTypes,
  });

  final CreatureSummary creature;
  final void Function() onEdit;
  final void Function() onClone;
  final void Function() onDelete;
  final List<ObjectSourceType>? restrictModificationToSourceTypes;

  @override
  Widget build(BuildContext context) {
    bool canModify = true;
    String? canModifyMessage;

    if(!creature.location.type.canWrite) {
      canModify = false;
      canModifyMessage = 'Modification impossible (créature en lecture seule)';
    }
    else if(restrictModificationToSourceTypes != null && !restrictModificationToSourceTypes!.contains(creature.source.type)) {
      canModify = false;
      canModifyMessage = 'Modification impossible depuis cette page';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          tooltip: !canModify
            ? canModifyMessage!
            : 'Modifier',
          onPressed: !canModify
            ? null
            : () => onEdit(),
        ),
        IconButton(
          icon: const Icon(Icons.content_copy_outlined),
          tooltip: 'Cloner',
          onPressed: () => onClone(),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          tooltip: !canModify
              ? canModifyMessage!
              : 'Supprimer',
          onPressed: !canModify
            ? null
            : () => onDelete(),
        ),
        IconButton(
          icon: const Icon(Icons.download),
          tooltip: 'Télécharger (JSON)',
          onPressed: () async {
            var model = await Creature.get(creature.id);
            var jsonStr = json.encode(model!.toJson());
            await FilePicker.platform.saveFile(
              fileName: 'creature-${creature.id}.json',
              bytes: utf8.encode(jsonStr),
            );
          },
        )
      ],
    );
  }
}

class CreatureDisplayWidget extends StatefulWidget {
  const CreatureDisplayWidget({
    super.key,
    required this.creature,
    required this.onEditRequested,
    required this.onCloneRequested,
    required this.onDeleteRequested,
    this.restrictModificationToSourceTypes,
  });

  final String creature;
  final void Function() onEditRequested;
  final void Function() onCloneRequested;
  final void Function() onDeleteRequested;
  final List<ObjectSourceType>? restrictModificationToSourceTypes;

  @override
  State<CreatureDisplayWidget> createState() => _CreatureDisplayWidgetState();
}

class _CreatureDisplayWidgetState extends State<CreatureDisplayWidget> {
  late Future<Creature?> creatureFuture;
  
  @override
  void initState() {
    super.initState();
    creatureFuture = Creature.get(widget.creature);
  }

  @override
  void didUpdateWidget(CreatureDisplayWidget old) {
    super.didUpdateWidget(old);
    creatureFuture = Creature.get(widget.creature);
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: creatureFuture,
      builder: (BuildContext context, AsyncSnapshot<Creature?> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return FullPageLoadingWidget();
        }

        if(snapshot.hasError) {
          return FullPageErrorWidget(message: snapshot.error!.toString(), canPop: false);
        }

        if(!snapshot.hasData || snapshot.data == null) {
          return FullPageErrorWidget(message: 'Créature non trouvée', canPop: false);
        }

        Creature creature = snapshot.data!;
        var theme = Theme.of(context);
        const skillGroupWidth = 280.0;

        var hasPhysicalSkills = SkillFamily.values.any(
            (SkillFamily f) => (f.defaultAttribute == Attribute.physique && creature.skills.forFamily(f).isNotEmpty)
        );
        var hasManualSkills = SkillFamily.values.any(
            (SkillFamily f) => (f.defaultAttribute == Attribute.manuel && creature.skills.forFamily(f).isNotEmpty)
        );
        var hasMentalSkills = SkillFamily.values.any(
            (SkillFamily f) => (f.defaultAttribute == Attribute.mental && creature.skills.forFamily(f).isNotEmpty)
        );
        var hasSocialSkills = SkillFamily.values.any(
            (SkillFamily f) => (f.defaultAttribute == Attribute.social && creature.skills.forFamily(f).isNotEmpty)
        );

        var isMagicUser = MagicSkill.values.any(
            (MagicSkill s) => creature.magic.skills.get(s) > 0
          );

        var hasWeapon = false;
        var hasArmor = false;
        for(var eq in creature.equipment) {
          if(eq is Weapon || eq is Shield) hasWeapon = true;
          if(eq is Armor) hasArmor = true;
        }

        return Column(
          spacing: 12.0,
          children: [
            Row(
              children: [
                Text(
                  creature.name,
                  overflow: TextOverflow.fade,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                CreatureActionButtons(
                  creature: creature.summary,
                  onEdit: () => widget.onEditRequested(),
                  onClone: () => widget.onCloneRequested(),
                  onDelete: () => widget.onDeleteRequested(),
                  restrictModificationToSourceTypes: widget.restrictModificationToSourceTypes,
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16.0,
              children: [
                if(creature.image != null && creature.image?.data != null)
                  SizedBox(
                    width: 250,
                    child: WidgetGroupContainer(
                      child: Image.memory(
                        creature.image!.data,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                Expanded(
                  child: WidgetGroupContainer(
                    child: Align(
                        alignment: AlignmentGeometry.topLeft,
                        child: Text(
                            creature.description.isNotEmpty
                                ? creature.description
                                : 'Pas de description'
                        )
                    ),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('Général'),
              controlAffinity: ListTileControlAffinity.leading,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16.0,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 12.0,
                        children: [
                          CreatureDisplayGeneralWidget(
                            creature: creature,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 16.0,
                            children: [
                              Expanded(
                                child: CreatureDisplaySecondaryAttributes(
                                  creature: creature
                                ),
                              ),
                              EntityDisplayInjuriesWidget(
                                injuries: creature.injuries.manager,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: EntityDisplayAbilitiesWidget(
                        entity: creature
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: EntityDisplayAttributesWidget(
                        entity: creature
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16.0,
                  children: [
                    Center(
                      child: CreatureDisplayNaturalWeaponsWidget(
                        creature: creature,
                      ),
                    ),
                    Expanded(
                      child: CreatureDisplaySpecialCapabilities(
                        creature: creature,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if(hasWeapon || hasArmor)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.0,
                children: [
                  if(hasWeapon)
                    Expanded(child: DisplayWeaponsWidget(entity: creature)),
                  if(hasArmor)
                    Expanded(child: DisplayArmorWidget(entity: creature)),
                ],
              ),
            ExpansionTile(
              title: const Text('Compétences'),
              controlAffinity: ListTileControlAffinity.leading,
              children: [
                Wrap(
                  spacing: 12.0,
                  children: [
                    if(hasPhysicalSkills)
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: skillGroupWidth,
                        ),
                        child: EntityDisplaySkillGroupWidget(
                          entity: creature,
                          attribute: Attribute.physique,
                        ),
                      ),
                    if(hasManualSkills)
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: skillGroupWidth,
                        ),
                        child: EntityDisplaySkillGroupWidget(
                          entity: creature,
                          attribute: Attribute.manuel,
                        ),
                      ),
                    if(hasMentalSkills)
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: skillGroupWidth,
                        ),
                        child: EntityDisplaySkillGroupWidget(
                          entity: creature,
                          attribute: Attribute.mental,
                        ),
                      ),
                    if(hasSocialSkills)
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: skillGroupWidth,
                        ),
                        child: EntityDisplaySkillGroupWidget(
                          entity: creature,
                          attribute: Attribute.social,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            if(isMagicUser)
              ExpansionTile(
                title: const Text('Magie'),
                controlAffinity: ListTileControlAffinity.leading,
                children: [
                  Column(
                    spacing: 12.0,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16.0,
                        children: [
                          ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 160,
                              ),
                              child: EntityDisplayMagicSkillsWidget(entity: creature)
                          ),
                          Expanded(
                              child: EntityDisplayMagicSpheresWidget(entity: creature)
                          ),
                        ],
                      ),
                      EntityDisplayMagicSpellsWidget(entity: creature)
                    ],
                  ),
                ],
              ),
          ],
        );
      }
    );
  }
}