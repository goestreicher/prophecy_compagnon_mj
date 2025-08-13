import 'package:fleather/fleather.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parchment/codecs.dart';

import '../../classes/scenario.dart';

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
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _synopsysController = TextEditingController();
  late final FleatherController storyController;
  late final FocusNode storyFocusNode;

  @override
  void initState() {
    super.initState();

    if(kIsWeb) {
      BrowserContextMenu.disableContextMenu();
    }

    _subtitleController.text = widget.scenario.subtitle;
    _synopsysController.text = widget.scenario.synopsys;

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
                            DigitInputWidget(
                              initialValue: widget.scenario.danger,
                              minValue: 0,
                              maxValue: 5,
                              onValueChanged: (int v) {
                                widget.scenario.danger = v;
                              }
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            const Text('Découverte'),
                            const Spacer(),
                            DigitInputWidget(
                                initialValue: widget.scenario.discovery,
                                minValue: 0,
                                maxValue: 5,
                                onValueChanged: (int v) {
                                  widget.scenario.discovery = v;
                                }
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            const Text('Magie'),
                            const Spacer(),
                            DigitInputWidget(
                                initialValue: widget.scenario.magic,
                                minValue: 0,
                                maxValue: 5,
                                onValueChanged: (int v) {
                                  widget.scenario.magic = v;
                                }
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            const Text('Implication'),
                            const Spacer(),
                            DigitInputWidget(
                                initialValue: widget.scenario.implication,
                                minValue: 0,
                                maxValue: 5,
                                onValueChanged: (int v) {
                                  widget.scenario.implication = v;
                                }
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
                  TextField(
                    controller: _subtitleController,
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
                  TextField(
                    controller: _synopsysController,
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
                  FleatherToolbar.basic(
                    controller: storyController,
                    hideUnderLineButton: true, // Not supported by markdown
                    hideForegroundColor: true, // Not supported by markdown
                    hideBackgroundColor: true, // Not supported by markdown
                    hideDirection: true,
                    hideAlignment: true, // Not supported by markdown
                    hideIndentation: true, // No-op for markdown
                    hideHorizontalRule: true, // No-op for markdown
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

class DigitInputWidget extends StatefulWidget {
  const DigitInputWidget({
    super.key,
    initialValue,
    required this.minValue,
    required this.maxValue,
    required this.onValueChanged,
  })
    : initialValue = initialValue ?? minValue;

  final int initialValue;
  final int minValue;
  final int maxValue;
  final void Function(int) onValueChanged;

  @override
  State<DigitInputWidget> createState() => _DigitInputWidgetState();
}

class _DigitInputWidgetState extends State<DigitInputWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      children: [
        IconButton(
          onPressed: () {
            if(_controller.text.isEmpty) {
              _controller.text = widget.initialValue.toString();
            }

            var curr = int.parse(_controller.text);
            if(curr > widget.minValue) {
              _controller.text = (curr - 1).toString();
              widget.onValueChanged(curr - 1);
            }
          },
          icon: const Icon(Icons.remove),
          iconSize: 12.0,
          style: IconButton.styleFrom(
            padding: const EdgeInsets.all(6.0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: Size.zero,
          ),
        ),
        SizedBox(
          width: 30.0,
          child: TextField(
            controller: _controller,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isCollapsed: true,
              contentPadding: EdgeInsets.all(8.0),
              error: null,
              errorText: null,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            if(_controller.text.isEmpty) {
              _controller.text = widget.initialValue.toString();
            }

            var curr = int.parse(_controller.text);
            if(curr < widget.maxValue) {
              _controller.text = (curr + 1).toString();
              widget.onValueChanged(curr + 1);
            }
          },
          icon: const Icon(Icons.add),
          iconSize: 12.0,
          style: IconButton.styleFrom(
            padding: const EdgeInsets.all(6.0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: Size.zero,
          ),
        )
      ]
    );
  }
}