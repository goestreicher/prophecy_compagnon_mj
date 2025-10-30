import 'package:flutter/material.dart';

import '../../../classes/faction.dart';
import '../../../classes/object_source.dart';
import '../../../classes/resource_link/resource_link.dart';
import '../generic_tree_widget.dart';
import 'faction_edit_dialog.dart';

class FactionTreeWidgetAdapter implements GenericTreeWidgetAdapter<FactionSummary, Faction> {
  const FactionTreeWidgetAdapter({
    this.itemSelectionCallback,
    this.itemCreationCallback,
    this.newFactionSource,
    this.resourceLinkProvider,
  });

  final void Function(FactionSummary)? itemSelectionCallback;
  final void Function(Faction)? itemCreationCallback;
  final ObjectSource? newFactionSource;
  final ResourceLinkProvider? resourceLinkProvider;

  @override
  FactionSummary toTreeDataType(Faction f) => f.summary;

  @override
  void onItemSelected(FactionSummary item) {
    itemSelectionCallback?.call(item);
  }

  @override
  void onItemCreated(Faction item) {
    itemCreationCallback?.call(item);
  }

  @override
  Widget getItemCreationWidget(BuildContext context, FactionSummary? parent) {
    return FactionEditDialog(
      parentId: parent?.id,
      source: newFactionSource,
      resourceLinkProvider: resourceLinkProvider,
    );
  }
}