import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

enum UniformHeightWrapAllocation {
  none,
  expandSpacing,
  resizeChildren,
}

class UniformHeightWrap extends MultiChildRenderObjectWidget {
  const UniformHeightWrap({
    super.key,
    super.children,
    this.spacing = 0.0,
    this.runSpacing = 0.0,
    this.allocation = UniformHeightWrapAllocation.none,
    this.maxRunCount = 0,
  });

  final double spacing;
  final double runSpacing;
  final UniformHeightWrapAllocation allocation;
  final int maxRunCount;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderUniformHeightWrap(
        spacing: spacing,
        runSpacing: runSpacing,
        allocation: allocation,
        maxRunCount: maxRunCount,
      );
}

class RenderUniformHeightWrap extends RenderBox with
    ContainerRenderObjectMixin<RenderBox, _UniformHeightWrapParentData>,
    RenderBoxContainerDefaultsMixin<RenderBox, _UniformHeightWrapParentData>
{
  RenderUniformHeightWrap({
    double spacing = 0.0,
    double runSpacing = 0.0,
    UniformHeightWrapAllocation allocation = UniformHeightWrapAllocation.none,
    int maxRunCount = 0,
  })
    : _spacing = spacing,
      _runSpacing = runSpacing,
      _allocation = allocation,
      _maxRunCount = maxRunCount;

  double get spacing => _spacing;
  set spacing(double s) {
    if(_spacing == s) return;
    _spacing = s;
    markNeedsLayout();
  }
  double _spacing;

  double get runSpacing => _runSpacing;
  set runSpacing(double r) {
    if(_runSpacing == r) return;
    _runSpacing = r;
    markNeedsLayout();
  }
  double _runSpacing;

  UniformHeightWrapAllocation get allocation => _allocation;
  set allocation(UniformHeightWrapAllocation a) {
    if(_allocation == a) return;
    _allocation = a;
    markNeedsLayout();
  }
  UniformHeightWrapAllocation _allocation;

  int get maxRunCount => _maxRunCount;
  set maxRunCount(int m) {
    if(_maxRunCount == m) return;
    _maxRunCount = m;
    markNeedsLayout();
  }
  int _maxRunCount;

  @override
  void setupParentData(covariant RenderObject child) {
    if(child.parentData is! _UniformHeightWrapParentData) {
      child.parentData = _UniformHeightWrapParentData();
    }
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    // The smallest intrinsic width is the minimum width of the largest child
    var largestChildWidth = 0.0;
    var child = firstChild;
    while(child != null) {
      final w = child.getMinIntrinsicWidth(height);
      if(w > largestChildWidth) largestChildWidth = w;
      child = childAfter(child);
    }
    return largestChildWidth;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    // The smallest intrinsic height in the height of the highest child
    var largestChildHeight = 0.0;
    var child = firstChild;
    while(child != null) {
      final h = child.getMinIntrinsicHeight(width);
      if(h > largestChildHeight) largestChildHeight = h;
      child = childAfter(child);
    }
    return largestChildHeight;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    var totalChildrenWidth = 0.0;
    var child = firstChild;
    while(child != null) {
      totalChildrenWidth += child.getMaxIntrinsicWidth(height);
      child = childAfter(child);
    }
    return totalChildrenWidth + spacing * (childCount - 1);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    var totalChildrenHeight = 0.0;
    var child = firstChild;
    while(child != null) {
      totalChildrenHeight += child.getMaxIntrinsicHeight(width);
      child = childAfter(child);
    }
    return totalChildrenHeight + runSpacing * (childCount - 1);
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    return defaultComputeDistanceToHighestActualBaseline(baseline);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    var rows = _createRows(constraints);
    var totalRowsHeight = 0.0;
    for(var r in rows) {
      totalRowsHeight += r.height;
    }
    return Size(constraints.maxWidth, totalRowsHeight + runSpacing * (rows.length - 1));
  }

  @override
  void performLayout() {
    var rows = _createRows(constraints);
    var xOffset = 0.0;
    var yOffset = 0.0;
    var child = firstChild;

    for(var i = 0; i < rows.length; ++i) {
      var row = rows[i];
      var childRowIndex = 0;
      var extraWidth = 0.0;
      xOffset = 0.0;

      if(constraints.maxWidth != double.infinity) {
        extraWidth = (constraints.maxWidth - row.childrenTotalWidth - spacing * (row.childrenCount - 1));
      }

      while(child != null && childRowIndex < row.childrenCount) {
        var effectiveSpacing = spacing;
        if(allocation == UniformHeightWrapAllocation.expandSpacing && extraWidth > 0.0) {
          effectiveSpacing += extraWidth / (row.childrenCount - 1);
        }

        final pData = child.parentData! as _UniformHeightWrapParentData;
        var effectiveChildWidth = pData.knownWidth;
        if(allocation == UniformHeightWrapAllocation.resizeChildren && extraWidth > 0.0) {
          effectiveChildWidth += extraWidth / (row.childrenCount);
        }
        final childConstraints = BoxConstraints.expand(
          width: effectiveChildWidth,
          height: row.height
        );
        child.layout(childConstraints);
        pData.offset = Offset(xOffset, yOffset);

        xOffset += effectiveChildWidth + effectiveSpacing;
        child = childAfter(child);
        ++childRowIndex;
      }

      yOffset += row.height;
      if(i != rows.length - 1) yOffset += runSpacing;
    }

    size = Size(constraints.maxWidth, yOffset);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  List<_UniformHeightWrapRow> _createRows(BoxConstraints constraints) {
    final childConstraints = BoxConstraints(
      minWidth: 0,
      maxWidth: constraints.maxWidth,
      minHeight: 0,
      maxHeight: constraints.maxHeight,
    );

    var child = firstChild;
    var rows = <_UniformHeightWrapRow>[];
    var currentRow = _UniformHeightWrapRow();
    while(child != null) {
      final pData = child.parentData! as _UniformHeightWrapParentData;
      final childSize = child.getDryLayout(childConstraints);
      pData.knownWidth = childSize.width;
      final remainingWidth = constraints.maxWidth - currentRow.childrenTotalWidth - spacing * (currentRow.childrenCount - 1);

      if(remainingWidth < childSize.width) {
        rows.add(currentRow);
        currentRow = _UniformHeightWrapRow();
      }

      if(maxRunCount != 0 && currentRow.childrenCount == maxRunCount) {
        rows.add(currentRow);
        currentRow = _UniformHeightWrapRow();
      }

      currentRow.childrenTotalWidth += childSize.width;
      ++currentRow.childrenCount;
      if(childSize.height > currentRow.height) currentRow.height = childSize.height;

      child = childAfter(child);
    }

    if(currentRow.childrenCount > 0) {
      rows.add(currentRow);
    }

    return rows;
  }
}

class _UniformHeightWrapParentData extends ContainerBoxParentData<RenderBox> with
    ContainerParentDataMixin<RenderBox>
{
  double knownWidth = 0.0;
}

class _UniformHeightWrapRow {
  _UniformHeightWrapRow();

  int childrenCount = 0;
  double childrenTotalWidth = 0.0;
  double height = 0.0;
}