import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../classes/exportable_binary_data.dart';
import '../../classes/map_background_data.dart';

class MapBackgroundPickerDialog extends StatefulWidget {
  const MapBackgroundPickerDialog({ super.key });

  @override
  State<MapBackgroundPickerDialog> createState() => _MapBackgroundPickerDialogState();
}

class _MapBackgroundPickerDialogState extends State<MapBackgroundPickerDialog> {
  ui.Image? image;
  Uint8List? imageData;
  String? imageName;
  TextEditingController realWidthController = TextEditingController();
  TextEditingController realHeightController = TextEditingController();

  @override
  void dispose() {
    image?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choix du fond de carte'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  var fpResult = await FilePicker.platform.pickFiles(type: FileType.image);
                  if(fpResult == null) return;

                  try {
                    var codec = await ui.instantiateImageCodec(fpResult.files.first.bytes!);
                    var frame = await codec.getNextFrame();
                    setState(() {
                      image = frame.image.clone();
                      imageData = fpResult.files.first.bytes!;
                      imageName = fpResult.files.first.name;
                    });
                    frame.image.dispose();
                  }
                  catch (e) {
                    if(!context.mounted) return;

                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                          title: const Text("Impossible d'importer l'image"),
                          content: Text(e.toString()),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('OK'),
                            )
                          ]
                      )
                    );
                  }
                },
                child: Text(
                    imageName == null
                        ? "Choisir l'image"
                        : imageName!
                ),
              ),
              const SizedBox(width: 8.0),
              if(image != null)
                Text('${image!.width}x${image!.height}'),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
              children: [
                const Text('Dimensions réelles (m)'),
                const SizedBox(width: 8.0),
                SizedBox(
                  width: 48.0,
                  child: TextFormField(
                    controller: realWidthController,
                    enabled: image != null,
                    onChanged: (String? value) {
                      if(value == null) return;

                      var w = double.tryParse(value);
                      if(w == null) return;

                      var whRatio = image!.width / image!.height;
                      realHeightController.text = (w / whRatio).toStringAsFixed(2);
                    },
                  ),
                ),
                const Text(' x '),
                SizedBox(
                  width: 48.0,
                  child: TextFormField(
                    controller: realHeightController,
                    enabled: image != null,
                    onChanged: (String? value) {
                      if(value == null) return;

                      var h = double.tryParse(value);
                      if(h == null) return;

                      var whRatio = image!.width / image!.height;
                      realWidthController.text = (h * whRatio).toStringAsFixed(2);
                    },
                  ),
                ),
              ]
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Annuler'),
              ),
              const SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: () async {
                  if(image == null) return;
                  if(realWidthController.text.isEmpty) return;
                  if(realHeightController.text.isEmpty) return;

                  var w = double.tryParse(realWidthController.text);
                  if(w == null) return;

                  var h = double.tryParse(realHeightController.text);
                  if(h == null) return;

                  var background = MapBackground(
                    image: ExportableBinaryData(data: imageData!),
                    imageWidth: image!.width,
                    imageHeight: image!.height,
                    realWidth: w,
                    realHeight: h,
                  );

                  Navigator.of(context).pop(background);
                },
                child: const Text('OK'),
              )
            ],
          ),
        ],
      ),
    );
  }
}