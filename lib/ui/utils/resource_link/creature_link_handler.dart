import 'package:flutter/material.dart';

import '../../../classes/creature.dart';
import '../../../classes/resource_link/resource_link.dart';
import '../creature/display_widget.dart';

Future<Widget?> handleCreatureLinkClicked(ResourceLink link, BuildContext context) async {
  var creature = await CreatureSummary.get(link.id);
  if(!context.mounted) return null;

  if(creature == null) {
    return AlertDialog(
      title: const Text('Créature non trouvée'),
      content: Text(
          "Impossible de trouver la créature avec l'ID ${link.id}"
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
      title: Text(creature.name),
      content: SizedBox(
        width: 800,
        child: SingleChildScrollView(
          child: CreatureDisplayWidget(id: creature.id),
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