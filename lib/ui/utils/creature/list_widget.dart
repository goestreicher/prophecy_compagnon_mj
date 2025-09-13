import 'package:flutter/material.dart';

import '../../../classes/creature.dart';
import '../../../classes/object_source.dart';
import 'display_widget.dart';

class CreaturesListWidget extends StatefulWidget {
  const CreaturesListWidget({
    super.key,
    required this.creatures,
    this.initialSelection,
    required this.onEditRequested,
    required this.onCloneRequested,
    required this.onDeleteRequested,
    this.restrictModificationToSourceTypes,
  });

  final List<CreatureSummary> creatures;
  final String? initialSelection;
  final void Function(String) onEditRequested;
  final void Function(String) onCloneRequested;
  final void Function(String) onDeleteRequested;
  final List<ObjectSourceType>? restrictModificationToSourceTypes;

  @override
  State<CreaturesListWidget> createState() => _CreaturesListWidgetState();
}

class _CreaturesListWidgetState extends State<CreaturesListWidget> {
  String? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialSelection;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return ListView.builder(
      itemCount: widget.creatures.length,
      itemBuilder: (BuildContext context, int index) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 800,
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if(selected == widget.creatures[index].id) {
                    selected = null;
                  }
                  else {
                    selected = widget.creatures[index].id;
                  }
                });
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if(selected != widget.creatures[index].id)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.creatures[index].name,
                                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.fade,
                              ),
                              CreatureActionButtons(
                                creature: widget.creatures[index],
                                onEdit: () => widget.onEditRequested(widget.creatures[index].id),
                                onClone: () => widget.onCloneRequested(widget.creatures[index].id),
                                onDelete: () => widget.onDeleteRequested(widget.creatures[index].id),
                                restrictModificationToSourceTypes: widget.restrictModificationToSourceTypes,
                              )
                            ],
                          ),
                        if(selected == widget.creatures[index].id)
                          CreatureDisplayWidget(
                            creature: selected!,
                            onEditRequested: () => widget.onEditRequested(widget.creatures[index].id),
                            onCloneRequested: () => widget.onCloneRequested(widget.creatures[index].id),
                            onDeleteRequested: () => widget.onDeleteRequested(widget.creatures[index].id),
                            restrictModificationToSourceTypes: widget.restrictModificationToSourceTypes,
                          ),
                      ],
                    ),
                  )
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}