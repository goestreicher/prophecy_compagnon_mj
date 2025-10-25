import 'package:flutter/material.dart';

import '../../../classes/non_player_character.dart';
import '../../../classes/npc_category.dart';
import '../../../classes/object_source.dart';
import '../../../text_utils.dart';
import '../error_feedback.dart';
import '../single_line_input_dialog.dart';
import '../character/edit_widget.dart';

class NPCCreateWidget extends StatefulWidget {
  const NPCCreateWidget({
    super.key,
    required this.onNPCCreated,
    this.source,
    this.cloneFrom
  });

  final void Function(NonPlayerCharacter?) onNPCCreated;
  final ObjectSource? source;
  final String? cloneFrom;

  @override
  State<NPCCreateWidget> createState() => _NPCCreateWidgetState();
}

class _NPCCreateWidgetState extends State<NPCCreateWidget> {
  NonPlayerCharacter? from;
  NonPlayerCharacter? npc;

  @override
  Widget build(BuildContext context) {
    if(widget.cloneFrom != null && from == null) {
      return FutureBuilder(
        future: NonPlayerCharacter.get(widget.cloneFrom!),
        builder: (BuildContext context, AsyncSnapshot<NonPlayerCharacter?> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return ErrorWidget(snapshot.error!);
          }

          if(!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text('PNJ source non trouvé'),
            );
          }

          from = snapshot.data!;
          return getNPCCreateForm();
        }
      );
    }

    if(npc == null) {
      return getNPCCreateForm();
    }

    return CharacterEditWidget(
      character: npc!,
      onEditDone: (bool result) async {
        if(result) {
          await NonPlayerCharacter.saveLocalModel(npc!);
        }
        else {
          NonPlayerCharacter.removeFromCache(npc!.id);
        }

        widget.onNPCCreated(npc);
      }
    );
  }

  Widget getNPCCreateForm() {
    return Center(
      child: SizedBox(
        width: 400,
        child: SizedBox(
          child: _NPCCreateForm(
            source: widget.source ?? ObjectSource.local,
            cloneFrom: from,
            onNPCCreated: (NonPlayerCharacter? n) {
              if(n == null) {
                widget.onNPCCreated(null);
              }
              else {
                setState(() {
                  npc = n;
                });
              }
            },
          ),
        ),
      ),
    );
  }
}

class _NPCCreateForm extends StatefulWidget {
  const _NPCCreateForm({
    required this.source,
    required this.onNPCCreated,
    this.cloneFrom,
  });

  final ObjectSource source;
  final void Function(NonPlayerCharacter?) onNPCCreated;
  final NonPlayerCharacter? cloneFrom;

  @override
  State<_NPCCreateForm> createState() => _NPCCreateFormState();
}

