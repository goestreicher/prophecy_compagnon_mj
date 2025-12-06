import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../classes/object_source.dart';
import '../../classes/star.dart';
import '../utils/error_feedback.dart';
import '../utils/star/display_widget.dart';
import '../utils/star/list_filter.dart';
import '../utils/star/list_filter_widget.dart';
import '../utils/star/list_widget.dart';

class StarsListPage extends StatefulWidget {
  const StarsListPage({ super.key, this.selected });

  final String? selected;

  @override
  State<StarsListPage> createState() => _StarsListPageState();
}

class _StarsListPageState extends State<StarsListPage> {
  bool isWorking = false;
  StarListFilter filter = StarListFilter();
  Future<void>? starsFuture;
  List<Star> stars = <Star>[];
  String? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.selected;
  }

  void resetStarsList() {
    starsFuture = null;
    stars.clear();
  }

  Future<void> updateStarsList() async {
    stars = (await Star.getAll()).toList();
    stars.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  @override
  Widget build(BuildContext context) {
    if(stars.isEmpty && starsFuture == null) {
      starsFuture = updateStarsList();
    }

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 0.0),
              child: Wrap(
                spacing: 16.0,
                runSpacing: 8.0,
                children: [
                  StarListFilterWidget(
                    filter: filter,
                    onFilterChanged: (StarListFilter f) {
                      setState(() {
                        filter = f;
                        selected = null;
                      });
                    }
                  ),
                  MenuAnchor(
                    alignmentOffset: const Offset(0, 4),
                    builder: (BuildContext context, MenuController controller, Widget? child) {
                      return IconButton.filled(
                        icon: const Icon(Icons.add),
                        iconSize: 24.0,
                        padding: const EdgeInsets.all(4.0),
                        tooltip: 'Créer / Importer',
                        onPressed: () {
                          if(controller.isOpen) {
                            controller.close();
                          }
                          else {
                            controller.open();
                          }
                        },
                      );
                    },
                    menuChildren: [
                      MenuItemButton(
                        child: const Row(
                          children: [
                            Icon(Icons.create),
                            SizedBox(width: 4.0),
                            Text('Nouvelle étoile'),
                          ],
                        ),
                        onPressed: () {
                          context.go('/stars/create');
                        },
                      ),
                      MenuItemButton(
                        child: const Row(
                          children: [
                            Icon(Icons.publish),
                            SizedBox(width: 4.0),
                            Text('Importer une étoile'),
                          ],
                        ),
                        onPressed: () async {
                          var result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['json'],
                            withData: true,
                          );
                          if(!context.mounted) return;
                          if(result == null) return;

                          try {
                            setState(() {
                              isWorking = true;
                            });

                            var jsonStr = const Utf8Decoder().convert(result.files.first.bytes!);
                            var j = json.decode(jsonStr);
                            var star = await Star.import(j);

                            setState(() {
                              selected = star.id;
                              isWorking = false;
                              resetStarsList();
                            });
                          } catch (e) {
                            setState(() {
                              isWorking = false;
                            });

                            if(!context.mounted) return;

                            displayErrorDialog(
                                context,
                                "Échec de l'import",
                                e.toString()
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12.0),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FutureBuilder(
                      future: starsFuture,
                      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return ErrorWidget(snapshot.error!);
                        }

                        return StarsListWidget(
                          stars: stars,
                          filter: filter,
                          selected: selected,
                          onSelected: (String? id) {
                            if(id == null && GoRouter.of(context).state.fullPath!.endsWith('/:uuid')) {
                              context.replace('/stars');
                            }

                            setState(() {
                              selected = id;
                            });
                          },
                          onEditRequested: (String id) async {
                            context.go('/stars/$id/edit');
                          },
                          onCloneRequested: (String id) async {
                            context.go('/stars/clone/$id');
                          },
                          onDeleteRequested: (String id) async {
                            try {
                              await Star.deleteLocalModel(id);
                              setState(() {
                                selected = null;
                                resetStarsList();
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
                          },
                          restrictModificationToSourceTypes: [
                            ObjectSourceType.original
                          ],
                        );
                      }
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
              )
            ),
          ],
        ),
        if(isWorking)
          const Opacity(
            opacity: 0.6,
            child: ModalBarrier(
              dismissible: false,
              color: Colors.black,
            ),
          ),
        if(isWorking)
          const Center(
              child: CircularProgressIndicator()
          ),
      ],
    );
  }
}