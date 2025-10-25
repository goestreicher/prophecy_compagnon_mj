import 'package:flutter/material.dart';

import '../../../classes/armor.dart';
import '../../../classes/caste/base.dart';
import '../../../classes/draconic_link.dart';
import '../../../classes/entity/attributes.dart';
import '../../../classes/entity/skill_family.dart';
import '../../../classes/equipment.dart';
import '../../../classes/magic.dart';
import '../../../classes/non_player_character.dart';
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
import '../character/background/display_advantages_widget.dart';
import '../character/relations/display_caste_details_widget.dart';
import '../character/base/display_general_widget.dart';
import '../character/base/display_secondary_attributes_widget.dart';
import '../character/base/tendencies_edit_widget.dart';
import '../character/relations/display_draconic_link_widget.dart';

class NPCDisplayWidget extends StatefulWidget {
  const NPCDisplayWidget({
    super.key,
    required this.id,
  });

  final String id;

  @override
  State<NPCDisplayWidget> createState() => _NPCDisplayWidgetState();
}

class _NPCDisplayWidgetState extends State<NPCDisplayWidget> {
  late Future<NonPlayerCharacter?> npcFuture;

  @override
  void initState() {
    super.initState();
    npcFuture = NonPlayerCharacter.get(widget.id);
  }

  @override
  void didUpdateWidget(NPCDisplayWidget old) {
    super.didUpdateWidget(old);
    npcFuture = NonPlayerCharacter.get(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: npcFuture,
      builder: (BuildContext context, AsyncSnapshot<NonPlayerCharacter?> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return FullPageLoadingWidget();
        }

        if(snapshot.hasError) {
          return FullPageErrorWidget(message: snapshot.error!.toString(), canPop: false);
        }

        if(!snapshot.hasData || snapshot.data == null) {
          return FullPageErrorWidget(message: 'PNJ ${widget.id} non trouvé', canPop: false);
        }

        NonPlayerCharacter npc = snapshot.data!;
        var theme = Theme.of(context);
        const skillGroupWidth = 280.0;

        var hasPhysicalSkills = SkillFamily.values.any(
          (SkillFamily f) => (f.defaultAttribute == Attribute.physique && npc.skills.forFamily(f).isNotEmpty)
        );
        var hasManualSkills = SkillFamily.values.any(
          (SkillFamily f) => (f.defaultAttribute == Attribute.manuel && npc.skills.forFamily(f).isNotEmpty)
        );
        var hasMentalSkills = SkillFamily.values.any(
          (SkillFamily f) => (f.defaultAttribute == Attribute.mental && npc.skills.forFamily(f).isNotEmpty)
        );
        var hasSocialSkills = SkillFamily.values.any(
          (SkillFamily f) => (f.defaultAttribute == Attribute.social && npc.skills.forFamily(f).isNotEmpty)
        );

        var isMagicUser = MagicSkill.values.any(
            (MagicSkill s) => npc.magic.skills.get(s) > 0
          );

        var hasWeapon = npc.equipment.any(
            (Equipment eq) => (eq is Weapon || eq is Shield),
          );
        var hasArmor = npc.equipment.any(
              (Equipment eq) => (eq is Armor),
        );

        return Column(
          spacing: 16.0,
          children: [
            Text(
              npc.name,
              style: theme.textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
              overflow: TextOverflow.fade,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16.0,
              children: [
                if(npc.image != null && npc.image?.data != null)
                  SizedBox(
                    width: 250,
                    child: WidgetGroupContainer(
                      child: Image.memory(
                        npc.image!.data,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                Expanded(
                  child: WidgetGroupContainer(
                    child: Align(
                      alignment: AlignmentGeometry.topLeft,
                      child: Text(
                        npc.description.isNotEmpty
                            ? npc.description
                            : 'Pas de description'
                      )
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
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
                        spacing: 12.0,
                        children: [
                          CharacterDisplayGeneralWidget(character: npc),
                          Row(
                            spacing: 16.0,
                            children: [
                              EntityDisplayInjuriesWidget(injuries: npc.injuries.manager),
                              Expanded(
                                child: Center(
                                  child: TendenciesEditWidget(
                                    tendencies: npc.tendencies,
                                    editValues: false,
                                    showCircles: false,
                                    backgroundWidth: 180,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ),
                    SizedBox(
                      width: 200.0,
                      child: Column(
                        spacing: 12.0,
                        children: [
                          EntityDisplayAbilitiesWidget(entity: npc),
                          Row(
                            spacing: 8.0,
                            children: [
                              Expanded(
                                child: EntityDisplayAttributesWidget(
                                  entity: npc
                                )
                              ),
                              Expanded(
                                child: CharacterDisplaySecondaryAttributesWidget(
                                  character: npc
                                )
                              ),
                            ],
                          ),
                        ],
                      )
                    ),
                  ],
                ),
                if(npc.disadvantages.isNotEmpty)
                  CharacterDisplayDisadvantagesWidget(character: npc),
                if(npc.advantages.isNotEmpty)
                  CharacterDisplayAdvantagesWidget(character: npc),
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
                          entity: npc,
                          attribute: Attribute.physique,
                        ),
                      ),
                    if(hasManualSkills)
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: skillGroupWidth,
                        ),
                        child: EntityDisplaySkillGroupWidget(
                          entity: npc,
                          attribute: Attribute.manuel,
                        ),
                      ),
                    if(hasMentalSkills)
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: skillGroupWidth,
                        ),
                        child: EntityDisplaySkillGroupWidget(
                          entity: npc,
                          attribute: Attribute.mental,
                        ),
                      ),
                    if(hasSocialSkills)
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: skillGroupWidth,
                        ),
                        child: EntityDisplaySkillGroupWidget(
                          entity: npc,
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
                            child: EntityDisplayMagicSkillsWidget(entity: npc)
                          ),
                          Expanded(
                            child: EntityDisplayMagicSpheresWidget(entity: npc)
                          ),
                        ],
                      ),
                      EntityDisplayMagicSpellsWidget(entity: npc)
                    ],
                  ),
                ],
              ),
            if(npc.caste.caste != Caste.sansCaste)
              ExpansionTile(
                title: const Text('Caste'),
                controlAffinity: ListTileControlAffinity.leading,
                children: [
                  CharacterDisplayCasteDetailsWidget(
                    character: npc,
                  ),
                ],
              ),
            if(npc.draconicLink.progress != DraconicLinkProgress.aucunLien)
              ExpansionTile(
                title: const Text('Lien'),
                controlAffinity: ListTileControlAffinity.leading,
                children: [
                  CharacterDisplayDraconicLinkWidget(
                    character: npc,
                  ),
                ],
              ),
            if(hasWeapon || hasArmor)
              ExpansionTile(
                title: const Text('Équipement'),
                controlAffinity: ListTileControlAffinity.leading,
                children: [
                  if(hasWeapon)
                    DisplayWeaponsWidget(entity: npc),
                  if(hasArmor)
                    DisplayArmorWidget(entity: npc),
                ],
              )
          ],
        );
      },
    );
  }
}