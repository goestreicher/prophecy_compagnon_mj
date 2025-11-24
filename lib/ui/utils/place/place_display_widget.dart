import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parchment/codecs.dart';

import '../../../classes/exportable_binary_data.dart';
import '../../../classes/object_location.dart';
import '../../../classes/object_source.dart';
import '../../../classes/place.dart';
import '../../../classes/place_map.dart';
import '../../../classes/resource_link/resource_link.dart';
import '../character_role_display_widget.dart';
import '../markdown_display_widget.dart';
import '../markdown_fleather_toolbar.dart';
import 'place_edit_dialog.dart';
import '../widget_group_container.dart';

class PlaceDisplayWidget extends StatelessWidget {
  const PlaceDisplayWidget({
    super.key,
    this.placeId,
    this.onEdited,
    this.onDelete,
    this.modifyIfSourceMatches,
    this.resourceLinkProvider,
  });

  final String? placeId;
  final void Function(Place)? onEdited;
  final void Function(Place)? onDelete;
  final ObjectSource? modifyIfSourceMatches;
  final ResourceLinkProvider? resourceLinkProvider;

  Future<Place?> load() {
    return placeId == null
        ? Future.sync(() => null)
        : Place.get(placeId!);
  }

  Future<List<Map<String, dynamic>>> _export(Place p, PlaceExportConfig cfg) async {
    var ret = <Map<String, dynamic>>[];

    var j = p.toJson();
    if(!cfg.maps) {
      j['map'] = null;
    }
    else if(p.map != null) {
      await p.map!.load();
      if(p.map!.imageData != null) {
        // Force inclusion of the resource by creating an ExportableBinaryData
        // and changing the source
        var data = ExportableBinaryData(data: p.map!.imageData!);
        var map = PlaceMap(
          sourceType: PlaceMapSourceType.local,
          source: data.hash,
          imageWidth: p.map!.imageWidth,
          imageHeight: p.map!.imageHeight,
          realWidth: p.map!.realWidth,
          realHeight: p.map!.realHeight,
        );
        map.exportableBinaryData = data;
        j['map'] = map.toJson();
      }
    }
    ret.add(j);

    if(cfg.recursive) {
      for (var child in await Place.withParent(p.id)) {
        ret.addAll(await _export(child, cfg));
      }
    }

    return ret;
  }

