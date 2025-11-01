import 'package:flutter/material.dart';

import '../../../classes/place_map.dart';
import '../../../classes/resource_link/resource_link.dart';
import '../place_map/display_widget.dart';

Future<Widget?> handleMapLinkClicked(ResourceLink link, BuildContext context) async {
  var map = await PlaceMapStore().get(link.id);
  if(!context.mounted) return null;

  if(map == null) {
    return AlertDialog(
      title: const Text('Carte non trouvée'),
      content: Text(
        "Impossible de trouver la carte avec l'ID ${link.id}"
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
      title: Text(link.name),
      content: SizedBox(
        width: 800,
        child: PlaceMapDisplayWidget(map: map),
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