import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:parchment/codecs.dart';

import '../../classes/resource_link/assets_resource_link_provider.dart';
import '../../classes/resource_link/resource_link.dart';
import 'resource_link_edit_widget.dart';

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

            String? selectedText;
            var selection = widget.controller.selection;
            var selectionLength = selection.extentOffset - selection.baseOffset;
            if(selectionLength > 0) {
              selectedText = selection.textInside(widget.controller.plainTextEditingValue.text);
            }

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

    // trailing.addAll([
    //   VerticalDivider(
    //     indent: 16,
    //     endIndent: 16,
    //   ),
    //   FLIconButton(
    //     onPressed: !hasPendingChanges ? null : () {
    //       widget.onSaved?.call(
    //         ParchmentMarkdownCodec().encode(widget.controller.document)
    //       );
    //       setState(() {
    //         hasPendingChanges = false;
    //       });
    //     },
    //     size: 32,
    //     icon: Icon(
    //       Icons.check_circle_rounded,
    //       size: 20,
    //       color: hasPendingChanges ? theme.iconTheme.color : theme.disabledColor,
    //     ),
    //   ),
    // ]);

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

class ResourceLinkPickerDialog extends StatefulWidget {
  const ResourceLinkPickerDialog({
    super.key,
    this.localProvider,
  });

  final ResourceLinkProvider? localProvider;

  @override
  State<ResourceLinkPickerDialog> createState() => _ResourceLinkPickerDialogState();
}

class _ResourceLinkPickerDialogState extends State<ResourceLinkPickerDialog> {
  late ResourceLinkProvider selectedProvider;
  ResourceLink? selected;

  @override
  void initState() {
    super.initState();

    selectedProvider = widget.localProvider ?? const AssetsResourceLinkProvider();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Sélection de la ressource'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12.0,
          children: [
            if(widget.localProvider != null)
              Row(
                spacing: 16.0,
                children: [
                  Switch(
                    value: widget.localProvider == selectedProvider,
                    onChanged: (bool value) {
                      setState(() {
                        selectedProvider = value
                            ? widget.localProvider!
                            : const AssetsResourceLinkProvider();
                        selected = null;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      widget.localProvider == selectedProvider
                        ? 'Utiliser les ressources locales (${widget.localProvider!.sourceNames()[0]}'
                        : 'Utiliser les ressources de base'
                    ),
                  ),
                ],
              ),
            ResourceLinkEditWidget(
              provider: selectedProvider,
              onChanged: (ResourceLink? l) {
                setState(() {
                  selected = l;
                });
              }
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Annuler'),
                  ),
                  const SizedBox(width: 12.0),
                  ElevatedButton(
                    onPressed: selected == null ? null : () {
                      Navigator.of(context).pop(selected);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                    ),
                    child: const Text('OK'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}