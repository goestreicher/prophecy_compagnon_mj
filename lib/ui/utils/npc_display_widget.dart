import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../classes/character/base.dart';
import '../../classes/magic.dart';
import '../../classes/non_player_character.dart';
import '../../classes/object_source.dart';
import 'ability_list_display_widget.dart';
import 'attribute_list_display_widget.dart';
import 'error_feedback.dart';
import 'full_page_loading.dart';
import 'injuries_display_widget.dart';
import 'tendencies_display_widget.dart';
import '../utils/uniform_height_wrap.dart';

class NPCActionButtons extends StatelessWidget {
  const NPCActionButtons({
    super.key,
    required this.npc,
    required this.onEdit,
    required this.onClone,
    required this.onDelete,
    this.restrictModificationToSourceTypes,
  });

  final NonPlayerCharacterSummary npc;
  final void Function() onEdit;
  final void Function() onClone;
  final void Function() onDelete;
  final List<ObjectSourceType>? restrictModificationToSourceTypes;

  @override
  Widget build(BuildContext context) {
    bool canModify = true;
    String? canModifyMessage;

    if(!npc.location.type.canWrite) {
      canModify = false;
      canModifyMessage = 'Modification impossible (créature par défaut)';
    }
    else if(restrictModificationToSourceTypes != null && !restrictModificationToSourceTypes!.contains(npc.source.type)) {
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
            var model = await NonPlayerCharacter.get(npc.id);
            var jsonStr = json.encode(model!.toJson());
            await FilePicker.platform.saveFile(
              fileName: 'pnj-${npc.id}.json',
              bytes: utf8.encode(jsonStr),
            );
          },
        ),
      ],
    );
  }
}

class NPCDisplayWidget extends StatefulWidget {
  const NPCDisplayWidget({
    super.key,
    required this.id,
    required this.onEditRequested,
    required this.onCloneRequested,
    required this.onDeleteRequested,
    this.restrictModificationToSourceTypes,
  });

  final String id;
  final void Function() onEditRequested;
  final void Function() onCloneRequested;
  final void Function() onDeleteRequested;
  final List<ObjectSourceType>? restrictModificationToSourceTypes;

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

