import 'package:flutter/material.dart';

class SingleDropdownInputDialog extends StatelessWidget {
  SingleDropdownInputDialog({
    super.key,
    required this.title,
    required this.label,
    required this.entries,
  });

  final String title;
  final String label;
  final List<String> entries;

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: Text(title),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownMenu(
              dropdownMenuEntries: entries.map((String e) => DropdownMenuEntry(value: e, label: e)).toList(),
              requestFocusOnTap: true,
              label: Text(label),
              controller: _controller,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Annuler'),
                  ),
                  const SizedBox(width: 12.0),
                  ElevatedButton(
                    onPressed: () {
                      if(_controller.text.isEmpty) return;
                      Navigator.of(context).pop(_controller.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                    ),
                    child: const Text('OK'),
                  )
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}