import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:float_column/float_column.dart';
import 'package:flutter/material.dart';

import '../../classes/exportable_binary_data.dart';
import '../../classes/object_location.dart';
import '../../classes/object_source.dart';
import '../../classes/place.dart';
import 'place_edit_dialog.dart';

class PlaceDisplayWidget extends StatelessWidget {
  const PlaceDisplayWidget({
    super.key,
    required this.place,
    required this.onEdited,
    required this.onDelete,
    this.modifyIfSourceMatches,
  });

  final Place place;
  final void Function(Place) onEdited;
  final void Function(Place) onDelete;
  final ObjectSource? modifyIfSourceMatches;

  Future<List<Map<String, dynamic>>> _export(Place p, PlaceExportConfig cfg) async {
    var ret = <Map<String, dynamic>>[];

    var j = p.toJson();
    if(!cfg.maps) {
      j.remove('map');
    }
    else if(p.map != null) {
      await p.map!.load();
      if(p.map!.exportableBinaryData != null) {
        var dataJson = p.map!.exportableBinaryData!.toJson();
        dataJson.remove('is_new');
        j['binary'] = <String, dynamic>{p.map!.exportableBinaryData!.hash: dataJson};
      }
      else if(place.map!.imageData != null) {
        // Force inclusion of the resource by creating an ExportableBinaryData
        // and changing the source
        var data = ExportableBinaryData(data: place.map!.imageData!);
        var map = PlaceMap(
          sourceType: PlaceMapSourceType.local,
          source: data.hash,
          imageWidth: place.map!.imageWidth,
          imageHeight: place.map!.imageHeight,
          realWidth: place.map!.realWidth,
          realHeight: place.map!.realHeight,
        );
        var dataJson = data.toJson();
        dataJson.remove('is_new');
        j['map'] = map.toJson();
        j['binary'] = <String, dynamic>{data.hash: dataJson};
      }
    }
    ret.add(j);

    if(cfg.recursive) {
      for (var child in Place.withParent(p.id)) {
        ret.addAll(await _export(child, cfg));
      }
    }

    return ret;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var paragraphSpacing = 16.0;
    bool canEdit = modifyIfSourceMatches != null
      ? place.source == modifyIfSourceMatches
      : place.source == ObjectSource.local;

    var actionButtons = <Widget>[];

    if(place.location.type != ObjectLocationType.assets) {
      actionButtons.add(IconButton(
        onPressed: () async {
          var config = await showDialog<PlaceExportConfig>(
            context: context,
            builder: (BuildContext context) => PlaceDownloadDialog(),
          );
          if(config == null) return;

          var j = await _export(place, config);
          var jStr = json.encode(j);
          await FilePicker.platform.saveFile(
            fileName: 'place_${place.id}.json',
            bytes: utf8.encode(jStr),
          );
        },
        icon: const Icon(Icons.download),
      ));
    }

    if(canEdit) {
      actionButtons.addAll([
        IconButton(
          onPressed: () {
            onDelete(place);
          },
          icon: const Icon(Icons.delete),
        ),
        const SizedBox(width: 12.0),
        IconButton(
          onPressed: () async {
            var child = await showDialog<Place>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) =>
                  PlaceEditDialog(parent: place.parentId!, place: place),
            );
            if(child == null) return;
            onEdited(place);
          },
          icon: const Icon(Icons.edit),
        ),
      ]);
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  place.name,
                  style: theme.textTheme.headlineMedium,
                ),
                Spacer(),
                ...actionButtons,
              ],
            ),
            const SizedBox(height: 16.0),
            FloatColumn(
              children: [
                if(place.map != null)
                  Floatable(
                    float: FCFloat.start,
                    padding: EdgeInsets.only(right: 8.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 200, maxHeight: 300),
                      child: FutureBuilder(
                        future: place.map!.load(),
                        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }

                          if(snapshot.hasError) {
                            return Center(child: Text(snapshot.error.toString()));
                          }

                          return MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () async {
                                await showDialog(
                                  context: context,
                                  barrierColor: Colors.black87,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      insetPadding: EdgeInsets.zero,
                                      child: InteractiveViewer(
                                        maxScale: 4.0,
                                        child: Image.memory(place.map!.image!)
                                      )
                                    );
                                  }
                                );
                              },
                              child: Image.memory(
                                place.map!.image!,
                                fit: BoxFit.contain,
                              ),
                            ),
                          );
                        }
                      ),
                    ),
                  ),
                WrappableText(
                  text: TextSpan(
                    text: 'Type : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: place.type.title,
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
                      )
                    ]
                  ),
                ),
                WrappableText(
                  margin: EdgeInsets.only(top: paragraphSpacing),
                  text: TextSpan(
                    text: 'Régime : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: place.government ?? 'aucun',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
                      )
                    ]
                  ),
                ),
                WrappableText(
                  margin: EdgeInsets.only(top: paragraphSpacing),
                  text: TextSpan(
                    text: 'Dirigeant : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: place.leader ?? 'aucun',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
                      )
                    ]
                  ),
                ),
                WrappableText(
                  margin: EdgeInsets.only(top: paragraphSpacing),
                  text: TextSpan(
                    text: 'Valeurs : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: place.motto ?? 'non renseigné',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
                      )
                    ]
                  ),
                ),
                WrappableText(
                  margin: EdgeInsets.only(top: paragraphSpacing),
                  text: TextSpan(
                    text: 'Climat : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: place.climate ?? 'non renseigné',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
                      )
                    ]
                  ),
                ),
                WrappableText(
                  margin: EdgeInsets.only(top: paragraphSpacing),
                  text: TextSpan(
                    text: 'Description : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: place.description.general,
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
                      )
                    ]
                  ),
                ),
                if(canEdit)
                  Floatable(
                    float: FCFloat.start,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, paragraphSpacing+2.0, 4.0, 0.0),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            var ret = await showDialog<String>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return _PlaceDescriptionItemEditDialog(
                                  item: 'Histoire',
                                  value: place.description.history
                                );
                              }
                            );
                            if(ret == null) return;
                            place.description.history = ret;
                            onEdited(place);
                          },
                          child: const Icon(Icons.edit, size: 16.0,),
                        ),
                      )
                    )
                  ),
                WrappableText(
                  margin: EdgeInsets.only(top: paragraphSpacing),
                  text: TextSpan(
                    text: 'Histoire : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: place.description.history ?? 'non renseignée',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
                      ),
                    ]
                  ),
                ),
                if(canEdit)
                  Floatable(
                    float: FCFloat.start,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, paragraphSpacing+2.0, 4.0, 0.0),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            var ret = await showDialog<String>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return _PlaceDescriptionItemEditDialog(
                                  item: 'Ethnologie',
                                  value: place.description.ethnology
                                );
                              }
                            );
                            if(ret == null) return;
                            place.description.ethnology = ret;
                            onEdited(place);
                          },
                          child: const Icon(Icons.edit, size: 16.0,),
                        ),
                      )
                    )
                  ),
                WrappableText(
                  margin: EdgeInsets.only(top: paragraphSpacing),
                  text: TextSpan(
                    text: 'Ethnologie : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: place.description.ethnology ?? 'non renseignée',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
                      )
                    ]
                  ),
                ),
                if(canEdit)
                  Floatable(
                    float: FCFloat.start,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, paragraphSpacing+2.0, 4.0, 0.0),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            var ret = await showDialog<String>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return _PlaceDescriptionItemEditDialog(
                                  item: 'Mentalité et société',
                                  value: place.description.society
                                );
                              }
                            );
                            if(ret == null) return;
                            place.description.society = ret;
                            onEdited(place);
                          },
                          child: const Icon(Icons.edit, size: 16.0,),
                        ),
                      )
                    )
                  ),
                WrappableText(
                  margin: EdgeInsets.only(top: paragraphSpacing),
                  text: TextSpan(
                    text: 'Mentalité et société : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: place.description.society ?? 'non renseigné',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
                      )
                    ]
                  ),
                ),
                if(canEdit)
                  Floatable(
                    float: FCFloat.start,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, paragraphSpacing+2.0, 4.0, 0.0),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            var ret = await showDialog<String>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return _PlaceDescriptionItemEditDialog(
                                  item: 'Politique',
                                  value: place.description.politics
                                );
                              }
                            );
                            if(ret == null) return;
                            place.description.politics = ret;
                            onEdited(place);
                          },
                          child: const Icon(Icons.edit, size: 16.0,),
                        ),
                      )
                    )
                  ),
                WrappableText(
                  margin: EdgeInsets.only(top: paragraphSpacing),
                  text: TextSpan(
                    text: 'Politique : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: place.description.politics ?? 'non renseignée',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
                      )
                    ]
                  ),
                ),
                if(canEdit)
                  Floatable(
                    float: FCFloat.start,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, paragraphSpacing+2.0, 4.0, 0.0),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            var ret = await showDialog<String>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return _PlaceDescriptionItemEditDialog(
                                  item: 'Juridique',
                                  value: place.description.judicial
                                );
                              }
                            );
                            if(ret == null) return;
                            place.description.judicial = ret;
                            onEdited(place);
                          },
                          child: const Icon(Icons.edit, size: 16.0,),
                        ),
                      )
                    )
                  ),
                WrappableText(
                  margin: EdgeInsets.only(top: paragraphSpacing),
                  text: TextSpan(
                    text: 'Juridique : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: place.description.judicial ?? 'non renseigné',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
                      )
                    ]
                  ),
                ),
                if(canEdit)
                  Floatable(
                    float: FCFloat.start,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, paragraphSpacing+2.0, 4.0, 0.0),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            var ret = await showDialog<String>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return _PlaceDescriptionItemEditDialog(
                                  item: 'Économie',
                                  value: place.description.economy
                                );
                              }
                            );
                            if(ret == null) return;
                            place.description.economy = ret;
                            onEdited(place);
                          },
                          child: const Icon(Icons.edit, size: 16.0,),
                        ),
                      )
                    )
                  ),
                WrappableText(
                  margin: EdgeInsets.only(top: paragraphSpacing),
                  text: TextSpan(
                    text: 'Économie : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: place.description.economy ?? 'non renseignée',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
                      )
                    ]
                  ),
                ),
                if(canEdit)
                  Floatable(
                    float: FCFloat.start,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, paragraphSpacing+2.0, 4.0, 0.0),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            var ret = await showDialog<String>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return _PlaceDescriptionItemEditDialog(
                                  item: 'Militaire',
                                  value: place.description.military
                                );
                              }
                            );
                            if(ret == null) return;
                            place.description.military = ret;
                            onEdited(place);
                          },
                          child: const Icon(Icons.edit, size: 16.0,),
                        ),
                      )
                    )
                  ),
                WrappableText(
                  margin: EdgeInsets.only(top: paragraphSpacing),
                  text: TextSpan(
                    text: 'Militaire : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: place.description.military ?? 'non renseigné',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
                      )
                    ]
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceDescriptionItemEditDialog extends StatelessWidget {
  _PlaceDescriptionItemEditDialog({ required this.item, this.value });

  final String item;
  final String? value;
  final TextEditingController valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    valueController.text = value ?? '';

    return AlertDialog(
      title: Text(item),
      content: SizedBox(
        width: 600,
        child: Focus(
          child: TextField(
            controller: valueController,
            minLines: 10,
            maxLines: 10,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Annuler'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(valueController.text),
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class PlaceExportConfig {
  const PlaceExportConfig({
    required this.recursive,
    required this.maps,
    required this.forceMaps,
  });

  final bool recursive;
  final bool maps;
  final bool forceMaps;
}

class PlaceDownloadDialog extends StatefulWidget {
  const PlaceDownloadDialog({ super.key });

  @override
  State<PlaceDownloadDialog> createState() => _PlaceDownloadDialogState();
}

class _PlaceDownloadDialogState extends State<PlaceDownloadDialog> {
  bool recursive = false;
  bool maps = false;
  bool forceMaps = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Téléchargement du lieu'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            value: recursive,
            title: const Text('Exporter tous les enfants (récursif)'),
            onChanged: (bool b) {
              setState(() {
                recursive = b;
              });
            },
          ),
          SwitchListTile(
              value: maps,
              title: const Text('Exporter les cartes'),
              onChanged: (bool b) {
                setState(() {
                  maps = b;
                  if(!b) forceMaps = false;
                });
              }
          ),
          SwitchListTile(
              value: forceMaps,
              title: const Text("Forcer l'inclusion des éléments distants"),
              onChanged: !maps ? null : (bool b) {
                setState(() {
                  forceMaps = b;
                });
              }
          )
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Annuler'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: const Text('OK'),
          onPressed: () => Navigator.of(context).pop(
              PlaceExportConfig(recursive: recursive, maps: maps, forceMaps: forceMaps)
          ),
        )
      ]
    );
  }
}