import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:file_saver/file_saver.dart';

import '../../classes/player_character.dart';
import 'edit_base_tab.dart';
import 'edit_magic_tab.dart';
import 'edit_skills_tab.dart';
import 'edit_equipment_tab.dart';

class PlayerCharacterEditPage extends StatefulWidget {
  const PlayerCharacterEditPage({super.key, required this.uuid})
    : character = null;
  PlayerCharacterEditPage.immediate({super.key, required this.character})
    : uuid = character!.uuid;

  @override
  State<PlayerCharacterEditPage> createState() => _PlayerCharacterEditPageState();

  final String uuid;
  final PlayerCharacter? character;
}

class _PlayerCharacterEditPageState extends State<PlayerCharacterEditPage> {
  bool _isWorking = false;
  late Future<PlayerCharacter> _characterFuture;
  late PlayerCharacter _character;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if(widget.character != null) {
      _characterFuture = Future<PlayerCharacter>.sync(() => widget.character!);
    }
    else {
      _characterFuture = getPlayerCharacter(widget.uuid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _characterFuture,
      builder: (context, AsyncSnapshot<PlayerCharacter> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text('Chargement...'));
        }

        if(!snapshot.hasData || snapshot.data == null) {
          // TODO: find a better way to notify the user
          return const Center(child: Text('Quelque chose a foiré grave'));
        }
        else {
          _character = snapshot.data!;
        }

        return Stack(
          children: [
            DefaultTabController(
              length: 4,
              child: Scaffold(
                appBar: AppBar(
                  title: Text('PJ: ${_character.name}'),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.download),
                      tooltip: 'Exporter le PJ',
                      onPressed: () async {
                        var jsonStr = json.encode(_character.toJson());
                        await FileSaver.instance.saveFile(
                          name: 'player-character_${_character.uuid}.json',
                          bytes: utf8.encode(jsonStr),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: 'Annuler',
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.check),
                      tooltip: 'Valider',
                      onPressed: () async {
                        if(!_formKey.currentState!.validate()) return;

                        setState(() {
                          _isWorking = true;
                        });
                        _formKey.currentState!.save();
                        await savePlayerCharacter(_character);
                        setState(() {
                          _isWorking = false;
                        });

                        if(!context.mounted) return;
                        Navigator.of(context).pop(true);
                      },
                    )
                  ],
                  bottom: const TabBar(
                    tabs: [
                      Tab(text: 'Base'),
                      Tab(text: 'Compétences'),
                      Tab(text: 'Équipement'),
                      Tab(text: 'Magie'),
                    ]
                  ),
                ),
                body: Form(
                  key: _formKey,
                  child: TabBarView(
                    children: [
                      EditBaseTab(character: _character),
                      EditSkillsTab(character: _character),
                      EditEquipmentTab(character: _character),
                      EditMagicTab(character: _character),
                    ],
                  ),
                )
              ),
            ),
            if(_isWorking)
              const Opacity(
                opacity: 0.6,
                child: ModalBarrier(
                  dismissible: false,
                  color: Colors.black,
                )
              ),
            if(_isWorking)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        );
      }
    );
  }
}