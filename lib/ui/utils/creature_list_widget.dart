import 'package:flutter/material.dart';

import '../../classes/creature.dart';
import '../../classes/object_source.dart';
import 'creature_display_widget.dart';
import '../utils/error_feedback.dart';

class CreaturesListWidget extends StatefulWidget {
  const CreaturesListWidget({
    super.key,
    this.creatures,
    this.source,
    this.category,
    this.initialSelection,
    required this.onEditRequested,
    this.restrictModificationToSourceTypes,
  });

  final List<CreatureModelSummary>? creatures;
  final CreatureCategory? category;
  final ObjectSource? source;
  final String? initialSelection;
  final void Function(CreatureModel) onEditRequested;
  final List<ObjectSourceType>? restrictModificationToSourceTypes;

  @override
  State<CreaturesListWidget> createState() => _CreaturesListWidgetState();
}

class _CreaturesListWidgetState extends State<CreaturesListWidget> {
  late List<CreatureModelSummary> creatures;
  String? selected;

  void _updateCreaturesList() {
    if(widget.creatures != null) {
      creatures = widget.creatures!;
    }
    else if(widget.source != null) {
      creatures = CreatureModel.forSource(widget.source!, widget.category);
    }
    else if(widget.category != null) {
      creatures = CreatureModel.forCategory(widget.category!);
    }
    else {
      creatures = <CreatureModelSummary>[];
    }
    creatures.sort((a, b) => a.id.compareTo(b.id));
  }

  Future<void> _deleteModel(BuildContext context, int index) async {
    try {
      await CreatureModel.deleteLocalModel(creatures[index].id);
      setState(() {
        creatures.removeAt(index);
      });
    }
    catch(e) {
      if(!context.mounted) return;
      displayErrorDialog(
        context,
        "Suppression impossible",
        e.toString()
      );
    }
    setState(() {
      selected = null;
    });
  }

  @override
  void initState() {
    super.initState();
    selected = widget.initialSelection;
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
      itemCount: creatures.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              if(selected == creatures[index].id) {
                selected = null;
              }
              else {
                selected = creatures[index].id;
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
                    if(selected != creatures[index].id)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            creatures[index].name,
                            style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.fade,
                          ),
                          CreatureActionButtons(
                            creature: creatures[index],
                            onEdit: () async {
                              var model = await CreatureModel.get(creatures[index].id);
                              widget.onEditRequested(model!);
                            },
                            onClone: (String newName) async {
                              var model = await CreatureModel.get(creatures[index].id);
                              var j = model!.toJson();
                              j['name'] = newName;
                              widget.onEditRequested(CreatureModel.fromJson(j));
                            },
                            onDelete: () async {
                              await _deleteModel(context, index);
                            },
                            restrictModificationToSourceTypes: widget.restrictModificationToSourceTypes,
                          )
                        ],
                      ),
                    if(selected == creatures[index].id)
                      CreatureDisplayWidget(
                        creature: selected!,
                        onEditRequested: (CreatureModel model) =>
                          widget.onEditRequested(model),
                        onDelete: () async {
                          await _deleteModel(context, index);
                        },
                        restrictModificationToSourceTypes: widget.restrictModificationToSourceTypes,
                      ),
                  ],
                ),
              )
            ),
          ),
        );
      }
    );
  }
}