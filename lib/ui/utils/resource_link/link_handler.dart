import 'package:flutter/material.dart';

import '../../../classes/resource_link/resource_link.dart';
import 'creature_link_handler.dart';
import 'map_link_handler.dart';
import 'npc_link_handler.dart';
import 'place_link_handler.dart';

void handleResourceLinkClicked(ResourceLink link, BuildContext context) async {
  Widget? dialog;

  switch(link.type) {
    case ResourceLinkType.creature:
      dialog = await handleCreatureLinkClicked(link, context);
      break;
    case ResourceLinkType.map:
      dialog = await handleMapLinkClicked(link, context);
      break;
    case ResourceLinkType.npc:
      dialog = await handleNPCLinkClicked(link, context);
      break;
    case ResourceLinkType.place:
      dialog = await handlePlaceLinkClicked(link, context);
      break;
    default:
      dialog = handleUnsupportedResourceType(link, context);
      break;
  }

  if(!context.mounted) return;

  if(dialog != null) {
    await showDialog(
      context: context,
      builder: (BuildContext context) => dialog!,
    );
  }
}

Widget handleUnsupportedResourceType(ResourceLink link, BuildContext context) {
  return AlertDialog(
    title: const Text('Type de lien non supporté'),
    content: Text(
      "Les liens vers les ressources de type '${link.type.name}' ne sont pas encore supportés."
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        child: const Text('OK')
      ),
    ],
  );
}