import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../classes/armor.dart';
import '../../classes/character/base.dart';
import '../../classes/character/injury.dart';
import '../../classes/character/skill.dart';
import '../../classes/equipment.dart';
import '../../classes/human_character.dart';
import '../../classes/magic.dart';
import '../../classes/non_player_character.dart';
import '../../classes/shield.dart';
import '../../classes/weapon.dart';
import '../utils/ability_list_display_widget.dart';
import '../utils/ability_list_edit_widget.dart';
import '../utils/advantage_picker_dialog.dart';
import '../utils/armor_picker_dialog.dart';
import '../utils/attribute_list_display_widget.dart';
import '../utils/attribute_list_edit_widget.dart';
import '../utils/caste_privilege_picker_dialog.dart';
import '../utils/character_digit_input_widget.dart';
import '../utils/disadvantage_picker_dialog.dart';
import '../utils/injuries_display_widget.dart';
import '../utils/injuries_edit_widget.dart';
import '../utils/interdict_picker_dialog.dart';
import '../utils/shield_picker_dialog.dart';
import '../utils/single_line_input_dialog.dart';
import '../utils/skill_picker_dialog.dart';
import '../utils/spell_picker_dialog.dart';
import '../utils/tendencies_display_widget.dart';
import '../utils/tendencies_edit_widget.dart';
import '../utils/weapon_picker_dialog.dart';
import '../../text_utils.dart';

class NPCMainPage extends StatefulWidget {
  const NPCMainPage({ super.key });

  @override
  State<NPCMainPage> createState() => _NPCMainPageState();
}

class _NPCMainPageState extends State<NPCMainPage> {
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _subCategoryController = TextEditingController();
  final GlobalKey<FormState> _newNPCFormKey = GlobalKey();
  NPCCategory? _category;
  NPCSubCategory? _subCategory;
  bool editing = false;
  NonPlayerCharacter? _selected;
  String? _newNPCName;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Widget mainArea;

    if(editing) {
      mainArea = _NPCEditWidget(
        npc: _selected,
        name: _newNPCName,
        onEditDone: (NonPlayerCharacter? npc) {
          if(_newNPCName != null) {
            _newNPCName = null;
          }

          setState(() {
            if(npc != null) {
              _selected = npc;
              _category = npc.category;
              _subCategory = npc.subCategory;
            }
            editing = false;
          });
        },
      );
    }
    else {
      mainArea = Column(
        children: [
          Row(
            children: [
              DropdownMenu(
                controller: _categoryController,
                label: const Text('Catégorie'),
                requestFocusOnTap: true,
                textStyle: theme.textTheme.bodySmall,
                onSelected: (NPCCategory? category) {
                  setState(() {
                    _category = category;
                    _subCategory = null;
                    _subCategoryController.clear();
                    _selected = null;
                  });
                },
                dropdownMenuEntries: NPCCategory.values
                    .map((NPCCategory c) => DropdownMenuEntry(value: c, label: c.title))
                    .toList(),
              ),
              if(_category != null)
                const SizedBox(width: 8.0),
              if(_category != null)
                DropdownMenu(
                  controller: _subCategoryController,
                  label: const Text('Sous-catégorie'),
                  requestFocusOnTap: true,
                  textStyle: theme.textTheme.bodySmall,
                  onSelected: (NPCSubCategory? subCategory) {
                    setState(() {
                      _subCategory = subCategory;
                      _selected = null;
                    });
                  },
                  dropdownMenuEntries: _category == null ?
                    <DropdownMenuEntry<NPCSubCategory>>[] :
                    NPCSubCategory.subCategoriesForCategory(_category!)
                      .map((NPCSubCategory s) => DropdownMenuEntry(value: s, label: s.title))
                      .toList(),
                ),
              const SizedBox(width: 8.0),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Nouveau PNJ'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                onPressed: () async {
                  var name = await showDialog(
                    context: context,
                    builder: (BuildContext context) => SingleLineInputDialog(
                      title: 'Nom du PNJ',
                      formKey: _newNPCFormKey,
                      hintText: 'Nom',
                    ),
                  );
                  if(!context.mounted) return;
                  if(name == null) return;

                  var id = sentenceToCamelCase(transliterateFrenchToAscii(name));
                  var model = NonPlayerCharacter.get(id);
                  if(model != null) {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('PNJ existant'),
                        content: const Text('Un PNJ avec ce nom (ou un nom similaire) existe déjà'),
                        actions: [
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    );
                    return;
                  }

                  setState(() {
                    _selected = null;
                    _newNPCName = name;
                    editing = true;
                  });
                },
              ),
              const SizedBox(width: 8.0),
              ElevatedButton.icon(
                icon: const Icon(Icons.upload),
                label: const Text('Importer un PNJ'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                onPressed: () async {
                  var result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['json'],
                  );
                  if(!context.mounted) return;
                  if(result == null) return;

                  try {
                    var jsonStr = const Utf8Decoder().convert(result.files.first.bytes!);
                    var npc = NonPlayerCharacter.fromJson(json.decode(jsonStr));
                    var model = NonPlayerCharacter.get(npc.id);
                    if(model != null) {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('PNJ existant'),
                          content: const Text('Un PNJ avec ce nom (ou un nom similaire) existe déjà'),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      );
                      return;
                    }

                    NonPlayerCharacter.saveLocalModel(npc);
                    setState(() {
                      _selected = npc;
                      _category = npc.category;
                      _categoryController.text = npc.category.title;
                      _subCategory = npc.subCategory;
                      _subCategoryController.text = npc.subCategory.title;
                    });
                  } catch (e) {
                    // TODO: notify the user that things went south
                    // TODO: catch FormatException from the UTF-8 conversion?
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          if(_category != null)
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 350,
                    child: _NPCListWidget(
                      category: _category!,
                      subCategory: _subCategory,
                      selected: _selected,
                      onSelected: (NonPlayerCharacter model) {
                        setState(() {
                          _selected = model;
                        });
                      },
                    )
                  ),
                  const SizedBox(width: 12.0),
                  if(_selected != null)
                    Expanded(
                      child: _NPCDisplayWidget(
                        npc: _selected!,
                        onEditRequested: () {
                          setState(() {
                            editing = true;
                          });
                        },
                        onCloneEditRequested: (NonPlayerCharacter clone) {
                          setState(() {
                            _selected = clone;
                            editing = true;
                          });
                        },
                        onDelete: () {
                          setState(() {
                            NonPlayerCharacter.deleteLocalModel(_selected!.id);
                            _selected = null;
                          });
                        }
                      )
                    ),
                ],
              ),
            ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: mainArea,
    );
  }
}

