import 'package:flutter/material.dart';

import '../../classes/non_player_character.dart';

class NPCListWidget extends StatefulWidget {
  const NPCListWidget({
    super.key,
    required this.category,
    this.subCategory,
    this.npcs,
    required this.onSelected,
    this.selected,
  });

  final NPCCategory category;
  final NPCSubCategory? subCategory;
  final List<NonPlayerCharacter>? npcs;
  final void Function(NonPlayerCharacter) onSelected;
  final NonPlayerCharacter? selected;

  @override
  State<NPCListWidget> createState() => _NPCListWidgetState();
}

class _NPCListWidgetState extends State<NPCListWidget> {
  late List<NonPlayerCharacter> _npcs;

  void _updateNPCList() {
    if(widget.npcs != null) {
      _npcs = widget.npcs!;
    }
    else {
      _npcs = NonPlayerCharacter.forCategory(widget.category, widget.subCategory);
    }
    _npcs.sort((a, b) => a.id.compareTo(b.id));
  }

  @override
  void initState() {
    super.initState();
    _updateNPCList();
  }

  @override
  void didUpdateWidget(NPCListWidget oldWidget) {
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
          theme.colorScheme.surfaceContainerHighest :
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