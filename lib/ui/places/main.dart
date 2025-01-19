import 'dart:convert';

import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../classes/object_source.dart';
import '../../classes/place.dart';
import '../utils/error_feedback.dart';
import '../utils/place_display_widget.dart';
import '../utils/place_tree_widget.dart';

class PlacesMainPage extends StatefulWidget {
  const PlacesMainPage({ super.key });

  @override
  State<PlacesMainPage> createState() => _PlacesMainPageState();
}

class _PlacesMainPageState extends State<PlacesMainPage> {
  late final TreeNode<PlaceTreeData> tree;
  late UniqueKey treeKey;
  TreeViewController? treeViewController;
  final PlaceTreeFilter treeFilter = PlaceTreeFilter();
  final TextEditingController sourceTypeController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();

  Place? selectedPlace;

  void buildSubTree(TreeNode root, Place place) {
    for(var child in Place.withParent(place.id)..sort(Place.sortComparator)) {
      bool match = treeFilter.matchesFilter(child);
      var node = TreeNode(
        key: child.id,
        data: PlaceTreeData(
          place: child,
          matchesCurrentFilter: match
        )
      );
      buildSubTree(node, child);
      if(treeFilter.hasChildMatchingFilter(node) || child.isDefault) {
        root.add(node);
      }
    }
  }

  void rebuildTree() {
    tree.clear();
    treeKey = UniqueKey();
    buildSubTree(tree, Place.byId('monde')!);
  }

  @override
  void initState() {
    super.initState();
    tree = TreeNode.root();
    rebuildTree();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              DropdownMenu(
                controller: sourceTypeController,
                label: const Text('Type de source'),
                textStyle: theme.textTheme.bodySmall,
                leadingIcon: treeFilter.sourceType == null
                  ? null
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          treeFilter.sourceType = null;
                          sourceTypeController.clear();
                          treeFilter.source = null;
                          sourceController.clear();
                          rebuildTree();
                        });
                        FocusScope.of(context).unfocus();
                      },
                      child: Icon(Icons.cancel, size: 16.0,)
                    ),
                initialSelection: treeFilter.sourceType,
                onSelected: (ObjectSourceType? sourceType) {
                  setState(() {
                    treeFilter.sourceType = sourceType;
                    sourceController.clear();
                    treeFilter.source = null;
                    rebuildTree();
                  });
                },
                dropdownMenuEntries: ObjectSourceType.values
                    .map((ObjectSourceType s) => DropdownMenuEntry(value: s, label: s.title))
                    .toList(),
              ),
              const SizedBox(width: 8.0),
              DropdownMenu(
                controller: sourceController,
                enabled: treeFilter.sourceType != null,
                label: const Text('Source'),
                textStyle: theme.textTheme.bodySmall,
                leadingIcon: treeFilter.source == null
                    ? null
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            treeFilter.source = null;
                            sourceController.clear();
                            rebuildTree();
                          });
                          FocusScope.of(context).unfocus();
                        },
                        child: Icon(Icons.cancel, size: 16.0,)
                      ),
                initialSelection: treeFilter.source,
                onSelected: (ObjectSource? source) {
                  setState(() {
                    treeFilter.source = source;
                    rebuildTree();
                  });
                },
                dropdownMenuEntries: treeFilter.sourceType == null
                    ? <DropdownMenuEntry<ObjectSource>>[]
                    : ObjectSource.forType(treeFilter.sourceType!)
                        .map((ObjectSource s) => DropdownMenuEntry(value: s, label: s.name))
                        .toList(),
              ),
              const SizedBox(width: 8.0),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Importer un lieu'),
                onPressed: () async {
                  var result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['json'],
                  );
                  if(!context.mounted) return;
                  if(result == null) return;

                  try {
                    var jsonStr = const Utf8Decoder().convert(result.files.first.bytes!);
                    List<dynamic> j = json.decode(jsonStr);
                    await Place.import(j);
                    setState(() {
                      rebuildTree();
                    });
                  } catch (e) {
                    if(!context.mounted) return;

                    displayErrorDialog(
                        context,
                        "Échec de l'import",
                        e.toString()
                    );
                  }
                },
              ),
            ]
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 350,
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.only(right: 8.0),
                      sliver: PlaceTreeWidget(
                        key: treeKey,
                        tree: tree,
                        filter: treeFilter,
                        onPlaceSelected: (Place p) => setState(() {
                          selectedPlace = p;
                        }),
                      )
                    )
                  ],
                ),
              ),
              if(selectedPlace != null)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(4.0, 16.0, 0.0, 16.0),
                    child: PlaceDisplayWidget(
                      place: selectedPlace!,
                      onEdited: (Place p) => setState(() {
                        selectedPlace = p;
                      }),
                      onDelete: (Place p) async {
                        var confirm = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Confirmer la suppression'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Supprimer ce lieux et tous ses enfants ?'),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('Annuler'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text('Supprimer'),
                              ),
                            ]
                          )
                        );
                        if(confirm == null || !confirm) return;
          
                        Place? current = p;
                        var path = p.id;
                        while(current != null && current.parentId != null && current.parentId != 'monde') {
                          current = Place.byId(current.parentId!);
                          path = '${current!.id}.$path';
                        }
                        var n = tree.elementAt(path);
                        setState(() {
                          selectedPlace = null;
                          n.parent?.remove(n);
                        });
          
                        await Place.delete(p);
                      },
                    ),
                  )
                ),
            ],
          ),
        ),
      ],
    );
  }
}
