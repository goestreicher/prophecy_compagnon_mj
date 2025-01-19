import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prophecy_compagnon_mj/classes/exportable_binary_data.dart';

import '../../classes/object_source.dart';
import '../../classes/place.dart';
import 'dropdown_menu_form_field.dart';

class PlaceEditDialog extends StatefulWidget {
  const PlaceEditDialog({
    super.key,
    required this.parent,
    this.place,
    this.source,
  });

  final String parent;
  final Place? place;
  final ObjectSource? source;

  @override
  State<PlaceEditDialog> createState() => _PlaceEditDialogState();
}

class _PlaceEditDialogState extends State<PlaceEditDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController placeTypeController = TextEditingController();
  PlaceType? selectedPlaceType;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController governmentController = TextEditingController();
  final TextEditingController leaderController = TextEditingController();
  final TextEditingController mottoController = TextEditingController();
  final TextEditingController climateController = TextEditingController();
  final TextEditingController mapSourceTypeController = TextEditingController();
  PlaceMapSourceType? selectedMapSourceType;
  String? mapSourceLocalFileName;
  Uint8List? mapSourceLocalFileData;
  int? mapImageWidth;
  int? mapImageHeight;
  final TextEditingController mapRealWidthController = TextEditingController();
  final TextEditingController mapRealHeightController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedPlaceType = widget.place?.type;
    nameController.text = widget.place?.name ?? '';
    governmentController.text = widget.place?.government ?? '';
    leaderController.text = widget.place?.leader ?? '';
    mottoController.text = widget.place?.motto ?? '';
    climateController.text = widget.place?.climate ?? '';
    selectedMapSourceType = widget.place?.map?.sourceType;
    mapSourceLocalFileName = widget.place?.map?.source;
    descriptionController.text = widget.place?.description.general ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Éditer le lieu'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 600,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownMenuFormField(
                  controller: placeTypeController,
                  requestFocusOnTap: true,
                  expandedInsets: EdgeInsets.zero,
                  label: const Text('Type de lieu'),
                  initialSelection: selectedPlaceType,
                  dropdownMenuEntries: PlaceType.values
                    .map((PlaceType type) => DropdownMenuEntry(value: type, label: type.title))
                    .toList(),
                  onSelected: (PlaceType? type) => selectedPlaceType = type,
                  validator: (PlaceType? type) => selectedPlaceType == null
                      ? 'Valeur manquante'
                      : null,
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nom du lieu',
                    border: OutlineInputBorder(),
                  ),
                  validator: (String? value) => value == null || value.isEmpty
                      ? 'Valeur manquante'
                      : null,
                ),
                const SizedBox(height: 8.0),
                TextField(
                  controller: governmentController,
                  decoration: InputDecoration(
                    labelText: 'Type de régime',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8.0),
                TextField(
                  controller: leaderController,
                  decoration: InputDecoration(
                    labelText: 'Dirigeant',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8.0),
                TextField(
                  controller: climateController,
                  decoration: InputDecoration(
                    labelText: 'Climat',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    DropdownMenu(
                      controller: mapSourceTypeController,
                      requestFocusOnTap: true,
                      initialSelection: widget.place?.map?.sourceType,
                      label: const Text('Source de la carte'),
                      dropdownMenuEntries: [
                        DropdownMenuEntry(
                          value: PlaceMapSourceType.local,
                          label: 'Fichier local',
                        ),
                      ],
                      onSelected: (PlaceMapSourceType? t) {
                        if(t == selectedMapSourceType) return;

                        setState(() {
                          if(selectedMapSourceType == PlaceMapSourceType.local) {
                            mapSourceLocalFileName = null;
                            mapSourceLocalFileData = null;
                          }

                          selectedMapSourceType = t;
                        });
                      },
                    ),
                    if(selectedMapSourceType == PlaceMapSourceType.local)
                      Expanded(
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              var fpResult = await FilePicker.platform.pickFiles(type: FileType.image);
                              if(fpResult == null) return;

                              try {
                                var codec = await ui.instantiateImageCodec(fpResult.files.first.bytes!);
                                var frame = await codec.getNextFrame();
                                setState(() {
                                  mapSourceLocalFileName = fpResult.files.first.name;
                                  mapSourceLocalFileData = fpResult.files.first.bytes;
                                  mapImageWidth = frame.image.width;
                                  mapImageHeight = frame.image.height;
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
                              mapSourceLocalFileName == null
                                  ? "Choisir l'image"
                                  : mapSourceLocalFileName!
                            )
                          )
                        )
                      ),
                  ],
                ),
                if(mapSourceLocalFileData != null)
                  const SizedBox(height: 8.0),
                if(mapSourceLocalFileData != null)
                  Row(
                    children: [
                      const Text('Dimensions réelles (m)'),
                      const SizedBox(width: 8.0),
                      SizedBox(
                        width: 96.0,
                        child: TextFormField(
                          controller: mapRealWidthController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[.0-9]')),
                          ],
                          onChanged: (String? value) {
                            if(value == null) return;

                            var w = double.tryParse(value);
                            if(w == null) return;

                            var whRatio = mapImageWidth! / mapImageHeight!;
                            mapRealHeightController.text = (w / whRatio).toStringAsFixed(2);
                          },
                          validator: (String? value) {
                            if(mapSourceLocalFileData == null) return null;
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
                        width: 96.0,
                        child: TextFormField(
                          controller: mapRealHeightController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[.0-9]')),
                          ],
                          onChanged: (String? value) {
                            if(value == null) return;

                            var h = double.tryParse(value);
                            if(h == null) return;

                            var whRatio = mapImageWidth! / mapImageHeight!;
                            mapRealWidthController.text = (h * whRatio).toStringAsFixed(2);
                          },
                          validator: (String? value) {
                            if(mapSourceLocalFileData == null) return null;
                            if(value == null || value.isEmpty) return 'Valeur manquante';
                            double? input = double.tryParse(value);
                            if(input == null) return 'Pas un nombre';
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 8.0),
                TextField(
                  controller: descriptionController,
                  minLines: 10,
                  maxLines: 10,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                )
              ],
            ),
          )
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Annuler'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: const Text('OK'),
          onPressed: () async {
            if(!formKey.currentState!.validate()) return;

            var w = double.parse(mapRealWidthController.text);
            var h = double.parse(mapRealHeightController.text);

            if(widget.place == null) {
              PlaceMap? map;

              if(selectedMapSourceType == PlaceMapSourceType.local
                  && mapSourceLocalFileName != null
                  && mapSourceLocalFileData != null
              ) {
                ExportableBinaryData data = ExportableBinaryData(
                  data: mapSourceLocalFileData!,
                  isNew: true,
                );

                map = PlaceMap(
                  sourceType: selectedMapSourceType!,
                  source: data.hash,
                  imageWidth: mapImageWidth!,
                  imageHeight: mapImageHeight!,
                  realWidth: w,
                  realHeight: h,
                );
                map.exportableBinaryData = data;
              }

              var p = Place(
                parentId: widget.parent,
                type: selectedPlaceType!,
                name: nameController.text,
                government: governmentController.text.isNotEmpty
                  ? governmentController.text
                  : null,
                leader: leaderController.text.isNotEmpty
                  ? leaderController.text
                  : null,
                motto: mottoController.text.isNotEmpty
                  ? mottoController.text
                  : null,
                climate: climateController.text.isNotEmpty
                  ? climateController.text
                  : null,
                description: PlaceDescription(
                  general: descriptionController.text,
                ),
                source: widget.source ?? ObjectSource.local,
                map: map,
              );
              await PlaceStore().save(p);
              if(!context.mounted) return;
              Navigator.of(context).pop(p);
            }
            else {
              if(selectedPlaceType != null) {
                widget.place!.type = selectedPlaceType!;
              }
              if(nameController.text.isNotEmpty) {
                widget.place!.name = nameController.text;
              }
              if(governmentController.text.isNotEmpty) {
                widget.place!.government = governmentController.text;
              }
              if(leaderController.text.isNotEmpty) {
                widget.place!.leader = leaderController.text;
              }
              if(mottoController.text.isNotEmpty) {
                widget.place!.motto = mottoController.text;
              }
              if(climateController.text.isNotEmpty) {
                widget.place!.climate = climateController.text;
              }
              if(descriptionController.text.isNotEmpty) {
                widget.place!.description.general = descriptionController.text;
              }

              // Delete the binary data held in local storage if it has been
              // updated
              if(widget.place!.map != null
                  && widget.place!.map!.sourceType == PlaceMapSourceType.local
                  && widget.place!.map!.source != mapSourceLocalFileName
                  && widget.place!.map!.exportableBinaryData != null
              ) {
                await BinaryDataStore().delete(widget.place!.map!.exportableBinaryData!);
              }

              if(selectedMapSourceType == null) {
                widget.place!.map = null;
              }
              else if(selectedMapSourceType == PlaceMapSourceType.local
                  && widget.place!.map?.source != mapSourceLocalFileName
                  && mapSourceLocalFileName != null
                  && mapSourceLocalFileData != null
              ) {
                ExportableBinaryData data = ExportableBinaryData(
                  data: mapSourceLocalFileData!,
                  isNew: true,
                );

                var map = PlaceMap(
                  sourceType: selectedMapSourceType!,
                  source: data.hash,
                  imageWidth: mapImageWidth!,
                  imageHeight: mapImageHeight!,
                  realWidth: w,
                  realHeight: h,
                );
                map.exportableBinaryData = data;

                widget.place!.map = map;
              }

              await PlaceStore().save(widget.place!);
              if(!context.mounted) return;
              Navigator.of(context).pop(widget.place);
            }
          },
        )
      ],
    );
  }
}