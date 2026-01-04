import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:parchment/codecs.dart';

import '../../../../classes/entity_base.dart';
import '../../../../classes/resource_link/assets_resource_link_provider.dart';
import '../../../../classes/resource_link/multi_resource_link_provider.dart';
import '../../../../classes/resource_link/resource_link.dart';
import '../../../../classes/resource_link/sourced_resource_link_provider.dart';
import '../../markdown_fleather_toolbar.dart';
import '../../widget_group_container.dart';

class EntityEditDescriptionWidget extends StatefulWidget {
  const EntityEditDescriptionWidget({
    super.key,
    required this.entity,
  });

  final EntityBase entity;

  @override
  State<EntityEditDescriptionWidget> createState() => _EntityEditDescriptionWidgetState();
}

class _EntityEditDescriptionWidgetState extends State<EntityEditDescriptionWidget> {
  late final FleatherController descriptionController;
  late final FocusNode descriptionFocusNode;

  @override
  void initState() {
    super.initState();

    descriptionFocusNode = FocusNode();
    ParchmentDocument document = ParchmentMarkdownCodec().decode(widget.entity.description);
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
          MarkdownFleatherToolbarFormField(
            controller: descriptionController,
            showResourcePicker: true,
            localResourceLinkProvider: SourcedResourceLinkProvider(source: widget.entity.source),
            onSaved: (String value) {
              widget.entity.description = value;
            },
          ),
          SizedBox(
            height: 300,
            child: FleatherTheme(
              data: FleatherThemeData.fallback(context).copyWith(
                link: FleatherThemeData.fallback(context).link.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                )
              ),
              child: FleatherField(
                controller: descriptionController,
                focusNode: descriptionFocusNode,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                expands: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}