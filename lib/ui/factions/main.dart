import 'dart:convert';

import 'package:animated_tree_view/tree_view/tree_node.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../classes/faction.dart';
import '../../classes/object_location.dart';
import '../../classes/object_source.dart';
import '../utils/error_feedback.dart';
import '../utils/faction_display_widget.dart';
import '../utils/faction_tree_widget_utils.dart';
import '../utils/generic_tree_widget.dart';

class FactionsMainPage extends StatefulWidget {
  const FactionsMainPage({
    super.key,
  });

  @override
  State<FactionsMainPage> createState() => _FactionsMainPageState();
}

class _FactionsMainPageState extends State<FactionsMainPage> {
  late final TreeNode<GenericTreeData<Faction>> fullTree;
  TreeNode<GenericTreeData<Faction>>? filteredTree;
  late UniqueKey treeKey;
  final GenericTreeFilter<Faction> treeFilter = GenericTreeFilter<Faction>();
  late FactionTreeWidgetAdapter adapter;
  final TextEditingController sourceTypeController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  Faction? selectedFaction;

  @override
  void initState() {
    super.initState();

    adapter = FactionTreeWidgetAdapter(
      itemSelectionCallback: (Faction f) {
        setState(() {
          selectedFaction = f;
        });
      },
      itemCreationCallback: (Faction f) async {
        await FactionStore().save(f);
      }
    );

    fullTree = TreeNode.root();
    rebuildFullTree();
  }

  void rebuildFullTree() {
    fullTree.clear();
    treeKey = UniqueKey();
    buildSubTree(fullTree, null);
  }

  void buildSubTree(TreeNode root, Faction? faction) {
    for(var child in Faction.withParent(faction?.id).toList()..sort(Faction.sortComparator)) {
      var node = TreeNode(
          key: child.id,
          data: GenericTreeData<Faction>(
            item: child,
            showInfo: !child.displayOnly,
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

                      await FactionStore().save(faction);

                      setState(() {
                        treeFilter.sourceType = ObjectSourceType.original;
                        treeFilter.source = ObjectSource.local;
                        selectedFaction = faction;
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
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                        padding: const EdgeInsets.only(right: 8.0),
                        sliver: GenericTreeWidget<Faction>(
                          key: treeKey,
                          tree: filteredTree ?? fullTree,
                          filter: treeFilter,
                          adapter: adapter,
                        )
                    )
                  ],
                ),
              ),
              if(selectedFaction != null)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(4.0, 16.0, 0.0, 16.0),
                    child: FactionDisplayWidget(
                      faction: selectedFaction!,
                      onEdited: (Faction f) async {
                        await FactionStore().save(f);
                        setState(() {
                          selectedFaction = f;
                        });
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
                          current = Faction.byId(current.parentId!);
                          path = '${current!.id}.$path';
                        }

                        await Faction.delete(f);

                        var fullTreeNode = fullTree.elementAt(path);
                        fullTreeNode.parent?.remove(fullTreeNode);

                        if(filteredTree != null) {
                          var filteredTreeNode = filteredTree!.elementAt(path);
                          filteredTreeNode.parent?.remove(filteredTreeNode);
                        }

                        setState(() {
                          selectedFaction = null;
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