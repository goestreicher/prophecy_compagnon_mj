import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';

class MarkdownFleatherToolbar extends StatelessWidget {
  const MarkdownFleatherToolbar({ super.key, required this.controller });

  final FleatherController controller;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.canvasColor,
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: FleatherToolbar.basic(
        controller: controller,
        hideUnderLineButton: true, // Not supported by markdown
        hideForegroundColor: true, // Not supported by markdown
        hideBackgroundColor: true, // Not supported by markdown
        hideDirection: true,
        hideAlignment: true, // Not supported by markdown
        hideIndentation: true, // No-op for markdown
        hideHorizontalRule: true,
      ),
    );
  }
}