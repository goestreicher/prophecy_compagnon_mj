import 'dart:ui';

import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/generic_image.dart';
import 'package:prophecy_compagnon_shared/classes/session/map/item.dart';
import 'package:prophecy_compagnon_shared/ui/entity/icon_builder.dart';

class SessionMapEntityItem extends SessionMapItem {
  SessionMapEntityItem({
    super.x,
    super.y,
    required this.entity,
  });

  final EntityBase entity;

  @override
  String get id => entity.id;

  @override
  String? get label => entity.name;

  @override
  Size get size => Size(entity.size, entity.size);

  @override
  Future<GenericImage?> get image async {
    if(_icon == null) {
      if(entity.icon != null) {
        _icon = GenericImage.memory(binary: entity.icon!);
      }
      else {
        _icon = await buildEntityIcon(entity);
      }
    }
    return _icon;
  }

  @override
  bool get movable => true;

  @override
  double get movementDistance => entity.baseMovementDistance;

  GenericImage? _icon;
}