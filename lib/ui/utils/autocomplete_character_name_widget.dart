import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../classes/object_source.dart';
import '../../classes/resource_link/resource_link.dart';
import '../../classes/resource_link/sourced_resource_link_provider.dart';
import 'resource_link_picker_dialog.dart';

Widget resourceLinkNameAutocompleteWidget(
    BuildContext context,
    void Function(String) onInput,
    List<ResourceLinkType> types,
) {
  var theme = Theme.of(context);

  return ListView(
    shrinkWrap: true,
    children: [
      ListTile(
        leading: Icon(Symbols.person),
        title: const Text('Sélectionner un PNJ existant'),
        tileColor: theme.colorScheme.surfaceBright,
        onTap: () async {
          var r = await showDialog<ResourceLink?>(
            context: context,
            builder: (BuildContext context) {
              return ResourceLinkPickerDialog(
                restrictToTypes: types,
                localProvider: SourcedResourceLinkProvider(
                  source: ObjectSource.local,
                ),
              );
            }
          );

          if(r != null) onInput(r.name);
        },
      ),
    ],
  );
}

Widget characterNameAutocompleteWidget(BuildContext context, void Function(String) onInput) {
  return resourceLinkNameAutocompleteWidget(
      context,
      onInput,
      [
        ResourceLinkType.npc,
        ResourceLinkType.pc,
      ]
  );
}