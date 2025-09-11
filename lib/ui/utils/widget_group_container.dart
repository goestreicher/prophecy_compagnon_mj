import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import 'measure_widget_offscreen.dart';

class WidgetGroupContainer extends StatelessWidget {
  const WidgetGroupContainer({
    super.key,
    this.title,
    required this.child,
  });

  final Widget? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var titleWidgetSize = Size.zero;

    if(title != null) {
      titleWidgetSize = measureWidgetOffscreen(title!);
    }

    return Center(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(8.0, 8.0 + (titleWidgetSize.height / 2), 8.0, 8.0),
            margin: EdgeInsets.fromLTRB(0.0, titleWidgetSize.height / 2, 0.0, 0.0),
            decoration: BoxDecoration(
              border: const GradientBoxBorder(
                width: 1.5,
                gradient: LinearGradient(
                  colors: [Colors.black54, Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.8]
                )
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: child,
          ),
          if(title != null)
            Positioned(
              top: 0,
              left: 12,
              child: Container(
                color: theme.colorScheme.surfaceBright,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: title,
              )
            )
        ],
      ),
    );
  }
}