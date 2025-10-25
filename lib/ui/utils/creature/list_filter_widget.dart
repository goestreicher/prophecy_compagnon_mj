import 'package:flutter/material.dart';

import '../../../classes/creature.dart';
import '../../../classes/object_source.dart';
import 'list_filter.dart';

class CreatureListFilterWidget extends StatefulWidget {
  const CreatureListFilterWidget({
    super.key,
    required this.onFilterChanged,
    this.filter,
  });

  final void Function(CreatureListFilter) onFilterChanged;
  final CreatureListFilter? filter;

  @override
  State<CreatureListFilterWidget> createState() => _CreatureListFilterWidgetState();
}

class _CreatureListFilterWidgetState extends State<CreatureListFilterWidget> {
  final TextEditingController sourceTypeController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  late CreatureListFilter currentFilter;

  @override
  void initState() {
    super.initState();

    currentFilter = widget.filter ?? CreatureListFilter();
    sourceTypeController.text = currentFilter.sourceType?.title ?? '';
    sourceController.text = currentFilter.source?.name ?? '';
    categoryController.text = currentFilter.category?.title ?? '';
    searchController.text = currentFilter.search ?? '';
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16.0,
      runSpacing: 8.0,
      children: [
        DropdownMenu(
          controller: sourceTypeController,
          label: Text(
            'Type de source',
            style: theme.textTheme.bodySmall,
          ),
          textStyle: theme.textTheme.bodySmall,
          initialSelection: currentFilter.sourceType,
          leadingIcon: currentFilter.sourceType == null
              ? null
              : GestureDetector(
              onTap: () {
                setState(() {
                  sourceTypeController.clear();
                  currentFilter.sourceType = null;
                  sourceController.clear();
                  currentFilter.source = null;
                });
                widget.onFilterChanged(currentFilter);
              },
              child: Icon(Icons.cancel, size: 16.0,)
          ),
          onSelected: (ObjectSourceType? sourceType) {
            setState(() {
              currentFilter.sourceType = sourceType;
              sourceController.clear();
              currentFilter.source = null;
            });
            widget.onFilterChanged(currentFilter);
          },
          dropdownMenuEntries: ObjectSourceType.values
              .map(
                  (ObjectSourceType s) => DropdownMenuEntry(
                      value: s,
                      label: s.title
                  )
              )
              .toList(),
        ),
        DropdownMenu(
          controller: sourceController,
          enabled: currentFilter.sourceType != null,
          label: Text(
            'Source',
            style: theme.textTheme.bodySmall,
          ),
          textStyle: theme.textTheme.bodySmall,
          initialSelection: currentFilter.source,
          leadingIcon: currentFilter.source == null
              ? null
              : GestureDetector(
              onTap: () {
                setState(() {
                  sourceController.clear();
                  currentFilter.source = null;
                });
                widget.onFilterChanged(currentFilter);
              },
              child: Icon(Icons.cancel, size: 16.0,)
          ),
          onSelected: (ObjectSource? source) {
            setState(() {
              currentFilter.source = source;
            });
            widget.onFilterChanged(currentFilter);
          },
          dropdownMenuEntries: currentFilter.sourceType == null
              ? <DropdownMenuEntry<ObjectSource>>[]
              : ObjectSource.forType(currentFilter.sourceType!)
                  .map(
                      (ObjectSource s) => DropdownMenuEntry(
                          value: s,
                          label: s.name
                      )
                  )
                  .toList(),
        ),
        DropdownMenu(
          controller: categoryController,
          label: Text(
            'Catégorie',
            style: theme.textTheme.bodySmall,
          ),
          textStyle: theme.textTheme.bodySmall,
          initialSelection: currentFilter.category,
          leadingIcon: currentFilter.category == null
              ? null
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      categoryController.clear();
                      currentFilter.category = null;
                    });
                    widget.onFilterChanged(currentFilter);
                  },
              child: Icon(Icons.cancel, size: 16.0,)
          ),
          onSelected: (CreatureCategory? category) {
            setState(() {
              currentFilter.category = category;
            });
            widget.onFilterChanged(currentFilter);
          },
          dropdownMenuEntries: CreatureCategory.values
              .map(
                  (CreatureCategory c) => DropdownMenuEntry(
                      value: c,
                      label: c.title
                  )
              )
              .toList(),
        ),
        SizedBox(
          width: 200.0,
          child: TextField(
            controller: searchController,
            style: theme.textTheme.bodySmall,
            decoration: InputDecoration(
              labelText: 'Recherche',
              labelStyle: theme.textTheme.bodySmall,
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.search),
              prefixIcon: currentFilter.search == null
                  ? null
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          searchController.clear();
                          currentFilter.search = null;
                        });
                        widget.onFilterChanged(currentFilter);
                        FocusScope.of(context).unfocus();
                      },
                  child: Icon(Icons.cancel, size: 16.0,)
              ),
            ),
            onSubmitted: (String? value) {
              if(value == null || value.length >= 3) {
                setState(() {
                  currentFilter.search = value;
                });
              }
            },
          ),
        ),
      ],
    );
  }
}