        Map<String, int> skills = <String, int>{};
        for(var s in npc.skills) {
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
                      npc.name,
                      softWrap: true,
                      style: theme.textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    NPCActionButtons(
                      npc: npc.summary,
                      onEdit: () => widget.onEditRequested(),
                      onClone: () => widget.onCloneRequested(),
                      onDelete: () => widget.onDeleteRequested(),
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
                            text: npc.unique ? 'Oui' : 'Non',
                            style: theme.textTheme.bodyLarge,
                          )
                        ]
                      )
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Caste : ',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: npc.caste.title,
                            style: theme.textTheme.bodyLarge,
                          )
                        ]
                      )
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Statut : ',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: Caste.statusName(npc.caste, npc.casteStatus),
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
                    AbilityListDisplayWidget(abilities: npc.abilities),
                    TendenciesDisplayWidget(tendencies: npc.tendencies),
                    AttributeListDisplayWidget(attributes: npc.attributes),
                  ],
                ),
                const SizedBox(height: 8.0),
                UniformHeightWrap(
                  spacing: 16.0,
                  runSpacing: 8.0,
                  allocation: UniformHeightWrapAllocation.resizeChildren,
                  children: [
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
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                  text: TextSpan(
                                      text: 'Initiative : ',
                                      style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                                      children: [
                                        TextSpan(
                                          text: npc.initiative.toString(),
                                          style: theme.textTheme.bodyMedium,
                                        )
                                      ]
                                  )
                              ),
                              const SizedBox(height: 8.0),
                              RichText(
                                  text: TextSpan(
                                      text: 'Chance : ',
                                      style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                                      children: [
                                        TextSpan(
                                          text: npc.luck.toString(),
                                          style: theme.textTheme.bodyMedium,
                                        )
                                      ]
                                  )
                              ),
                              const SizedBox(height: 8.0),
                              RichText(
                                  text: TextSpan(
                                      text: 'Maîtrise : ',
                                      style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                                      children: [
                                        TextSpan(
                                          text: npc.proficiency.toString(),
                                          style: theme.textTheme.bodyMedium,
                                        )
                                      ]
                                  )
                              ),
                              const SizedBox(height: 8.0),
                              RichText(
                                  text: TextSpan(
                                      text: 'Renommée : ',
                                      style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                                      children: [
                                        TextSpan(
                                          text: npc.renown.toString(),
                                          style: theme.textTheme.bodyMedium,
                                        )
                                      ]
                                  )
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
                                'Seuils de blessure',
                                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                              ),
                              InjuriesDisplayWidget(injuries: npc.injuries.levels()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if(npc.interdicts.isNotEmpty || npc.castePrivileges.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                    child: UniformHeightWrap(
                      spacing: 16.0,
                      runSpacing: 8.0,
                      allocation: UniformHeightWrapAllocation.resizeChildren,
                      children: [
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
                                    'Interdits',
                                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  if(npc.interdicts.isEmpty)
                                    Text(
                                      "Pas d'interdits",
                                      style: theme.textTheme.bodyMedium!.copyWith(
                                        color: Colors.black54,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  for(var i in npc.interdicts)
                                    Text('${i.title} (${i.caste.title})'),
                                ],
                              ),
                            ],
                          ),
                        ),
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
                                    'Privilèges',
                                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  if(npc.castePrivileges.isEmpty)
                                    Text(
                                      "Pas de privilèges",
                                      style: theme.textTheme.bodyMedium!.copyWith(
                                        color: Colors.black54,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  for(var p in npc.castePrivileges)
                                    Text(
                                      '${p.privilege.caste.title} / ${p.privilege.title} (${p.privilege.cost})${p.description == null ? "" : " : ${p.description!}"}',
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                if(npc.disadvantages.isNotEmpty || npc.advantages.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                    child: UniformHeightWrap(
                      spacing: 16.0,
                      runSpacing: 8.0,
                      allocation: UniformHeightWrapAllocation.resizeChildren,
                      children: [
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
                                    'Désavantages',
                                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  if(npc.disadvantages.isEmpty)
                                    Text(
                                      'Pas de désavantages',
                                      style: theme.textTheme.bodyMedium!.copyWith(
                                        color: Colors.black54,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  for(var d in npc.disadvantages)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${d.disadvantage.title} (${d.cost})'),
                                        if(d.details.isNotEmpty)
                                          SizedBox(
                                            width: 140,
                                            child: Text(
                                              d.details,
                                              style: theme.textTheme.bodySmall,
                                            ),
                                          ),
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
                                    'Avantages',
                                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  if(npc.advantages.isEmpty)
                                    Text(
                                      "Pas d'avantages",
                                      style: theme.textTheme.bodyMedium!.copyWith(
                                        color: Colors.black54,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  for(var a in npc.advantages)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${a.advantage.title} (${a.cost})'),
                                        if(a.details.isNotEmpty)
                                          SizedBox(
                                            width: 140,
                                            child: Text(
                                              a.details,
                                              style: theme.textTheme.bodySmall,
                                            ),
                                          ),
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 8.0),
                UniformHeightWrap(
                  spacing: 16.0,
                  runSpacing: 8.0,
                  allocation: UniformHeightWrapAllocation.resizeChildren,
                  children: [
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
                        ]
                      ),
                    ),
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
                                for(var e in npc.equipment)
                                  Text(e.name()),
                              ],
                            ),
                          ]
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black87),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Magie',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: [
                            RichText(
                                text: TextSpan(
                                    text: 'Instinctive : ',
                                    style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                        text: npc.magicSkill(MagicSkill.instinctive).toString(),
                                        style: theme.textTheme.bodyMedium,
                                      )
                                    ]
                                )
                            ),
                            RichText(
                                text: TextSpan(
                                    text: 'Invocatoire : ',
                                    style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                        text: npc.magicSkill(MagicSkill.invocatoire).toString(),
                                        style: theme.textTheme.bodyMedium,
                                      )
                                    ]
                                )
                            ),
                            RichText(
                                text: TextSpan(
                                    text: 'Sorcellerie : ',
                                    style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                        text: npc.magicSkill(MagicSkill.sorcellerie).toString(),
                                        style: theme.textTheme.bodyMedium,
                                      )
                                    ]
                                )
                            ),
                            RichText(
                                text: TextSpan(
                                    text: 'Réserve : ',
                                    style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                        text: npc.magicPool.toString(),
                                        style: theme.textTheme.bodyMedium,
                                      )
                                    ]
                                )
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                        child: UniformHeightWrap(
                          spacing: 16.0,
                          runSpacing: 8.0,
                          allocation: UniformHeightWrapAllocation.resizeChildren,
                          maxRunCount: 3,
                          children: [
                            for(var i = 0; i < 3; ++i)
                              for(var j = 0; j < 3; ++j)
                                _MagicSphereDisplayWidget(
                                  sphere: MagicSphere.values[i+j*3],
                                  value: npc.magicSphere(MagicSphere.values[i+j*3]),
                                  pool: npc.magicSpherePool(MagicSphere.values[i+j*3]),
                                ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Sorts connus',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      for(var sphere in MagicSphere.values)
                        for(var spell in npc.spells(sphere)..sort((a, b) => a.name.compareTo(b.name)))
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Image.asset('assets/images/magic/sphere-${sphere.name}-icon.png'),
                                ),
                                const SizedBox(width: 8.0),
                                Text('${spell.name} (niveau ${spell.level})'),
                              ],
                            ),
                          ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Description',
                  style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  npc.description,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MagicSphereDisplayWidget extends StatelessWidget {
  const _MagicSphereDisplayWidget({
    required this.sphere,
    required this.value,
    required this.pool,
  });

  final MagicSphere sphere;
  final int value;
  final int pool;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 32,
            height: 48,
            child: Image.asset(
              'assets/images/magic/sphere-${sphere.name}-icon.png',
            ),
          ),
          const SizedBox(width: 12.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                  text: TextSpan(
                      text: 'Niveau : ',
                      style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: value.toString(),
                          style: theme.textTheme.bodyMedium,
                        )
                      ]
                  )
              ),
              const SizedBox(height: 8.0),
              RichText(
                  text: TextSpan(
                      text: 'Réserve : ',
                      style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: pool.toString(),
                          style: theme.textTheme.bodyMedium,
                        )
                      ]
                  )
              ),
            ],
          )
        ],
      ),
    );
  }
}