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
  late final TreeNode<GenericTreeData<Faction>> tree;
  late UniqueKey treeKey;
  final GenericTreeFilter<Faction> treeFilter = GenericTreeFilter<Faction>();
  late FactionTreeWidgetAdapter adapter;
  final TextEditingController sourceTypeController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();

  Faction? selectedFaction;

  @override
  void initState() {
    super.initState();
    tree = TreeNode.root();
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
    rebuildTree();
  }

  void rebuildTree() {
    tree.clear();
    treeKey = UniqueKey();
    buildSubTree(tree, null);
  }

  void buildSubTree(TreeNode root, Faction? faction) {
    for(var child in Faction.withParent(faction?.id).toList()..sort(Faction.sortComparator)) {
      bool match = treeFilter.matchesFilter(child);
      var node = TreeNode(
          key: child.id,
          data: GenericTreeData<Faction>(
            item: child,
            matchesCurrentFilter: match,
            showInfo: !child.displayOnly,
          )
      );
      buildSubTree(node, child);
      if(treeFilter.hasChildMatchingFilter(node) || child.location.type == ObjectLocationType.assets) {
        root.add(node);
      }
    }
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
                  label: const Text('Importer une faction'),
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
                        sliver: GenericTreeWidget<Faction>(
                          key: treeKey,
                          tree: tree,
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
                        var n = tree.elementAt(path);
                        setState(() {
                          selectedFaction = null;
                          tree.root.remove(n);
                        });

                        await Faction.delete(f);
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