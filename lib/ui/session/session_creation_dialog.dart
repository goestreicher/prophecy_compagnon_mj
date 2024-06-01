import 'package:flutter/material.dart';

import '../../classes/calendar.dart';
import '../../classes/game_session.dart';
import '../../classes/scenario.dart';
import '../../classes/table.dart';
import '../utils/kor_date_picker_dialog.dart';

class SessionCreationDialog extends StatefulWidget {
  const SessionCreationDialog({ super.key });

  @override
  State<SessionCreationDialog> createState() => _SessionCreationDialogState();
}

class _SessionCreationDialogState extends State<SessionCreationDialog> {
  late Future<dynamic> _buildFuture;
  GameTableSummary? _table;
  final TextEditingController _tableController = TextEditingController();
  ScenarioSummary? _scenario;
  final TextEditingController _scenarioController = TextEditingController();
  List<GameTableSummary> _tables = <GameTableSummary>[];
  List<ScenarioSummary> _scenarios = <ScenarioSummary>[];
  KorDate? _startDate;
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _buildFuture = Future.wait([
      getGameTableSummaries(),
      getScenarioSummaries(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return FutureBuilder(
      future: _buildFuture,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        Widget dialogContent;

        if (snapshot.connectionState == ConnectionState.waiting) {
          dialogContent = const CircularProgressIndicator();
        }
        else if(!snapshot.hasData) {
          dialogContent = const Center(child: Text('Erreur en chargeant les données de session'));
        }
        else {
          _tables = snapshot.data![0];
          _scenarios = snapshot.data[1];

          dialogContent = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownMenu(
                controller: _tableController,
                label: const Text('Table'),
                expandedInsets: EdgeInsets.zero,
                onSelected: (GameTableSummary? t) async {
                  _table = t;
                },
                dropdownMenuEntries:
                  _tables
                    .map((GameTableSummary t) => DropdownMenuEntry(value: t, label: t.name))
                    .toList(),
              ),
              const SizedBox(height: 12.0),
              DropdownMenu(
                controller: _scenarioController,
                label: const Text('Scénario'),
                expandedInsets: EdgeInsets.zero,
                onSelected: (ScenarioSummary? s) {
                  _scenario = s;
                },
                dropdownMenuEntries:
                  _scenarios
                    .map((ScenarioSummary s) => DropdownMenuEntry(value: s, label: s.name))
                    .toList(),
              ),
              const SizedBox(height: 12.0),
              Row(
                children: [
                  const Text('Début'),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: TextFormField(
                      key: GlobalKey<FormFieldState>(),
                      controller: _dateController,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  IconButton(
                    icon: const Icon(Icons.edit_calendar),
                    onPressed: () async {
                      var date = await showKorDatePicker(
                        context: context,
                        initialDate: _startDate ?? KorDate(year: 1299, cycle: KorCycle.blanc, week: 1, day: WeekDay.roc),
                      );
                      if(date == null) return;
                      _startDate = date;
                      _dateController.text = _startDate!.toCompactString();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Annuler'),
                      ),
                      const SizedBox(width: 12.0),
                      ElevatedButton(
                        onPressed: () async {
                          if(_table == null) return;
                          if(_scenario == null) return;
                          if(_startDate == null) return;

                          var session = GameSession(
                              table: _table!,
                              scenario: _scenario!,
                              startDate: _startDate!,
                          );

                          Navigator.of(context).pop(session);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                        ),
                        child: const Text('OK'),
                      )
                    ],
                  )
              ),
            ],
          );
        }

        return AlertDialog(
            title: const Text('Nouvelle session'),
            content: dialogContent,
        );
      }
    );
  }
}
