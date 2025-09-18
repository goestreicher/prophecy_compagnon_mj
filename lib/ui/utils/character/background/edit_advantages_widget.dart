import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../classes/human_character.dart';
import '../../dismissible_dialog.dart';
import '../../widget_group_container.dart';
import '../change_stream.dart';
import 'advantage_picker_dialog.dart';
import 'disadvantage_picker_dialog.dart';

class CharacterEditDisadvantagesWidget extends StatefulWidget {
  const CharacterEditDisadvantagesWidget({
    super.key,
    required this.character,
    required this.changeStreamController,
    this.initialDisadvantages,
    this.onChanged,
  });

  final HumanCharacter character;
  final StreamController<CharacterChange> changeStreamController;
  final List<CharacterDisadvantage>? initialDisadvantages;
  final void Function(List<CharacterDisadvantage>)? onChanged;

  @override
  State<CharacterEditDisadvantagesWidget> createState() => _CharacterEditDisadvantagesWidgetState();
}

class _CharacterEditDisadvantagesWidgetState extends State<CharacterEditDisadvantagesWidget> {
  late final List<CharacterDisadvantage> currentDisadvantages;

  @override
  void initState() {
    super.initState();

    currentDisadvantages = widget.initialDisadvantages ?? widget.character.disadvantages;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Désavantages',
        style: theme.textTheme.bodyMedium!.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 4.0,
        children: [
          for(var d in currentDisadvantages)
            Card(
              child: Container(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  spacing: 8.0,
                  children: [
                    IconButton(
                      style: IconButton.styleFrom(
                        iconSize: 16.0,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        setState(() {
                          currentDisadvantages.remove(d);
                        });
                      },
                      icon: const Icon(Icons.delete),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4.0,
                        children: [
                          Text(
                            '${d.disadvantage.title} (${d.cost})',
                            style: theme.textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            )
                          ),
                          if(d.details.isNotEmpty)
                            Text(
                              d.details,
                              style: theme.textTheme.bodySmall,
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      style: IconButton.styleFrom(
                        iconSize: 16.0,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.info_outlined),
                      onPressed: () {
                        Navigator.of(context).push(
                            DismissibleDialog<void>(
                              title: d.disadvantage.title,
                              content: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: 400,
                                  maxWidth: 400,
                                  maxHeight: 400,
                                ),
                                child: SingleChildScrollView(
                                  child: Text(
                                    d.disadvantage.description,
                                  ),
                                )
                              )
                            )
                        );
                      },
                    ),
                  ],
                ),
              )
            ),
          Center(
            child: TextButton(
              style: TextButton.styleFrom(
                textStyle: theme.textTheme.bodySmall,
              ),
              onPressed: () async {
                var result = await showDialog<CharacterDisadvantage>(
                  context: context,
                  builder: (BuildContext context) => const DisadvantagePickerDialog(),
                );
                if(!context.mounted) return;
                if(result == null) return;

                setState(() {
                  currentDisadvantages.add(result);
                });
              },
              child: const Text('Nouveau désavantage'),
            ),
          )
        ],
      ),
    );
  }
}

class CharacterEditAdvantagesWidget extends StatefulWidget {
  const CharacterEditAdvantagesWidget({
    super.key,
    required this.character,
    required this.changeStreamController,
    this.initialAdvantages,
    this.onChanged,
  });

  final HumanCharacter character;
  final StreamController<CharacterChange> changeStreamController;
  final List<CharacterAdvantage>? initialAdvantages;
  final void Function(List<CharacterAdvantage>)? onChanged;

  @override
  State<CharacterEditAdvantagesWidget> createState() => _CharacterEditAdvantagesWidgetState();
}

class _CharacterEditAdvantagesWidgetState extends State<CharacterEditAdvantagesWidget> {
  late final List<CharacterAdvantage> currentAdvantages;

  @override
  void initState() {
    super.initState();

    currentAdvantages = widget.initialAdvantages ?? widget.character.advantages;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Avantages',
        style: theme.textTheme.bodyMedium!.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 4.0,
        children: [
          for(var a in currentAdvantages)
            Card(
              child: Container(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  spacing: 8.0,
                  children: [
                    IconButton(
                      style: IconButton.styleFrom(
                        iconSize: 16.0,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        setState(() {
                          currentAdvantages.remove(a);
                        });
                      },
                      icon: const Icon(Icons.delete),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4.0,
                        children: [
                          Text(
                            '${a.advantage.title} (${a.cost})',
                            style: theme.textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            )
                          ),
                          if(a.details.isNotEmpty)
                            Text(
                              a.details,
                              style: theme.textTheme.bodySmall,
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      style: IconButton.styleFrom(
                        iconSize: 16.0,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.info_outlined),
                      onPressed: () {
                        Navigator.of(context).push(
                          DismissibleDialog<void>(
                            title: a.advantage.title,
                            content: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: 400,
                                maxWidth: 400,
                                maxHeight: 400,
                              ),
                              child: SingleChildScrollView(
                                child: Text(
                                  a.advantage.description,
                                ),
                              )
                            )
                          )
                        );
                      },
                    ),
                  ],
                ),
              )
            ),
          Center(
            child: TextButton(
              style: TextButton.styleFrom(
                textStyle: theme.textTheme.bodySmall,
              ),
              onPressed: () async {
                var result = await showDialog<CharacterAdvantage>(
                  context: context,
                  builder: (BuildContext context) => const AdvantagePickerDialog(),
                );
                if(!context.mounted) return;
                if(result == null) return;

                setState(() {
                  currentAdvantages.add(result);
                });
              },
              child: const Text('Nouvel avantage'),
            ),
          )
        ],
      ),
    );
  }
}