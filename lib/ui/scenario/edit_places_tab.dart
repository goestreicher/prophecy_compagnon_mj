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
    required this.places,
    required this.scenarioName,
    required this.onPlaceCommitted,
  });

  final List<Place> places;
  final String scenarioName;
  final void Function() onPlaceCommitted;

  @override
  State<ScenarioEditPlacesPage> createState() => _ScenarioEditPlacesPageState();
}

class _ScenarioEditPlacesPageState extends State<ScenarioEditPlacesPage> {
  late final TreeNode<PlaceTreeData> tree;
  late UniqueKey treeKey;
  final PlaceTreeFilter treeFilter = PlaceTreeFilter();
  Place? selectedPlace;
  late final ObjectSource mySource;

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
    mySource = ObjectSource(
        type: ObjectSourceType.scenario,
        name: widget.scenarioName
    );
    tree = TreeNode.root();
    treeFilter.source = mySource;
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
                    newPlaceSource: mySource,
                    onPlaceCreated: (Place p) => widget.onPlaceCommitted(),
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
                  modifyIfSourceMatches: mySource,
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
                      widget.onPlaceCommitted();
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
    );
  }
}