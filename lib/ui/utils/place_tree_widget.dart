import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';

import 'place_edit_dialog.dart';
import '../../classes/object_source.dart';
import '../../classes/place.dart';

class PlaceTreeData {
  PlaceTreeData({ required this.place, this.matchesCurrentFilter = true});

  Place place;
  bool matchesCurrentFilter;
}

class PlaceTreeFilter {
  ObjectSourceType? sourceType;
  ObjectSource? source;

  bool isNull() => sourceType == null && source == null;

  bool matchesFilter(Place p) {
    if(source != null && p.source != source) {
      return false;
    }

    if(sourceType != null && p.source.type != sourceType) {
      return false;
    }

    return true;
  }

  bool hasChildMatchingFilter(TreeNode<PlaceTreeData> node) {
    var data = node.data as PlaceTreeData;
    if(data.matchesCurrentFilter) return true;

    for(var child in node.childrenAsList) {
      if(hasChildMatchingFilter(child as TreeNode<PlaceTreeData>)) {
        return true;
      }
    }

    return false;
  }
}

class PlaceTreeWidget extends StatefulWidget {
  const PlaceTreeWidget({
    super.key,
    required this.tree,
    this.filter,
    this.onPlaceSelected,
    this.newPlaceSource,
  });

  final TreeNode<PlaceTreeData> tree;
  final PlaceTreeFilter? filter;
  final void Function(Place)? onPlaceSelected;
  final ObjectSource? newPlaceSource;

  @override
  State<PlaceTreeWidget> createState() => _PlaceTreeWidgetState();
}

class _PlaceTreeWidgetState extends State<PlaceTreeWidget> {
  List<TreeNode<PlaceTreeData>> treeNodesToExpand = <TreeNode<PlaceTreeData>>[];

  void getNodesToExpand(TreeNode<PlaceTreeData> root) {
    if(widget.filter != null && widget.filter!.hasChildMatchingFilter(root)) {
      treeNodesToExpand.add(root);
      for(var child in root.childrenAsList) {
        getNodesToExpand(child as TreeNode<PlaceTreeData>);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    var kor = widget.tree.elementAt("kor") as TreeNode<PlaceTreeData>;
    if(widget.filter == null || widget.filter!.isNull()) {
      treeNodesToExpand.add(kor);
    }
    else {
      getNodesToExpand(kor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverTreeView.simple(
      tree: widget.tree,
      showRootNode: false,
      onTreeReady: (TreeViewController controller) {
        for(var node in treeNodesToExpand) {
          controller.expandNode(node);
        }
      },
      expansionIndicatorBuilder: (BuildContext context, node) {
        var data = node.data as PlaceTreeData;
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

        var data = node.data as PlaceTreeData;

        return Card(
          child: Padding(
            padding: EdgeInsets.fromLTRB(leftPad, 0.0, 6.0, 0.0),
            child: Row(
              children: [
                Text(
                  data.place.name,
                  style: data.matchesCurrentFilter
                      ? TextStyle(color: Colors.black)
                      : TextStyle(color: Colors.black26),
                ),
                Spacer(),
                if(data.matchesCurrentFilter)
                  IconButton(
                    icon: Icon(Icons.info_outline),
                    iconSize: 18.0,
                    onPressed: () {
                      widget.onPlaceSelected?.call(data.place);
                    },
                  ),
                IconButton(
                  icon: const Icon(Icons.add),
                  iconSize: 18.0,
                  tooltip: 'Nouveau lieu',
                  onPressed: () async {
                    var child = await showDialog<Place>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) =>
                          PlaceEditDialog(
                            parent: data.place.id,
                            source: widget.newPlaceSource,
                          ),
                    );
                    if(child == null) return;

                    setState(() {
                      node.add(
                        TreeNode(
                          key: child.id,
                          data: PlaceTreeData(
                            place: child,
                            matchesCurrentFilter: true
                          ),
                        )
                      );
                      widget.onPlaceSelected?.call(child);
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