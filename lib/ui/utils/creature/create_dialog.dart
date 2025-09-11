import 'package:flutter/material.dart';

import '../../../classes/creature.dart';
import '../../../classes/object_source.dart';
import '../../../text_utils.dart';
import '../error_feedback.dart';

class CreatureCreateDialog extends StatefulWidget {
  const CreatureCreateDialog({ super.key, required this.source, this.cloneFrom });

  final ObjectSource source;
  final CreatureModel? cloneFrom;

  @override
  State<CreatureCreateDialog> createState() => _CreatureCreateDialogState();
}

class _CreatureCreateDialogState extends State<CreatureCreateDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  CreatureCategory? currentCategory;
  String? createCategoryName;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Nouvelle créature'),
      content: Form(
        key: formKey,
        child: SizedBox(
          width: 400,
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
                dropdownMenuEntries: CreatureCategory.values
                    .map((CreatureCategory c) => DropdownMenuEntry(value: c, label: c.title))
                    .toList(),
                enableSearch: true,
                enableFilter: true,
                filterCallback: (List<DropdownMenuEntry<CreatureCategory>> entries, String filter) {
                  if(filter.isEmpty || filter == currentCategory?.title) {
                    return entries;
                  }

                  String lcFilter = filter.toLowerCase();
                  var ret = entries
                      .where((DropdownMenuEntry<CreatureCategory> c) =>
                      c.label.toLowerCase().contains(lcFilter)
                  )
                      .toList();

                  if(ret.isEmpty) {
                    createCategoryName = filter;
                    ret.add(DropdownMenuEntry(
                        value: CreatureCategory.createNewCreatureCategory,
                        label: 'Créer "$filter"',
                        leadingIcon: const Icon(Icons.add)),
                    );
                  }

                  return ret;
                },
                onSelected: (CreatureCategory? c) {
                  setState(() {
                    if(createCategoryName != null && c == CreatureCategory.createNewCreatureCategory) {
                      c = CreatureCategory(title: createCategoryName!);
                      createCategoryName = null;
                    }
                    else {
                      currentCategory = c;
                    }
                  });
                },
                validator: (CreatureCategory? value) {
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
                        Navigator.of(context).pop();
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
                        var model = await CreatureModel.get(id);
                        if(!context.mounted) return;
                        if(model != null) {
                          displayErrorDialog(
                              context,
                              'Créature existante',
                              'Une créature par défaut avec ce nom (ou un nom similaire) existe déjà'
                          );
                          return;
                        }

                        CreatureModel creature;

                        if(widget.cloneFrom == null) {
                          creature = CreatureModel(
                            source: widget.source,
                            name: nameController.text,
                            category: currentCategory!,
                            initiative: 1,
                            size: 0.8,
                            biome: '',
                            realSize: '',
                            weight: '',
                            naturalArmor: 0,
                          );
                        }
                        else {
                          creature = widget.cloneFrom!.clone(nameController.text);
                          creature.source = widget.source;
                          creature.category = currentCategory!;
                        }

                        Navigator.of(context).pop(creature);
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
        ),
      ),
    );
  }
}