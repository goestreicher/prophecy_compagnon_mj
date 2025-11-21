import 'package:flutter/material.dart';

import '../../../classes/armor.dart';
import '../../../classes/caste/base.dart';
import '../../../classes/draconic_link.dart';
import '../../../classes/entity/attributes.dart';
import '../../../classes/entity/skill_family.dart';
import '../../../classes/equipment.dart';
import '../../../classes/human_character.dart';
import '../../../classes/magic.dart';
import '../../../classes/shield.dart';
import '../../../classes/weapon.dart';
import '../entity/base/display_abilities_widget.dart';
import '../entity/base/display_attributes_widget.dart';
import '../entity/base/display_injuries_widget.dart';
import '../entity/base/display_skill_group_widget.dart';
import '../entity/base/draconic_favors_widget.dart';
import '../entity/equipment/display_armor_widget.dart';
import '../entity/equipment/display_weapons_widget.dart';
import '../entity/magic/display_magic_skills_widget.dart';
import '../entity/magic/display_magic_spells_widget.dart';
import '../entity/magic/display_magic_spheres_widget.dart';
import '../markdown_display_widget.dart';
import '../widget_group_container.dart';
import 'background/display_advantages_widget.dart';
import 'base/display_general_widget.dart';
import 'base/display_secondary_attributes_widget.dart';
import 'base/tendencies_edit_widget.dart';
import 'relations/display_caste_details_widget.dart';
import 'relations/display_draconic_link_widget.dart';

class CharacterDisplayWidget extends StatelessWidget {
  const CharacterDisplayWidget({ super.key, required this.character });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    const skillGroupWidth = 280.0;

    var hasPhysicalSkills = SkillFamily.values.any(
      (SkillFamily f) => (f.defaultAttribute == Attribute.physique && character.skills.forFamily(f).isNotEmpty)
    );
    var hasManualSkills = SkillFamily.values.any(
      (SkillFamily f) => (f.defaultAttribute == Attribute.manuel && character.skills.forFamily(f).isNotEmpty)
    );
    var hasMentalSkills = SkillFamily.values.any(
      (SkillFamily f) => (f.defaultAttribute == Attribute.mental && character.skills.forFamily(f).isNotEmpty)
    );
    var hasSocialSkills = SkillFamily.values.any(
      (SkillFamily f) => (f.defaultAttribute == Attribute.social && character.skills.forFamily(f).isNotEmpty)
    );

    var isMagicUser = MagicSkill.values.any(
      (MagicSkill s) => character.magic.skills.get(s) > 0
    );

    var hasWeapon = character.equipment.any(
      (Equipment eq) => (eq is Weapon || eq is Shield),
    );
    var hasArmor = character.equipment.any(
      (Equipment eq) => (eq is Armor),
    );

    return Column(
      spacing: 16.0,
      children: [
        Text(
          character.name,
          style: theme.textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
          overflow: TextOverflow.fade,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            if(character.image != null && character.image?.data != null)
              SizedBox(
                width: 250,
                child: WidgetGroupContainer(
                  child: Image.memory(
                    character.image!.data,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            Expanded(
              child: WidgetGroupContainer(
                child: Align(
                  alignment: AlignmentGeometry.topLeft,
                  child: MarkdownDisplayWidget(
                    data: character.description.isNotEmpty
                      ? character.description
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
                      CharacterDisplayGeneralWidget(character: character),
                      Row(
                        spacing: 16.0,
                        children: [
                          EntityDisplayInjuriesWidget(injuries: character.injuries.manager),
                          Expanded(
                            child: Center(
                              child: TendenciesEditWidget(
                                tendencies: character.tendencies,
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
                      EntityDisplayAbilitiesWidget(entity: character),
                      Row(
                        spacing: 8.0,
                        children: [
                          Expanded(
                            child: EntityDisplayAttributesWidget(
                              entity: character
                            )
                          ),
                          Expanded(
                            child: CharacterDisplaySecondaryAttributesWidget(
                              character: character
                            )
                          ),
                        ],
                      ),
                    ],
                  )
                ),
              ],
            ),
            if(character.disadvantages.isNotEmpty)
              CharacterDisplayDisadvantagesWidget(character: character),
            if(character.advantages.isNotEmpty)
              CharacterDisplayAdvantagesWidget(character: character),
            if(character.favors.isNotEmpty)
              EntityDisplayDraconicFavorsWidget(
                entity: character,
              )
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
                      entity: character,
                      attribute: Attribute.physique,
                    ),
                  ),
                if(hasManualSkills)
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: skillGroupWidth,
                    ),
                    child: EntityDisplaySkillGroupWidget(
                      entity: character,
                      attribute: Attribute.manuel,
                    ),
                  ),
                if(hasMentalSkills)
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: skillGroupWidth,
                    ),
                    child: EntityDisplaySkillGroupWidget(
                      entity: character,
                      attribute: Attribute.mental,
                    ),
                  ),
                if(hasSocialSkills)
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: skillGroupWidth,
                    ),
                    child: EntityDisplaySkillGroupWidget(
                      entity: character,
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
                        child: EntityDisplayMagicSkillsWidget(entity: character)
                      ),
                      Expanded(
                        child: EntityDisplayMagicSpheresWidget(entity: character)
                      ),
                    ],
                  ),
                  EntityDisplayMagicSpellsWidget(entity: character)
                ],
              ),
            ],
          ),
        if(character.caste.caste != Caste.sansCaste)
          ExpansionTile(
            title: const Text('Caste'),
            controlAffinity: ListTileControlAffinity.leading,
            children: [
              CharacterDisplayCasteDetailsWidget(
                character: character,
              ),
            ],
          ),
        if(character.draconicLink.progress != DraconicLinkProgress.aucunLien)
          ExpansionTile(
            title: const Text('Lien'),
            controlAffinity: ListTileControlAffinity.leading,
            children: [
              CharacterDisplayDraconicLinkWidget(
                character: character,
              ),
            ],
          ),
        if(hasWeapon || hasArmor)
          ExpansionTile(
            title: const Text('Équipement'),
            controlAffinity: ListTileControlAffinity.leading,
            children: [
              if(hasWeapon)
                DisplayWeaponsWidget(entity: character),
              if(hasArmor)
                DisplayArmorWidget(entity: character),
            ],
          )
      ],
    );
  }
}