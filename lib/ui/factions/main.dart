import 'dart:convert';

import 'package:animated_tree_view/tree_view/tree_node.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../classes/faction.dart';
import '../../classes/object_location.dart';
import '../../classes/object_source.dart';
import '../utils/error_feedback.dart';
import '../utils/faction/faction_selection_model.dart';
import '../utils/faction/faction_display_widget.dart';
import '../utils/faction/faction_tree_widget_utils.dart';
import '../utils/generic_tree_widget.dart';

class FactionsMainPage extends StatefulWidget {
  const FactionsMainPage({
    super.key,
    this.selected,
  });

  final String? selected;

  @override
  State<FactionsMainPage> createState() => _FactionsMainPageState();
}

class _FactionsMainPageState extends State<FactionsMainPage> {
  late final TreeNode<GenericTreeData<FactionSummary>> fullTree;
  TreeNode<GenericTreeData<FactionSummary>>? filteredTree;
  late UniqueKey treeKey;
  final GenericTreeFilter<FactionSummary> treeFilter = GenericTreeFilter<FactionSummary>();
  late FactionTreeWidgetAdapter adapter;
  final TextEditingController sourceTypeController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  late FactionSelectionModel factionSelectionModel;

  @override
  void initState() {
    super.initState();

    factionSelectionModel = FactionSelectionModel(id: widget.selected);

    adapter = FactionTreeWidgetAdapter(
      itemSelectionCallback: (FactionSummary f) {
        factionSelectionModel.id = f.id;
      },
      itemCreationCallback: (Faction f) async {
        await Faction.saveLocalModel(f);
      }
    );

    fullTree = TreeNode.root();
  }

  Future<void> load() async {
    await FactionSummary.loadAll();
    await rebuildFullTree();
  }

  Future<void> rebuildFullTree() async {
    fullTree.clear();
    treeKey = UniqueKey();
    await buildSubTree(fullTree, null);
  }

  Future<void> buildSubTree(TreeNode root, FactionSummary? faction) async {
    for(var child in (await FactionSummary.withParent(faction?.id)).toList()..sort(FactionSummary.sortComparator)) {
      var node = TreeNode(
          key: child.id,
          data: GenericTreeData<FactionSummary>(
            item: child,
            showInfo: !child.displayOnly,
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
                        Text('Créer une faction'),
                      ],
                    ),
                    onPressed: () async {
                      var faction = await showDialog<Faction>(
                        context: context,
                        builder: (BuildContext context) => adapter.getItemCreationWidget(context, null),
                      );
                      if(faction == null) return;

                      await Faction.saveLocalModel(faction);
                      factionSelectionModel.id = faction.summary.id;

                      setState(() {
                        treeFilter.sourceType = ObjectSourceType.original;
                        treeFilter.source = ObjectSource.local;
                      });
                      rebuildFullTree();
                      updateFilteredTree();
                    },
                  ),
                  MenuItemButton(
                    child: const Row(
                      children: [
                        Icon(Icons.publish),
                        SizedBox(width: 4.0),
                        Text('Importer une faction'),
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
                        var jsonStr = const Utf8Decoder().convert(result.files.first.bytes!);
                        List<dynamic> j = json.decode(jsonStr);
                        await Faction.import(j);

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
                ],
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
                          sliver: GenericTreeWidget<FactionSummary, Faction>(
                            key: treeKey,
                            tree: filteredTree ?? fullTree,
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
                          onEdited: (Faction f) async {
                            await Faction.saveLocalModel(f);
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
                                    onPressed: () =>Navigator.of(context).pop(false),
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

                            Faction? current = f;
                            var path = f.id;
                            while (current != null && current.parentId != null) {
                              current = await Faction.byId(current.parentId!);
                              path = '${current!.id}.$path';
                            }

                            await Faction.delete(f);

                            var fullTreeNode = fullTree.elementAt(path);
                            fullTreeNode.parent?.remove(fullTreeNode);

                            if (filteredTree != null) {
                              var filteredTreeNode = filteredTree!.elementAt(path);
                              filteredTreeNode.parent?.remove(filteredTreeNode);
                            }

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
        ),
      ],
    );
  }
}