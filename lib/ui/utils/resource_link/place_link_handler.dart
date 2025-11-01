import 'package:flutter/material.dart';

import '../../../classes/place.dart';
import '../../../classes/resource_link/resource_link.dart';
import '../place/place_display_widget.dart';

Future<Widget?> handlePlaceLinkClicked(ResourceLink link, BuildContext context) async {
  var place = await PlaceSummary.byId(link.id);
  if(!context.mounted) return null;

  if(place == null) {
    return AlertDialog(
      title: const Text('Lieu non trouvé'),
      content: Text(
        "Impossible de trouver le lieu avec l'ID ${link.id}"
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: const Text('OK')
        ),
      ],
    );
  }
  else {
    return AlertDialog(
      title: Text(place.name),
      content: SizedBox(
        width: 800,
        child: SingleChildScrollView(
          child: PlaceDisplayWidget(placeId: place.id),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: const Text('OK')
        ),
      ],
    );
  }
}