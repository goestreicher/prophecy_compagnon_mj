import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../classes/place.dart';
import '../../classes/scenario_map.dart';
import '../utils/full_page_loading.dart';
import '../utils/place_map_picker_dialog.dart';
import '../utils/single_line_input_dialog.dart';

class ScenarioEditMapsPage extends StatefulWidget {
  const ScenarioEditMapsPage({
    super.key,
    required this.maps,
    required this.onMapCreated,
    required this.onMapModified,
    required this.onMapDeleted,
  });

  final List<ScenarioMap> maps;
  final void Function(ScenarioMap) onMapCreated;
  final void Function(ScenarioMap) onMapModified;
  final void Function(ScenarioMap) onMapDeleted;

  @override
  State<ScenarioEditMapsPage> createState() => _ScenarioEditMapsPageState();
}

class _ScenarioEditMapsPageState extends State<ScenarioEditMapsPage> {
  final GlobalKey<FormState> _newMapFormKey = GlobalKey();
  ScenarioMap? _selected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Widget mapEditWidget;
    if(_selected == null) {
      mapEditWidget = const Center(child: Text('Selectionner une carte'));
    }
    else {
      mapEditWidget = _MapEditWidget(
        map: _selected!,
        onChanged: () {
          if(_selected!.isDefault) {
            for (var map in widget.maps) {
              if(map.name != _selected!.name && map.isDefault) {
                map.isDefault = false;
                widget.onMapModified(map);
              }
            }
          }

          setState(() {
            widget.onMapModified(_selected!);
          });
        },
      );
    }

    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16.0),
                ElevatedButton.icon(
                  onPressed: () async {
                    var newMapName = await showDialog(
                      context: context,
                      builder: (context) => SingleLineInputDialog(
                        title: 'Nouvelle carte',
                        formKey: _newMapFormKey,
                        hintText: 'Nom',
                      ),
                    );
                    // User canceled the pop-up dialog
                    if(newMapName == null) return;
                    if(!context.mounted) return;

                    var map = await showDialog<PlaceMap>(
                      context: context,
                      builder: (BuildContext context) => const PlaceMapPickerDialog(),
                    );
                    if(map == null) return;
                    if(!context.mounted) return;

                    setState(() {
                      widget.onMapCreated(
                        ScenarioMap(
                          name: newMapName,
                          placeMap: map,
                        )
                      );
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Nouvelle carte'),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.maps.length,
                    itemBuilder: (BuildContext context, int index) {
                      return FutureBuilder(
                        future: widget.maps[index].placeMap.load(),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          var map = widget.maps[index];

                          return Card(
                            clipBehavior: Clip.hardEdge,
                            color: _selected == map
                                ? theme.colorScheme.surfaceContainerHighest
                                : null,
                            child: InkWell(
                              splashColor: theme.colorScheme.surface,
                              onTap: () {
                                setState(() {
                                  _selected = map;
                                });
                              },
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () async {
                                      widget.onMapDeleted(map);
                                      setState(() {
                                        if(_selected == map) {
                                          _selected = null;
                                        }
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 12.0),
                                  if(map.placeMap.image != null)
                                    Image.memory(
                                      map.placeMap.image!,
                                      width: 128,
                                    ),
                                  if(map.placeMap.image == null)
                                    SizedBox(
                                      width: 128,
                                      height: 128 * (map.placeMap.imageHeight / map.placeMap.imageWidth)
                                    ),
                                  const SizedBox(width: 8.0),
                                  if(map.isDefault)
                                    Text(
                                      '${map.name} (Par défaut)',
                                      style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  if(!map.isDefault)
                                    Text(map.name),
                                  const Spacer(),
                                  const Icon(Icons.arrow_forward_ios),
                                ],
                              ),
                            ),
                          );
                        }
                      );
                    },
                  ),
                ),
              ],
            )
        ),
        Expanded(
          flex: 2,
          child: Container(
              color: theme.colorScheme.surfaceContainerHighest,
              child: mapEditWidget,
          ),
        ),
      ],
    );
  }
}

