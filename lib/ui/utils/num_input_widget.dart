import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumDoubleInputWidget extends StatefulWidget {
  const NumDoubleInputWidget({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.onSaved,
    this.minValue = 0.0,
    this.maxValue = 10.0,
    this.increment = 0.1,
    this.decimals = 2,
    this.label,
    this.collapsed = true,
    this.enabled = true,
    this.controller,
  });

  final double initialValue;
  final void Function(double) onChanged;
  final void Function(double)? onSaved;
  final double minValue;
  final double maxValue;
  final double increment;
  final int decimals;
  final String? label;
  final bool collapsed;
  final bool enabled;
  final TextEditingController? controller;

  @override
  State<NumDoubleInputWidget> createState() => _NumDoubleInputWidgetState();
}

class _NumDoubleInputWidgetState extends State<NumDoubleInputWidget> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController();
    controller.text = widget.initialValue.toString();
  }

  double roundValue(double input) {
    var p = pow(10, widget.decimals);
    return (input * p).round() / p;
  }
  
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      enabled: widget.enabled,
      decoration: InputDecoration(
        label: widget.label == null
            ? null
            : Text(
          widget.label!,
          maxLines: 1,
          overflow: TextOverflow.clip,
        ),
        labelStyle: theme.textTheme.labelSmall,
        floatingLabelStyle: theme.textTheme.labelLarge,
        border: const OutlineInputBorder(),
        isCollapsed: widget.collapsed,
        contentPadding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
        error: null,
        errorText: null,
        prefix: InkWell(
          onTap: !widget.enabled ? null : () {
            FocusScope.of(context).unfocus();
            if(controller.text.isEmpty) return;
            double? input = double.tryParse(controller.text);
            if(input == null) return;
            if(input > widget.minValue) {
              input = roundValue(input - widget.increment);
              setState(() {
                controller.text = input!.toStringAsFixed(widget.decimals);
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
          onTap: !widget.enabled ? null : () {
            FocusScope.of(context).unfocus();
            if(controller.text.isEmpty) return;
            double? input = double.tryParse(controller.text);
            if(input == null) return;
            if(input < widget.maxValue) {
              input = roundValue(input + widget.increment);
              setState(() {
                controller.text = input!.toStringAsFixed(widget.decimals);
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
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[.0-9]')),
      ],
      validator: (String? value) {
        if(value == null || value.isEmpty) return 'Valeur manquante';
        double? input = double.tryParse(value);
        if(input == null) return 'Pas un nombre';
        if(input < widget.minValue) return 'Nombre >= ${widget.minValue}';
        if(input > widget.maxValue) return 'Nombre <= ${widget.maxValue}';
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (String? value) {
        if(value == null) return;
        double? input = double.tryParse(value);
        if(input == null) return;
        widget.onChanged(input);
      },
      onSaved: (String? value) {
        widget.onSaved?.call(double.parse(value!));
      },
    );
  }
}

class NumIntInputWidget extends StatelessWidget {
  const NumIntInputWidget({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.onSaved,
    this.minValue = 1,
    this.maxValue = 15,
    this.label,
    this.collapsed = true,
    this.enabled = true,
    this.controller,
  });

  final int initialValue;
  final void Function(int) onChanged;
  final void Function(int)? onSaved;
  final int minValue;
  final int maxValue;
  final String? label;
  final bool collapsed;
  final bool enabled;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return NumDoubleInputWidget(
      key: key,
      initialValue: initialValue.toDouble(),
      minValue: minValue.toDouble(),
      maxValue: maxValue.toDouble(),
      increment: 1.0,
      decimals: 0,
      label: label,
      collapsed: collapsed,
      enabled: enabled,
      controller: controller,
      onChanged: (double v) => onChanged(v.ceil()),
      onSaved: onSaved == null ? null : (double v) {
        onSaved!(v.ceil());
      }
    );
  }
}