import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../classes/game_session.dart';
import 'command_dispatcher.dart';
import 'play.dart';
import 'session_creation_dialog.dart';
import 'session_model.dart';

class SessionsListPage extends StatefulWidget {
  const SessionsListPage({ super.key });

  @override
  State<SessionsListPage> createState() => _SessionsListPageState();
}

class _SessionsListPageState extends State<SessionsListPage> {
  bool _isWorking = false;
  late Future<List<GameSession>> _sessionsFuture;
  List<GameSession> _sessions = <GameSession>[];

  @override
  void initState() {
    super.initState();
    loadSessionSummaries();
  }

  void loadSessionSummaries() {
    _sessionsFuture = getGameSessions();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return FutureBuilder<List<GameSession>>(
        future: _sessionsFuture,
        builder: (BuildContext context,
            AsyncSnapshot<List<GameSession>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              // TODO: something more fancy
                child: Text('Chargement...'));
          }

          _sessions = snapshot.hasData
              ? snapshot.data!
              : <GameSession>[];

          Widget mainArea;
          if (_sessions.isEmpty) {
            mainArea = const Center(
              child: Text('Pas de sessions en cours...'),
            );
          }
          else {
            mainArea = ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _sessions.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    splashColor: theme.colorScheme.surface,
                    onTap: () async {
                      var session = await createSessionModel(_sessions[index].uuid);
                      if(!context.mounted) return;

                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                            MultiProvider(
                              providers: [
                                ChangeNotifierProvider.value(value: session),
                                ChangeNotifierProvider(create: (_) => CommandDispatcher(session: session)),
                              ],
                              child: const SessionPlayPage()
                            ),
                        ),
                      );
                      setState(() {
                        loadSessionSummaries();
                      });
                    },
                    child: ListTile(
                        title: Text(
                          'Table: ${_sessions[index].table.name}\n'
                          'Scénario: ${_sessions[index].scenario.name} (jour ${_sessions[index].scenarioDay})'
                        ),
                        subtitle: Text('Date: ${_sessions[index].currentDate.toFullString()}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            // TODO: ask confirmation maybe?
                            setState(() {
                              _isWorking = true;
                            });
                            await deleteGameSession(_sessions[index].uuid);
                            setState(() {
                              _isWorking = false;
                              loadSessionSummaries();
                            });
                          },
                        )
                    ),
                  ),
                );
              },
            );
          }

          return Stack(
            children: [
              mainArea,
              Positioned(
                bottom: 16.0,
                right: 16.0,
                child: MenuAnchor(
                  alignmentOffset: const Offset(-100, 10),
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
                    MenuItemButton(
                      child: const Row(
                        children: [
                          Icon(Icons.create),
                          SizedBox(width: 4.0),
                          Text('Nouvelle session'),
                        ],
                      ),
                      onPressed: () async {
                        var session = await showDialog(
                            context: context,
                            builder: (BuildContext context) => const SessionCreationDialog(),
                        );
                        if(session == null) return;
                        await saveGameSession(session);
                        setState(() {
                          _sessions.clear();
                          loadSessionSummaries();
                        });
                      },
                    ),
                  ],
                ),
              ),
              if(_isWorking)
                const Opacity(
                  opacity: 0.6,
                  child: ModalBarrier(
                    dismissible: false,
                    color: Colors.black,
                  ),
                ),
              if(_isWorking)
                const Center(
                    child: CircularProgressIndicator()
                ),
            ],
          );
        }
    );
  }
}