import 'package:flutter/material.dart';

import '../../../classes/magic_spell.dart';

class SpellsListWidget extends StatelessWidget {
  const SpellsListWidget({
    super.key,
    required this.spells,
    this.selected,
    required this.onSelected,
  });

  final List<MagicSpell> spells;
  final String? selected;
  final void Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var spellsWidgets = <Widget>[];

    for(var i = 1; i <= 3; ++i) {
      var s = spells.where((MagicSpell spell) => spell.level == i);

      if(s.isNotEmpty) {
        spellsWidgets.add(
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              'Niveau $i',
              style: theme.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          )
        );

        spellsWidgets.addAll(
          s.map(
            (MagicSpell spell) => Card(
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              color: selected == spell.id ?
              theme.colorScheme.surfaceContainerHighest :
              null,
              child: InkWell(
                onTap: () {
                  onSelected(spell.id);
                },
                child: ListTile(
                  title: Text(
                    spell.name,
                    style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),
            )
          )
        );
      }
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: spellsWidgets,
        )
      )
    );
  }
}