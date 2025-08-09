import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../classes/creature.dart';
import '../../classes/equipment.dart';
import '../../classes/object_source.dart';
import '../utils/ability_list_display_widget.dart';
import '../utils/attribute_list_display_widget.dart';
import '../utils/error_feedback.dart';
import '../utils/full_page_loading.dart';
import '../utils/injuries_display_widget.dart';
import '../utils/single_line_input_dialog.dart';
import '../utils/uniform_height_wrap.dart';
import '../../text_utils.dart';

class CreatureActionButtons extends StatelessWidget {
  const CreatureActionButtons({
    super.key,
    required this.creature,
    required this.onEdit,
    required this.onClone,
    required this.onDelete,
    this.restrictModificationToSourceTypes,
  });

  final CreatureModelSummary creature;
  final void Function() onEdit;
  final void Function(String) onClone;
  final void Function() onDelete;
  final List<ObjectSourceType>? restrictModificationToSourceTypes;

  @override
  Widget build(BuildContext context) {
    bool canModify = true;
    String? canModifyMessage;

    if(creature.isDefault) {
      canModify = false;
      canModifyMessage = 'Modification impossible (créature par défaut)';
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
          onPressed: () async {
            var name = await showDialog(
              context: context,
              builder: (BuildContext context) => SingleLineInputDialog(
                title: 'Nom de la créature',
                hintText: 'Nom',
                formKey: GlobalKey<FormState>(),
              ),
            );
            if(!context.mounted) return;
            if(name == null) return;

            var id = sentenceToCamelCase(transliterateFrenchToAscii(name));
            var model = await CreatureModel.get(id);
            if(!context.mounted) return;
            if(model != null) {
              displayErrorDialog(
                context,
                'Clonage impossible',
                'Une créature avec ce nom (ou un nom similaire) existe déjà'
              );
              return;
            }

            onClone(name);
          },
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
            var model = await CreatureModel.get(creature.id);
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
    required this.onDelete,
    this.restrictModificationToSourceTypes,
  });

  final String creature;
  final void Function(CreatureModel) onEditRequested;
  final void Function() onDelete;
  final List<ObjectSourceType>? restrictModificationToSourceTypes;

  @override
  State<CreatureDisplayWidget> createState() => _CreatureDisplayWidgetState();
}

class _CreatureDisplayWidgetState extends State<CreatureDisplayWidget> {
  late Future<CreatureModel?> creatureFuture;
  
  @override
  void initState() {
    super.initState();
    creatureFuture = CreatureModel.get(widget.creature);
  }

  @override
  void didUpdateWidget(CreatureDisplayWidget old) {
    super.didUpdateWidget(old);
    creatureFuture = CreatureModel.get(widget.creature);
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: creatureFuture,
      builder: (BuildContext context, AsyncSnapshot<CreatureModel?> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return FullPageLoadingWidget();
        }

        if(snapshot.hasError) {
          return FullPageErrorWidget(message: snapshot.error!.toString(), canPop: false);
        }

        if(!snapshot.hasData || snapshot.data == null) {
          return FullPageErrorWidget(message: 'Créature non trouvée', canPop: false);
        }

        CreatureModel creature = snapshot.data!;
        var theme = Theme.of(context);

        List<String> equipment = <String>[];
        for(var e in creature.equipment) {
          var eq = EquipmentFactory.instance.forgeEquipment(e);
          if(eq != null ) {
            equipment.add(eq.name());
          }
        }

        var armorDescription = creature.naturalArmor.toString();
        if(creature.naturalArmorDescription.isNotEmpty) {
          armorDescription += ' (${creature.naturalArmorDescription})';
        }

        Map<String, int> weapons = <String, int>{};
        for(var w in creature.naturalWeapons) {
          weapons[w.name] = w.damage;
        }

        Map<String, int> skills = <String, int>{};
        for(var s in creature.skills) {
          if(s.value > 0) {
            skills[s.skill.title] = s.value;
          }
          for(var sp in s.specializations.keys) {
            skills['${s.skill.title} (${sp.title})'] = s.specializations[sp]!;
          }
        }
        var skillsOrder = skills.keys.toList()..sort((a, b) => a.compareTo(b));

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 20.0, 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UniformHeightWrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  allocation: UniformHeightWrapAllocation.expandSpacing,
                  children: [
                    Text(
                      creature.name,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    CreatureActionButtons(
                      creature: creature.summary,
                      onEdit: () => widget.onEditRequested(creature),
                      onClone: (String newName) {
                        var j = creature.toJson();
                        j['is_default'] = false;
                        j['name'] = newName;
                        widget.onEditRequested(CreatureModel.fromJson(j));
                      },
                      onDelete: () => widget.onDelete(),
                      restrictModificationToSourceTypes: widget.restrictModificationToSourceTypes,
                    ),
                  ]
                ),
                const SizedBox(height: 16.0),
                Wrap(
                  direction: Axis.horizontal,
                  spacing: 12.0,
                  runSpacing: 4.0,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Unique : ',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: creature.unique ? 'Oui' : 'Non',
                            style: theme.textTheme.bodyLarge,
                          )
                        ]
                      )
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Taille : ',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: creature.size,
                            style: theme.textTheme.bodyLarge,
                          )
                        ]
                      )
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Poids : ',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: creature.weight,
                            style: theme.textTheme.bodyLarge,
                          )
                        ]
                      )
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Habitat : ',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: creature.biome,
                            style: theme.textTheme.bodyLarge,
                          )
                        ]
                      )
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                UniformHeightWrap(
                  spacing: 16.0,
                  runSpacing: 8.0,
                  allocation: UniformHeightWrapAllocation.resizeChildren,
                  children: [
                    AbilityListDisplayWidget(abilities: creature.abilities),
                    AttributeListDisplayWidget(attributes: creature.attributes),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black87),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'Initiative : ',
                                  style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                                  children: [
                                    TextSpan(
                                      text: creature.initiative.toString(),
                                      style: theme.textTheme.bodyLarge,
                                    )
                                  ]
                                )
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'Armure : ',
                                  style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                                  children: [
                                    TextSpan(
                                      text: armorDescription,
                                      style: theme.textTheme.bodyLarge,
                                    )
                                  ]
                                )
                              ),
                              Text(
                                'Seuils de blessure',
                                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                                child: InjuriesDisplayWidget(injuries: creature.injuries),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8.0),
                UniformHeightWrap(
                  spacing: 16.0,
                  runSpacing: 8.0,
                  allocation: UniformHeightWrapAllocation.resizeChildren,
                  children: [
                    if(skillsOrder.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black87),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Compétences',
                                  style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                                ),
                                for(var skill in skillsOrder)
                                  Text('$skill ${skills[skill]}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    if(creature.naturalWeapons.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black87),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Armes naturelles',
                                  style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                                ),
                                for(var w in creature.naturalWeapons)
                                  Text('${w.name} (${w.skill}), Dommages ${w.damage}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    if(equipment.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black87),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Équipement',
                                  style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                                ),
                                for(var e in equipment)
                                  Text(e),
                              ],
                            ),
                          ],
                        ),
                      ),
                    if(creature.specialCapability.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black87),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Capacité spéciale',
                                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(creature.specialCapability, softWrap: true),
                                ],
                              ),
                            ),
                          ],
                        )
                      ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Description',
                  style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                  child: Text(creature.description),
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
        );
      }
    );
  }
}