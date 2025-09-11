import 'package:flutter/material.dart';

class AttributeDisplayWidget extends StatelessWidget {
  const AttributeDisplayWidget({ super.key, required this.name, required this.value });
  
  final String name;
  final int value;
  
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      spacing: 8.0,
      children: [
        Text(
          name,
          textAlign: TextAlign.end,
          style: theme.textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          height: 24.0,
          width: 36.0,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Center(
            child: Text(
              value.toString(),
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ),
      ],
    );
  }
}