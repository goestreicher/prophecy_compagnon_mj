import 'package:flutter/material.dart';

import '../../../classes/non_player_character.dart';
import '../../../classes/resource_link/resource_link.dart';
import '../non_player_character/display_widget.dart';

Future<Widget?> handleNPCLinkClicked(ResourceLink link, BuildContext context) async {
  var npc = await NonPlayerCharacterSummary.get(link.id);
  if(!context.mounted) return null;

  if(npc == null) {
    return AlertDialog(
      title: const Text('PNJ non trouvé'),
      content: Text(
        "Impossible de trouver le PNJ avec l'ID ${link.id}"
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
      title: Text(npc.name),
      content: SizedBox(
        width: 800,
        child: SingleChildScrollView(
          child: NPCDisplayWidget(id: npc.id),
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