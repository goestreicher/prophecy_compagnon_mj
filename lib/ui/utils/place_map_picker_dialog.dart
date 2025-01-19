import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'error_feedback.dart';
import '../../classes/exportable_binary_data.dart';
import '../../classes/place.dart';

class PlaceMapPickerDialog extends StatefulWidget {
  const PlaceMapPickerDialog({ super.key });

  @override
  State<PlaceMapPickerDialog> createState() => _MapBackgroundPickerDialogState();
}

class _MapBackgroundPickerDialogState extends State<PlaceMapPickerDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
      content: Form(
        key: formKey,
        child: Column(
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
                      displayErrorDialog(
                        context,
                        "Impossible d'importer l'image",
                        e.toString()
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
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[.0-9]')),
                    ],
                    onChanged: (String? value) {
                      if(value == null) return;

                      var w = double.tryParse(value);
                      if(w == null) return;

                      var whRatio = image!.width / image!.height;
                      realHeightController.text = (w / whRatio).toStringAsFixed(2);
                    },
                    validator: (String? value) {
                      if(value == null || value.isEmpty) return 'Valeur manquante';
                      double? input = double.tryParse(value);
                      if(input == null) return 'Pas un nombre';
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
                const Text(' x '),
                SizedBox(
                  width: 48.0,
                  child: TextFormField(
                    controller: realHeightController,
                    enabled: image != null,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[.0-9]')),
                    ],
                    onChanged: (String? value) {
                      if(value == null) return;

                      var h = double.tryParse(value);
                      if(h == null) return;

                      var whRatio = image!.width / image!.height;
                      realWidthController.text = (h * whRatio).toStringAsFixed(2);
                    },
                    validator: (String? value) {
                      if(value == null || value.isEmpty) return 'Valeur manquante';
                      double? input = double.tryParse(value);
                      if(input == null) return 'Pas un nombre';
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    if(!formKey.currentState!.validate()) return;

                    var w = double.parse(realWidthController.text);
                    var h = double.parse(realHeightController.text);
                    var data = ExportableBinaryData(data: imageData!);
                    var map = PlaceMap(
                      sourceType: PlaceMapSourceType.local,
                      source: data.hash,
                      imageWidth: image!.width,
                      imageHeight: image!.height,
                      realWidth: w,
                      realHeight: h,
                    );
                    map.exportableBinaryData = data;

                    Navigator.of(context).pop(map);
                  },
                  child: const Text('OK'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}