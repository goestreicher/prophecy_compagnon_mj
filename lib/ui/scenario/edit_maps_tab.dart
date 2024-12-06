import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../classes/map_background_data.dart';
import '../../classes/scenario_map.dart';
import '../utils/map_background_picker.dart';
import '../utils/single_line_input_dialog.dart';

class ScenarioEditMapsPage extends StatefulWidget {
  const ScenarioEditMapsPage({ super.key, required this.maps });

  final List<ScenarioMap> maps;

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
        onDefaultChanged: (bool value) {
          if(value) {
            for(var map in widget.maps) {
              if(map.name != _selected!.name && map.isDefault) {
                map.isDefault = false;
              }
            }
          }
          setState(() {
            _selected!.isDefault = value;
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

                    var background = await showDialog<MapBackground>(
                      context: context,
                      builder: (BuildContext context) => const MapBackgroundPickerDialog(),
                    );
                    if(background == null) return;
                    if(!context.mounted) return;

                    setState(() {
                      widget.maps.add(ScenarioMap(name: newMapName, background: background));
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
                      return Card(
                        clipBehavior: Clip.hardEdge,
                        color: _selected == widget.maps[index] ?
                        theme.colorScheme.surfaceContainerHighest :
                        null,
                        child: InkWell(
                          splashColor: theme.colorScheme.surface,
                          onTap: () {
                            setState(() {
                              _selected = widget.maps[index];
                            });
                          },
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  // TODO: ask confirmation maybe?
                                  await ScenarioMapStore().delete(widget.maps[index]);
                                  setState(() {
                                    if(_selected == widget.maps[index]) {
                                      _selected = null;
                                    }
                                    widget.maps.removeAt(index);
                                  });
                                },
                              ),
                              const SizedBox(width: 12.0),
                              Image.memory(
                                widget.maps[index].background.image.data,
                                width: 128,
                              ),
                              const SizedBox(width: 8.0),
                              if(widget.maps[index].isDefault)
                                Text(
                                  '${widget.maps[index].name} (Par défaut)',
                                  style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                                ),
                              if(!widget.maps[index].isDefault)
                                Text(widget.maps[index].name),
                              const Spacer(),
                              const Icon(Icons.arrow_forward_ios),
                            ],
                          ),
                        ),
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
  const _MapEditWidget({ required this.map, required this.onDefaultChanged });

  final ScenarioMap map;
  final void Function(bool) onDefaultChanged;

  @override
  State<_MapEditWidget> createState() => _MapEditWidgetState();
}

class _MapEditWidgetState extends State<_MapEditWidget> {
  late bool _isDefault;
  final TextEditingController _realWidthController = TextEditingController();
  final TextEditingController _realHeightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isDefault = widget.map.isDefault;
    _realWidthController.text = widget.map.background.realWidth.toStringAsFixed(2);
    _realHeightController.text = widget.map.background.realHeight.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Carte par défaut: '),
                Checkbox(
                  value: _isDefault,
                  onChanged: (bool? value) {
                    if(value == null) return;
                    widget.onDefaultChanged(value);
                    setState(() {
                      _isDefault = value;
                    });
                  }
                ),
                const SizedBox(width: 12.0),
                const Text('Largeur réelle (m): '),
                SizedBox(
                  width: 96.0,
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
                    onChanged: (String? value) {
                      if(value == null) return;

                      var w = double.tryParse(value);
                      if(w == null) return;

                      var whRatio = widget.map.background.imageWidth / widget.map.background.imageHeight;
                      var hStr = (w / whRatio).toStringAsFixed(2);
                      widget.map.background.realWidth = w;
                      widget.map.background.realHeight = double.parse(hStr);
                      _realHeightController.text = hStr;
                    },
                  ),
                ),
                const SizedBox(width: 12.0),
                const Text('Hauteur réelle (m): '),
                SizedBox(
                  width: 96.0,
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
                    onChanged: (String? value) {
                      if(value == null) return;

                      var h = double.tryParse(value);
                      if(h == null) return;

                      var whRatio = widget.map.background.imageWidth / widget.map.background.imageHeight;
                      var wStr = (h * whRatio).toStringAsFixed(2);
                      widget.map.background.realWidth = double.parse(wStr);
                      widget.map.background.realHeight = h;
                      _realWidthController.text = wStr;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Image.memory(widget.map.background.image.data),
          ]
        )
      )
    );
  }
}