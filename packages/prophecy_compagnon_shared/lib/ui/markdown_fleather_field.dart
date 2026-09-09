import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';

class MarkdownFleatherField extends StatelessWidget {
  const MarkdownFleatherField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.expands = false,
    this.decoration,
  });

  final FleatherController controller;
  final FocusNode focusNode;
  final bool expands;
  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return FleatherTheme(
      data: FleatherThemeData.fallback(context).copyWith(
          link: FleatherThemeData.fallback(context).link.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          )
      ),
      child: FleatherField(
        controller: controller,
        focusNode: focusNode,
        decoration: decoration ?? const InputDecoration(
          border: OutlineInputBorder(),
        ),
        expands: expands,
      ),
    );
  }
}