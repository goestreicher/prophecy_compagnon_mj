import 'dart:math';

import 'package:flutter/material.dart';

class AutocompleteOverlayWidget extends StatefulWidget {
  const AutocompleteOverlayWidget({
    required super.key,
    required this.focusNode,
    required this.childBuilder,
    required this.onInput,
  });

  final FocusNode focusNode;
  final Widget Function(BuildContext, void Function(String)) childBuilder;
  final void Function(String) onInput;

  @override
  State<AutocompleteOverlayWidget> createState() => _AutocompleteOverlayWidgetState();
}

class _AutocompleteOverlayWidgetState extends State<AutocompleteOverlayWidget> {
  OverlayPortalController detailsController = OverlayPortalController();

  @override
  void initState() {
    super.initState();

    widget.focusNode.addListener(focusChanged);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(focusChanged);

    super.dispose();
  }

  void focusChanged() {
    if(widget.focusNode.hasFocus && !detailsController.isShowing) {
      detailsController.show();
    }
  }

  void tapOutside(PointerDownEvent event) {
    if(detailsController.isShowing) {
      detailsController.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal.overlayChildLayoutBuilder(
      controller: detailsController,
      overlayChildBuilder: (BuildContext context, OverlayChildLayoutInfo layoutInfo) {
        // This is lifted from flutter/lib/src/widgets/autocomplete.dart

        final EdgeInsets mediaQueryPadding = MediaQuery.paddingOf(context);
        final EdgeInsets viewInsets = MediaQuery.viewInsetsOf(context);

        final Rect overlayRect = mediaQueryPadding.deflateRect(
          viewInsets.deflateRect(Offset.zero & layoutInfo.overlaySize),
        );

        final Matrix4 invertTransform = layoutInfo.childPaintTransform.clone()..invert();
        final Rect overlayRectInField = MatrixUtils.transformRect(
            invertTransform,
            overlayRect
        );

        final boundingBox = Size(
          layoutInfo.childSize.width,
          max(overlayRectInField.bottom, kMinInteractiveDimension),
        );

        final Matrix4 transform = layoutInfo.childPaintTransform.clone()
          ..translateByDouble(0.0, overlayRectInField.bottom - boundingBox.height, 0, 1);

        return Transform(
          transform: transform,
          child: Align(
            alignment: Alignment.topLeft,
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: TapRegion(
                onTapOutside: tapOutside,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: boundingBox.width,
                  ),
                  child: widget.childBuilder(
                    context,
                        (String v) {
                      widget.onInput(v);
                      detailsController.hide();
                    }
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: const SizedBox(width: double.infinity, height: 0.0),
    );
  }
}