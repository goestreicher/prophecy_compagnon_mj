import 'package:flutter/material.dart';
import 'package:prophecy_compagnon_shared/classes/faction.dart';
import 'package:prophecy_compagnon_shared/classes/resource_link/resource_link.dart';
import 'package:prophecy_compagnon_shared/ui/faction/faction_display_widget.dart';

Future<Widget?> handleFactionLinkClicked(
    ResourceLink link,
    BuildContext context,
    {
      List<Widget>? extraActionButtons,
    }
) async {
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
        ...?extraActionButtons,
        TextButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            child: const Text('OK')
        ),
      ],
    );
  }
}