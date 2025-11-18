import 'package:flutter/material.dart';

import '../../classes/object_source.dart';
import '../../classes/star.dart';
import '../utils/star/create_widget.dart';
import '../utils/star/display_widget.dart';
import '../utils/star/edit_widget.dart';
import '../utils/star/list_widget.dart';

class ScenarioEditStarsPage extends StatefulWidget {
  const ScenarioEditStarsPage({
    super.key,
    required this.stars,
    required this.scenarioSource,
    required this.onStarCreated,
    required this.onStarModified,
    required this.onStarDeleted,
    this.onEditStarted,
    this.onEditFinished,
  });

  final List<Star> stars;
  final ObjectSource scenarioSource;
  final void Function(Star) onStarCreated;
  final void Function(Star) onStarModified;
  final void Function(Star) onStarDeleted;
  final void Function()? onEditStarted;
  final void Function()? onEditFinished;

  @override
  State<ScenarioEditStarsPage> createState() => _ScenarioEditStarsPageState();
}

class _ScenarioEditStarsPageState extends State<ScenarioEditStarsPage> {
  String? selected;
  bool creating = false;
  Star? editing;
  String? cloning;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    Widget mainArea;

    if(creating) {
      mainArea = Container(
        color: theme.colorScheme.surfaceContainerHighest,
        child: StarCreateWidget(
          source: widget.scenarioSource,
          onStarCreated: (Star? star) {
            if(star != null) {
              selected = star.id;
              widget.onStarCreated(star);
            }

            setState(() {
              creating = false;
            });
          },
        ),
      );
    }
    else if(cloning != null) {
      mainArea = Container(
        color: theme.colorScheme.surfaceContainerHighest,
        child: StarCreateWidget(
          source: widget.scenarioSource,
          cloneFrom: cloning,
          onStarCreated: (Star? star) {
            if(star != null) {
              selected = star.id;
              widget.onStarCreated(star);
            }

            setState(() {
              cloning = null;
            });
          },
        ),
      );
    }
    else if(editing != null) {
      mainArea = Container(
        color: theme.colorScheme.surfaceContainerHighest,
        child: StarEditWidget(
          star: editing!,
          onEditDone: (bool result) async {
            if(result) {
              await Star.saveLocalModel(editing!);
            }
            else {
              await Star.reloadFromStore(editing!.id);
            }

            setState(() {
              selected = editing!.id;
              editing = null;
            });
          }
        ),
      );
    }
    else {
      mainArea = Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
        ),
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            Expanded(
              child: Column(
                spacing: 12.0,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        creating = true;
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Nouvelle étoile'),
                  ),
                  Expanded(
                    child: StarsListWidget(
                      stars: widget.stars,
                      selected: selected,
                      onSelected: (String? id) {
                        setState(() {
                          selected = id;
                        });
                      },
                      onEditRequested: (String id) async {
                        var star = widget.stars.firstWhere(
                            (Star s) => s.id == id
                          );

                        setState(() {
                          editing = star;
                        });
                      },
                      onCloneRequested: (String id) async {
                        setState(() {
                          cloning = id;
                        });
                      },
                      onDeleteRequested: (String id) async {
                        var star = widget.stars.firstWhere(
                            (Star s) => s.id == id
                          );

                        widget.onStarDeleted(star);
                        setState(() {
                          if(editing?.id == id) editing = null;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            if(selected != null)
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 8.0),
                    child: StarDisplayWidget(
                      id: selected!,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return mainArea;
  }
}