import 'dart:async';

import 'package:flutter/material.dart';

import '../../../classes/human_character.dart';
import 'change_stream.dart';
import 'edit_background_widget.dart';
import 'edit_base_widget.dart';
import 'edit_equipment_widget.dart';
import 'edit_fervor_widget.dart';
import 'edit_magic_widget.dart';
import 'edit_relations_widget.dart';

class CharacterEditWidget extends StatefulWidget {
  const CharacterEditWidget({
    super.key,
    required this.character,
    required this.onEditDone,
  });

  final HumanCharacter character;
  final void Function(bool) onEditDone;

  @override
  State<CharacterEditWidget> createState() => _CharacterEditWidgetState();
}

class _CharacterEditWidgetState extends State<CharacterEditWidget> with TickerProviderStateMixin {
  late final StreamController<CharacterChange> changeStreamController;
  late final TabController tabController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    changeStreamController = StreamController<CharacterChange>.broadcast();
    tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    changeStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.cancel_outlined),
              onPressed: () {
                widget.onEditDone(false);
              },
            ),
            IconButton(
              icon: const Icon(Icons.check_circle_outline),
              onPressed: () {
                if(formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  widget.onEditDone(true);
                }
              }
            )
          ],
        ),
        TabBar.secondary(
          controller: tabController,
          tabs: const [
            Tab(text: 'Base'),
            Tab(text: 'Caste & Lien'),
            Tab(text: 'Background'),
            Tab(text: 'Équipement'),
            Tab(text: 'Magie'),
            Tab(text: "Pouvoirs de l'esprit"),
          ]
        ),
        Expanded(
          child: Form(
            key: formKey,
            child: TabBarView(
              controller: tabController,
              children: [
                _CharacterEditTabWidget(
                  child: CharacterEditBaseWidget(
                    character: widget.character,
                  )
                ),
                _CharacterEditTabWidget(
                  child: CharacterEditRelationsWidget(
                    character: widget.character,
                  ),
                ),
                _CharacterEditTabWidget(
                  child: CharacterEditBackgroundWidget(
                    character: widget.character,
                    changeStreamController: changeStreamController,
                  )
                ),
                _CharacterEditTabWidget(
                  child: CharacterEditEquipmentWidget(
                    character: widget.character,
                  )
                ),
                _CharacterEditTabWidget(
                  child: CharacterEditMagicWidget(
                    character: widget.character,
                  )
                ),
                _CharacterEditTabWidget(
                  child: CharacterEditFervorWidget(
                    character: widget.character,
                  )
                )
              ],
            ),
          )
        )
      ],
    );
  }
}

class _CharacterEditTabWidget extends StatefulWidget {
  const _CharacterEditTabWidget({ required this.child });

  final Widget child;

  @override
  State<_CharacterEditTabWidget> createState() => _CharacterEditTabWidgetState();
}

class _CharacterEditTabWidgetState extends State<_CharacterEditTabWidget> with AutomaticKeepAliveClientMixin<_CharacterEditTabWidget> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 1000,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}