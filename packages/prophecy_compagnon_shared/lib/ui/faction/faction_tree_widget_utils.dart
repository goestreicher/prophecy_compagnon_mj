import 'package:flutter/material.dart';
import 'package:prophecy_compagnon_shared/classes/faction.dart';
import 'package:prophecy_compagnon_shared/classes/object_source.dart';
import 'package:prophecy_compagnon_shared/classes/resource_link/resource_link.dart';
import 'package:prophecy_compagnon_shared/ui/faction/faction_edit_dialog.dart';
import 'package:prophecy_compagnon_shared/ui/generic_tree_widget.dart';

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