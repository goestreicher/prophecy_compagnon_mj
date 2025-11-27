import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../classes/creature.dart';
import '../../widget_group_container.dart';

class CreatureEditGeneralWidget extends StatefulWidget {
  const CreatureEditGeneralWidget({ super.key, required this.creature });

  final Creature creature;

  @override
  State<CreatureEditGeneralWidget> createState() => _CreatureEditGeneralWidgetState();
}

class _CreatureEditGeneralWidgetState extends State<CreatureEditGeneralWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController mapSizeController = TextEditingController();
  final TextEditingController biomeController = TextEditingController();

  late CreatureCategory currentCategory;
  String? createCategoryName;

  @override
  void initState() {
    super.initState();

    nameController.text = widget.creature.name;
    currentCategory = widget.creature.category;
    sizeController.text = widget.creature.realSize;
    weightController.text = widget.creature.weight;
    mapSizeController.text = widget.creature.size.toStringAsFixed(2);
    biomeController.text = widget.creature.biome;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Général',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        )
      ),
      child: Column(
        spacing: 12.0,
        children: [
          Row(
            spacing: 16.0,
            children: [
              Expanded(
                child: TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    label: Text('Nom'),
                    border: OutlineInputBorder(),
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(12.0),
                  ),
                  style: theme.textTheme.bodySmall,
                  validator: (String? value) {
                    if(value == null || value.isEmpty) {
                      return 'Valeur manquante';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (String? value) => widget.creature.name = nameController.text,
                ),
              ),
              Expanded(
                child: DropdownMenuFormField(
                  controller: categoryController,
                  initialSelection: widget.creature.category,
                  requestFocusOnTap: true,
                  label: const Text('Catégorie'),
                  textStyle: theme.textTheme.bodySmall,
                  expandedInsets: EdgeInsets.zero,
                  inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(),
                    isCollapsed: true,
                    constraints: BoxConstraints(maxHeight: 36.0),
                    contentPadding: EdgeInsets.all(12.0),
                  ),
                  dropdownMenuEntries: CreatureCategory.values
                      .map((CreatureCategory c) => DropdownMenuEntry(value: c, label: c.title))
                      .toList(),
                  enableSearch: true,
                  enableFilter: true,
                  filterCallback: (List<DropdownMenuEntry<CreatureCategory>> entries, String filter) {
                    if(filter.isEmpty || filter == currentCategory.title) {
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
                        value: CreatureCategory.createNewCategory,
                        label: 'Créer "$filter"',
                        leadingIcon: const Icon(Icons.add)),
                      );
                    }

                    return ret;
                  },
                  onSelected: (CreatureCategory? category) {
                    setState(() {
                      if(category == CreatureCategory.createNewCategory) {
                        widget.creature.category = CreatureCategory(title: createCategoryName!);
                      }
                      else if(category != null) {
                        widget.creature.category = category;
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
              ),
            ],
          ),
          Row(
            spacing: 16.0,
            children: [
              Expanded(
                child: TextFormField(
                  controller: sizeController,
                  decoration: const InputDecoration(
                    label: Text('Taille'),
                    border: OutlineInputBorder(),
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(12.0),
                  ),
                  style: theme.textTheme.bodySmall,
                  validator: (String? value) {
                    if(value == null || value.isEmpty) {
                      return 'Valeur manquante';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (String? value) => widget.creature.realSize = sizeController.text,
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: weightController,
                  decoration: const InputDecoration(
                    label: Text('Poids'),
                    border: OutlineInputBorder(),
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(12.0),
                  ),
                  style: theme.textTheme.bodySmall,
                  validator: (String? value) {
                    if(value == null || value.isEmpty) {
                      return 'Valeur manquante';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (String? value) => widget.creature.weight = weightController.text,
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: mapSizeController,
                  decoration: const InputDecoration(
                    label: Text('Taille sur la carte (m)'),
                    border: OutlineInputBorder(),
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(12.0),
                    // error: null,
                    // errorText: null,
                  ),
                  style: theme.textTheme.bodySmall,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[.0-9]')),
                  ],
                  validator: (String? value) {
                    if(value == null || value.isEmpty) return 'Valeur manquante';
                    double? input = double.tryParse(value);
                    if(input == null) return 'Pas un nombre';
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (String? value) => widget.creature.size = double.parse(value!),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: biomeController,
                  decoration: const InputDecoration(
                    label: Text('Habitat'),
                    border: OutlineInputBorder(),
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(12.0),
                    // error: null,
                    // errorText: null,
                  ),
                  style: theme.textTheme.bodySmall,
                  validator: (String? value) {
                    if(value == null || value.isEmpty) {
                      return 'Valeur manquante';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (String? value) => widget.creature.biome = biomeController.text,
                ),
              ),
              const SizedBox(width: 16.0),
              Switch(
                value: widget.creature.unique,
                onChanged: (bool value) => setState(() {
                  widget.creature.unique = value;
                }),
              ),
              const Text('Créature unique'),
            ],
          ),
        ],
      )
    );
  }
}