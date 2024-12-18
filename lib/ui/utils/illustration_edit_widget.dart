import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import '../../classes/entity_base.dart';
import '../../classes/exportable_binary_data.dart';
import 'error_feedback.dart';

class IllustrationEditData {
  IllustrationEditData({ this.image, this.icon });

  ExportableBinaryData? image;
  ExportableBinaryData? icon;
}

class IllustrationEditFormField extends FormField<IllustrationEditData> {
  IllustrationEditFormField({
    super.key,
    required this.entity,
    this.onImageChanged,
    this.onIconChanged,
  })
    : super(
        initialValue: IllustrationEditData(image: entity.image, icon: entity.icon),
        onSaved: (IllustrationEditData? data) {
          print(data);
          if(data == null) {
            entity.image = null;
            entity.icon = null;
          }
          else {
            print('${entity.image} - ${entity.icon}');
            print('${data.image} - ${data.icon}');
            entity.image = data.image;
            entity.icon = data.icon;
          }
        },
        builder: (FormFieldState<IllustrationEditData> s) {
          var state = s as _IllustrationEditFormFieldState;

          return IllustrationEditWidget(
            entity: entity,
            onImageChanged: (ExportableBinaryData? newImage) {
              state.data.image = newImage;
              s.didChange(state.data);
              onImageChanged?.call(newImage);
            },
            onIconChanged: (ExportableBinaryData? newIcon) {
              state.data.icon = newIcon;
              s.didChange(state.data);
              onIconChanged?.call(newIcon);
            },
          );
        }
    );

  final EntityBase entity;
  final void Function(ExportableBinaryData?)? onImageChanged;
  final void Function(ExportableBinaryData?)? onIconChanged;

  @override
  FormFieldState<IllustrationEditData> createState() => _IllustrationEditFormFieldState();
}

class _IllustrationEditFormFieldState extends FormFieldState<IllustrationEditData> {
  _IllustrationEditFormFieldState();

  late IllustrationEditData data;

  @override
  void initState() {
    super.initState();
    var w = widget as IllustrationEditFormField;
    data = IllustrationEditData(image: w.entity.image, icon: w.entity.icon);
  }
}

class IllustrationEditWidget extends StatefulWidget {
  const IllustrationEditWidget({
    super.key,
    required this.entity,
    required this.onImageChanged,
    required this.onIconChanged,
  });

  final EntityBase entity;
  final void Function(ExportableBinaryData?) onImageChanged;
  final void Function(ExportableBinaryData?) onIconChanged;

  @override
  State<IllustrationEditWidget> createState() => _IllustrationEditWidgetState();
}

class _IllustrationEditWidgetState extends State<IllustrationEditWidget> {
  ExportableBinaryData? image;
  ui.Image? uiImage;
  int imageWidth = 0;
  int imageHeight = 0;
  ExportableBinaryData? icon;

  bool creatingIcon = false;
  double imageDisplayScale = 1.0;
  Rect? clipRect;

  Future<void> _getImageInfo() async {
    if(image == null) return;

    var codec = await ui.instantiateImageCodec(image!.data);
    var frame = await codec.getNextFrame();
    setState(() {
      uiImage = frame.image.clone();
      imageWidth = frame.image.width;
      imageHeight = frame.image.height;
    });
    frame.image.dispose();
  }

