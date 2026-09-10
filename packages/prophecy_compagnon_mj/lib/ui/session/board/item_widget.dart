import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_mj/ui/session/board/item_map_widget.dart';
import 'package:prophecy_compagnon_shared/classes/session/board/item.dart';
import 'package:prophecy_compagnon_shared/classes/session/board/item_map.dart';
import 'package:prophecy_compagnon_shared/ui/generic_image_widget.dart';

class SessionBoardItemWidget<T extends SessionBoardItem> extends StatelessWidget {
  const SessionBoardItemWidget({ super.key, required this.item });

  final T item;

  @override
  Widget build(BuildContext context) {
    Widget finalWidget;

    if(item is SessionBoardItemMap) {
      finalWidget = SessionBoardItemMapWidget(
        map: (item as SessionBoardItemMap),
      );
    }
    else {
      finalWidget = InteractiveViewer(
        minScale: 0.1,
        maxScale: 5.0,
        child: GenericImageWidget(
          image: item.image(),
        )
      );
    }

    return finalWidget;
  }
}