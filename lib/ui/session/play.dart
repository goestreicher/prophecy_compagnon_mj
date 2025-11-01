import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../classes/place_map.dart';
import 'command_dispatcher.dart';
import 'map_model.dart';
import 'play_events_tab.dart';
import 'play_map_tab.dart';
import 'session_model.dart';
import '../utils/place_map_picker_dialog.dart';

class SessionPlayPage extends StatefulWidget {
  const SessionPlayPage({ super.key });

  @override
  State<SessionPlayPage> createState() => _SessionPlayPageState();
}

class _SessionPlayPageState extends State<SessionPlayPage> {
  bool _isWorking = false;

  @override
  Widget build(BuildContext context) {
    var dispatcher = context.read<CommandDispatcher>();
    var session = context.watch<SessionModel>();

    Widget mapPage;
    if(session.map == null) {
      mapPage = Center(
          child: ElevatedButton(
            onPressed: () async {
              var background = await showDialog<PlaceMap>(
                context: context,
                builder: (BuildContext context) => const PlaceMapPickerDialog(),
              );

              if(background == null) return;

              dispatcher.dispatchCommand(
                  SessionCommand.mapPush,
                  <String, dynamic>{ 'map': MapModel(background: background) },
              );
            },
            child: const Text('Sélectionner un fichier'),
          )
      );
    }
    else {
      mapPage = MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: dispatcher),
          ChangeNotifierProvider.value(value: session),
        ],
        child: const PlayMapPage(),
      );
    }

    var pageTitle = '${session.scenario.name} (jour ${session.session.scenarioDay})';
    if(session.encounter != null) {
      pageTitle += ' / Rencontre: ${session.encounter!.name}';
    }

    return Stack(
      children: [
        DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text(pageTitle),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Carte'),
                  Tab(text: 'Événements'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                mapPage,
                MultiProvider(
                  providers: [
                    ChangeNotifierProvider.value(value: dispatcher),
                    ChangeNotifierProvider.value(value: session),
                  ],
                  child: const PlayEventsPage(),
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
            ),
          ),
        if(_isWorking)
          const Center(
              child: CircularProgressIndicator()
          ),
      ],
    );
  }
}