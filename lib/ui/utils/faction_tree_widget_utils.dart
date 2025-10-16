import 'package:flutter/material.dart';

import '../../classes/faction.dart';
import '../../classes/object_source.dart';
import 'faction_edit_dialog.dart';
import 'generic_tree_widget.dart';

class FactionTreeWidgetAdapter implements GenericTreeWidgetAdapter<FactionSummary, Faction> {
  const FactionTreeWidgetAdapter({
    this.itemSelectionCallback,
    this.itemCreationCallback,
    this.newFactionSource,
  });

  final void Function(FactionSummary)? itemSelectionCallback;
  final void Function(Faction)? itemCreationCallback;
  final ObjectSource? newFactionSource;

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
    );
  }
}