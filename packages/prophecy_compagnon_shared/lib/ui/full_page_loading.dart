import 'package:material_ui/material_ui.dart';

class FullPageLoadingWidget extends StatelessWidget {
  const FullPageLoadingWidget({ super.key });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
        ),
        child: Center(child: CircularProgressIndicator()),
      )
    );
  }
}