  @override
  Widget build(BuildContext context) {
    if(placeId == null) {
      return Text('Pas de lieu sélectionné');
    }

    return FutureBuilder(
      future: load(),
      builder: (BuildContext context, AsyncSnapshot<Place?> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if(snapshot.hasError) {
          return ErrorWidget(snapshot.error!);
        }

        if(!snapshot.hasData || snapshot.data == null) {
          return Center(
            child: const Text('Lieu non trouvé'),
          );
        }

        var place = snapshot.data!;
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

        if(onDelete != null && canEdit) {
          actionButtons.addAll([
            IconButton(
              onPressed: () {
                onDelete!(place);
              },
              icon: const Icon(Icons.delete),
            ),
          ]);
        }

        var leadersWidgets = <InlineSpan>[];
        for(var leader in place.leaders) {
          leadersWidgets.addAll([
            WidgetSpan(
              child: CharacterRoleDisplayWidget(
                  member: leader
              )
            ),
            TextSpan(
              text: '\n',
            ),
          ]);
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12.0,
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
                WidgetGroupContainer(
                  title: Row(
                    children: [
                      if(onEdited != null && canEdit)
                        Padding(
                            padding: EdgeInsets.only(right: 4.0),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () async {
                                  var child = await showDialog<Place>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) => PlaceEditDialog(
                                      parent: place.parentId!,
                                      place: place,
                                      resourceLinkProvider: resourceLinkProvider,
                                    ),
                                  );
                                  if(child == null) return;
                                  onEdited!(place);
                                },
                                child: const Icon(Icons.edit, size: 16.0,),
                              ),
                            )
                        ),
                      Text(
                        'Général',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ]
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16.0,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: paragraphSpacing,
                          children: [
                            RichText(
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
                            if(place.government != null && place.government!.isNotEmpty)
                              RichText(
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
                            if(place.leaders.isNotEmpty)
                              RichText(
                                text: TextSpan(
                                  text: 'Dirigeants :\n',
                                  style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                                  children: leadersWidgets,
                                ),
                              ),
                            if(place.motto != null && place.motto!.isNotEmpty)
                              RichText(
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
                            if(place.climate != null && place.climate!.isNotEmpty)
                              RichText(
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
                          ],
                        ),
                      ),
                      if(place.map != null)
                        ConstrainedBox(
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
                    ],
                  ),
                ),
                _PlaceDescriptionItemDisplayWidget(
                  item: 'Description',
                  value: place.description.general,
                  canEdit: onEdited != null && canEdit,
                  onChanged: (String value) {
                    place.description.general = value;
                    onEdited?.call(place);
                  },
                ),
                _PlaceDescriptionItemDisplayWidget(
                  item: 'Histoire',
                  value: place.description.history,
                  canEdit: onEdited != null && canEdit,
                  onChanged: (String value) {
                    place.description.history = value;
                    onEdited?.call(place);
                  },
                ),
                _PlaceDescriptionItemDisplayWidget(
                  item: 'Mentalité et société',
                  value: place.description.society,
                  canEdit: onEdited != null && canEdit,
                  onChanged: (String value) {
                    place.description.society = value;
                    onEdited?.call(place);
                  },
                ),
                _PlaceDescriptionItemDisplayWidget(
                  item: 'Ethnologie',
                  value: place.description.ethnology,
                  canEdit: onEdited != null && canEdit,
                  onChanged: (String value) {
                    place.description.ethnology = value;
                    onEdited?.call(place);
                  },
                ),
                _PlaceDescriptionItemDisplayWidget(
                  item: 'Politique',
                  value: place.description.politics,
                  canEdit: onEdited != null && canEdit,
                  onChanged: (String value) {
                    place.description.politics = value;
                    onEdited?.call(place);
                  },
                ),
                _PlaceDescriptionItemDisplayWidget(
                  item: 'Juridique',
                  value: place.description.judicial,
                  canEdit: onEdited != null && canEdit,
                  onChanged: (String value) {
                    place.description.judicial = value;
                    onEdited?.call(place);
                  },
                ),
                _PlaceDescriptionItemDisplayWidget(
                  item: 'Économie',
                  value: place.description.economy,
                  canEdit: onEdited != null && canEdit,
                  onChanged: (String value) {
                    place.description.economy = value;
                    onEdited?.call(place);
                  },
                ),
                _PlaceDescriptionItemDisplayWidget(
                  item: 'Militaire',
                  value: place.description.military,
                  canEdit: onEdited != null && canEdit,
                  onChanged: (String value) {
                    place.description.military = value;
                    onEdited?.call(place);
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

class _PlaceDescriptionItemDisplayWidget extends StatelessWidget {
  const _PlaceDescriptionItemDisplayWidget({
    required this.item,
    this.value,
    this.canEdit = false,
    this.onChanged,
  });

  final String item;
  final String? value;
  final bool canEdit;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Row(
        children: [
          if(canEdit)
            Padding(
              padding: EdgeInsets.only(right: 4.0),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () async {
                    var ret = await showDialog<String>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return _PlaceDescriptionItemEditDialog(
                          item: item,
                          value: value,
                        );
                      }
                    );
                    if(ret == null) return;
                    onChanged?.call(ret);
                  },
                  child: const Icon(Icons.edit, size: 16.0,),
                ),
              )
            ),
          Text(
            item,
            style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
        ]
      ),
      child: Align(
        alignment: AlignmentGeometry.topLeft,
        child: MarkdownDisplayWidget(
          data: value == null || value!.isEmpty
              ? 'Non renseigné'
              : value!
        ),
      ),
    );
  }
}

class _PlaceDescriptionItemEditDialog extends StatefulWidget {
  const _PlaceDescriptionItemEditDialog({ required this.item, this.value });

  final String item;
  final String? value;

  @override
  State<_PlaceDescriptionItemEditDialog> createState() => _PlaceDescriptionItemEditDialogState();
}

class _PlaceDescriptionItemEditDialogState extends State<_PlaceDescriptionItemEditDialog> {
  late final FleatherController controller;
  late final FocusNode documentFocusNode;

  @override
  void initState() {
    super.initState();

    if(kIsWeb) {
      BrowserContextMenu.disableContextMenu();
    }

    ParchmentDocument document;
    if(widget.value == null) {
      document = ParchmentDocument();
    }
    else {
      document = ParchmentMarkdownCodec().decode(widget.value!);
    }

    documentFocusNode = FocusNode();
    controller = FleatherController(document: document);
  }

  @override
  void dispose() {
    if(kIsWeb) {
      BrowserContextMenu.enableContextMenu();
    }
    documentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.item),
      content: SizedBox(
        width: 600,
        child: Column(
          spacing: 4.0,
          children: [
            Center(child: MarkdownFleatherToolbar(controller: controller)),
            Expanded(
              child: FleatherField(
                controller: controller,
                focusNode: documentFocusNode,
                expands: true,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        )
      ),
      actions: [
        TextButton(
          child: const Text('Annuler'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(
            ParchmentMarkdownCodec().encode(controller.document)
          ),
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