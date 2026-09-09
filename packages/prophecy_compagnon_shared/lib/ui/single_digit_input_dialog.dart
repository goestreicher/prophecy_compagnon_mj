import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SingleDigitInputDialog extends StatelessWidget {
  SingleDigitInputDialog({
    super.key,
    required this.title,
    required this.label,
    initialValue,
    this.minValue,
    this.maxValue,
  })
    : initialValue = initialValue ?? 0;

  final String title;
  final String label;
  final int initialValue;
  final int? minValue;
  final int? maxValue;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    _controller.text = initialValue.toString();

    return AlertDialog(
      title: Text(title),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    var curr = int.parse(_controller.text);
                    if(minValue == null || curr > minValue!) {
                      _controller.text = (curr - 1).toString();
                    }
                  },
                  icon: const Icon(Icons.remove),
                ),
                SizedBox(
                  width: 60.0,
                  child: TextFormField(
                    controller: _controller,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      label: Text(label),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (String? value) {
                      if(value == null || value.isEmpty) return 'Valeur manquante';
                      int? input = int.tryParse(value);
                      if(input == null) return 'Pas un nombre';
                      if(minValue != null && input < minValue!) return 'Nombre >= $minValue';
                      if(maxValue != null && input > maxValue!) return 'Nombre <= $maxValue';
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    var curr = int.parse(_controller.text);
                    if(maxValue == null || curr < maxValue!) {
                      _controller.text = (curr + 1).toString();
                    }
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
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
                      var input = int.parse(_controller.text);
                      _controller.clear();
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