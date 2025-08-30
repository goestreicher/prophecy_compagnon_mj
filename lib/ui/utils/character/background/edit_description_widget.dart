import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:parchment/codecs.dart';

import '../../../../classes/entity_base.dart';
import '../../markdown_fleather_toolbar.dart';
import '../widget_group_container.dart';

class CharacterEditDescriptionWidget extends StatefulWidget {
  const CharacterEditDescriptionWidget({
    super.key,
    required this.character,
  });

  final EntityBase character;

  @override
  State<CharacterEditDescriptionWidget> createState() => _CharacterEditDescriptionWidgetState();
}

class _CharacterEditDescriptionWidgetState extends State<CharacterEditDescriptionWidget> {
  late final FleatherController descriptionController;
  late final FocusNode descriptionFocusNode;

  @override
  void initState() {
    super.initState();

    descriptionFocusNode = FocusNode();
    ParchmentDocument document = ParchmentMarkdownCodec().decode(widget.character.description);
    descriptionController = FleatherController(document: document);
  }

  @override
  void dispose() {
    descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Description',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Column(
        spacing: 8.0,
        children: [
          MarkdownFleatherToolbar(
            controller: descriptionController,
            onSaved: (String value) {
              widget.character.description = value;
            },
          ),
          SizedBox(
            height: 300,
            child: FleatherField(
              controller: descriptionController,
              focusNode: descriptionFocusNode,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              expands: true,
            ),
          ),
        ],
      ),
    );
  }
}