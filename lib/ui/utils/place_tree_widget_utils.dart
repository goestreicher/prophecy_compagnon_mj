import 'package:flutter/material.dart';

import '../../classes/object_source.dart';
import '../../classes/place.dart';
import 'error_feedback.dart';
import 'generic_tree_widget.dart';
import 'place_edit_dialog.dart';

class PlaceTreeWidgetAdapter implements GenericTreeWidgetAdapter<PlaceSummary, Place> {
  const PlaceTreeWidgetAdapter({
    this.itemSelectionCallback,
    this.itemCreationCallback,
    this.newPlaceSource,
  });

  final void Function(PlaceSummary)? itemSelectionCallback;
  final void Function(Place)? itemCreationCallback;
  final ObjectSource? newPlaceSource;

  @override
  PlaceSummary toTreeDataType(Place p) => p.summary;

  @override
  void onItemSelected(PlaceSummary item) {
    itemSelectionCallback?.call(item);
  }

  @override
  void onItemCreated(Place item) {
    itemCreationCallback?.call(item);
  }

  @override
  Widget getItemCreationWidget(BuildContext context, PlaceSummary? parent) {
    if(parent == null) {
      return FullPageErrorWidget(
        message: 'Impossible de créer un nouveau lieu sans parent',
        canPop: true,
      );
    }

    return PlaceEditDialog(
      parent: parent.id,
      source: newPlaceSource,
    );
  }
}