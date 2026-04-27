import 'package:flutter/material.dart';

import '../../classes/resource_link/assets_resource_link_provider.dart';
import '../../classes/resource_link/resource_link.dart';
import 'resource_link_edit_widget.dart';

class ResourceLinkPickerDialog extends StatefulWidget {
  const ResourceLinkPickerDialog({
    super.key,
    this.localProvider,
    this.restrictToTypes,
  });

  final ResourceLinkProvider? localProvider;
  final List<ResourceLinkType>? restrictToTypes;

  @override
  State<ResourceLinkPickerDialog> createState() => _ResourceLinkPickerDialogState();
}

class _ResourceLinkPickerDialogState extends State<ResourceLinkPickerDialog> {
  late ResourceLinkProvider selectedProvider;
  ResourceLink? selected;

  @override
  void initState() {
    super.initState();

    selectedProvider = widget.localProvider ?? const AssetsResourceLinkProvider();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Sélection de la ressource'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12.0,
          children: [
            if(widget.localProvider != null)
              Row(
                spacing: 16.0,
                children: [
                  Switch(
                    value: widget.localProvider == selectedProvider,
                    onChanged: (bool value) {
                      setState(() {
                        selectedProvider = value
                            ? widget.localProvider!
                            : const AssetsResourceLinkProvider();
                        selected = null;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                        widget.localProvider == selectedProvider
                            ? 'Utiliser les ressources locales (${widget.localProvider!.sourceNames()[0]}'
                            : 'Utiliser les ressources de base'
                    ),
                  ),
                ],
              ),
            ResourceLinkEditWidget(
                provider: selectedProvider,
                restrictToTypes: widget.restrictToTypes,
                onChanged: (ResourceLink? l) {
                  setState(() {
                    selected = l;
                  });
                }
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: const Text('Annuler'),
                  ),
                  const SizedBox(width: 12.0),
                  ElevatedButton(
                    onPressed: selected == null ? null : () {
                      Navigator.of(context, rootNavigator: true).pop(selected);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                    ),
                    child: const Text('OK'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}