import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CharacterDigitInputWidget extends StatefulWidget {
  const CharacterDigitInputWidget({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.minValue = 1,
    this.maxValue = 15,
    this.label,
    this.collapsed = true,
    this.controller,
  });

  final int initialValue;
  final void Function(int) onChanged;
  final int minValue;
  final int maxValue;
  final String? label;
  final bool collapsed;
  final TextEditingController? controller;

  @override
  State<CharacterDigitInputWidget> createState() => _CharacterDigitInputWidgetState();
}

class _CharacterDigitInputWidgetState extends State<CharacterDigitInputWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.text = widget.initialValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        label: widget.label == null ? null : Text(widget.label!),
        labelStyle: theme.textTheme.labelSmall,
        floatingLabelStyle: theme.textTheme.labelLarge,
        border: const OutlineInputBorder(),
        isCollapsed: widget.collapsed,
        contentPadding: const EdgeInsets.all(12.0),
        error: null,
        errorText: null,
        prefix: InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            if(_controller.text.isEmpty) return;
            int? input = int.tryParse(_controller.text);
            if(input == null) return;
            if(input > widget.minValue) {
              input -= 1;
              setState(() {
                _controller.text = input.toString();
              });
              widget.onChanged(input);
            }
          },
          child: const Icon(
            Icons.remove,
            size: 12.0,
          ),
        ),
        suffix: InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            if(_controller.text.isEmpty) return;
            int? input = int.tryParse(_controller.text);
            if(input == null) return;
            if(input < widget.maxValue) {
              input += 1;
              setState(() {
                _controller.text = input.toString();
              });
              widget.onChanged(input);
            }
          },
          child: const Icon(
            Icons.add,
            size: 12.0,
          ),
        ),
      ),
      style: theme.textTheme.bodySmall,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      validator: (String? value) {
        if(value == null || value.isEmpty) return 'Valeur manquante';
        int? input = int.tryParse(value);
        if(input == null) return 'Pas un nombre';
        if(input < widget.minValue) return 'Nombre >= ${widget.minValue}';
        if(input > widget.maxValue) return 'Nombre <= ${widget.maxValue}';
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (String? value) {
        if(value == null) return;
        int? input = int.tryParse(value);
        if(input == null) return;
        widget.onChanged(input);
      },
    );
  }
}