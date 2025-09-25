import 'dart:convert';

import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../classes/object_location.dart';
import '../../classes/object_source.dart';
import '../../classes/place.dart';
import '../utils/error_feedback.dart';
import '../utils/generic_tree_widget.dart';
import '../utils/place_display_widget.dart';
import '../utils/place_tree_widget_utils.dart';

class PlacesMainPage extends StatefulWidget {
  const PlacesMainPage({ super.key });

  @override
  State<PlacesMainPage> createState() => _PlacesMainPageState();
}

class _PlacesMainPageState extends State<PlacesMainPage> {
  late final TreeNode<GenericTreeData<Place>> fullTree;
  TreeNode<GenericTreeData<Place>>? filteredTree;
  late UniqueKey treeKey;
  final GenericTreeFilter<Place> treeFilter = GenericTreeFilter<Place>();
  late PlaceTreeWidgetAdapter adapter;
  final TextEditingController sourceTypeController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  Place? selectedPlace;

  @override
  void initState() {
    super.initState();

    adapter = PlaceTreeWidgetAdapter(
      itemSelectionCallback: (Place p) {
        setState(() {
          selectedPlace = p;
        });
      },
      itemCreationCallback: (Place p) async {
        await PlaceStore().save(p);
      },
    );

    fullTree = TreeNode.root();
    rebuildFullTree();
  }

  void rebuildFullTree() {
    fullTree.clear();
    treeKey = UniqueKey();
    buildSubTree(fullTree, Place.byId('monde')!);
  }

  void buildSubTree(TreeNode root, Place place) {
    for(var child in Place.withParent(place.id)..sort(Place.sortComparator)) {
      var node = TreeNode(
          key: child.id,
          data: GenericTreeData<Place>(
            item: child,
            canCreateChildren: (
                child.location.type == ObjectLocationType.assets
                || child.source == ObjectSource.local
            ),
          )
      );
      buildSubTree(node, child);
      root.add(node);
    }
  }

  void updateFilteredTree() {
    if(treeFilter.isNull()) {
      setState(() {
        filteredTree = null;
        treeKey = UniqueKey();
      });
    }
    else {
      var tree = treeFilter.createFilteredTree(fullTree);
      setState(() {
        filteredTree = tree;
        treeKey = UniqueKey();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
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
                leadingIcon: treeFilter.sourceType == null
                  ? null
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          treeFilter.sourceType = null;
                          sourceTypeController.clear();
                          treeFilter.source = null;
                          sourceController.clear();
                        });
                        updateFilteredTree();
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
                  });
                  updateFilteredTree();
                },
                dropdownMenuEntries: ObjectSourceType.values
                    .map((ObjectSourceType s) => DropdownMenuEntry(value: s, label: s.title))
                    .toList(),
              ),
              DropdownMenu(
                key: UniqueKey(),
                controller: sourceController,
                enabled: treeFilter.sourceType != null,
                label: Text(
                  'Source',
                  style: theme.textTheme.bodySmall,
                ),
                textStyle: theme.textTheme.bodySmall,
                leadingIcon: treeFilter.source == null
                    ? null
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            treeFilter.source = null;
                            sourceController.clear();
                          });
                          updateFilteredTree();
                          FocusScope.of(context).unfocus();
                        },
                        child: Icon(Icons.cancel, size: 16.0,)
                      ),
                initialSelection: treeFilter.source,
                onSelected: (ObjectSource? source) {
                  setState(() {
                    treeFilter.source = source;
                  });
                  updateFilteredTree();
                },
                dropdownMenuEntries: treeFilter.sourceType == null
                    ? <DropdownMenuEntry<ObjectSource>>[]
                    : ObjectSource.forType(treeFilter.sourceType!)
                        .map((ObjectSource s) => DropdownMenuEntry(value: s, label: s.name))
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
                    prefixIcon: treeFilter.nameFilter == null
                        ? null
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                searchController.clear();
                                treeFilter.nameFilter = null;
                              });
                              updateFilteredTree();
                              FocusScope.of(context).unfocus();
                            },
                            child: Icon(Icons.cancel, size: 16.0,)
                    ),
                  ),
                  onSubmitted: (String? value) {
                    if(value == null || value.length >= 3) {
                      setState(() {
                        treeFilter.nameFilter = value;
                      });
                      updateFilteredTree();
                    }
                  },
                ),
              ),
              IconButton.filled(
                icon: const Icon(Icons.publish),
                iconSize: 24.0,
                padding: const EdgeInsets.all(4.0),
                tooltip: 'Importer un lieu',
                onPressed: () async {
                  var result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['json'],
                    withData: true,
                  );
                  if(!context.mounted) return;
                  if(result == null) return;

                  try {
                    var jsonStr = const Utf8Decoder().convert(result.files.first.bytes!);
                    List<dynamic> j = json.decode(jsonStr);
                    await Place.import(j);

                    setState(() {
                      treeFilter.sourceType = ObjectSource.local.type;
                      treeFilter.source = ObjectSource.local;
                      rebuildFullTree();
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
                      sliver: GenericTreeWidget<Place>(
                        key: treeKey,
                        tree: filteredTree ?? fullTree,
                        filter: treeFilter,
                        adapter: adapter,
                        autoExpandLevel: 1,
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
                      onEdited: (Place p) {
                        PlaceStore().save(p);
                        setState(() {
                          selectedPlace = p;
                        });
                      },
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

                        await Place.delete(p);

                        var fullTreeNode = fullTree.elementAt(path);
                        fullTreeNode.parent?.remove(fullTreeNode);

                        if(filteredTree != null) {
                          var filteredTreeNode = filteredTree!.elementAt(path);
                          filteredTreeNode.parent?.remove(filteredTreeNode);
                        }

                        setState(() {
                          selectedPlace = null;
                        });
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
