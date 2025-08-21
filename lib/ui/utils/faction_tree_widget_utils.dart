import 'package:flutter/material.dart';

import '../../classes/faction.dart';
import '../../classes/object_source.dart';
import 'faction_edit_dialog.dart';
import 'generic_tree_widget.dart';

class FactionTreeWidgetAdapter implements GenericTreeWidgetAdapter<Faction> {
  const FactionTreeWidgetAdapter({
    this.itemSelectionCallback,
    this.itemCreationCallback,
    this.newFactionSource,
  });

  final void Function(Faction)? itemSelectionCallback;
  final void Function(Faction)? itemCreationCallback;
  final ObjectSource? newFactionSource;

  @override
  void onItemSelected(Faction item) {
    itemSelectionCallback?.call(item);
  }

  @override
  void onItemCreated(Faction item) {
    itemCreationCallback?.call(item);
  }

  @override
  Widget getItemCreationWidget(BuildContext context, Faction? parent) {
    return FactionEditDialog(
      parentId: parent?.id,
      source: newFactionSource,
    );
  }
}