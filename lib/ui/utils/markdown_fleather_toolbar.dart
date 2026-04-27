import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:parchment/codecs.dart';

import '../../classes/resource_link/resource_link.dart';
import 'resource_link_picker_dialog.dart';

class MarkdownFleatherToolbarFormField extends FormField<bool> {
  MarkdownFleatherToolbarFormField({
    super.key,
    required this.controller,
    bool showResourcePicker = false,
    ResourceLinkProvider? localResourceLinkProvider,
    void Function(String)? onSaved,
  })
    : super(
        initialValue: false,
        onSaved: (bool? hasChanges) {
          onSaved?.call(
            ParchmentMarkdownCodec().encode(controller.document)
          );
        },
        builder: (FormFieldState<bool> s) {
          return MarkdownFleatherToolbar(
            controller: controller,
            showResourcePicker: showResourcePicker,
            localResourceLinkProvider: localResourceLinkProvider,
          );
        }
    );

  final FleatherController controller;
}

class MarkdownFleatherToolbar extends StatefulWidget {
  const MarkdownFleatherToolbar({
    super.key,
    required this.controller,
    this.showResourcePicker = false,
    this.localResourceLinkProvider,
    this.onSaved,
  });

  final FleatherController controller;
  final bool showResourcePicker;
  final ResourceLinkProvider? localResourceLinkProvider;
  final void Function(String)? onSaved;

  @override
  State<MarkdownFleatherToolbar> createState() => _MarkdownFleatherToolbarState();
}

class _MarkdownFleatherToolbarState extends State<MarkdownFleatherToolbar> {
  bool hasPendingChanges = false;

  @override
  void initState() {
    super.initState();

    widget.controller.document.changes.listen((ParchmentChange c) {
      setState(() {
        hasPendingChanges = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var trailing = <Widget>[];

    if(widget.showResourcePicker) {
      trailing.addAll([
        VerticalDivider(
          indent: 16,
          endIndent: 16,
        ),
        FLIconButton(
          onPressed: () async {
            var result = await showDialog<ResourceLink>(
              context: context,
              builder: (BuildContext context) => ResourceLinkPickerDialog(
                localProvider: widget.localResourceLinkProvider,
              ),
            );
            if(result == null) return;

            var selection = widget.controller.selection;
            var selectionLength = selection.extentOffset - selection.baseOffset;

            if(selectionLength == 0) {
              widget.controller.replaceText(
                selection.baseOffset,
                0,
                result.name
              );
              widget.controller.updateSelection(
                TextSelection(
                  baseOffset: widget.controller.selection.baseOffset,
                  extentOffset: widget.controller.selection.baseOffset + result.name.length,
                )
              );
              selectionLength = result.name.length;
            }

            widget.controller.formatSelection(
              ParchmentAttribute.link.fromString(result.link),
            );
            widget.controller.updateSelection(
              TextSelection(
                baseOffset: widget.controller.selection.baseOffset + selectionLength,
                extentOffset: widget.controller.selection.baseOffset + selectionLength,
              )
            );
          },
          size: 32,
          icon: Icon(
            Icons.book_outlined,
            size: 20,
          ),
        ),
      ]);
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.canvasColor,
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: FleatherToolbar.basic(
        controller: widget.controller,
        hideUnderLineButton: true, // Not supported by markdown
        hideForegroundColor: true, // Not supported by markdown
        hideBackgroundColor: true, // Not supported by markdown
        hideDirection: true,
        hideAlignment: true, // Not supported by markdown
        hideIndentation: true, // No-op for markdown
        hideHorizontalRule: true,
        trailing: trailing,
      ),
    );
  }
}

Widget openBaseResourceLinkPickerDialog() {
  return ResourceLinkPickerDialog();
}