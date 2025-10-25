import 'package:fleather/fleather.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parchment/codecs.dart';
import 'package:prophecy_compagnon_mj/ui/scenario/scenario_fleather_toolbar.dart';

import '../../classes/resource_link.dart';
import '../../classes/scenario.dart';
import '../utils/markdown_fleather_toolbar.dart';
import '../utils/num_input_widget.dart';

class ScenarioEditGeneralPage extends StatefulWidget {
  const ScenarioEditGeneralPage({
    super.key,
    required this.scenario,
    this.registerPreSaveCallback,
  });

  final Scenario scenario;
  final void Function(void Function())? registerPreSaveCallback;

  @override
  State<ScenarioEditGeneralPage> createState() => _ScenarioEditGeneralPageState();
}

class _ScenarioEditGeneralPageState extends State<ScenarioEditGeneralPage> {
  late final FleatherController storyController;
  late final FocusNode storyFocusNode;

  @override
  void initState() {
    super.initState();

    if(kIsWeb) {
      BrowserContextMenu.disableContextMenu();
    }

    var document = ParchmentMarkdownCodec().decode(widget.scenario.story);
    storyController = FleatherController(document: document);
    storyFocusNode = FocusNode();

    widget.registerPreSaveCallback?.call(() {
      widget.scenario.story = ParchmentMarkdownCodec().encode(storyController.document);
    });
  }

  @override
  void dispose() {
    if(kIsWeb) {
      BrowserContextMenu.enableContextMenu();
    }

    storyFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 250.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Expérience',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12.0),
                        Row(
                          children: [
                            const Text('Danger'),
                            const Spacer(),
                            SizedBox(
                              width: 80,
                              child: NumIntInputWidget(
                                initialValue: widget.scenario.danger,
                                minValue: 0,
                                maxValue: 5,
                                onChanged: (int v) {
                                  widget.scenario.danger = v;
                                }
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            const Text('Découverte'),
                            const Spacer(),
                            SizedBox(
                              width: 80,
                              child: NumIntInputWidget(
                                initialValue: widget.scenario.discovery,
                                minValue: 0,
                                maxValue: 5,
                                onChanged: (int v) {
                                  widget.scenario.discovery = v;
                                }
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            const Text('Magie'),
                            const Spacer(),
                            SizedBox(
                              width: 80,
                              child: NumIntInputWidget(
                                initialValue: widget.scenario.magic,
                                minValue: 0,
                                maxValue: 5,
                                onChanged: (int v) {
                                  widget.scenario.magic = v;
                                }
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            const Text('Implication'),
                            const Spacer(),
                            SizedBox(
                              width: 80,
                              child: NumIntInputWidget(
                                initialValue: widget.scenario.implication,
                                minValue: 0,
                                maxValue: 5,
                                onChanged: (int v) {
                                  widget.scenario.implication = v;
                                }
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: widget.scenario.subtitle,
                    maxLength: 150,
                    onChanged: (String value) {
                      widget.scenario.subtitle = value;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Sous-titre'),
                    ),
                  ),
                  Divider(),
                  TextFormField(
                    initialValue: widget.scenario.synopsys,
                    minLines: 5,
                    maxLines: 10,
                    onChanged: (String value) {
                      widget.scenario.synopsys = value;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Synopsys'),
                    ),
                  ),
                  Divider(),
                  MarkdownFleatherToolbar(
                    controller: storyController,
                    showResourcePicker: true,
                    openResourceLinkPickerDialog: () => ResourceLinkPickerDialog(
                      localResourcesLinkGenerator: (ResourceLinkType type) =>
                          generateScenarioResourceLinks(type, widget.scenario),
                    ),
                  ),
                  Expanded(
                    child: FleatherField(
                      controller: storyController,
                      focusNode: storyFocusNode,
                      expands: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Histoire'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}