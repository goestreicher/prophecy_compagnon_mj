import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../classes/table.dart' as pc;
import '../../classes/player_character.dart';
import '../player_character/new_character_dialog.dart';
import '../utils/character/edit_widget.dart';
import '../utils/error_feedback.dart';
import '../utils/full_page_loading.dart';
import 'characters_list_widget.dart';

class TableEditPage extends StatefulWidget {
  const TableEditPage({super.key, required this.uuid}) : table = null;
  TableEditPage.immediate({super.key, required this.table}) : uuid = table!.uuid;

  @override
  State<TableEditPage> createState() => _TableEditPageState();

  final String uuid;
  final pc.GameTable? table;
}

class _TableEditPageState extends State<TableEditPage> {
  bool _isWorking = false;
  bool _canCancel = true;
  late Future<pc.GameTable?> _tableFuture;
  late pc.GameTable _table;
  String? selectedId;
  PlayerCharacter? newPC;
  final GlobalKey<FormState> _newPlayerCharacterForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if(widget.table != null) {
      _tableFuture = Future<pc.GameTable?>.sync(() => widget.table!)
        .then((pc.GameTable? t) async {
          await t?.loadPlayers();
          return t;
        });
    }
    else {
      _tableFuture = pc.GameTableStore().get(widget.uuid)
          .then((pc.GameTable? t) async {
        await t?.loadPlayers();
        return t;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _tableFuture,
      builder: (BuildContext context, AsyncSnapshot<pc.GameTable?> snapshot) {
        if(snapshot.connectionState != ConnectionState.done) {
          return FullPageLoadingWidget();
        }

        if(snapshot.hasError) {
          return FullPageErrorWidget(message: snapshot.error!.toString(), canPop: true);
        }

        if(!snapshot.hasData || snapshot.data == null) {
          return FullPageErrorWidget(message: 'Aucune donnée retournée', canPop: true);
        }

        _table = snapshot.data!;

        var listWidget = TableCharactersListWidget(
          summaries: _table.playerSummaries,
          selected: selectedId,
          onCharacterSelected: (String? id) async {
            setState(() {
              selectedId = id;
            });
          },
          onCharacterEdited: (String id) async {
            setState(() {
              _isWorking = true;
            });
            await pc.GameTableStore().save(_table);
            setState(() {
              _isWorking = false;
            });
          },
          onCharacterDeleted: (String id) async {
            setState(() {
              _canCancel = false;
              _isWorking = true;
            });
            var character = await PlayerCharacterStore().get(id);
            if(character != null) {
              await PlayerCharacterStore().delete(character);
            }
            await pc.GameTableStore().save(_table);
            setState(() {
              _isWorking = false;
            });
          },
          onCharacterCreationRequested: () async {
            PlayerCharacter? character = await showDialog(
              context: context,
              builder: (context) => NewPlayerCharacterDialog(
                formKey: _newPlayerCharacterForm,
              ),
            );
            // User canceled the pop-up dialog
            if(character == null) return;
            if(!context.mounted) return;

            setState(() {
              selectedId = character.id;
              newPC = character;
            });
          },
          onCharacterImportRequested: () async {
            var result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['json'],
              withData: true,
            );
            if(result == null) return;

            try {
              setState(() {
                _isWorking = true;
              });

              var jsonStr = const Utf8Decoder().convert(result.files.first.bytes!);
              var character = PlayerCharacter.import(json.decode(jsonStr));
              await PlayerCharacterStore().save(character);

              setState(() {
                _table.playerSummaries.add(character.summary);
              });

              await pc.GameTableStore().save(_table);

              setState(() {
                _isWorking = false;
                _canCancel = false;
              });
            } catch (e) {
              setState(() {
                _isWorking = false;
              });

              if(!context.mounted) return;

              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                    title: const Text("Échec de l'import"),
                    content: Text(e.toString()),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('OK'),
                      )
                    ]
                )
              );
            }
          },
        );

        Widget mainArea = Row(
          children: [
            if(selectedId == null)
              Expanded(child: listWidget),
            if(selectedId != null)
              SizedBox(
                width: 300,
                child: listWidget,
              ),
            if(selectedId != null)
              Expanded(
                child: CharacterEditWidget(
                  character: newPC ?? _table.players.firstWhere((PlayerCharacter p) => p.id == selectedId!),
                  onEditDone: (bool result) async {
                    if(result) {
                      if(newPC != null) {
                        await PlayerCharacterStore().save(newPC!);

                        _table.playerSummaries.add(newPC!.summary);
                        _table.players.add(newPC!);
                      }
                      else {
                        var summaryIndex = _table.playerSummaries
                          .indexWhere((PlayerCharacterSummary s) => s.id == selectedId);
                        var pcIndex = _table.players
                          .indexWhere((PlayerCharacter p) => p.id == selectedId);

                        if(summaryIndex != -1 && pcIndex != -1) {
                          await PlayerCharacterStore().save(_table.players[pcIndex]);
                          _table.playerSummaries[summaryIndex] = _table.players[pcIndex].summary;
                        }
                      }
                    }
                    setState(() {
                      selectedId = null;
                      newPC = null;
                    });
                  }
                ),
              )
          ],
        );

        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text('Table: ${_table.name}'),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.download),
                    tooltip: 'Exporter la table',
                    onPressed: selectedId != null ? null : () async {
                      setState(() {
                        _isWorking = true;
                      });
                      var jsonFull = await _table.toJsonFull();
                      var jsonStr = json.encode(jsonFull);
                      setState(() {
                        _isWorking = false;
                      });
                      await FilePicker.platform.saveFile(
                        fileName: 'table_${_table.uuid}.json',
                        bytes: utf8.encode(jsonStr),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: 'Annuler',
                    onPressed: (selectedId != null || !_canCancel) ? null : () async {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.check),
                    tooltip: 'Valider',
                    onPressed: selectedId != null ? null : () async {
                      setState(() {
                        _isWorking = true;
                      });
                      await pc.GameTableStore().save(_table);
                      setState(() {
                        _isWorking = false;
                      });

                      if(!context.mounted) return;
                      Navigator.of(context).pop(true);
                    },
                  )
                ],
              ),
              body: mainArea,
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
      },
    );
  }
}