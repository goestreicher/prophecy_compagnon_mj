import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_shared/classes/resource_link/resource_link.dart';
import 'package:prophecy_compagnon_shared/classes/scenario/scenario.dart';
import 'package:prophecy_compagnon_shared/classes/scenario/scenario_encounter.dart';
import 'package:prophecy_compagnon_shared/ui/scenario/encounter_display_widget.dart';

Future<Widget?> handleEncounterLinkClicked(
    ResourceLink link,
    BuildContext context,
    {
      List<Widget>? extraActionButtons,
    }
) async {
  var scenario = await ScenarioStore().get(link.uri.pathSegments[1]);
  if(scenario == null) {
    return AlertDialog(
      title: const Text('Scénario non trouvé'),
      content: Text(
          "Impossible de trouver le scénario avec l'ID ${link.uri.pathSegments[1]}"
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: const Text('OK')
        ),
      ],
    );
  }

  ScenarioEncounter? encounter;
  for(var e in scenario.encounters) {
    if(e.uuid == link.id) {
      encounter = e;
      break;
    }
  }

  if(encounter == null) {
    return AlertDialog(
      title: const Text('Rencontre non trouvée'),
      content: Text(
          "Impossible de trouver la rencontre avec l'ID ${link.id}"
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
      title: Text('Rencontre ${link.name}'),
      content: SizedBox(
        width: 400,
        child: ScenarioEncounterDisplayWidget(encounter: encounter),
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