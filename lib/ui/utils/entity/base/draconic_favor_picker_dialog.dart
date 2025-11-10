import 'package:flutter/material.dart';

import '../../../../classes/draconic_favor.dart';
import '../../../../classes/magic.dart';

class DraconicFavorPickerDialog extends StatefulWidget {
  const DraconicFavorPickerDialog({ super.key });

  @override
  State<DraconicFavorPickerDialog> createState() => _DraconicFavorPickerDialogState();
}

class _DraconicFavorPickerDialogState extends State<DraconicFavorPickerDialog> {
  final TextEditingController favorController = TextEditingController();

  MagicSphere? sphere;
  DraconicFavor? favor;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: Text('Faveurs draconiques'),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text('Annuler'),
        ),
        const SizedBox(width: 12.0),
        ElevatedButton(
          onPressed: favor == null ? null : () {
            Navigator.of(context, rootNavigator: true).pop(favor);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          child: const Text('OK'),
        )
      ],
      content: Row(
        spacing: 16.0,
        children: [
          SizedBox(
            width: 250,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 12.0,
              children: [
                DropdownMenu(
                  label: const Text('Sphère'),
                  requestFocusOnTap: true,
                  expandedInsets: EdgeInsets.zero,
                  onSelected: (MagicSphere? s) {
                    setState(() {
                      sphere = s;
                      favorController.clear();
                      favor = null;
                    });
                  },
                  dropdownMenuEntries: MagicSphere.values
                      .map((MagicSphere s) => DropdownMenuEntry(
                        value: s, label: s.title
                      ))
                      .toList(),
                ),
                DropdownMenu(
                  enabled: sphere != null,
                  label: const Text('Faveur'),
                  requestFocusOnTap: true,
                  expandedInsets: EdgeInsets.zero,
                  onSelected: (DraconicFavor? f) {
                    setState(() {
                      favor = f;
                    });
                  },
                  dropdownMenuEntries: sphere == null
                    ? <DropdownMenuEntry<DraconicFavor>>[]
                    : DraconicFavor.bySphere(sphere!)
                        .map(
                          (DraconicFavor f) => DropdownMenuEntry(
                            value: f,
                            label: f.title
                          )
                        )
                        .toList(),
                ),
              ],
            ),
          ),
          if(favor != null)
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 500,
                maxHeight: 400,
              ),
              child: SingleChildScrollView(child: Text(favor!.description)),
            ),
        ],
      ),
    );
  }
}