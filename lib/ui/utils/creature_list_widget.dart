import 'package:flutter/material.dart';

import '../../classes/creature.dart';

class CreaturesListWidget extends StatefulWidget {
  const CreaturesListWidget({
    super.key,
    this.category,
    required this.onSelected,
    this.selected,
    this.source,
  });

  final CreatureCategory? category;
  final void Function(String) onSelected;
  final String? selected;
  final String? source;

  @override
  State<CreaturesListWidget> createState() => _CreaturesListWidgetState();
}

class _CreaturesListWidgetState extends State<CreaturesListWidget> {
  late List<CreatureModelSummary> _creatures;

  void _updateCreaturesList() {
    if(widget.source != null) {
      _creatures = CreatureModel.forSource(widget.source!, widget.category);
    }
    else if(widget.category != null) {
      _creatures = CreatureModel.forCategory(widget.category!);
    }
    else {
      _creatures = <CreatureModelSummary>[];
    }
    _creatures.sort((a, b) => a.id.compareTo(b.id));
  }

  @override
  void initState() {
    super.initState();
    _updateCreaturesList();
  }

  @override
  void didUpdateWidget(CreaturesListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateCreaturesList();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return ListView.builder(
        itemCount: _creatures.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              color: widget.selected == _creatures[index].id ?
              theme.colorScheme.surfaceContainerHighest :
              null,
              child: InkWell(
                onTap: () {
                  widget.onSelected(_creatures[index].id);
                },
                child: ListTile(
                  title: Text(
                    _creatures[index].name,
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