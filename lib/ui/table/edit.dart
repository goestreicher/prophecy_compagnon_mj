import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';

import '../../classes/table.dart' as pc;
import '../../classes/player_character.dart';
import '../../classes/character/base.dart';
import '../player_character/edit.dart';
import '../player_character/new_character_dialog.dart';

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
  late Future<pc.GameTable> _tableFuture;
  late pc.GameTable _table;
  final GlobalKey<FormState> _newPlayerCharacterForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if(widget.table != null) {
      _tableFuture = Future<pc.GameTable>.sync(() => widget.table!);
    }
    else {
      _tableFuture = pc.getGameTable(widget.uuid);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return FutureBuilder(
      future: _tableFuture,
      builder: (BuildContext context, AsyncSnapshot<pc.GameTable> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text('Chargement...'));
        }

        if(!snapshot.hasData || snapshot.data == null) {
          // TODO: find a better way to notify the user
          return const Center(child: Text('Quelque chose a foiré grave'));
        }
        else {
          _table = snapshot.data!;
        }

        Widget mainArea;
        if(_table.playerSummaries.isEmpty) {
          mainArea = const Center(
            child: Text('On va rajouter des PJs, hein'),
          );
        }
        else {
          mainArea = ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _table.playerSummaries.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: theme.colorScheme.surface,
                  onTap: () async {
                    var saved = await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PlayerCharacterEditPage(uuid: _table.playerSummaries[index].uuid)),
                    );
                    if(saved != null && saved) {
                      setState(() {
                        _isWorking = true;
                      });
                      await pc.saveGameTable(_table);
                      setState(() {
                        _isWorking = false;
                      });
                    }
                  },
                  child: ListTile(
                    title: Text(_table.playerSummaries[index].name),
                    subtitle: Text(
                        'Caste: ${_table.playerSummaries[index].caste.title} '
                        '(${Caste.statusName(_table.playerSummaries[index].caste, _table.playerSummaries[index].casteStatus)})'
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        // TODO: ask confirmation maybe?
                        setState(() {
                          _canCancel = false;
                          _isWorking = true;
                        });
                        await deletePlayerCharacter(_table.playerSummaries[index].uuid);
                        _table.playerSummaries.removeAt(index);
                        await pc.saveGameTable(_table);
                        setState(() {
                          _isWorking = false;
                        });
                      },
                    )
                  ),
                )
              );
            }
          );
        }

        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text('Table: ${_table.name}'),
                leading: IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () async {
                    setState(() {
                      _isWorking = true;
                    });
                    var jsonFull = await _table.toJsonFull();
                    var jsonStr = json.encode(jsonFull);
                    setState(() {
                      _isWorking = false;
                    });
                    await FileSaver.instance.saveFile(
                      name: 'table_${_table.uuid}.json',
                      bytes: utf8.encode(jsonStr),
                    );
                  },
                ),
                automaticallyImplyLeading: false,
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.publish),
                    tooltip: 'Importer un PJ',
                    onPressed: () async {
                      var result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['json'],
                      );
                      if(result == null) return;
                      try {
                        setState(() {
                          _isWorking = true;
                        });
                        var jsonStr = const Utf8Decoder().convert(result.files.first.bytes!);
                        var character = PlayerCharacter.import(json.decode(jsonStr));
                        await savePlayerCharacter(character);
                        setState(() {
                          _table.playerSummaries.add(character.summary());
                        });
                        await pc.saveGameTable(_table);
                        setState(() {
                          _isWorking = false;
                          _canCancel = false;
                        });
                      } catch (e) {
                        setState(() {
                          _isWorking = false;
                        });
                        // TODO: notify the user that things went south
                        // TODO: catch FormatException from the UTF-8 conversion?
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: 'Annuler',
                    onPressed: !_canCancel
                      ? null
                      : () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.check),
                    tooltip: 'Valider',
                    onPressed: () async {
                      setState(() {
                        _isWorking = true;
                      });
                      await pc.saveGameTable(_table);
                      setState(() {
                        _isWorking = false;
                      });

                      if(!context.mounted) return;
                      Navigator.of(context).pop(true);
                    },
                  )
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                icon: const Icon(Icons.add),
                label: const Text('Nouveau PJ'),
                onPressed: () async {
                  PlayerCharacter? character = await showDialog(
                    context: context,
                    builder: (context) => NewPlayerCharacterDialog(
                      formKey: _newPlayerCharacterForm,
                    ),
                  );
                  // User canceled the pop-up dialog
                  if(character == null) return;


                  if(!context.mounted) return;
                  var saved = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PlayerCharacterEditPage.immediate(character: character)),
                  );
                  if(saved != null && saved) {
                    setState(() {
                      _canCancel = false;
                      _isWorking = true;
                    });
                    _table.playerSummaries.add(character.summary());
                    await pc.saveGameTable(_table);
                    setState(() {
                      _isWorking = false;
                    });
                  }
                },
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