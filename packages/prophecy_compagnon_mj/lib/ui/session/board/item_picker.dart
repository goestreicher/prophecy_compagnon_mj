import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prophecy_compagnon_shared/classes/generic_image.dart';
import 'package:prophecy_compagnon_shared/classes/place_map.dart';
import 'package:prophecy_compagnon_shared/classes/session/board/item.dart';
import 'package:prophecy_compagnon_shared/classes/session/board/item_image.dart';
import 'package:prophecy_compagnon_shared/classes/session/board/item_map.dart';
import 'package:prophecy_compagnon_shared/ui/generic_image_widget.dart';

class SessionBoardItemPickerDialog extends StatefulWidget {
  const SessionBoardItemPickerDialog({
    super.key,
    this.isMap = false,
  });

  final bool isMap;

  @override
  State<SessionBoardItemPickerDialog> createState() => _SessionBoardItemPickerDialogState();
}

class _SessionBoardItemPickerDialogState extends State<SessionBoardItemPickerDialog> {
  SessionBoardItem? item;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Ajouter un élément au plateau'),
      content: SizedBox(
        width: 600,
        child: SessionBoardItemPickerWidget(
          onItemPicked: (SessionBoardItem? i) {
            setState(() {
              item = i;
            });
          },
          isMap: widget.isMap,
        )
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: item == null ? null : () {
            Navigator.of(context, rootNavigator: true).pop(item);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          child: const Text('OK'),
        ),
      ]
    );
  }
}

class SessionBoardItemPickerWidget extends StatefulWidget {
  const SessionBoardItemPickerWidget({
    super.key,
    required this.onItemPicked,
    this.isMap = false,
  });

  final void Function(SessionBoardItem?) onItemPicked;
  final bool isMap;

  @override
  State<SessionBoardItemPickerWidget> createState() => _SessionBoardItemPickerWidgetState();
}

class _SessionBoardItemPickerWidgetState extends State<SessionBoardItemPickerWidget> {
  Widget? selectorWidget;
  GenericImageSourceType? selectedSource;
  String? imageError;
  SessionBoardItemImage? item;
  bool addAsMap = false;
  TextEditingController realWidthController = TextEditingController();
  TextEditingController realHeightController = TextEditingController();

  @override
  void initState() {
    super.initState();

    addAsMap = widget.isMap;
  }

  Future<void> itemSelected(SessionBoardItemImage? i) async {
    if(i != null) {
      try {
        await i.content.load();
        setState(() {
          imageError = null;
          item = i;
        });
      }
      catch(e) {
        setState(() {
          imageError = "Échec de chargement des données de l'image: ${e.toString()}";
          item = null;
        });
      }
    }
    else {
      setState(() {
        imageError = null;
        item = null;
      });
    }

    setState(() {
      if(!canUseAsMap()) {
        addAsMap = false;
      }
    });

    if(validate()) {
      notifyWithCorrectType();
    }
  }

  bool canUseAsMap() {
    return item != null
        && item!.content.width != null
        && item!.content.height != null;
  }

  bool validate() {
    if(imageError != null) return false;
    if(item == null) return false;

    if(addAsMap) {
      return canUseAsMap()
          && realWidthController.text.isNotEmpty
          && realHeightController.text.isNotEmpty;
    }

    return true;
  }

