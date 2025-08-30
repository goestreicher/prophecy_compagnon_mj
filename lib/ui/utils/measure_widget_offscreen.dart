import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

Size measureWidgetOffscreen(Widget root) {
  var measured = Size.zero;

  final PipelineOwner pipelineOwner = PipelineOwner();
  final _MeasurementView rootView = pipelineOwner.rootNode = _MeasurementView(BoxConstraints());
  final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());
  final RenderObjectToWidgetElement<RenderBox> element = RenderObjectToWidgetAdapter<RenderBox>(
      container: rootView,
      debugShortDescription: '[root]',
      child: Directionality(textDirection: TextDirection.ltr, child: root),
    ).attachToRenderTree(buildOwner);

  try {
    rootView.scheduleInitialLayout();
    pipelineOwner.flushLayout();
    measured = rootView.size;
  } finally {
    // Clean up.
    element.update(RenderObjectToWidgetAdapter<RenderBox>(container: rootView));
    buildOwner.finalizeTree();
  }

  return measured;
}

class _MeasurementView extends RenderBox with RenderObjectWithChildMixin<RenderBox> {
  _MeasurementView(this.boxConstraints);

  final BoxConstraints boxConstraints;

  @override
  void performLayout() {
    assert(child != null);
    child!.layout(boxConstraints, parentUsesSize: true);
    size = child!.size;
  }

  @override
  void debugAssertDoesMeetConstraints() => true;
}