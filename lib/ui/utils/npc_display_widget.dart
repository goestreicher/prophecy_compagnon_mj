import 'dart:convert';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';

import '../../classes/character/base.dart';
import '../../classes/magic.dart';
import '../../classes/non_player_character.dart';
import 'ability_list_display_widget.dart';
import 'attribute_list_display_widget.dart';
import 'injuries_display_widget.dart';
import 'single_line_input_dialog.dart';
import 'tendencies_display_widget.dart';

class NPCDisplayWidget extends StatelessWidget {
  const NPCDisplayWidget({
    super.key,
    required this.npc,
    required this.onEditRequested,
    required this.onCloneEditRequested,
    required this.onDelete,
  });

  final NonPlayerCharacter npc;
  final void Function() onEditRequested;
  final void Function(NonPlayerCharacter) onCloneEditRequested;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
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

    return Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 24.0, 12.0, 12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        npc.name,
                        softWrap: true,
                        style: theme.textTheme.headlineMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      tooltip: !npc.editable ?
                      'Modification impossible (PNJ par défaut)' :
                      'Modifier',
                      onPressed: !npc.editable ? null : () => onEditRequested(),
                    ),
                    const SizedBox(width: 8.0),
                    IconButton(
                      icon: const Icon(Icons.content_copy_outlined),
                      tooltip: 'Cloner',
                      onPressed: () async {
                        var name = await showDialog(
                          context: context,
                          builder: (BuildContext context) => SingleLineInputDialog(
                            title: 'Nom du PNJ',
                            hintText: 'Nom',
                            formKey: GlobalKey<FormState>(),
                          ),
                        );
                        if(!context.mounted) return;
                        if(name == null) return;

                        var jsonObj = npc.toJson();
                        jsonObj['name'] = name;
                        // The round-trip through json.encode and json.decode seems necessary
                        // to ensure that the full object in converted, otherwise List elements
                        // are not correctly converted to JSON
                        onCloneEditRequested(
                            NonPlayerCharacter.fromJson(
                                json.decode(json.encode(jsonObj))
                            )
                        );
                      },
                    ),
                    const SizedBox(width: 8.0),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: !npc.editable ?
                      'Suppression impossible (PNJ par défaut)' :
                      'Supprimer',
                      onPressed: !npc.editable ? null : () => onDelete(),
                    ),
                    const SizedBox(width: 8.0),
                    IconButton(
                      icon: const Icon(Icons.download),
                      tooltip: 'Télécharger (JSON)',
                      onPressed: () async {
                        var jsonStr = json.encode(npc.toJson());
                        await FileSaver.instance.saveFile(
                          name: 'pnj-${npc.id}.json',
                          bytes: utf8.encode(jsonStr),
                        );
                      },
                    ),
                  ]
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
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
                  const SizedBox(width: 8.0),
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
                  const SizedBox(width: 8.0),
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
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const SizedBox(width: 8.0),
                  AbilityListDisplayWidget(abilities: npc.abilities),
                  const SizedBox(width: 32.0),
                  AttributeListDisplayWidget(attributes: npc.attributes),
                ],
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
                child: Row(
                  children: [
                    TendenciesDisplayWidget(tendencies: npc.tendencies),
                    const SizedBox(width: 16),
                    Column(
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
              const SizedBox(height: 8.0),
              if(npc.interdicts.isNotEmpty || npc.castePrivileges.isNotEmpty)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Interdits',
                            style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          if(npc.interdicts.isEmpty)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                              child: Text(
                                "Pas d'interdits",
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: Colors.black54,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          for(var i in npc.interdicts)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                              child: Text('${i.title} (${i.caste.title})'),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    SizedBox(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Privilèges',
                            style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          if(npc.castePrivileges.isEmpty)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                              child: Text(
                                "Pas de privilèges",
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: Colors.black54,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          for(var p in npc.castePrivileges)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                              child: Text('${p.title} / ${p.caste.title} (${p.cost})'),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 8.0),
              if(npc.disadvantages.isNotEmpty || npc.advantages.isNotEmpty)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Désavantages',
                            style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          if(npc.disadvantages.isEmpty)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                              child: Text(
                                'Pas de désavantages',
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: Colors.black54,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          for(var d in npc.disadvantages)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                              child: Column(
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
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    SizedBox(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Avantages',
                            style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          if(npc.advantages.isEmpty)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                              child: Text(
                                "Pas d'avantages",
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: Colors.black54,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          for(var a in npc.advantages)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                              child: Column(
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
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 8.0),
              Text(
                'Compétences',
                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              for(var skill in skillsOrder)
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                  child: Text('$skill ${skills[skill]}'),
                ),
              const SizedBox(height: 8.0),
              Text(
                'Seuils de blessure',
                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                child: InjuriesDisplayWidget(injuries: npc.injuries.levels()),
              ),
              if(npc.equipment.isNotEmpty)
                const SizedBox(height: 8.0),
              if(npc.equipment.isNotEmpty)
                Text(
                  'Équipement',
                  style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
              for(var e in npc.equipment)
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                  child: Text(e.name()),
                ),
              const SizedBox(height: 8.0),
              Text(
                'Magie',
                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                child: Row(
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
                    const SizedBox(width: 8.0),
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
                    const SizedBox(width: 8.0),
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
                    const SizedBox(width: 8.0),
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
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                child: Row(
                  children: [
                    for(var i = 0; i < 3; ++i)
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 24, 0),
                        child: Column(
                          children: [
                            for(var j = 0; j < 3; ++j)
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                                child: _MagicSphereDisplayWidget(
                                  sphere: MagicSphere.values[i+j*3],
                                  value: npc.magicSphere(MagicSphere.values[i+j*3]),
                                  pool: npc.magicSpherePool(MagicSphere.values[i+j*3]),
                                ),
                              ),
                          ],
                        ),
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
        )
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