  @override
  void dispose() {
    uiImage?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    image = widget.entity.image;
    icon = widget.entity.icon;
    _getImageInfo();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    if(image == null) {
      return Center(
        child: TextButton(
          onPressed: () async {
            var fpResult = await FilePicker.platform.pickFiles(type: FileType.image);
            if(fpResult == null) return;

            try {
              image = ExportableBinaryData(data: fpResult.files.first.bytes!);
              await _getImageInfo();
              icon = null;
              setState(() {
                widget.onImageChanged(image);
                widget.onIconChanged(icon);
              });
            }
            catch (e) {
              if(!context.mounted) return;
              displayErrorDialog(
                context,
                "Impossible d'importer l'image",
                e.toString(),
              );
            }
          },
          child: const Text("Sélectionner un fichier"),
        )
      );
    }

    Widget imageWidget;
    if(creatingIcon) {
      imageWidget = LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        if(constraints.maxWidth == double.infinity && constraints.maxHeight == double.infinity) {
          return Center(child: const Text("Création de l'aperçu impossible"));
        }

        double displayWidth, displayHeight;
        if(constraints.maxWidth != double.infinity) {
          displayWidth = constraints.maxWidth;
          displayHeight = imageHeight * (constraints.maxWidth / imageWidth);
          imageDisplayScale = constraints.maxWidth / imageWidth;
        }
        else {
          displayWidth = imageWidth * (constraints.maxHeight / imageHeight);
          displayHeight = constraints.maxHeight;
          imageDisplayScale = constraints.maxHeight / imageHeight;
        }

        clipRect ??= Rect.fromLTWH(
            displayWidth / 2.0 - displayWidth / 10.0,
            displayHeight / 5.0 - displayHeight / 10.0,
            displayWidth / 5.0,
            displayWidth / 5.0
        );

        double controlBoxPadding = 2.0;
        double contralHandleWidth = 8.0;

        double iconCreationActionsMargin = 4.0;
        double iconCreationActionsTop = 0.0;
        double iconCreationActionsLeft = 0.0;
        double buttonSize = 48.0; // default for Material
        Widget iconCreationActionsWidget;
        var iconCreationActions = <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                creatingIcon = false;
              });
            },
            icon: Icon(Icons.cancel),
            color: Colors.red,
          ),
          IconButton(
            onPressed: () async {
              var imgBytes = await uiImage!.toByteData();
              var crop = img.copyCrop(
                img.Image.fromBytes(
                  width: imageWidth,
                  height: imageHeight,
                  bytes: imgBytes!.buffer,
                  numChannels: 4,
                ),
                x: (clipRect!.left / imageDisplayScale).floor(),
                y: (clipRect!.top / imageDisplayScale).floor(),
                width: (clipRect!.width / imageDisplayScale).floor(),
                height: (clipRect!.width / imageDisplayScale).floor()
              );
              var sizedIcon = img.copyResize(
                crop,
                width: 128,
                height: 128,
              );

              if (sizedIcon.format != img.Format.uint8 || sizedIcon.numChannels != 4) {
                final cmd = img.Command()
                  ..image(sizedIcon)
                  ..convert(format: img.Format.uint8, numChannels: 4);
                final rgba8 = await cmd.getImageThread();
                if (rgba8 != null) {
                  sizedIcon = rgba8;
                }
              }

              setState(() {
                //icon = ExportableBinaryData(data: cropBytes!.buffer.asUint8List());
                icon = ExportableBinaryData(data: img.encodePng(sizedIcon));
                widget.onIconChanged(icon);
                creatingIcon = false;
              });
            },
            icon: Icon(Icons.check_circle),
            color: Colors.green,
          )
        ];

        // Preferred location for actions is at the bottom
        if(clipRect!.bottom + buttonSize + iconCreationActionsMargin < displayHeight) {
          iconCreationActionsTop = clipRect!.bottom + iconCreationActionsMargin;
          iconCreationActionsLeft = clipRect!.left;
          iconCreationActionsWidget = Row(children: iconCreationActions);
        }
        // Second preferred location is on the right
        else if(clipRect!.right + buttonSize + iconCreationActionsMargin < displayWidth) {
          iconCreationActionsTop = clipRect!.top;
          iconCreationActionsLeft = clipRect!.right + iconCreationActionsMargin;
          iconCreationActionsWidget = Column(children: iconCreationActions);
        }
        // Third preferred location is on the left
        else if(clipRect!.left - buttonSize - iconCreationActionsMargin > 0.0) {
          iconCreationActionsTop = clipRect!.top;
          iconCreationActionsLeft = clipRect!.left - buttonSize - iconCreationActionsMargin;
          iconCreationActionsWidget = Column(children: iconCreationActions);
        }
        // Fourth preferred location is on the top
        else if(clipRect!.top - buttonSize - iconCreationActionsMargin > 0.0) {
          iconCreationActionsTop = clipRect!.top - buttonSize - iconCreationActionsMargin;
          iconCreationActionsLeft = clipRect!.left;
          iconCreationActionsWidget = Row(children: iconCreationActions);
        }
        else {
          // Fallback to displaying within the clipRect, bottom left
          iconCreationActionsTop = clipRect!.bottom - buttonSize + iconCreationActionsMargin;
          iconCreationActionsLeft = clipRect!.left;
          iconCreationActionsWidget = Row(
            children: iconCreationActions,
          );
        }

        return Stack(
          children: [
            Positioned(
                child: Image.memory(image!.data)
            ),
            Positioned(
              child: ClipPath(
                clipper: _IconClipper(rect: clipRect!),
                child: Container(
                  height: displayHeight,
                  width: displayWidth,
                  color: Colors.black.withAlpha(200),
                ),
              )
            ),
            Positioned(
              top: clipRect!.top,
              left: clipRect!.left,
              child: GestureDetector(
                onPanUpdate: (DragUpdateDetails details) {
                  var newRect = Rect.fromLTWH(
                      clipRect!.left + details.delta.dx,
                      clipRect!.top + details.delta.dy,
                      clipRect!.width,
                      clipRect!.height
                  );
                  if(newRect.top >= 0.0 && newRect.left >= 0.0 && newRect.bottom <= displayHeight && newRect.right <= displayWidth) {
                    setState(() {
                      clipRect = newRect;
                    });
                  }
                },
                child: Container(
                  width: clipRect!.width,
                  height: clipRect!.width,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(clipRect!.width / 2),
                  ),
                ),
              )
            ),
            Positioned(
              top: clipRect!.top - controlBoxPadding,
              left: clipRect!.left - controlBoxPadding,
              child: IgnorePointer(
                child: Container(
                  width: clipRect!.width + 2 * controlBoxPadding,
                  height: clipRect!.width + 2 * controlBoxPadding,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white.withAlpha(100),
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ),
            // Top left handle
            Positioned(
              top: clipRect!.top - controlBoxPadding - contralHandleWidth / 2.0,
              left: clipRect!.left - controlBoxPadding - contralHandleWidth / 2.0,
              child: GestureDetector(
                onPanUpdate: (DragUpdateDetails details) {
                  var newRect = Rect.fromLTWH(
                    clipRect!.left + details.delta.dx,
                    clipRect!.top + details.delta.dx,
                    clipRect!.width - details.delta.dx,
                    clipRect!.height - details.delta.dx,
                  );
                  if(newRect.top >= 0.0 && newRect.left >= 0.0 && newRect.bottom <= displayHeight && newRect.right <= displayWidth) {
                    setState(() {
                      clipRect = newRect;
                    });
                  }
                },
                child: Container(
                  width: contralHandleWidth,
                  height: contralHandleWidth,
                  color: Colors.white,
                ),
              )
            ),
            // Top right handle
            Positioned(
                top: clipRect!.top - controlBoxPadding - contralHandleWidth / 2.0,
                left: clipRect!.right - contralHandleWidth / 2.0,
                child: GestureDetector(
                  onPanUpdate: (DragUpdateDetails details) {
                    var newRect = Rect.fromLTWH(
                      clipRect!.left,
                      clipRect!.top - details.delta.dx,
                      clipRect!.width + details.delta.dx,
                      clipRect!.height + details.delta.dx,
                    );
                    if(newRect.top >= 0.0 && newRect.left >= 0.0 && newRect.bottom <= displayHeight && newRect.right <= displayWidth) {
                      setState(() {
                        clipRect = newRect;
                      });
                    }
                  },
                  child: Container(
                    width: contralHandleWidth,
                    height: contralHandleWidth,
                    color: Colors.white,
                  ),
                )
            ),
            // Bottom right handle
            Positioned(
              top: clipRect!.bottom - contralHandleWidth / 2.0,
              left: clipRect!.right - contralHandleWidth / 2.0,
              child: GestureDetector(
                onPanUpdate: (DragUpdateDetails details) {
                  var newRect = Rect.fromLTWH(
                      clipRect!.left,
                      clipRect!.top,
                      clipRect!.width + details.delta.dx,
                      clipRect!.height + details.delta.dx,
                  );
                  if(newRect.top >= 0.0 && newRect.left >= 0.0 && newRect.bottom <= displayHeight && newRect.right <= displayWidth) {
                    setState(() {
                      clipRect = newRect;
                    });
                  }
                },
                child: Container(
                  width: contralHandleWidth,
                  height: contralHandleWidth,
                  color: Colors.white,
                ),
              )
            ),
            // Bottom left handle
            Positioned(
              top: clipRect!.bottom - contralHandleWidth / 2.0,
              left: clipRect!.left - controlBoxPadding - contralHandleWidth / 2.0,
              child: GestureDetector(
                onPanUpdate: (DragUpdateDetails details) {
                  var newRect = Rect.fromLTWH(
                    clipRect!.left + details.delta.dx,
                    clipRect!.top,
                    clipRect!.width - details.delta.dx,
                    clipRect!.height - details.delta.dx,
                  );
                  if(newRect.top >= 0.0 && newRect.left >= 0.0 && newRect.bottom <= displayHeight && newRect.right <= displayWidth) {
                    setState(() {
                      clipRect = newRect;
                    });
                  }
                },
                child: Container(
                  width: contralHandleWidth,
                  height: contralHandleWidth,
                  color: Colors.white,
                ),
              )
            ),
            Positioned(
              top: iconCreationActionsTop,
              left: iconCreationActionsLeft,
              child: iconCreationActionsWidget,
            )
          ],
        );
      });
    }
    else {
      imageWidget = Image.memory(
        image!.data,
        fit: BoxFit.fill,
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: imageWidget,
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        Row(
          children: [
            Text(
              'Icône',
              style: theme.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
              )
            ),
            if(icon != null)
              const SizedBox(width: 12.0),
            if(icon != null)
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  image: DecorationImage(image: MemoryImage(icon!.data)),
                  border: Border.all(color: Colors.green, width: 4.0),
                  borderRadius: BorderRadius.circular(48.0),
                ),
              ),
            const SizedBox(width: 8.0),
            TextButton(
              onPressed: () {
                setState(() {
                  creatingIcon = true;
                });
              },
              child: Text(
                icon == null
                  ? "Créer l'icône"
                  : "Modifier l'icône"
              ),
            )
          ],
        )
      ],
    );
  }
}

class _IconClipper extends CustomClipper<Path> {
  _IconClipper({ required this.rect });

  final Rect rect;

  @override
  Path getClip(Size size) {
    return Path()
      ..addOval(Rect.fromCircle(center: rect.center, radius: rect.width / 2))
      ..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> old) => old is _IconClipper && old.rect != rect;
}