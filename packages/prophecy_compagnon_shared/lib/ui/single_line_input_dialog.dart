import 'package:flutter/material.dart';

class SingleLineInputDialog extends StatelessWidget {
  SingleLineInputDialog({
    super.key,
    required this.title,
    required this.formKey,
    this.hintText = 'Valeur',
  });

  final String title;
  final GlobalKey<FormState> formKey;
  final String hintText;
  final TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: inputController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: hintText,
              ),
              validator: (String? value) {
                if(value == null || value.isEmpty) {
                  return 'La valeur est obligatoire';
                }
                return null;
              },
              onFieldSubmitted: (value) {
                if(formKey.currentState!.validate()) {
                  var input = inputController.text;
                  inputController.clear();
                  Navigator.of(context).pop(input);
                }
              },
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
                      var input = inputController.text;
                      inputController.clear();
                      Navigator.of(context).pop(input);
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