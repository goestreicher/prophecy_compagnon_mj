import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../classes/table.dart' as pc;
import '../../classes/player_character.dart';
import '../../classes/character/base.dart';
import '../player_character/edit.dart';
import '../player_character/new_character_dialog.dart';
import '../utils/error_feedback.dart';
import '../utils/full_page_loading.dart';

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
  final GlobalKey<FormState> _newPlayerCharacterForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if(widget.table != null) {
      _tableFuture = Future<pc.GameTable?>.sync(() => widget.table!);
    }
    else {
      _tableFuture = pc.GameTableStore().get(widget.uuid);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

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

        Widget mainArea;
        if(_table.playerSummaries.isEmpty) {
          mainArea = const Center(
            child: Text('On va rajouter des PJs, hein'),
          );
        }
        else {
          mainArea = Stack(
            children: [
              ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _table.playerSummaries.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: theme.colorScheme.surface,
                      onTap: () async {
                        var saved = await Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => PlayerCharacterEditPage(id: _table.playerSummaries[index].id)),
                        );
                        if(saved != null && saved) {
                          setState(() {
                            _isWorking = true;
                          });
                          await pc.GameTableStore().save(_table);
                          setState(() {
                            _isWorking = false;
                          });
                        }
                      },
                      child: ListTile(
                        title: Text(_table.playerSummaries[index].name),
                        leading: _table.playerSummaries[index].icon == null
                          ? null
                          : Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24.0),
                                image: DecorationImage(
                                  image: MemoryImage(
                                    _table.playerSummaries[index].icon!.data
                                  )
                                ),
                              ),
                            ),
                        subtitle: Text(
                            'Caste: ${_table.playerSummaries[index].caste.title} '
                            '(${Caste.statusName(_table.playerSummaries[index].caste, _table.playerSummaries[index].casteStatus)})'
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            var confirm = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Confirmer la suppression'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Supprimer ce personnage ?'),
                                    const SizedBox(height: 8.0),
                                    const Text('Cette action ne peut pas être annulée.'),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text('Annuler'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text('Supprimer'),
                                  ),
                                ]
                              )
                            );
                            if(confirm == null || !confirm) return;

                            setState(() {
                              _canCancel = false;
                              _isWorking = true;
                            });
                            var character = await PlayerCharacterStore().get(_table.playerSummaries[index].id);
                            if(character != null) {
                              await PlayerCharacterStore().delete(character);
                            }
                            _table.playerSummaries.removeAt(index);
                            await pc.GameTableStore().save(_table);
                            setState(() {
                              _isWorking = false;
                            });
                          },
                        )
                      ),
                    )
                  );
                }
              ),
            ],
          );
        }

        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text('Table: ${_table.name}'),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.download),
                    tooltip: 'Exporter la table',
                    onPressed: () async {
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
            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: MenuAnchor(
                  alignmentOffset: const Offset(0, 4),
                  builder: (BuildContext context, MenuController controller, Widget? child) {
                    return IconButton.filled(
                      icon: const Icon(Icons.add),
                      padding: const EdgeInsets.all(12.0),
                      tooltip: 'Créer / Importer',
                      onPressed: () {
                        if(controller.isOpen) {
                          controller.close();
                        }
                        else {
                          controller.open();
                        }
                      },
                    );
                  },
                  menuChildren: [
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: MenuItemButton(
                        child: const Row(
                          children: [
                            Icon(Icons.create),
                            SizedBox(width: 4.0),
                            Text('Nouveau PJ'),
                          ],
                        ),
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
                            _table.playerSummaries.add(character.summary);
                            await pc.GameTableStore().save(_table);
                            setState(() {
                              _isWorking = false;
                            });
                          }
                        },
                      ),
                    ),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: MenuItemButton(
                        child: const Row(
                          children: [
                            Icon(Icons.publish),
                            SizedBox(width: 4.0),
                            Text('Importer un PJ'),
                          ],
                        ),
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
                      ),
                    ),
                  ],
                ),
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
      },
    );
  }
}