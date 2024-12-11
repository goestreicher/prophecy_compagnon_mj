import 'package:flutter/material.dart';

class FullPageLoadingWidget extends StatelessWidget {
  const FullPageLoadingWidget({ super.key });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
        ),
        child: Center(child: CircularProgressIndicator()),
      )
    );
  }
}