class _NPCListWidget extends StatefulWidget {
  const _NPCListWidget({
    required this.category,
    this.subCategory,
    required this.onSelected,
    this.selected,
  });

  final NPCCategory category;
  final NPCSubCategory? subCategory;
  final void Function(NonPlayerCharacter) onSelected;
  final NonPlayerCharacter? selected;

  @override
  State<_NPCListWidget> createState() => _NPCListWidgetState();
}

class _NPCListWidgetState extends State<_NPCListWidget> {
  late List<NonPlayerCharacter> _npcs;

  void _updateNPCList() {
    _npcs = NonPlayerCharacter.forCategory(widget.category, widget.subCategory);
    _npcs.sort((a, b) => a.id.compareTo(b.id));
  }

  @override
  void initState() {
    super.initState();
    _updateNPCList();
  }

  @override
  void didUpdateWidget(_NPCListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateNPCList();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return ListView.builder(
      itemCount: _npcs.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          color: widget.selected == _npcs[index] ?
          theme.colorScheme.surfaceVariant :
          null,
          child: InkWell(
            onTap: () {
              widget.onSelected(_npcs[index]);
            },
            child: ListTile(
              title: Text(
                _npcs[index].name,
                style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          )
        );
      }
    );
  }
}

class _NPCDisplayWidget extends StatelessWidget {
  const _NPCDisplayWidget({
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
                    Text(
                      npc.name,
                      style: theme.textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.bold,
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

class _NPCEditWidget extends StatefulWidget {
  const _NPCEditWidget({
    this.npc,
    this.name,
    required this.onEditDone,
  });

  final NonPlayerCharacter? npc;
  final String? name;
  final void Function(NonPlayerCharacter?) onEditDone;

  @override
  State<_NPCEditWidget> createState() => _NPCEditWidgetState();
}

class _NPCEditWidgetState extends State<_NPCEditWidget> {
  late final String _name;
  final TextEditingController _categoryController = TextEditingController();
  NPCCategory? _category;
  final List<NPCSubCategory> _validSubCategories = <NPCSubCategory>[];
  final TextEditingController _subCategoryController = TextEditingController();
  NPCSubCategory? _subCategory;
  bool _unique = false;
  final TextEditingController _casteController = TextEditingController();
  Caste _caste = Caste.sansCaste;
  final TextEditingController _casteStatusController = TextEditingController();
  CasteStatus _casteStatus = CasteStatus.none;
  final Map<CasteStatus, String> _casteStatusLabels = <CasteStatus, String>{};
  Map<Ability, int> _abilities = <Ability, int>{};
  Map<Attribute, int> _attributes = <Attribute, int>{};
  CharacterTendencies _tendencies = CharacterTendencies.empty();
  int _initiative = 0;
  int _luck = 0;
  int _proficiency = 0;
  int _renown = 0;
  final List<Interdict> _interdicts = <Interdict>[];
  final List<CastePrivilege> _castePrivileges = <CastePrivilege>[];
  final List<CharacterDisadvantage> _disadvantages = <CharacterDisadvantage>[];
  final List<CharacterAdvantage> _advantages = <CharacterAdvantage>[];
  final List<SkillInstance> _skills = <SkillInstance>[];
  bool _useHumanInjuryManager = false;
  final List<InjuryLevel> _injuries = <InjuryLevel>[
    InjuryLevel(
      rank: 0,
      title: 'Blessé',
      start: 0,
      end: 40,
      malus: 0,
      capacity: 3,
    ),
    InjuryLevel(
      rank: 1,
      title: 'Mort',
      start: 40,
      end: -1,
      malus: 0,
      capacity: 1,
    ),
  ];
  final List<Equipment> _equipment = <Equipment>[];
  final Map<MagicSkill, int> _magicSkills = Map.fromEntries(
    MagicSkill.values.map((MagicSkill s) => MapEntry(s, 0))
  );
  int _magicPool = 0;
  final Map<MagicSphere, int> _magicSphereSkills = Map.fromEntries(
    MagicSphere.values.map((MagicSphere s) => MapEntry(s, 0))
  );
  final Map<MagicSphere, int> _magicSpherePools = Map.fromEntries(
      MagicSphere.values.map((MagicSphere s) => MapEntry(s, 0))
  );
  final Map<MagicSphere, List<MagicSpell>> _magicSpells = <MagicSphere, List<MagicSpell>>{};
  final TextEditingController _descriptionController = TextEditingController();
  
  void _updateSubCategories() {
    _validSubCategories.clear();
    if(_category == null) return;
    _validSubCategories.addAll(
      NPCSubCategory.subCategoriesForCategory(_category!)
          .where((NPCSubCategory s) => s.categories.contains(_category))
    );
  }

  void _updateCasteStatusLabels() {
    _casteStatusLabels.clear();
    if(_caste == Caste.sansCaste) {
      _casteStatusLabels[CasteStatus.none] = Caste.statusName(Caste.sansCaste, CasteStatus.none);
    }
    else {
      for(var status in CasteStatus.values) {
        _casteStatusLabels[status] = Caste.statusName(_caste, status);
      }
    }
  }

  NonPlayerCharacter? _createNPC() {
    if(_category == null) return null;
    if(_subCategory == null) return null;

    var ret = NonPlayerCharacter.create(
      name: _name,
      category: _category!,
      subCategory: _subCategory!,
      unique: _unique,
      useHumanInjuryManager: _useHumanInjuryManager,
      caste: _caste,
      casteStatus: _casteStatus,
      description: _descriptionController.text,
      tendencies: _tendencies,
      initiative: _initiative,
      luck: _luck,
      proficiency: _proficiency,
      renown: _renown,
      interdicts: _interdicts,
      castePrivileges: _castePrivileges,
      disadvantages: _disadvantages,
      advantages: _advantages,
    );

    _abilities.forEach((a, v) => ret.setAbility(a, v));
    _attributes.forEach((a, v) => ret.setAttribute(a, v));
    if(_useHumanInjuryManager) {
      ret.injuries = fullCharacterDefaultInjuries(ret, null);
    } else {
      ret.injuries = InjuryManager(levels: _injuries);
    }
    for(var s in _skills) {
      ret.skills.add(SkillInstance.fromJson(s.toJson()));
    }
    for(var eq in _equipment) {
      ret.addEquipment(eq);
    }
    for(var s in _magicSkills.keys) {
      ret.setMagicSkill(s, _magicSkills[s]!);
    }
    ret.magicPool = _magicPool;
    for(var s in MagicSphere.values) {
      ret.setMagicSphere(s, _magicSphereSkills[s]!);
      ret.setMagicSpherePool(s, _magicSpherePools[s]!);
    }
    for(var s in _magicSpells.keys) {
      for(var spell in _magicSpells[s]!) {
        ret.addSpell(spell);
      }
    }

    return ret;
  }

  bool _saveNPC() {
    if(widget.npc == null) return false;
    if(_category == null) return false;
    if(_subCategory == null) return false;

    widget.npc!.category = _category!;
    widget.npc!.subCategory = _subCategory!;
    widget.npc!.unique = _unique;
    widget.npc!.caste = _caste;
    widget.npc!.casteStatus = _casteStatus;
    widget.npc!.description = _descriptionController.text;
    for(var a in _abilities.keys) {
      widget.npc!.abilities[a] = _abilities[a]!;
    }
    for(var a in _attributes.keys) {
      widget.npc!.attributes[a] = _attributes[a]!;
    }
    widget.npc!.tendencies = _tendencies;
    widget.npc!.initiative = _initiative;
    widget.npc!.luck = _luck;
    widget.npc!.proficiency = _proficiency;
    widget.npc!.renown = _renown;
    widget.npc!.interdicts = _interdicts;
    widget.npc!.castePrivileges = _castePrivileges;
    widget.npc!.disadvantages = _disadvantages;
    widget.npc!.advantages = _advantages;
    widget.npc!.skills.clear();
    for(var s in _skills) {
      widget.npc!.skills.add(SkillInstance.fromJson(s.toJson()));
    }
    widget.npc!.useHumanInjuryManager = _useHumanInjuryManager;
    if(_useHumanInjuryManager) {
      widget.npc!.injuries = fullCharacterDefaultInjuries(widget.npc!, null);
    } else {
      widget.npc!.injuries = InjuryManager(levels: _injuries);
    }
    widget.npc!.equipment.clear();
    for(var e in _equipment) {
      widget.npc!.equipment.add(e);
    }
    for(var s in _magicSkills.keys) {
      widget.npc!.setMagicSkill(s, _magicSkills[s]!);
    }
    widget.npc!.magicPool = _magicPool;
    for(var s in MagicSphere.values) {
      widget.npc!.setMagicSphere(s, _magicSphereSkills[s]!);
      widget.npc!.setMagicSpherePool(s, _magicSpherePools[s]!);
    }
    widget.npc!.magicSpells.clear();
    for(var s in _magicSpells.keys) {
      for(var spell in _magicSpells[s]!) {
        widget.npc!.addSpell(spell);
      }
    }

    return true;
  }

  @override void initState() {
    super.initState();

    if(widget.npc != null) {
      _name = widget.npc!.name;
      _category = widget.npc!.category;
      _subCategory = widget.npc!.subCategory;
      _updateSubCategories();
      _unique = widget.npc!.unique;
      _caste = widget.npc!.caste;
      _casteStatus = widget.npc!.casteStatus;
      _updateCasteStatusLabels();
      for(var a in Ability.values) {
        _abilities[a] = widget.npc!.abilities[a]!;
      }
      for(var a in Attribute.values) {
        _attributes[a] = widget.npc!.attributes[a]!;
      }
      _initiative = widget.npc!.initiative;
      _luck = widget.npc!.luck;
      _proficiency = widget.npc!.proficiency;
      _renown = widget.npc!.renown;
      _tendencies = CharacterTendencies.fromJson(
          json.decode(json.encode(widget.npc!.tendencies.toJson()))
      );
      _interdicts.addAll(widget.npc!.interdicts);
      _castePrivileges.addAll(widget.npc!.castePrivileges);
      _disadvantages.addAll(widget.npc!.disadvantages);
      _advantages.addAll(widget.npc!.advantages);
      for(var s in widget.npc!.skills) {
        _skills.add(SkillInstance.fromJson(s.toJson()));
      }
      _skills.sort((a, b) => a.skill.title.compareTo(b.skill.title));
      _useHumanInjuryManager = widget.npc!.useHumanInjuryManager;
      if(!_useHumanInjuryManager) {
        _injuries.clear();
        for (var level in widget.npc!.injuries.levels()) {
          _injuries.add(InjuryLevel.fromJson(level.toJson()));
        }
        _injuries.sort((InjuryLevel a, InjuryLevel b) => a.start - b.start);
      }
      for(var e in widget.npc!.equipment) {
        var eq = EquipmentFactory.instance.forgeEquipment(e.type());
        if(eq != null ) {
          _equipment.add(eq);
        }
      }
      for(var s in MagicSkill.values) {
        _magicSkills[s] = widget.npc!.magicSkill(s);
      }
      _magicPool = widget.npc!.magicPool;
      _magicSpells.clear();
      for(var s in MagicSphere.values) {
        _magicSphereSkills[s] = widget.npc!.magicSphere(s);
        _magicSpherePools[s] = widget.npc!.magicSpherePool(s);
        var spells = widget.npc!.spells(s);
        if(spells.isNotEmpty) {
          _magicSpells[s] = spells;
        }
      }
      _descriptionController.text = widget.npc!.description;
    }
    else {
      if(widget.name == null) {
        throw ArgumentError('Pas de nom fourni pour le nouveau PNJ');
      }
      _name = widget.name!;
      _abilities = Map.fromEntries(Ability.values.map((a) => MapEntry(a, 0)));
      _attributes = Map.fromEntries(Attribute.values.map((a) => MapEntry(a, 0)));
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var skillsWidgets = <Widget>[];
    for(var s in _skills) {
      var spWidgets = <Widget>[];
      for(var sp in s.specializations.keys) {
        spWidgets.add(
            Container(
              margin: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
              child: Card(
                color: theme.colorScheme.surfaceVariant,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        iconSize: 16,
                        onPressed: () {
                          setState(() {
                            s.specializations.remove(sp);
                          });
                        },
                      ),
                      Text(
                        sp.title,
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(width: 8.0),
                      SizedBox(
                        width: 80,
                        child: CharacterDigitInputWidget(
                          initialValue: s.specializations[sp]!,
                          minValue: 0,
                          onChanged: (int value) {
                            s.specializations[sp] = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
        );
      }

      skillsWidgets.add(
          Card(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            iconSize: 16,
                            onPressed: () {
                              setState(() {
                                _skills.remove(s);
                              });
                            },
                          ),
                          Text(
                            s.skill.title,
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(width: 8.0),
                          if(!s.skill.requireSpecialization)
                            SizedBox(
                              width: 80,
                              child: CharacterDigitInputWidget(
                                initialValue: s.value,
                                minValue: 0,
                                onChanged: (int value) {
                                  s.value = value;
                                },
                              ),
                            ),
                        ],
                      ),
                      if(spWidgets.isNotEmpty)
                        const SizedBox(height: 4.0),
                      ...spWidgets,
                    ],
                  )
              )
          )
      );
    }

    return Stack(
      children: [
        SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 700,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
                child: Column(
                  children: [
                    Text(
                      _name,
                      style: theme.textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownMenu(
                            controller: _categoryController,
                            initialSelection: _category,
                            requestFocusOnTap: true,
                            label: const Text('Catégorie'),
                            textStyle: theme.textTheme.bodySmall,
                            expandedInsets: EdgeInsets.zero,
                            inputDecorationTheme: InputDecorationTheme(
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.all(12.0),
                              labelStyle: theme.textTheme.labelSmall,
                            ),
                            dropdownMenuEntries: NPCCategory.values
                                .map((NPCCategory c) => DropdownMenuEntry(value: c, label: c.title))
                                .toList(),
                            onSelected: (NPCCategory? category) {
                              setState(() {
                                _category = category;
                                _subCategory = null;
                                _subCategoryController.clear();
                                _updateSubCategories();
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: DropdownMenu(
                            controller: _subCategoryController,
                            initialSelection: _subCategory,
                            requestFocusOnTap: true,
                            label: const Text('Sous-catégorie'),
                            textStyle: theme.textTheme.bodySmall,
                            expandedInsets: EdgeInsets.zero,
                            inputDecorationTheme: InputDecorationTheme(
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.all(12.0),
                              labelStyle: theme.textTheme.labelSmall,
                            ),
                            dropdownMenuEntries: _category == null ?
                              <DropdownMenuEntry<NPCSubCategory>>[] :
                              NPCSubCategory.subCategoriesForCategory(_category!)
                                .where((NPCSubCategory s) => s.categories.contains(_category))
                                .map((NPCSubCategory s) => DropdownMenuEntry(value: s, label: s.title))
                                .toList(),
                            onSelected: (NPCSubCategory? subCategory) {
                              setState(() {
                                _subCategory = subCategory;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        const Text('Unique'),
                        Switch(
                          value: _unique,
                          onChanged: (bool value) {
                            setState(() {
                              _unique = value;
                            });
                          }
                        )
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownMenu(
                            controller: _casteController,
                            initialSelection: _caste,
                            requestFocusOnTap: true,
                            label: const Text('Caste'),
                            textStyle: theme.textTheme.bodySmall,
                            expandedInsets: EdgeInsets.zero,
                            inputDecorationTheme: InputDecorationTheme(
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.all(12.0),
                              labelStyle: theme.textTheme.labelSmall,
                            ),
                            dropdownMenuEntries: Caste.values
                                .map((Caste c) => DropdownMenuEntry(value: c, label: c.title))
                                .toList(),
                            onSelected: (Caste? caste) {
                              setState(() {
                                if(caste == null) {
                                  _caste = Caste.sansCaste;
                                }
                                else {
                                  _caste = caste;
                                }
                                _casteStatus = CasteStatus.none;
                                _casteController.clear();
                                _updateCasteStatusLabels();
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: DropdownMenu(
                            controller: _casteStatusController,
                            initialSelection: _casteStatus,
                            requestFocusOnTap: true,
                            label: const Text('Statut de Caste'),
                            textStyle: theme.textTheme.bodySmall,
                            expandedInsets: EdgeInsets.zero,
                            inputDecorationTheme: InputDecorationTheme(
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.all(12.0),
                              labelStyle: theme.textTheme.labelSmall,
                            ),
                            dropdownMenuEntries: _casteStatusLabels.keys
                                .map((CasteStatus s) => DropdownMenuEntry(value: s, label: _casteStatusLabels[s]!))
                                .toList(),
                            onSelected: (CasteStatus? status) {
                              setState(() {
                                if(status == null) {
                                  _casteStatus = CasteStatus.none;
                                }
                                else {
                                  _casteStatus = status;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      'Caractéristiques & Attributs',
                      style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: AbilityListEditWidget(
                              abilities: _abilities,
                              minValue: 0,
                              maxValue: 30,
                              onAbilityChanged: (Ability ability, int value) {
                                _abilities[ability] = value;
                              }
                          ),
                        ),
                        const SizedBox(width: 20.0),
                        Expanded(
                          flex: 1,
                          child: AttributeListEditWidget(
                            attributes: _attributes,
                            minValue: 0,
                            maxValue: 30,
                            onAttributeChanged: (Attribute attribute, int value) {
                              _attributes[attribute] = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black87),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TendenciesEditWidget(
                            tendencies: _tendencies,
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 120,
                          child: Column(
                            children: [
                              SizedBox(
                                width: 120,
                                child: CharacterDigitInputWidget(
                                    initialValue: _initiative,
                                    label: 'Initiative',
                                    onChanged: (int value) {
                                      _initiative = value;
                                    }
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              SizedBox(
                                width: 120,
                                child: CharacterDigitInputWidget(
                                    initialValue: _luck,
                                    label: 'Chance',
                                    minValue: 0,
                                    maxValue: 6,
                                    onChanged: (int value) {
                                      _luck = value;
                                    }
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              SizedBox(
                                width: 120,
                                child: CharacterDigitInputWidget(
                                    initialValue: _proficiency,
                                    label: 'Maîtrise',
                                    minValue: 0,
                                    maxValue: 6,
                                    onChanged: (int value) {
                                      _proficiency = value;
                                    }
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              SizedBox(
                                width: 120,
                                child: CharacterDigitInputWidget(
                                    initialValue: _renown,
                                    label: 'Renommée',
                                    minValue: 0,
                                    maxValue: 10,
                                    onChanged: (int value) {
                                      _renown = value;
                                    }
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Interdits',
                              style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                            ),
                            for(var i in _interdicts)
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    iconSize: 20,
                                    onPressed: () {
                                      setState(() {
                                        _interdicts.remove(i);
                                      });
                                    },
                                  ),
                                  SizedBox(width: 200, child: Text('${i.title} (${i.caste.title})')),
                                ],
                              ),
                            const SizedBox(height: 16.0),
                            ElevatedButton.icon(
                              icon: const Icon(
                                Icons.add,
                                size: 16.0,
                              ),
                              style: ElevatedButton.styleFrom(
                                textStyle: theme.textTheme.bodySmall,
                              ),
                              label: const Text('Nouvel interdit'),
                              onPressed: () async {
                                var result = await showDialog<Interdict>(
                                  context: context,
                                  builder: (BuildContext context) => InterdictPickerDialog(
                                    defaultCaste: _caste != Caste.sansCaste ?
                                        _caste :
                                        null,
                                  ),
                                );
                                if(!context.mounted) return;
                                if(result == null) return;
                                setState(() {
                                  _interdicts.add(result);
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(width: 8.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Privilèges',
                              style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                            ),
                            for(var p in _castePrivileges)
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    iconSize: 20,
                                    onPressed: () {
                                      setState(() {
                                        _castePrivileges.remove(p);
                                      });
                                    },
                                  ),
                                  SizedBox(width: 200, child: Text('${p.title} (${p.cost})')),
                                ],
                              ),
                            const SizedBox(height: 16.0),
                            ElevatedButton.icon(
                              icon: const Icon(
                                Icons.add,
                                size: 16.0,
                              ),
                              style: ElevatedButton.styleFrom(
                                textStyle: theme.textTheme.bodySmall,
                              ),
                              label: const Text('Nouveau privilège'),
                              onPressed: () async {
                                var result = await showDialog<CastePrivilege>(
                                  context: context,
                                  builder: (BuildContext context) => CastePrivilegePickerDialog(
                                    defaultCaste: _caste != Caste.sansCaste ?
                                        _caste :
                                        null,
                                  ),
                                );
                                if(!context.mounted) return;
                                if(result == null) return;
                                setState(() {
                                  _castePrivileges.add(result);
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Désavantages',
                              style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                            ),
                            for(var d in _disadvantages)
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    iconSize: 20,
                                    onPressed: () {
                                      setState(() {
                                        _disadvantages.remove(d);
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: 200,
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
                            const SizedBox(height: 16.0),
                            ElevatedButton.icon(
                              icon: const Icon(
                                Icons.add,
                                size: 16.0,
                              ),
                              style: ElevatedButton.styleFrom(
                                textStyle: theme.textTheme.bodySmall,
                              ),
                              label: const Text('Nouveau désavantage'),
                              onPressed: () async {
                                var result = await showDialog<CharacterDisadvantage>(
                                  context: context,
                                  builder: (BuildContext context) => const DisadvantagePickerDialog(),
                                );
                                if(!context.mounted) return;
                                if(result == null) return;

                                setState(() {
                                  _disadvantages.add(result);
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(width: 8.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Avantages',
                              style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                            ),
                            for(var a in _advantages)
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    iconSize: 20,
                                    onPressed: () {
                                      setState(() {
                                        _advantages.remove(a);
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: 200,
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
                            const SizedBox(height: 16.0),
                            ElevatedButton.icon(
                              icon: const Icon(
                                Icons.add,
                                size: 16.0,
                              ),
                              style: ElevatedButton.styleFrom(
                                textStyle: theme.textTheme.bodySmall,
                              ),
                              label: const Text('Nouvel avantage'),
                              onPressed: () async {
                                var result = await showDialog<CharacterAdvantage>(
                                  context: context,
                                  builder: (BuildContext context) => const AdvantagePickerDialog(),
                                );
                                if(!context.mounted) return;
                                if(result == null) return;

                                setState(() {
                                  _advantages.add(result);
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      'Compétences',
                      style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12.0),
                    ...skillsWidgets,
                    if(skillsWidgets.isNotEmpty)
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
                                const FamilyAndSkillPickerDialog() // TODO: add excluded skills
                            );
                            if(skill == null) return;
                            setState(() {
                              _skills.add(SkillInstance(skill: skill, value: 0));
                              // _skills.sort((a, b) => a.skill.title.compareTo(b.skill.title));
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
                              builder: (BuildContext context) =>
                                SpecializedSkillPickerDialog(
                                  skills: Skill.values
                                      .where((Skill s) => s.requireSpecialization || _skills.any((SkillInstance si) => s == si.skill))
                                      .toList(),
                                )
                            );
                            if(skill == null) return;

                            for(var s in _skills) {
                              if(s.skill == skill.parent) {
                                setState(() {
                                  s.specializations[skill] = 0;
                                });
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      'Seuils de blessure',
                      style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        Switch(
                          value: _useHumanInjuryManager,
                          onChanged: (bool value) {
                            setState(() {
                              _useHumanInjuryManager = value;
                            });
                          },
                        ),
                        const Text('Utiliser les seuils de blessure complets'),
                      ],
                    ),
                    if(!_useHumanInjuryManager)
                      const SizedBox(height: 12.0),
                    if(!_useHumanInjuryManager)
                      InjuriesEditWidget(injuries: _injuries),
                    const SizedBox(height: 20.0),
                    Text(
                      'Équipement',
                      style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12.0),
                    for(var eq in _equipment.whereType<Weapon>())
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            iconSize: 20,
                            onPressed: () {
                              setState(() {
                                _equipment.remove(eq);
                              });
                            },
                          ),
                          Text(
                            '\u{2694} ${eq.name()}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    for(var eq in _equipment.whereType<Shield>())
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            iconSize: 20,
                            onPressed: () {
                              setState(() {
                                _equipment.remove(eq);
                              });
                            },
                          ),
                          Text(
                            '\u{1F6E1} ${eq.name()}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    for(var eq in _equipment.whereType<Armor>())
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            iconSize: 20,
                            onPressed: () {
                              setState(() {
                                _equipment.remove(eq);
                              });
                            },
                          ),
                          Text(
                            '\u{1F6E1} ${eq.name()}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    if(_equipment.isNotEmpty)
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
                          label: const Text('Nouvelle arme'),
                          onPressed: () async {
                            var id = await showDialog(
                              context: context,
                              builder: (BuildContext context) => const WeaponPickerDialog(),
                            );
                            if(!context.mounted) return;
                            if(id == null) return;

                            var eq = EquipmentFactory.instance.forgeEquipment('weapon:$id');
                            if(eq == null) return;

                            setState(() {
                              _equipment.add(eq);
                            });
                          },
                        ),
                        const SizedBox(width: 12.0),
                        ElevatedButton.icon(
                          icon: const Icon(
                            Icons.add,
                            size: 16.0,
                          ),
                          style: ElevatedButton.styleFrom(
                            textStyle: theme.textTheme.bodySmall,
                          ),
                          label: const Text('Nouveau bouclier'),
                          onPressed: () async {
                            var id = await showDialog(
                              context: context,
                              builder: (BuildContext context) => const ShieldPickerDialog(),
                            );
                            if(!context.mounted) return;
                            if(id == null) return;

                            var eq = EquipmentFactory.instance.forgeEquipment('shield:$id');
                            if(eq == null) return;

                            setState(() {
                              _equipment.add(eq);
                            });
                          },
                        ),
                        const SizedBox(width: 12.0),
                        ElevatedButton.icon(
                          icon: const Icon(
                            Icons.add,
                            size: 16.0,
                          ),
                          style: ElevatedButton.styleFrom(
                            textStyle: theme.textTheme.bodySmall,
                          ),
                          label: const Text('Nouvelle armure'),
                          onPressed: () async {
                            var id = await showDialog(
                              context: context,
                              builder: (BuildContext context) => const ArmorPickerDialog(),
                            );
                            if(!context.mounted) return;
                            if(id == null) return;

                            var eq = EquipmentFactory.instance.forgeEquipment('armor:$id');
                            if(eq == null) return;

                            setState(() {
                              _equipment.add(eq);
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      'Magie',
                      style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        Expanded(
                          child: CharacterDigitInputWidget(
                            label: 'Instinctive',
                            initialValue: _magicSkills[MagicSkill.instinctive]!,
                            minValue: 0,
                            maxValue: 30,
                            onChanged: (int value) {
                              setState(() {
                                _magicSkills[MagicSkill.instinctive] = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: CharacterDigitInputWidget(
                            label: 'Invocatoire',
                            initialValue: _magicSkills[MagicSkill.invocatoire]!,
                            minValue: 0,
                            maxValue: 30,
                            onChanged: (int value) {
                              setState(() {
                                _magicSkills[MagicSkill.invocatoire] = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: CharacterDigitInputWidget(
                            label: 'Sorcellerie',
                            initialValue: _magicSkills[MagicSkill.sorcellerie]!,
                            minValue: 0,
                            maxValue: 30,
                            onChanged: (int value) {
                              setState(() {
                                _magicSkills[MagicSkill.sorcellerie] = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: CharacterDigitInputWidget(
                            label: 'Réserve',
                            initialValue: _magicPool,
                            minValue: 0,
                            maxValue: 30,
                            onChanged: (int value) {
                              setState(() {
                                _magicPool = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      children: [
                        for(var i = 0; i < 3; ++i)
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 24, 0),
                            child: Column(
                              children: [
                                for(var j = 0; j < 3; ++j)
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                                    child: _MagicSphereEditWidget(
                                      sphere: MagicSphere.values[i+j*3],
                                      value: _magicSphereSkills[MagicSphere.values[i+j*3]]!,
                                      pool: _magicSpherePools[MagicSphere.values[i+j*3]]!,
                                      onValueChanged: (int value) {
                                        setState(() {
                                          _magicSphereSkills[MagicSphere.values[i+j*3]] = value;
                                        });
                                      },
                                      onPoolChanged: (int value) {
                                        setState(() {
                                          _magicSpherePools[MagicSphere.values[i+j*3]] = value;
                                        });
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      'Sorts',
                      style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    for(var sphere in MagicSphere.values.where((MagicSphere s) => _magicSpells.containsKey(s)))
                      for(var spell in _magicSpells[sphere]!..sort((a, b) => a.name.compareTo(b.name)))
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete),
                              iconSize: 20,
                              onPressed: () {
                                setState(() {
                                  _magicSpells[sphere]!.remove(spell);
                                });
                              },
                            ),
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Image.asset('assets/images/magic/sphere-${sphere.name}-icon.png'),
                            ),
                            const SizedBox(width: 8.0),
                            Text('${spell.name} (niveau ${spell.level})'),
                          ],
                        ),
                    const SizedBox(height: 12.0),
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.add,
                        size: 16.0,
                      ),
                      style: ElevatedButton.styleFrom(
                        textStyle: theme.textTheme.bodySmall,
                      ),
                      label: const Text('Nouveau sort'),
                      onPressed: () async {
                        var result = await showDialog<MagicSpell>(
                          context: context,
                          builder: (BuildContext context) => const MagicSpellPickerDialog(),
                        );
                        if(result == null) return;
                        setState(() {
                          if(!_magicSpells.containsKey(result.sphere)) {
                            _magicSpells[result.sphere] = <MagicSpell>[];
                          }
                          _magicSpells[result.sphere]!.add(result);
                        });
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      'Description',
                      style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(12.0),
                              error: null,
                              errorText: null,
                            ),
                            style: theme.textTheme.bodySmall,
                            minLines: 10,
                            maxLines: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
            top: 8,
            right: 12,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.cancel_outlined),
                  onPressed: () {
                    widget.onEditDone(null);
                  },
                ),
                IconButton(
                    icon: const Icon(Icons.check_circle_outline),
                    onPressed: () async {
                      NonPlayerCharacter? npc;
                      if(widget.npc == null) {
                        npc = _createNPC();
                        if(npc == null) return; // TODO: give status on why this failed
                      }
                      else {
                        if(!_saveNPC()) return; // TODO: give status on why this failed
                        npc = widget.npc;
                      }

                      npc!.editable = true;
                      await NonPlayerCharacter.saveLocalModel(npc);
                      widget.onEditDone(npc);
                    }
                )
              ],
            )
        ),
      ],
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

class _MagicSphereEditWidget extends StatefulWidget {
  const _MagicSphereEditWidget({
    required this.sphere,
    required this.value,
    required this.pool,
    required this.onValueChanged,
    required this.onPoolChanged,
  });

  final MagicSphere sphere;
  final int value;
  final int pool;
  final void Function(int) onValueChanged;
  final void Function(int) onPoolChanged;

  @override
  State<_MagicSphereEditWidget> createState() => _MagicSphereEditWidgetState();
}

class _MagicSphereEditWidgetState extends State<_MagicSphereEditWidget> {
  late int _value;
  late int _pool;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    _pool = widget.pool;
  }

  @override
  Widget build(BuildContext context) {
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
              'assets/images/magic/sphere-${widget.sphere.name}-icon.png',
            ),
          ),
          const SizedBox(width: 12.0),
          Column(
            children: [
              SizedBox(
                width: 96,
                child: CharacterDigitInputWidget(
                    label: 'Niveau',
                    initialValue: _value,
                    minValue: 0,
                    maxValue: 15,
                    onChanged: (int value) {
                      var old = _value;
                      var delta = value - old;

                      setState(() {
                        _value = value;
                        _pool = _pool + delta;
                      });

                      widget.onValueChanged(_value);
                      widget.onPoolChanged(_pool);
                    }
                ),
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                width: 96,
                child: CharacterDigitInputWidget(
                  label: 'Réserve',
                  initialValue: _pool,
                  minValue: 0,
                  maxValue: 15,
                  onChanged: (int value) {
                    setState(() {
                      _pool = value;
                    });

                    widget.onPoolChanged(_pool);
                  }
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}