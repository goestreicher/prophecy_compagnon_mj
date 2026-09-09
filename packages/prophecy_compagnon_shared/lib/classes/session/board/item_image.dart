import 'dart:typed_data';

import 'package:prophecy_compagnon_shared/classes/exportable_binary_data.dart';
import 'package:prophecy_compagnon_shared/classes/generic_image.dart';
import 'package:prophecy_compagnon_shared/classes/session/board/item.dart';

class SessionBoardItemImage extends SessionBoardItem {
  SessionBoardItemImage({
    required super.title,
    super.removable,
    required this.content,
  });

  SessionBoardItemImage.fromUint8List({
    required super.title,
    super.removable,
    required Uint8List data,
  })
    : content = GenericImage.memory(binary: ExportableBinaryData(data: data));

  @override
  Future<GenericImage> thumbnail(double maxDimension) async =>
      content.thumbnail(maxDimension);

  @override
  GenericImage image() =>
      content;

  GenericImage content;

  @override
  Map<String, dynamic> toJson() {
    // TODO
    return <String, dynamic>{};
  }
}