class _MapEditWidget extends StatefulWidget {
  const _MapEditWidget({ required this.map, required this.onChanged });

  final ScenarioMap map;
  final void Function() onChanged;

  @override
  State<_MapEditWidget> createState() => _MapEditWidgetState();
}

class _MapEditWidgetState extends State<_MapEditWidget> {
  final TextEditingController _realWidthController = TextEditingController();
  final TextEditingController _realHeightController = TextEditingController();

  late bool currentIsDefault;
  late double currentRealWidth;
  late double currentRealHeight;

  @override
  void initState() {
    super.initState();

    currentIsDefault = widget.map.isDefault;
    currentRealWidth = widget.map.placeMap.realWidth;
    currentRealHeight = widget.map.placeMap.realHeight;

    _realWidthController.text = currentRealWidth.toStringAsFixed(2);
    _realHeightController.text = currentRealHeight.toStringAsFixed(2);
  }

  bool hasChanges() {
    return currentIsDefault != widget.map.isDefault
        || currentRealWidth != widget.map.placeMap.realWidth
        || currentRealHeight != widget.map.placeMap.realHeight;
  }

  void applyChanges() {
    if(!hasChanges()) return;
    setState(() {
      widget.map.isDefault = currentIsDefault;
      widget.map.placeMap.realWidth = currentRealWidth;
      widget.map.placeMap.realHeight = currentRealHeight;
      widget.onChanged();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.map.placeMap.load(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.connectionState != ConnectionState.done) {
          return FullPageLoadingWidget();
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('Carte par défaut: '),
                    Checkbox(
                      value: currentIsDefault,
                      onChanged: (bool? value) {
                        if(value == null) return;
                        setState(() {
                          currentIsDefault = value;
                        });
                      }
                    ),
                    const SizedBox(width: 12.0),
                    const Text('Largeur réelle (m): '),
                    SizedBox(
                      width: 96.0,
                      child: Focus(
                        onFocusChange: (bool focus) {
                          if(focus) return;
                          if(_realWidthController.text.isEmpty) return;

                          var w = double.tryParse(_realWidthController.text);
                          if(w == null) return;

                          var whRatio = widget.map.placeMap.imageWidth / widget.map.placeMap.imageHeight;
                          var hStr = (w / whRatio).toStringAsFixed(2);
                          setState(() {
                            currentRealWidth = w;
                            currentRealHeight = double.parse(hStr);
                          });
                          _realHeightController.text = hStr;
                        },
                        child: TextFormField(
                          controller: _realWidthController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[.0-9]')),
                          ],
                          validator: (String? value) {
                            if(value == null || value.isEmpty) return 'Valeur manquante';
                            double? input = double.tryParse(value);
                            if(input == null) return 'Pas un nombre';
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    const Text('Hauteur réelle (m): '),
                    SizedBox(
                      width: 96.0,
                      child: Focus(
                        onFocusChange: (bool focus) {
                          if(focus) return;
                          if(_realHeightController.text.isEmpty) return;

                          var h = double.tryParse(_realHeightController.text);
                          if(h == null) return;

                          var whRatio = widget.map.placeMap.imageWidth / widget.map.placeMap.imageHeight;
                          var wStr = (h * whRatio).toStringAsFixed(2);
                          setState(() {
                            currentRealWidth = double.parse(wStr);
                            currentRealHeight = h;
                          });
                          _realWidthController.text = wStr;
                        },
                        child: TextFormField(
                          controller: _realHeightController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[.0-9]')),
                          ],
                          validator: (String? value) {
                            if(value == null || value.isEmpty) return 'Valeur manquante';
                            double? input = double.tryParse(value);
                            if(input == null) return 'Pas un nombre';
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    ElevatedButton(
                      onPressed: !hasChanges() ? null : () {
                        applyChanges();
                      },
                      child: const Text('Appliquer'),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                if(widget.map.placeMap.image != null)
                  Image.memory(widget.map.placeMap.image!),
              ]
            )
          )
        );
      }
    );
  }
}