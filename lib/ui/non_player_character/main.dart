import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../classes/non_player_character.dart';
import '../utils/error_feedback.dart';
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
  bool _isWorking = false;
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _subCategoryController = TextEditingController();
  final GlobalKey<FormState> _newNPCFormKey = GlobalKey();
  NPCCategory? _category;
  NPCSubCategory? _subCategory;
  bool editing = false;
  String? _selectedDisplay;
  String? _selectedEdit;
  NonPlayerCharacter? _selectedEditNPC;
  String? _newNPCName;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Widget mainArea;

    if(editing && _newNPCName != null) {
      mainArea = NPCEditWidget(
        name: _newNPCName!,
        npc: _selectedEditNPC,
        npcId: _selectedEdit,
        onEditDone: (NonPlayerCharacter? npc) {
          if(_newNPCName != null) {
            _newNPCName = null;
          }

          setState(() {
            if(npc != null) {
              _selectedDisplay = npc.id;
              _category = npc.category;
              _subCategory = npc.subCategory;
            }
            _selectedEdit = null;
            _selectedEditNPC = null;
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
                textStyle: theme.textTheme.bodySmall,
                onSelected: (NPCCategory? category) {
                  setState(() {
                    _category = category;
                    _subCategory = null;
                    _subCategoryController.clear();
                    _selectedDisplay = null;
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
                      _selectedDisplay = null;
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
                  var model = await NonPlayerCharacter.get(id);
                  if(!context.mounted) return;
                  if(model != null) {
                    displayErrorDialog(
                      context,
                      'PNJ existant',
                      'Un PNJ avec ce nom (ou un nom similaire) existe déjà'
                    );
                    return;
                  }

                  setState(() {
                    _selectedEdit = null;
                    _selectedEditNPC = null;
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
                    setState(() {
                      _isWorking = true;
                    });

                    var jsonStr = const Utf8Decoder().convert(result.files.first.bytes!);
                    var npc = NonPlayerCharacter.fromJson(json.decode(jsonStr));
                    var model = await NonPlayerCharacter.get(npc.id);
                    if(!context.mounted) return;
                    if(model != null) {
                      setState(() {
                        _isWorking = false;
                      });

                      displayErrorDialog(
                        context,
                        'PNJ existant',
                        'Un PNJ avec ce nom (ou un nom similaire) existe déjà'
                      );
                      return;
                    }

                    npc.editable = true;
                    await NonPlayerCharacter.saveLocalModel(npc);
                    setState(() {
                      _selectedDisplay = npc.id;
                      _category = npc.category;
                      _categoryController.text = npc.category.title;
                      _subCategory = npc.subCategory;
                      _subCategoryController.text = npc.subCategory.title;
                      _isWorking = false;
                    });
                  } catch (e) {
                    setState(() {
                      _isWorking = false;
                    });

                    if(!context.mounted) return;

                    displayErrorDialog(
                      context,
                      "Échec de l'import",
                      e.toString()
                    );
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
                      selected: _selectedDisplay,
                      onSelected: (String id) {
                        setState(() {
                          _selectedDisplay = id;
                        });
                      },
                    )
                  ),
                  const SizedBox(width: 12.0),
                  if(_selectedDisplay != null)
                    Expanded(
                      child: NPCDisplayWidget(
                        id: _selectedDisplay!,
                        onEditRequested: (NonPlayerCharacter npc) {
                          setState(() {
                            _newNPCName = npc.name;
                            _selectedEdit = npc.id;
                            _selectedEditNPC = npc;
                            editing = true;
                          });
                        },
                        onDelete: () async {
                          setState(() {
                            _isWorking = true;
                          });
                          try {
                            await NonPlayerCharacter.deleteLocalModel(_selectedDisplay!);
                          }
                          catch(e) {
                            if(!context.mounted) return;
                            displayErrorDialog(
                              context,
                              "Suppression impossible",
                              e.toString()
                            );
                          }
                          setState(() {
                            _isWorking = false;
                            _selectedDisplay = null;
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

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: mainArea,
        ),
        if(_isWorking)
          const Opacity(
            opacity: 0.6,
            child: ModalBarrier(
              dismissible: false,
              color: Colors.black,
            ),
          ),
        if(_isWorking)
          const Center(
              child: CircularProgressIndicator()
          ),
      ],
    );
  }
}