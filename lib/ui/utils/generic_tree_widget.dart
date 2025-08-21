import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';

import '../../classes/object_source.dart';
import '../../classes/resource_base_class.dart';

class GenericTreeData<T extends ResourceBaseClass> {
  GenericTreeData({
    required this.item,
    this.matchesCurrentFilter = true,
    this.showInfo = true,
    this.canCreateChildren = true,
  });

  T item;
  bool matchesCurrentFilter;
  bool showInfo;
  bool canCreateChildren;
}

class GenericTreeFilter<T extends ResourceBaseClass> {
  ObjectSourceType? sourceType;
  ObjectSource? source;

  bool isNull() => sourceType == null && source == null;

  bool matchesFilter(T t) {
    if(source != null && t.source != source) {
      return false;
    }

    if(sourceType != null && t.source.type != sourceType) {
      return false;
    }

    return true;
  }

  bool hasChildMatchingFilter(TreeNode<GenericTreeData<T>> node) {
    var data = node.data as GenericTreeData<T>;
    if(data.matchesCurrentFilter) return true;

    for(var child in node.childrenAsList) {
      if(hasChildMatchingFilter(child as TreeNode<GenericTreeData<T>>)) {
        return true;
      }
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
  });

  final TreeNode<GenericTreeData<T>> tree;
  final GenericTreeFilter<T>? filter;
  final GenericTreeWidgetAdapter<T> adapter;

  @override
  State<GenericTreeWidget<T>> createState() => _GenericTreeWidgetState<T>();
}

class _GenericTreeWidgetState<T extends ResourceBaseClass> extends State<GenericTreeWidget<T>> {
  List<TreeNode<GenericTreeData<T>>> nodesToExpand = <TreeNode<GenericTreeData<T>>>[];

  void getNodesToExpand(TreeNode<GenericTreeData<T>> root) {
    if(widget.filter != null && !widget.filter!.isNull() && widget.filter!.hasChildMatchingFilter(root)) {
      nodesToExpand.add(root);
      for(var child in root.childrenAsList) {
        getNodesToExpand(child as TreeNode<GenericTreeData<T>>);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    nodesToExpand.clear();
    for(var n in widget.tree.root.childrenAsList) {
      getNodesToExpand(n as TreeNode<GenericTreeData<T>>);
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

                      setState(() {
                        node.add(
                          TreeNode(
                            key: item.id,
                            data: GenericTreeData<T>(item: item),
                          )
                        );
                        widget.adapter.onItemCreated(item);
                        widget.adapter.onItemSelected(item);
                      });
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