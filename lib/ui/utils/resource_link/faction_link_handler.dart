import 'package:flutter/material.dart';

import '../../../classes/faction.dart';
import '../../../classes/resource_link/resource_link.dart';
import '../faction/faction_display_widget.dart';

Future<Widget?> handleFactionLinkClicked(ResourceLink link, BuildContext context) async {
  var faction = await FactionSummary.get(link.id);
  if(!context.mounted) return null;

  if(faction == null) {
    return AlertDialog(
      title: const Text('Faction non trouvée'),
      content: Text(
        "Impossible de trouver la faction avec l'ID ${link.id}"
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
      title: Text(faction.name),
      content: SizedBox(
        width: 800,
        child: SingleChildScrollView(
          child: FactionDisplayWidget(
            factionId: faction.id,
          ),
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