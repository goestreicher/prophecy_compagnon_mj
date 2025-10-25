import 'dart:convert';

import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../classes/object_location.dart';
import '../../classes/object_source.dart';
import '../../classes/place.dart';
import '../utils/error_feedback.dart';
import '../utils/generic_tree_widget.dart';
import '../utils/place/place_selection_model.dart';
import '../utils/place_display_widget.dart';
import '../utils/place_tree_widget_utils.dart';

class PlacesMainPage extends StatefulWidget {
  const PlacesMainPage({ super.key, this.selected });

  final String? selected;

  @override
  State<PlacesMainPage> createState() => _PlacesMainPageState();
}

class _PlacesMainPageState extends State<PlacesMainPage> {
  late final TreeNode<GenericTreeData<PlaceSummary>> fullTree;
  TreeNode<GenericTreeData<PlaceSummary>>? filteredTree;
  late UniqueKey treeKey;
  final GenericTreeFilter<PlaceSummary> treeFilter = GenericTreeFilter<PlaceSummary>();
  late PlaceTreeWidgetAdapter adapter;
  final TextEditingController sourceTypeController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  late PlaceSelectionModel placeSelectionModel;

  @override
  void initState() {
    super.initState();

    placeSelectionModel = PlaceSelectionModel(id: widget.selected);

    adapter = PlaceTreeWidgetAdapter(
      itemSelectionCallback: (PlaceSummary p) {
        placeSelectionModel.id = p.id;
      },
      itemCreationCallback: (Place p) async {
        await PlaceStore().save(p);
      },
    );

    fullTree = TreeNode.root();
  }

  Future<void> load() async {
    await PlaceSummary.loadAll();
    await rebuildFullTree();
  }

  Future<void> rebuildFullTree() async {
    fullTree.clear();
    treeKey = UniqueKey();
    await buildSubTree(fullTree, (await PlaceSummary.byId('monde'))!);
  }

  Future<void> buildSubTree(TreeNode root, PlaceSummary place) async {
    for(var child in (await PlaceSummary.withParent(place.id)).toList()..sort(PlaceSummary.sortComparator)) {
      var node = TreeNode(
          key: child.id,
          data: GenericTreeData<PlaceSummary>(
            item: child,
            canCreateChildren: (
                child.location.type == ObjectLocationType.assets
                || child.source == ObjectSource.local
            ),
          )
      );
      await buildSubTree(node, child);
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
                child: FutureBuilder(
                  future: load(),
                  builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if(snapshot.hasError) {
                      return ErrorWidget(snapshot.error!);
                    }

                    return CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.only(right: 8.0),
                          sliver: GenericTreeWidget<PlaceSummary, Place>(
                            key: treeKey,
                            tree: filteredTree ?? fullTree,
                            filter: treeFilter,
                            adapter: adapter,
                            autoExpandLevel: 1,
                          )
                        )
                      ],
                    );
                  }
                ),
              ),
              ChangeNotifierProvider.value(
                value: placeSelectionModel,
                child: Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(4.0, 16.0, 0.0, 16.0),
                    child: Consumer<PlaceSelectionModel>(
                      builder: (_, selectedPlace, _) {
                        return PlaceDisplayWidget(
                          placeId: selectedPlace.id,
                          onEdited: (Place p) {
                            PlaceStore().save(p);
                            selectedPlace.id = p.id;
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
                            if (confirm == null || !confirm) return;

                            Place? current = p;
                            var path = p.id;
                            while(
                                current != null
                                && current.parentId != null
                                && current.parentId != 'monde'
                            ) {
                              current = await Place.byId(current.parentId!);
                              path = '${current!.id}.$path';
                            }

                            await Place.delete(p);

                            var fullTreeNode = fullTree.elementAt(path);
                            fullTreeNode.parent?.remove(fullTreeNode);

                            if (filteredTree != null) {
                              var filteredTreeNode = filteredTree!.elementAt(path);
                              filteredTreeNode.parent?.remove(filteredTreeNode);
                            }

                            selectedPlace.id = null;
                          },
                        );
                      }
                    ),
                  )
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
