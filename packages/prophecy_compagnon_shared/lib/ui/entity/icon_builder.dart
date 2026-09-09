import 'dart:typed_data';
import 'dart:ui';

import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/exportable_binary_data.dart';
import 'package:prophecy_compagnon_shared/classes/generic_image.dart';

Future<GenericImage?> buildEntityIcon(EntityBase entity) async {
  GenericImage? ret;

  var pBuilder = ParagraphBuilder(
    ParagraphStyle(
      fontSize: 40,
      fontWeight: FontWeight.bold,
      textAlign: TextAlign.center,
    )
  );
  pBuilder.addText(entity.name[0]);
  Paragraph paragraph = pBuilder.build();
  paragraph.layout(ParagraphConstraints(width: 48));

  final recorder = PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.drawParagraph(paragraph, Offset((50-paragraph.height)/2, (50-paragraph.width)/2));

  final picture = recorder.endRecording();
  final res = await picture.toImage(50, 50);
  ByteData? data = await res.toByteData(format: ImageByteFormat.png);
  if(data != null) {
    ret = GenericImage.memory(binary: ExportableBinaryData(data: Uint8List.view(data.buffer)));
  }

  return ret;
}