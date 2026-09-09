import 'package:flutter/material.dart';
import 'package:prophecy_compagnon_shared/classes/resource_link/resource_link.dart';
import 'package:prophecy_compagnon_shared/ui/resource_link/creature_link_handler.dart';
import 'package:prophecy_compagnon_shared/ui/resource_link/encounter_link_handler.dart';
import 'package:prophecy_compagnon_shared/ui/resource_link/faction_link_handler.dart';
import 'package:prophecy_compagnon_shared/ui/resource_link/map_link_handler.dart';
import 'package:prophecy_compagnon_shared/ui/resource_link/npc_link_handler.dart';
import 'package:prophecy_compagnon_shared/ui/resource_link/pc_link_handler.dart';
import 'package:prophecy_compagnon_shared/ui/resource_link/place_link_handler.dart';
import 'package:prophecy_compagnon_shared/ui/resource_link/star_link_handler.dart';

typedef ExtraActionButtonBuilder = Widget Function(BuildContext, ResourceLink);

Future<void> handleResourceLinkClicked(
    ResourceLink link,
    BuildContext context,
    {
      List<ExtraActionButtonBuilder>? extraActionButtonBuilders,
    }
) async {
  Widget? dialog;

  Navigator.of(context, rootNavigator: true).push(
    DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    )
  );

  var extraActionButtons = (extraActionButtonBuilders ?? <ExtraActionButtonBuilder>[])
    .map(
      (ExtraActionButtonBuilder b) => b(context, link)
    ).toList();

  switch(link.type) {
    case ResourceLinkType.creature:
      dialog = await handleCreatureLinkClicked(
        link,
        context,
        extraActionButtons: extraActionButtons,
      );
      break;
    case ResourceLinkType.encounter:
      dialog = await handleEncounterLinkClicked(
        link,
        context,
        extraActionButtons: extraActionButtons,
      );
      break;
    case ResourceLinkType.faction:
      dialog = await handleFactionLinkClicked(
        link,
        context,
        extraActionButtons: extraActionButtons,
      );
      break;
    case ResourceLinkType.map:
      dialog = await handleMapLinkClicked(
        link,
        context,
        extraActionButtons: extraActionButtons,
      );
      break;
    case ResourceLinkType.npc:
      dialog = await handleNPCLinkClicked(
        link,
        context,
        extraActionButtons: extraActionButtons,
      );
      break;
    case ResourceLinkType.pc:
      dialog = await handlePCLinkClicked(
        link,
        context,
        extraActionButtons: extraActionButtons,
      );
      break;
    case ResourceLinkType.place:
      dialog = await handlePlaceLinkClicked(
        link,
        context,
        extraActionButtons: extraActionButtons,
      );
      break;
    case ResourceLinkType.star:
      dialog = await handleStarLinkClicked(
        link,
        context,
        extraActionButtons: extraActionButtons,
      );
      break;
  }

  if(!context.mounted) return;
  Navigator.of(context, rootNavigator: true).pop();

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