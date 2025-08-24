import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';

import '../../classes/object_source.dart';
import '../../classes/resource_base_class.dart';

class GenericTreeData<T extends ResourceBaseClass> {
  GenericTreeData({
    required this.item,
    this.matchesCurrentFilter = true,
    this.descendantMatchesCurrentFilter = true,
    this.showInfo = true,
    this.canCreateChildren = true,
  });

  T item;
  bool matchesCurrentFilter;
  bool descendantMatchesCurrentFilter;
  bool showInfo;
  bool canCreateChildren;
}

class GenericTreeFilter<T extends ResourceBaseClass> {
  ObjectSourceType? sourceType;
  ObjectSource? source;
  String? nameFilter;

  bool isNull() => sourceType == null && source == null && nameFilter == null;

  TreeNode<GenericTreeData<T>>? createFilteredTree(TreeNode<GenericTreeData<T>> root) {
    if(root.data == null && !root.isRoot) {
      return null;
    }

    TreeNode<GenericTreeData<T>>? filteredRoot;
    List<TreeNode<GenericTreeData<T>>> filteredChildren = <TreeNode<GenericTreeData<T>>>[];

    for(var child in root.childrenAsList) {
      var cast = child as TreeNode<GenericTreeData<T>>;

      if(cast.data == null) {
        continue;
      }

      var filteredChild = createFilteredTree(child);
      if(filteredChild != null) filteredChildren.add(filteredChild);
    }

    bool filteredRootMatches = root.isRoot || matchesFilter(root.data!.item);

    if(filteredRootMatches || filteredChildren.isNotEmpty) {
      if(root.isRoot) {
        filteredRoot = TreeNode.root();
      }
      else {
        filteredRoot = TreeNode(
          key: root.data!.item.id,
          data: GenericTreeData(
            item: root.data!.item,
            showInfo: root.data!.showInfo,
            canCreateChildren: root.data!.canCreateChildren,
            matchesCurrentFilter: filteredRootMatches,
            descendantMatchesCurrentFilter: filteredChildren.isNotEmpty,
          ),
        );
      }

      for(var filteredChild in filteredChildren) {
        filteredRoot.add(filteredChild);
      }
    }

    return filteredRoot;
  }

  bool matchesFilter(T t) {
    if(source != null && t.source != source) {
      return false;
    }

    if(sourceType != null && t.source.type != sourceType) {
      return false;
    }

    if(nameFilter != null && !t.name.toLowerCase().contains(nameFilter!.toLowerCase())) {
      return false;
    }

    return true;
  }

  bool hasChildMatchingFilter(TreeNode<GenericTreeData<T>> node) {
    for(var child in node.childrenAsList) {
      var data = (child as TreeNode<GenericTreeData<T>>).data;
      if(data != null && data.matchesCurrentFilter) return true;
    }

    return false;
  }
}

abstract interface class GenericTreeWidgetAdapter<T extends ResourceBaseClass> {
  void onItemSelected(T item);
  void onItemCreated(T item);
  Widget getItemCreationWidget(BuildContext context, T? parent);
}

class GenericTreeWidget<T extends ResourceBaseClass> extends StatefulWidget {
  const GenericTreeWidget({
    super.key,
    required this.tree,
    this.filter,
    required this.adapter,
    this.autoExpandLevel = 0,
  });

  final TreeNode<GenericTreeData<T>> tree;
  final GenericTreeFilter<T>? filter;
  final GenericTreeWidgetAdapter<T> adapter;
  final int autoExpandLevel;

  @override
  State<GenericTreeWidget<T>> createState() => _GenericTreeWidgetState<T>();
}

class _GenericTreeWidgetState<T extends ResourceBaseClass> extends State<GenericTreeWidget<T>> {
  List<TreeNode<GenericTreeData<T>>> nodesToExpand = <TreeNode<GenericTreeData<T>>>[];

  void getNodesToExpand(TreeNode<GenericTreeData<T>> root, int forceExpansionLevel) {
    if(forceExpansionLevel > 0) {
      nodesToExpand.add(root);
      for(var child in root.childrenAsList) {
        getNodesToExpand(child as TreeNode<GenericTreeData<T>>, forceExpansionLevel - 1);
      }
    }
    else if(widget.filter != null && !widget.filter!.isNull()) {
      if(root.data == null) return;

      if(root.data!.matchesCurrentFilter) {
        nodesToExpand.add(root);
      }
      else if(root.data!.descendantMatchesCurrentFilter) {
        nodesToExpand.add(root);
        for (var child in root.childrenAsList) {
          getNodesToExpand(child as TreeNode<GenericTreeData<T>>, 0);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    nodesToExpand.clear();
    for(var n in widget.tree.root.childrenAsList) {
      getNodesToExpand(n as TreeNode<GenericTreeData<T>>, widget.autoExpandLevel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverTreeView.simple(
      tree: widget.tree,
      showRootNode: false,
      onTreeReady: (TreeViewController controller) {
        for(var node in nodesToExpand) {
          controller.expandNode(node);
        }
      },
      expansionIndicatorBuilder: (BuildContext context, node) {
        var data = node.data as GenericTreeData<T>;
        return ChevronIndicator.rightDown(
            tree: node,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
            color: data.matchesCurrentFilter
                ? Colors.black
                : Colors.black26
        );
      },
      indentation: const Indentation(),
      builder: (BuildContext context, TreeNode node) {
        var leftPad = 12.0;
        if(node.children.isNotEmpty) {
          leftPad = 24.0;
        }

        var data = node.data as GenericTreeData<T>;

        return Card(
          child: Padding(
            padding: EdgeInsets.fromLTRB(leftPad, 0.0, 6.0, 0.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                    data.item.name,
                    style: data.matchesCurrentFilter
                        ? TextStyle(color: Colors.black)
                        : TextStyle(color: Colors.black26),
                  ),
                ),
                if(data.matchesCurrentFilter && data.showInfo)
                  IconButton(
                    icon: Icon(Icons.info_outline),
                    iconSize: 18.0,
                    onPressed: () {
                      widget.adapter.onItemSelected(data.item);
                    },
                  ),
                if(data.canCreateChildren)
                  IconButton(
                    icon: const Icon(Icons.add),
                    iconSize: 18.0,
                    tooltip: 'Ajouter',
                    onPressed: () async {
                      var item = await showDialog<T>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) => widget.adapter.getItemCreationWidget(context, data.item),
                      );
                      if(item == null) return;

                      node.add(
                        TreeNode(
                          key: item.id,
                          data: GenericTreeData<T>(item: item),
                        )
                      );
                      widget.adapter.onItemCreated(item);
                      widget.adapter.onItemSelected(item);
                    },
                  ),
              ],
            ),
          ),
        );
      }
    );
  }
}