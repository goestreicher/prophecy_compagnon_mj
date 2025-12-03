import 'package:flutter/material.dart';

import '../../../classes/creature.dart';
import '../../../classes/entity/attributes.dart';
import '../entity/background/edit_description_widget.dart';
import '../entity/background/edit_illustration_widget.dart';
import '../entity/base/edit_abilities_widget.dart';
import '../entity/base/edit_attributes_widget.dart';
import '../entity/base/draconic_favors_widget.dart';
import '../entity/base/edit_injuries_widget.dart';
import '../entity/base/edit_skill_group_container.dart';
import '../entity/equipment/edit_armor_widget.dart';
import '../entity/equipment/edit_weapons_widget.dart';
import '../entity/magic/edit_magic_skills_widget.dart';
import '../entity/magic/edit_magic_spells_widget.dart';
import '../entity/magic/edit_magic_spheres_widget.dart';
import 'base/edit_general_widget.dart';
import 'base/edit_natural_weapons.dart';
import 'base/edit_secondary_attributes.dart';
import 'base/edit_special_capabilities_widget.dart';

class CreatureEditWidget extends StatefulWidget {
  const CreatureEditWidget({
    super.key,
    required this.creature,
    required this.onEditDone,
  });

  final Creature creature;
  final void Function(bool) onEditDone;

  @override
  State<CreatureEditWidget> createState() => _CreatureEditWidgetState();
}

class _CreatureEditWidgetState extends State<CreatureEditWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 1000.0,
          ),
          child: Form(
            key: formKey,
            child: Column(
              spacing: 12.0,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.cancel_outlined),
                      onPressed: () {
                        widget.onEditDone(false);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.check_circle_outline),
                      onPressed: () {
                        if(formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          widget.onEditDone(true);
                        }
                      }
                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16.0,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 300,
                      ),
                      child: EntityEditIllustrationWidget(
                        entity: widget.creature,
                      ),
                    ),
                    Expanded(
                      child: EntityEditDescriptionWidget(
                        entity: widget.creature,
                      )
                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16.0,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          CreatureEditGeneralWidget(
                            creature: widget.creature,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 16.0,
                            children: [
                              Expanded(
                                child: CreatureEditSecondaryAttributes(
                                  creature: widget.creature,
                                ),
                              ),
                              Expanded(
                                child: EntityEditInjuriesWidget(
                                  entity: widget.creature,
                                )
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 220,
                      child: EntityEditAbilitiesWidget(
                        entity: widget.creature,
                        maxValue: 30,
                      ),
                    ),
                    SizedBox(
                      width: 110,
                      child: EntityEditAttributesWidget(
                        entity: widget.creature,
                        maxValue: 30,
                      ),
                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16.0,
                  children: [
                    Expanded(
                      child: CreatureEditNaturalWeapons(
                        creature: widget.creature,
                      ),
                    ),
                    Expanded(
                      child: CreatureEditSpecialCapabilitiesWidget(
                        creature: widget.creature,
                      )
                    )
                  ],
                ),
                EntityEditWeaponsWidget(
                  entity: widget.creature,
                ),
                EntityEditArmorWidget(
                  entity: widget.creature,
                ),
                EntityDisplayDraconicFavorsWidget(
                  entity: widget.creature,
                  edit: true,
                ),
                Divider(),
                Wrap(
                  spacing: 16.0,
                  runSpacing: 12.0,
                  children: [
                    EntityEditSkillGroupContainer(
                      entity: widget.creature,
                      attribute: Attribute.physique,
                    ),
                    EntityEditSkillGroupContainer(
                      entity: widget.creature,
                      attribute: Attribute.mental,
                    ),
                    EntityEditSkillGroupContainer(
                      entity: widget.creature,
                      attribute: Attribute.manuel,
                    ),
                    EntityEditSkillGroupContainer(
                      entity: widget.creature,
                      attribute: Attribute.social,
                    ),
                  ],
                ),
                Divider(),
                EntityEditMagicSkillsWidget(
                  entity: widget.creature,
                ),
                EntityEditMagicSpheresWidget(
                  entity: widget.creature,
                ),
                EntityEditMagicSpellsWidget(
                  entity: widget.creature,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}