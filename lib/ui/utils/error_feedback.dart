import 'package:flutter/material.dart';

void displayErrorDialog(BuildContext context, String title, String content) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text('Erreur - $title'),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        )
      ],
    )
  );
}

class FullPageErrorWidget extends StatelessWidget {
  const FullPageErrorWidget({ super.key, required this.message, required this.canPop });

  final String message;
  final bool canPop;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurfaceVariant,
      ),
      child: Center(
        child: SizedBox(
          width: 320,
          child: Card(
            color: theme.colorScheme.surfaceContainerLow,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Erreur',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12.0),
                  Text(message),
                  if(canPop)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('OK'),
                      ),
                    ),
                  if(!canPop)
                    SizedBox(height: 8.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}