  void notifyWithCorrectType() {
    if(addAsMap && canUseAsMap()) {
      var pm = PlaceMap(
        sourceType: PlaceMapSourceType.local,
        source: item!.content.binary!.hash,
        imageWidth: item!.content.width!,
        imageHeight: item!.content.height!,
        realWidth: double.parse(realWidthController.text),
        realHeight: double.parse(realHeightController.text),
      );
      pm.exportableBinaryData = item!.content.binary;

      widget.onItemPicked(
        SessionBoardItemMap(
          title: item!.title,
          background: pm,
        )
      );
    }
    else {
      widget.onItemPicked(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var validSourceTypeEntries = <DropdownMenuEntry<GenericImageSourceType>>[
      DropdownMenuEntry(
          value: GenericImageSourceType.memory,
          label: "Envoyer une image"
      ),
    ];

    if(!widget.isMap) {
      validSourceTypeEntries.addAll([
        DropdownMenuEntry(
            value: GenericImageSourceType.url,
            label: "Utiliser une image web"
        ),
      ]);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 16.0,
      children: [
        DropdownMenu<GenericImageSourceType>(
          requestFocusOnTap: true,
          label: const Text('Source'),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
          expandedInsets: EdgeInsets.zero,
          dropdownMenuEntries: validSourceTypeEntries,
          onSelected: (GenericImageSourceType? source) {
            if(source == selectedSource) return;

            Widget? selector;

            switch(source) {
              case GenericImageSourceType.memory:
                selector = _FileUploadSelectorWidget(
                  onSelected: itemSelected,
                );
              case GenericImageSourceType.url:
                selector = _UrlSelectorWidget(
                  onSelected: itemSelected,
                );
              case null:
              default:
                selector = null;
            }

            setState(() {
              item = null;
              selectedSource = source;
              selectorWidget = selector;
              widget.onItemPicked(null);
            });
          }
        ),
        ?selectorWidget,
        if(item != null)
          GenericImageWidget(
            image: item!.content,
            maxDimension: 150.0,
            onError: (BuildContext context, Object error, StackTrace? st) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => setState(() {
                  item = null;
                  imageError = error.toString();
                  widget.onItemPicked(null);
                })
              );
              return SizedBox.shrink();
            }
          ),
        if(!widget.isMap && canUseAsMap())
          Row(
            spacing: 12.0,
            children: [
              Switch(
                value: addAsMap,
                onChanged: (bool v) {
                  setState(() {
                    addAsMap = v;
                    if(validate()) {
                      notifyWithCorrectType();
                    }
                    else {
                      widget.onItemPicked(null);
                    }
                  });
                },
              ),
              const Text('Ajouter en tant que carte')
            ],
          ),
        if(addAsMap)
          Row(
            spacing: 8.0,
            children: [
              const Text('Dimensions réelles (m) :'),
              SizedBox(
                width: 48.0,
                child: TextFormField(
                  controller: realWidthController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[.0-9]')),
                  ],
                  onChanged: (String? value) {
                    if(value == null) return;

                    var w = double.tryParse(value);
                    if(w == null) return;

                    var whRatio = item!.image().width! / item!.image().height!;
                    realHeightController.text = (w / whRatio).toStringAsFixed(2);

                    if(validate()) {
                      notifyWithCorrectType();
                    }
                    else if(item != null) {
                      widget.onItemPicked(null);
                    }
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
              const Text('x'),
              SizedBox(
                width: 48.0,
                child: TextFormField(
                  controller: realHeightController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[.0-9]')),
                  ],
                  onChanged: (String? value) {
                    if(value == null) return;

                    var h = double.tryParse(value);
                    if(h == null) return;

                    var whRatio = item!.image().width! / item!.image().height!;
                    realWidthController.text = (h * whRatio).toStringAsFixed(2);

                    if(validate()) {
                      notifyWithCorrectType();
                    }
                    else if(item != null) {
                      widget.onItemPicked(null);
                    }
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
        if(imageError != null)
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.shadow,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                spacing: 12.0,
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.white,
                  ),
                  Expanded(
                    child: Text(
                      "Image invalide: $imageError",
                      style: theme.textTheme.bodyMedium!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ],
              )
            )
          ),
      ],
    );
  }
}

class _FileUploadSelectorWidget extends StatelessWidget {
  const _FileUploadSelectorWidget({
    required this.onSelected,
  });

  final void Function(SessionBoardItemImage?) onSelected;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        var fpResult = await FilePicker.pickFiles(
          type: FileType.image,
          withData: true,
        );
        if(fpResult == null) return;

        var item = SessionBoardItemImage.fromUint8List(
          title: fpResult.files.first.name,
          data: fpResult.files.first.bytes!,
        );
        // ignore: unused_local_variable
        var h = item.content.binary!.hash; // pre-cache the hash now instead of when the dimension text fields are updated
        onSelected(item);
      },
      child: Text("Choisir l'image"),
    );
  }
}

class _UrlSelectorWidget extends StatefulWidget {
  const _UrlSelectorWidget({
    required this.onSelected,
  });

  final void Function(SessionBoardItemImage?) onSelected;

  @override
  State<_UrlSelectorWidget> createState() => _UrlSelectorWidgetState();
}

class _UrlSelectorWidgetState extends State<_UrlSelectorWidget> {
  TextEditingController controller = TextEditingController();
  Timer? urlDebounce;
  String? urlError;
  bool loading = false;

  @override
  void dispose() {
    urlDebounce?.cancel();

    super.dispose();
  }

  Future<void> checkUrl(String? input) async {
    String? currentError;

    if(input != null && input.isNotEmpty) {
      var uri = Uri.tryParse(input);
      if(uri == null || !uri.isAbsolute) {
        currentError = "URL invalide";
      }
    }

    setState(() {
      urlError = currentError;
    });

    if(urlError == null && input != null && input.isNotEmpty) {
      widget.onSelected(
        SessionBoardItemImage(
          title: input,
          content: GenericImage(
            sourceType: GenericImageSourceType.url,
            source: input,
          )
        )
      );
    }
  }

  void urlChanged(String? input) {
    if(urlDebounce?.isActive ?? false) {
      urlDebounce!.cancel();
    }
    urlDebounce = Timer(
      const Duration(milliseconds: 300),
      () {
        checkUrl(input);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        label: const Text('URL'),
        border: const OutlineInputBorder(),
        errorText: urlError,
      ),
      onChanged: urlChanged,
    );
  }
}