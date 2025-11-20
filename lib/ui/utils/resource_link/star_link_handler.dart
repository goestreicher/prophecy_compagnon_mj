import 'package:flutter/material.dart';

import '../../../classes/resource_link/resource_link.dart';
import '../../../classes/star.dart';
import '../star/display_widget.dart';

Future<Widget?> handleStarLinkClicked(ResourceLink link, BuildContext context) async {
  var star = await Star.get(link.id);
  if(!context.mounted) return null;

  if(star == null) {
    return AlertDialog(
      title: const Text('Étoile non trouvée'),
      content: Text(
        "Impossible de trouver l'étoile avec l'ID ${link.id}"
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
      title: Text(star.name),
      content: SizedBox(
        width: 800,
        child: SingleChildScrollView(
          child: StarDisplayWidget(id: star.id),
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