import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../classes/object_location.dart';
import '../../classes/object_source.dart';
import '../../classes/place.dart';
import '../../classes/resource_link/assets_resource_link_provider.dart';
import '../../classes/resource_link/multi_resource_link_provider.dart';
import '../../classes/resource_link/scenario_resource_link_provider.dart';
import '../utils/generic_tree_widget.dart';
import '../utils/place/place_selection_model.dart';
import '../utils/place/place_display_widget.dart';
import '../utils/place/place_tree_widget_utils.dart';

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
  late final TreeNode<GenericTreeData<PlaceSummary>> tree;
  late UniqueKey treeKey;
  final GenericTreeFilter<PlaceSummary> treeFilter = GenericTreeFilter<PlaceSummary>();
  late PlaceTreeWidgetAdapter adapter;

  PlaceSelectionModel placeSelectionModel = PlaceSelectionModel();

  @override
  void initState() {
    super.initState();

    adapter = PlaceTreeWidgetAdapter(
      newPlaceSource: widget.scenarioSource,
      resourceLinkProvider: MultiResourceLinkProvider(
        providers: [
          AssetsResourceLinkProvider(),
          ScenarioResourceLinkProvider(
            source: widget.scenarioSource,
          ),
        ]
      ),
      itemSelectionCallback: (PlaceSummary p) {
        placeSelectionModel.id = p.id;
      },
      itemCreationCallback: (Place p) async {
        widget.onPlaceCreated(p);
      },
    );

    tree = TreeNode.root();
    treeFilter.source = widget.scenarioSource;
  }

  Future<void> load() async {
    await PlaceSummary.loadAll();
    await rebuildTree();
  }

  Future<void> rebuildTree() async {
    tree.clear();
    treeKey = UniqueKey();
    await buildSubTree(tree, (await PlaceSummary.byId('monde'))!);
  }

  Future<void> buildSubTree(TreeNode root, PlaceSummary place) async {
    for(var child in (await PlaceSummary.withParent(place.id)).toList()..sort(PlaceSummary.sortComparator)) {
      var node = TreeNode<GenericTreeData<PlaceSummary>>(
        key: child.id,
      );
      await buildSubTree(node, child);

      bool match = treeFilter.matchesFilter(child);
      bool descendantMatch = node.childrenAsList
        .any(
          (ListenableNode n) {
            if(n.isRoot) return true;
            var tn = n as TreeNode<GenericTreeData<PlaceSummary>>;
            return tn.data != null
                && (
                    tn.data!.matchesCurrentFilter
                    || tn.data!.descendantMatchesCurrentFilter
                );
          }
      );

      node.data = GenericTreeData<PlaceSummary>(
        item: child,
        matchesCurrentFilter: match,
        descendantMatchesCurrentFilter: descendantMatch,
      );

      if(match || descendantMatch || child.location.type == ObjectLocationType.assets) {
        root.add(node);
      }
    }
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
                        tree: tree,
                        filter: treeFilter,
                        adapter: adapter,
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
                      modifyIfSourceMatches: widget.scenarioSource,
                      resourceLinkProvider: MultiResourceLinkProvider(
                        providers: [
                          AssetsResourceLinkProvider(),
                          ScenarioResourceLinkProvider(
                            source: widget.scenarioSource,
                          ),
                        ]
                      ),
                      onEdited: (Place p) => setState(() {
                        widget.onPlaceModified(p);
                        selectedPlace.id = p.id;
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
                          current = await Place.byId(current.parentId!);
                          path = '${current!.id}.$path';
                        }
                        var n = tree.elementAt(path);
                        n.parent?.remove(n);
                        widget.onPlaceDeleted(p);
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
    );
  }
}