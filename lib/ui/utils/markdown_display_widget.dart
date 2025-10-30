import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

class MarkdownDisplayWidget extends StatelessWidget {
  const MarkdownDisplayWidget({ super.key, required this.data });

  final String data;

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: data,
      onTapLink: (String text, String? href, String title) {
        print('$text - $href - $title');
      },
    );
  }
}