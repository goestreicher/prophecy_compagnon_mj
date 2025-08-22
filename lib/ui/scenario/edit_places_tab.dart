import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';

import '../../classes/object_location.dart';
import '../../classes/object_source.dart';
import '../../classes/place.dart';
import '../utils/place_display_widget.dart';
import '../utils/place_tree_widget.dart';

class ScenarioEditPlacesPage extends StatefulWidget {
  const ScenarioEditPlacesPage({
    super.key,
    required this.scenarioSource,
    required this.onPlaceCreated,
    required this.onPlaceModified,
    required this.onPlaceDeleted,
  });

  final ObjectSource scenarioSource;
  final void Function(Place) onPlaceCreated;
  final void Function(Place) onPlaceModified;
  final void Function(Place) onPlaceDeleted;

  @override
  State<ScenarioEditPlacesPage> createState() => _ScenarioEditPlacesPageState();
}

class _ScenarioEditPlacesPageState extends State<ScenarioEditPlacesPage> {
  late final TreeNode<PlaceTreeData> tree;
  late UniqueKey treeKey;
  final PlaceTreeFilter treeFilter = PlaceTreeFilter();
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
      if(treeFilter.hasChildMatchingFilter(node) || child.location.type == ObjectLocationType.assets) {
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
    treeFilter.source = widget.scenarioSource;
    rebuildTree();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
      ),
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
                    newPlaceSource: widget.scenarioSource,
                    onPlaceCreated: (Place p) => widget.onPlaceCreated(p),
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
                  modifyIfSourceMatches: widget.scenarioSource,
                  onEdited: (Place p) => setState(() {
                    widget.onPlaceModified(p);
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
                    widget.onPlaceDeleted(p);
                    setState(() {
                      selectedPlace = null;
                      n.parent?.remove(n);
                    });
                  },
                ),
              )
            ),
        ],
      ),
    );
  }
}