import 'dart:typed_data';

import '../../exportable_binary_data.dart';
import '../../generic_image.dart';
import 'item.dart';

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