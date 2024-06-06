import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../classes/non_player_character.dart';
import '../utils/npc_display_widget.dart';
import '../utils/npc_edit_widget.dart';
import '../utils/npc_list_widget.dart';
import '../utils/single_line_input_dialog.dart';
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
      mainArea = NPCEditWidget(
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
                    child: NPCListWidget(
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
                      child: NPCDisplayWidget(
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