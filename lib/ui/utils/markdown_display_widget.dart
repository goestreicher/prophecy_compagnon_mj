import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../../classes/resource_link/resource_link.dart';
import 'resource_link/link_handler.dart';

class MarkdownDisplayWidget extends StatelessWidget {
  const MarkdownDisplayWidget({
    super.key,
    required this.data,
    this.extraActionButtonBuilders,
  });

  final String data;
  final Map<ResourceLinkType, List<ExtraActionButtonBuilder>>? extraActionButtonBuilders;

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: data,
      onTapLink: (String text, String? href, String title) async {
        if(href == null) return;
        if(!ResourceLink.isValidLink(href)) return;

        var link = ResourceLink(name: text, link: href);
        handleResourceLinkClicked(
          link,
          context,
          extraActionButtonBuilders: extraActionButtonBuilders?[link.type],
        );
      },
    );
  }
}