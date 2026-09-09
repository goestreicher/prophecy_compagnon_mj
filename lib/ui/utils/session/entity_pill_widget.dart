import 'dart:math';

import 'package:flutter/material.dart';

import '../../../classes/entity_base.dart';
import '../../../classes/generic_image.dart';
import '../entity/icon_builder.dart';
import '../generic_image_widget.dart';

class SessionEntityPillWidget extends StatelessWidget {
  const SessionEntityPillWidget({
    super.key,
    required this.entity,
    required this.width,
    required this.height,
    this.image,
  });

  final EntityBase entity;
  final double width;
  final double height;
  final GenericImage? image;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    Widget imageWidget;
    var borderWidth = 4.0;

    if(image != null) {
      imageWidget = GenericImageWidget(
        image: image!,
      );
    }
    else if(entity.icon != null) {
      imageWidget = GenericImageWidget(
        image: GenericImage.memory(binary: entity.icon!),
      );
    }
    else {
      imageWidget = FutureBuilder(
        future: buildEntityIcon(entity),
        builder: (BuildContext context, AsyncSnapshot<GenericImage?> snapshot) {
          if(snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Text(
                entity.name[0],
                style: theme.textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          return GenericImageWidget(
            image: snapshot.data!
          );
        },
      );
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: borderWidth),
        borderRadius: BorderRadius.circular(max(width, height) / 2),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(max(width, height)/2 - borderWidth/2),
        child: imageWidget,
      ),
    );
  }
}