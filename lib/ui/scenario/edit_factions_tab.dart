import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../classes/faction.dart';
import '../../classes/object_location.dart';
import '../../classes/object_source.dart';
import '../utils/faction/faction_selection_model.dart';
import '../utils/faction/faction_display_widget.dart';
import '../utils/faction/faction_tree_widget_utils.dart';
import '../utils/generic_tree_widget.dart';

class ScenarioEditFactionsPage extends StatefulWidget {
  const ScenarioEditFactionsPage({
    super.key,
    required this.scenarioSource,
    required this.onFactionCreated,
    required this.onFactionModified,
    required this.onFactionDeleted,
  });

  final ObjectSource scenarioSource;
  final void Function(Faction) onFactionCreated;
  final void Function(Faction) onFactionModified;
  final void Function(Faction) onFactionDeleted;

  @override
  State<ScenarioEditFactionsPage> createState() => _ScenarioEditFactionsPageState();
}

class _ScenarioEditFactionsPageState extends State<ScenarioEditFactionsPage> {
  late final TreeNode<GenericTreeData<FactionSummary>> tree;
  late UniqueKey treeKey;
  final GenericTreeFilter<FactionSummary> treeFilter = GenericTreeFilter<FactionSummary>();
  late FactionTreeWidgetAdapter adapter;

  FactionSelectionModel factionSelectionModel = FactionSelectionModel();

  @override
  void initState() {
    super.initState();

    adapter = FactionTreeWidgetAdapter(
      newFactionSource: widget.scenarioSource,
      itemSelectionCallback: (FactionSummary f) {
        factionSelectionModel.id = f.id;
      },
      itemCreationCallback: (Faction f) => widget.onFactionCreated(f),
    );

    tree = TreeNode.root();
    treeFilter.source = widget.scenarioSource;
  }

  Future<void> load() async {
    await FactionSummary.loadAll();
    await rebuildTree();
  }

  Future<void> rebuildTree() async {
    tree.clear();
    treeKey = UniqueKey();
    await buildSubTree(tree, null);
  }

  Future<void> buildSubTree(TreeNode root, FactionSummary? faction) async {
    for(var child in (await FactionSummary.withParent(faction?.id)).toList()..sort(FactionSummary.sortComparator)) {
      var node = TreeNode<GenericTreeData<FactionSummary>>(
        key: child.id,
      );
      await buildSubTree(node, child);

      bool match = treeFilter.matchesFilter(child);
      bool descendantMatch = node.childrenAsList
        .any(
          (ListenableNode n) {
            if(n.isRoot) return true;
            var tn = n as TreeNode<GenericTreeData<FactionSummary>>;
            return tn.data != null
              && (
                    tn.data!.matchesCurrentFilter
                    || tn.data!.descendantMatchesCurrentFilter
                );
          }
        );

      node.data = GenericTreeData<FactionSummary>(
        item: child,
        matchesCurrentFilter: match,
        descendantMatchesCurrentFilter: descendantMatch,
        showInfo: !child.displayOnly,
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
            width: 400,
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
                      sliver: GenericTreeWidget<FactionSummary, Faction>(
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
            value: factionSelectionModel,
            child: Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(4.0, 16.0, 0.0, 16.0),
                child: Consumer<FactionSelectionModel>(
                  builder: (_, selectedFaction, _) {
                    return FactionDisplayWidget(
                      factionId: selectedFaction.id,
                      modifyIfSourceMatches: widget.scenarioSource,
                      onEdited: (Faction f) {
                        widget.onFactionModified(f);
                        selectedFaction.id = f.id;
                      },
                      onDelete: (Faction f) async {
                        var confirm = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                              title: const Text('Confirmer la suppression'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Supprimer cette faction et tous ses enfants ?'),
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

                        Faction? current = f;
                        var path = f.id;
                        while(current != null && current.parentId != null) {
                          current = await Faction.byId(current.parentId!);
                          path = '${current!.id}.$path';
                        }
                        var n = tree.elementAt(path);
                        n.parent?.remove(n);
                        widget.onFactionDeleted(f);

                        selectedFaction.id = null;
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