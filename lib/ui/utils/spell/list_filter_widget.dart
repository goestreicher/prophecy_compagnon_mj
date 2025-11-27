import 'package:flutter/material.dart';
import 'package:prophecy_compagnon_mj/classes/magic_spell.dart';

import '../../../classes/magic.dart';
import '../../../classes/object_source.dart';

class SpellListFilterWidget extends StatefulWidget {
  const SpellListFilterWidget({
    super.key,
    required this.onFilterChanged,
    this.filter,
  });

  final void Function(MagicSpellFilter) onFilterChanged;
  final MagicSpellFilter? filter;

  @override
  State<SpellListFilterWidget> createState() => _SpellListFilterWidgetState();
}

class _SpellListFilterWidgetState extends State<SpellListFilterWidget> {
  final TextEditingController sourceTypeController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController skillController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  late MagicSpellFilter currentFilter;

  @override
  void initState() {
    super.initState();

    currentFilter = widget.filter ?? MagicSpellFilter();
    sourceTypeController.text = currentFilter.sourceType?.title ?? '';
    sourceController.text = currentFilter.source?.name ?? '';
    skillController.text = currentFilter.skill?.title ?? '';
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
          controller: skillController,
          label: Text(
            'Discipline',
            style: theme.textTheme.bodySmall,
          ),
          textStyle: theme.textTheme.bodySmall,
          initialSelection: currentFilter.skill,
          leadingIcon: currentFilter.skill == null
              ? null
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      skillController.clear();
                      currentFilter.skill = null;
                    });
                    widget.onFilterChanged(currentFilter);
                  },
                  child: Icon(Icons.cancel, size: 16.0,)
                ),
          onSelected: (MagicSkill? skill) {
            setState(() {
              currentFilter.skill = skill;
            });
            widget.onFilterChanged(currentFilter);
          },
          dropdownMenuEntries: MagicSkill.values
            .map(
              (MagicSkill s) => DropdownMenuEntry(
                value: s,
                label: s.title
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
                widget.onFilterChanged(currentFilter);
              }
            },
          ),
        ),
      ],
    );
  }
}