class _NPCCreateFormState extends State<_NPCCreateForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController subCategoryController = TextEditingController();

  NPCCategory? category;
  String? createCategoryName;

  final List<NPCSubCategory> validSubCategories = <NPCSubCategory>[];
  NPCSubCategory? subCategory;
  String? createSubCategoryName;

  @override
  void initState() {
    super.initState();

    category = widget.cloneFrom?.category;
    subCategory = widget.cloneFrom?.subCategory;
    nameController.text = widget.cloneFrom != null
        ? '${widget.cloneFrom!.name} (clone)'
        : '';

    updateSubCategories();
  }

  void updateSubCategories() {
    validSubCategories.clear();
    if(category == null) return;
    validSubCategories.addAll(
        NPCSubCategory.subCategoriesForCategory(category!)
            .where((NPCSubCategory s) => s.categories.contains(category))
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var subCategoryDropdownMenuEntries = <DropdownMenuEntry<NPCSubCategory>>[];
    if(category != null) {
      subCategoryDropdownMenuEntries.addAll(
          NPCSubCategory.subCategoriesForCategory(category!)
              .where((NPCSubCategory s) => s.categories.contains(category))
              .map((NPCSubCategory s) => DropdownMenuEntry(value: s, label: s.title))
      );

      if(subCategoryDropdownMenuEntries.isEmpty) {
        subCategoryDropdownMenuEntries.add(
            DropdownMenuEntry(
              value: NPCSubCategory.createNewSubCategory,
              label: NPCSubCategory.createNewSubCategory.title,
              leadingIcon: const Icon(Icons.add),
            )
        );
      }
    }

    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12.0,
        children: [
          TextFormField(
            controller: nameController,
            autofocus: true,
            decoration: InputDecoration(
              label: const Text('Nom'),
            ),
            validator: (String? value) {
              if(value == null || value.isEmpty) {
                return 'La valeur est obligatoire';
              }

              return null;
            },
          ),
          DropdownMenuFormField(
            controller: categoryController,
            initialSelection: widget.cloneFrom?.category,
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
            enableSearch: true,
            enableFilter: true,
            filterCallback: (List<DropdownMenuEntry<NPCCategory>> entries, String filter) {
              if(filter.isEmpty || (category != null && filter == category!.title)) {
                return entries;
              }

              String lcFilter = filter.toLowerCase();
              var ret = entries
                  .where(
                      (DropdownMenuEntry<NPCCategory> c) =>
                          c.label.toLowerCase().contains(lcFilter)
                  )
                  .toList();

              if(ret.isEmpty) {
                createCategoryName = filter;
                ret.add(
                  DropdownMenuEntry(
                    value: NPCCategory.createNewCategory,
                    label: 'Créer "$filter"',
                    leadingIcon: const Icon(Icons.add)
                  )
                );
              }

              return ret;
            },
            onSelected: (NPCCategory? c) {
              setState(() {
                if(createCategoryName != null && c == NPCCategory.createNewCategory) {
                  c = NPCCategory(title: createCategoryName!);
                  createCategoryName = null;
                }
                else {
                  category = c;
                }
                subCategory = null;
                subCategoryController.clear();
                updateSubCategories();
              });
            },
            validator: (NPCCategory? value) {
              if(value == null) {
                return 'Valeur manquante';
              }
              return null;
            },
          ),
          DropdownMenuFormField(
            controller: subCategoryController,
            initialSelection: widget.cloneFrom?.subCategory,
            requestFocusOnTap: true,
            label: const Text('Sous-catégorie'),
            textStyle: theme.textTheme.bodySmall,
            expandedInsets: EdgeInsets.zero,
            inputDecorationTheme: InputDecorationTheme(
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.all(12.0),
              labelStyle: theme.textTheme.labelSmall,
            ),
            dropdownMenuEntries: subCategoryDropdownMenuEntries,
            enableSearch: true,
            enableFilter: true,
            filterCallback: (List<DropdownMenuEntry<NPCSubCategory>> entries, String filter) {
              if(filter.isEmpty || (subCategory != null && filter == subCategory!.title)) {
                return entries;
              }

              String lcFilter = filter.toLowerCase();
              var ret = entries
                  .where((DropdownMenuEntry<NPCSubCategory> c) =>
              c.value != NPCSubCategory.createNewSubCategory
                  && c.label.toLowerCase().contains(lcFilter)
              )
                  .toList();

              if(ret.isEmpty) {
                createSubCategoryName = filter;
                ret.add(
                    DropdownMenuEntry(
                        value: NPCSubCategory.createNewSubCategory,
                        label: 'Créer "$filter"',
                        leadingIcon: const Icon(Icons.add)
                    )
                );
              }

              return ret;
            },
            onSelected: (NPCSubCategory? s) async {
              NPCSubCategory? sub;

              if(s == NPCSubCategory.createNewSubCategory) {
                if(createSubCategoryName != null) {
                  sub = NPCSubCategory(
                    title: createSubCategoryName!,
                    categories: [category!],
                  );
                  createSubCategoryName = null;
                }
                else {
                  var name = await showDialog(
                    context: context,
                    builder: (BuildContext context) => SingleLineInputDialog(
                      title: 'Nom de la sous-catégorie',
                      hintText: 'Nom',
                      formKey: GlobalKey<FormState>(),
                    ),
                  );
                  if(!context.mounted) return;
                  if(name == null) return;
                  sub = NPCSubCategory(
                    title: name,
                    categories: [category!],
                  );
                }
              }
              else {
                sub = s;
              }

              setState(() {
                subCategory = sub;
              });
            },
            validator: (NPCSubCategory? value) {
              if(value == null) {
                return 'Valeur manquante';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    widget.onNPCCreated(null);
                  },
                  child: const Text('Annuler'),
                ),
                const SizedBox(width: 12.0),
                ElevatedButton(
                  onPressed: () async {
                    if(!formKey.currentState!.validate()) {
                      return;
                    }

                    var id = sentenceToCamelCase(transliterateFrenchToAscii(nameController.text));
                    var model = await NonPlayerCharacter.get(id);
                    if(!context.mounted) return;
                    if(model != null) {
                      displayErrorDialog(
                        context,
                        'PNJ existant',
                        'Un PNJ par défaut avec ce nom (ou un nom similaire) existe déjà'
                      );
                      return;
                    }

                    NonPlayerCharacter npc;

                    if(widget.cloneFrom == null) {
                      npc = NonPlayerCharacter(
                        source: widget.source,
                        name: nameController.text,
                        category: category!,
                        subCategory: subCategory!
                      );
                    }
                    else {
                      npc = widget.cloneFrom!.clone(
                        nameController.text,
                        source: widget.source
                      );
                      npc.source = widget.source;
                      npc.category = category!;
                      npc.subCategory = subCategory!;
                    }

                    widget.onNPCCreated(npc);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  child: const Text('OK'),
                )
              ],
            )
          )
        ],
      ),
    );
  }
}