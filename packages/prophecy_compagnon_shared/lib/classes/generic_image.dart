import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:prophecy_compagnon_shared/classes/exportable_binary_data.dart';

part 'generic_image.g.dart';

enum GenericImageSourceType {
  asset,
  local,
  memory,
  url,
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class GenericImage {
  GenericImage({
    required this.sourceType,
    required this.source,
  });

  GenericImage.memory({
    this.source = 'memory',
    required this.binary,
  })
    : sourceType = GenericImageSourceType.memory;

  GenericImageSourceType sourceType;
  String source;

  @JsonKey(includeFromJson: false, includeToJson: false)
  ExportableBinaryData? binary; // TODO: conditionally include this in JSON
  @JsonKey(includeFromJson: false, includeToJson: false)
  int? width;
  @JsonKey(includeFromJson: false, includeToJson: false)
  int? height;

  Future<void> load() async {
    try {
      if(binary == null) {
        switch (sourceType) {
          case GenericImageSourceType.memory:
          case GenericImageSourceType.url:
            break;
          case GenericImageSourceType.local:
            binary = await BinaryDataStore().get(source);
          case GenericImageSourceType.asset:
            var bytes = await rootBundle.load(source);
            binary = ExportableBinaryData(
                data: Uint8List.sublistView(bytes)
            );
        }
      }

      if(binary == null) return;

      var codec = await ui.instantiateImageCodec(binary!.data);
      var frame = await codec.getNextFrame();
      width = frame.image.width;
      height = frame.image.height;
      frame.image.dispose();
    }
    catch(e) {
      binary = null;
      width = null;
      height = null;
      rethrow;
    }
  }

  Future<GenericImage> thumbnail(double maxDimension) async {
    await load();
    // TODO
    return this;
  }

  factory GenericImage.fromJson(Map<String, dynamic> json) =>
      _$GenericImageFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GenericImageToJson(this);
}