import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../classes/generic_image.dart';
import '../../../../classes/session/map/item.dart';
import '../../../../classes/session/map/item_entity.dart';
import '../entity_pill_widget.dart';

class SessionMapItemWidget extends StatelessWidget {
  const SessionMapItemWidget({
    super.key,
    required this.item,
    required this.ppm,
  });

  final SessionMapItem item;
  final double ppm;

  @override
  Widget build(BuildContext context) {
    var w = item.size.width * ppm;
    var h = item.size.height * ppm;

    if(item is SessionMapEntityItem) {
      return FutureBuilder(
          future: item.image,
          builder: (BuildContext context, AsyncSnapshot<GenericImage?> snapshot) {
            GenericImage? image;

            if(!snapshot.hasError && snapshot.data != null) {
              image = snapshot.data!;
            }

            return SessionEntityPillWidget(
              entity: (item as SessionMapEntityItem).entity,
              width: w,
              height: h,
              image: image,
            );
          }
      );
    }
    else {
      throw(UnimplementedError());
    }
  }
}