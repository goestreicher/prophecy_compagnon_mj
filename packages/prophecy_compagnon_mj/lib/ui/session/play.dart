import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prophecy_compagnon_mj/ui/session/play_board_tab.dart';
import 'package:prophecy_compagnon_mj/ui/session/play_characters_tab.dart';
import 'package:prophecy_compagnon_mj/ui/session/play_events_tab.dart';
import 'package:prophecy_compagnon_mj/ui/session/session_connection_widget.dart';
import 'package:prophecy_compagnon_shared/classes/calendar.dart';
import 'package:prophecy_compagnon_shared/classes/session/event.dart';
import 'package:prophecy_compagnon_shared/classes/session/game_session.dart';
import 'package:prophecy_compagnon_shared/ui/error_feedback.dart';
import 'package:prophecy_compagnon_shared/ui/full_page_loading.dart';
import 'package:prophecy_compagnon_shared/ui/session/clients/session_message_bus_client.dart';
import 'package:prophecy_compagnon_shared/ui/session/clients/session_message_bus_local_client.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/set_state/datetime.dart';
import 'package:provider/provider.dart';

class SessionPlayPage extends StatefulWidget {
  const SessionPlayPage({
    super.key,
    required this.uuid,
  });

  final String uuid;

  @override
  State<SessionPlayPage> createState() => _SessionPlayPageState();
}

class _SessionPlayPageState extends State<SessionPlayPage> with SingleTickerProviderStateMixin {
  bool isWorking = false;
  late Future<void> connectionFuture;
  late SessionMessageBusClient sessionMessageBusClient;
  GameSession? gameSession;

  @override
  void initState() {
    super.initState();

    sessionMessageBusClient = SessionCommandBusLocalClient(
      sessionUuid: widget.uuid,
    );
    connectionFuture = loadGameSession();
  }

  Future<void> loadGameSession() async {
    gameSession = await sessionMessageBusClient.connect();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: connectionFuture,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return FullPageLoadingWidget();
          }

          if(snapshot.hasError) {
            return FullPageErrorWidget(
              message: 'Échec de chargement de la session : ${snapshot.error}\n${snapshot.stackTrace}',
              canPop: true,
            );
          }

          if(gameSession == null) {
            return FullPageErrorWidget(
              message: 'Aucune donnée retournée pour cette session',
              canPop: true,
            );
          }

          return MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: gameSession!),
            ],
            child: DefaultTabController(
              length: 3,
              child: Stack(
                children: [
                  Scaffold(
                    appBar: AppBar(
                      leading: SessionConnectionWidget(
                        client: sessionMessageBusClient,
                      ),
                      title: _PlayPageTitle(
                        sessionCommandBusClient: sessionMessageBusClient,
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.check),
                          tooltip: 'Terminer la session',
                          onPressed: () async {
                            setState(() {
                              isWorking = true;
                            });
                            await GameSessionStore().save(gameSession!);
                            setState(() {
                              isWorking = false;
                            });
                            if(!context.mounted) return;
                            context.go('/sessions');
                          },
                        ),
                      ],
                      bottom: TabBar(
                        tabs: [
                          Tab(text: 'Événements'),
                          Tab(text: 'Plateau'),
                          Tab(text: 'Personnages'),
                        ],
                      ),
                    ),
                    body: TabBarView(
                      children: [
                        const PlayEventsPage(),
                        const PlayBoardTab(),
                        const PlayCharactersPage(),
                      ],
                    ),
                  ),
                  if(isWorking)
                    const Opacity(
                      opacity: 0.6,
                      child: ModalBarrier(
                        dismissible: false,
                        color: Colors.black,
                      ),
                    ),
                  if(isWorking)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          );
        }
    );
  }
}

class _PlayPageTitle extends StatelessWidget {
  const _PlayPageTitle({ required this.sessionCommandBusClient });

  final SessionMessageBusClient sessionCommandBusClient;

  Future<bool> _prepareDayChange(GameSession session, BuildContext context) async {
    var dayRanges = session.sessionDays.rangesForDay(session.day)
        .where((DayRange r) => r.end == session.day);

    var unrealized = <DayRange, List<SessionEvent>>{};
    for(var r in dayRanges) {
      var unrealizedEvents = session.sessionDays.unrealized(r);
      if(unrealizedEvents.isNotEmpty) {
        unrealized[r] = unrealizedEvents;
      }
    }

    if(unrealized.isNotEmpty) {
      var action = await showDialog<_DayEndAction>(
        context: context,
        builder: (BuildContext context) =>
            _DayEndActionDialog(),
      );
      if(action == null) return false;
      if(!context.mounted) return false;

      if(action == _DayEndAction.markAllAsRealized) {
        for(var originalRange in unrealized.keys) {
          for(var event in unrealized[originalRange]!) {
            DayRange realizationRange;
            if(event.isRealizedInASingleDay) {
              realizationRange = DayRange(
                  start: session.day,
                  end: session.day
              );
            }
            else {
              realizationRange = originalRange;
            }

            session.sessionDays.markEventAsRealized(
              originalRange,
              event.uuid,
              realizationRange,
            );
          }
        }
      }
      else if(action == _DayEndAction.offsetUnrealized) {
        // TODO
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    var session = context.watch<GameSession>();

    return Row(
      spacing: 8.0,
      children: [
        Text(
            '${session.scenario.name} / '
            'Jour ${session.day+1} '
            '(${session.currentDate.toString()}) / '
            '${session.hour}h',
        ),
        IconButton.outlined(
          onPressed: () async {
            if(session.hour == 23) {
              if(!(await _prepareDayChange(session, context))) {
                return;
              }
            }
            sessionCommandBusClient.publish(
              SessionSetStateNextHour()
            );
          },
          icon: Icon(Icons.keyboard_arrow_right),
          tooltip: "Avancer d'une heure",
          iconSize: 20.0,
          padding: const EdgeInsets.all(4.0),
          constraints: const BoxConstraints(),
        ),
        IconButton.outlined(
          onPressed: () async {
            if(!(await _prepareDayChange(session, context))) {
              return;
            }
            sessionCommandBusClient.publish(
              SessionSetStateNextDay()
            );
          },
          icon: Icon(Icons.keyboard_double_arrow_right),
          tooltip: 'Terminer cette journée',
          iconSize: 20.0,
          padding: const EdgeInsets.all(4.0),
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}

enum _DayEndAction {
  markAllAsRealized,
  offsetUnrealized,
}

class _DayEndActionDialog extends StatelessWidget {
  const _DayEndActionDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Fin de journée"),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16.0,
          children: [
            const Text(
              "Certains événements ne sont pas réalisés. Quelle action entreprendre "
              "pour ces événements ?"
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(_DayEndAction.markAllAsRealized);
              },
              child: Center(child: const Text("Marquer tous les événements réalisés")),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(_DayEndAction.offsetUnrealized);
              },
              child: Center(child: const Text("Décaler les événements au jour suivant")),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text('Annuler'),
        ),
      ]
    );
  }
}