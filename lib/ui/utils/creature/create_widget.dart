import 'package:flutter/material.dart';

import '../../../classes/creature.dart';
import '../../../classes/object_source.dart';
import '../../../text_utils.dart';
import '../error_feedback.dart';
import 'edit_widget.dart';

class CreatureCreateWidget extends StatefulWidget {
  const CreatureCreateWidget({
    super.key,
    required this.onCreatureCreated,
    this.source,
    this.cloneFrom,
  });

  final void Function(Creature?) onCreatureCreated;
  final ObjectSource? source;
  final String? cloneFrom;

  @override
  State<CreatureCreateWidget> createState() => _CreatureCreateWidgetState();
}

class _CreatureCreateWidgetState extends State<CreatureCreateWidget> {
  Creature? from;
  Creature? creature;

  @override
  Widget build(BuildContext context) {
    if(widget.cloneFrom != null && from == null) {
      return FutureBuilder(
        future: Creature.get(widget.cloneFrom!),
        builder: (BuildContext context, AsyncSnapshot<Creature?> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return ErrorWidget(snapshot.error!);
          }

          if(!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text('Créature source non trouvée'),
            );
          }

          from = snapshot.data!;
          return getCreatureCreateForm();
        }
      );
    }

    if(creature == null) {
      return getCreatureCreateForm();
    }

    return CreatureEditWidget(
      creature: creature!,
      onEditDone: (bool result) async {
        if(result) {
          await Creature.saveLocalModel(creature!);
        }
        else {
          Creature.removeFromCache(creature!.id);
        }

        widget.onCreatureCreated(creature);
      }
    );
  }

  Widget getCreatureCreateForm() {
    return Center(
      child: SizedBox(
        width: 400,
        child: SizedBox(
          child: _CreatureCreateForm(
            source: widget.source ?? ObjectSource.local,
            cloneFrom: from,
            onCreatureCreated: (Creature? c) {
              if(c == null) {
                widget.onCreatureCreated(null);
              }
              else {
                setState(() {
                  creature = c;
                });
              }
            },
          ),
        ),
      ),
    );
  }
}

class _CreatureCreateForm extends StatefulWidget {
  const _CreatureCreateForm({
    required this.source,
    required this.onCreatureCreated,
    this.cloneFrom,
  });

  final ObjectSource source;
  final void Function(Creature?) onCreatureCreated;
  final Creature? cloneFrom;

  @override
  State<_CreatureCreateForm> createState() => _CreatureCreateFormState();
}

class _CreatureCreateFormState extends State<_CreatureCreateForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  CreatureCategory? currentCategory;
  String? createCategoryName;

  @override
  void initState() {
    super.initState();

    currentCategory = widget.cloneFrom?.category;
    nameController.text = widget.cloneFrom != null
        ? '${widget.cloneFrom!.name} (clone)'
        : '';
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

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
            initialSelection: currentCategory,
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
                .map(
                    (CreatureCategory c) => DropdownMenuEntry(
                        value: c,
                        label: c.title
                    )
                )
                .toList(),
            enableSearch: true,
            enableFilter: true,
            filterCallback: (List<DropdownMenuEntry<CreatureCategory>> entries, String filter) {
              if(filter.isEmpty || filter == currentCategory?.title) {
                return entries;
              }

              String lcFilter = filter.toLowerCase();
              var ret = entries
                  .where(
                      (DropdownMenuEntry<CreatureCategory> c) =>
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
                    widget.onCreatureCreated(null);
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
                    var model = await Creature.get(id);
                    if(!context.mounted) return;
                    if(model != null) {
                      displayErrorDialog(
                        context,
                        'Créature existante',
                        'Une créature par défaut avec ce nom (ou un nom similaire) existe déjà'
                      );
                      return;
                    }

                    Creature creature;

                    if(widget.cloneFrom == null) {
                      creature = Creature(
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
                      creature = widget.cloneFrom!.clone(
                        nameController.text,
                        source: widget.source,
                      );
                      creature.category = currentCategory!;
                    }

                    widget.onCreatureCreated(creature);
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