import 'package:flutter/material.dart';

import '../../../classes/player_character.dart';
import '../../../classes/resource_link/resource_link.dart';
import '../../player_character/display_widget.dart';

Future<Widget?> handlePCLinkClicked(ResourceLink link, BuildContext context) async {
  var pc = await PlayerCharacterSummaryStore().get(link.id);
  if(!context.mounted) return null;

  if(pc == null) {
    return AlertDialog(
      title: const Text('PJ non trouvé'),
      content: Text(
        "Impossible de trouver le PJ avec l'ID ${link.id}"
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
      title: Text(pc.name),
      content: SizedBox(
        width: 800,
        child: SingleChildScrollView(
          child: PCDisplayWidget(id: pc.id),
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