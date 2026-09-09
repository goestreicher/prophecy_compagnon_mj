import 'package:flutter/material.dart';
import 'package:prophecy_compagnon_shared/classes/calendar.dart';
import 'package:prophecy_compagnon_shared/classes/scenario/scenario.dart';
import 'package:prophecy_compagnon_shared/classes/session/game_session.dart';
import 'package:prophecy_compagnon_shared/classes/table.dart';
import 'package:prophecy_compagnon_shared/ui/kor_date_picker_dialog.dart';

class SessionCreationDialog extends StatefulWidget {
  const SessionCreationDialog({ super.key });

  @override
  State<SessionCreationDialog> createState() => _SessionCreationDialogState();
}

class _SessionCreationDialogState extends State<SessionCreationDialog> {
  late Future<dynamic> buildFuture;
  GameTableSummary? table;
  final TextEditingController tableController = TextEditingController();
  ScenarioSummary? scenario;
  final TextEditingController scenarioController = TextEditingController();
  List<GameTableSummary> tables = <GameTableSummary>[];
  List<ScenarioSummary> scenarios = <ScenarioSummary>[];
  KorDate? startDate;
  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    buildFuture = Future.wait([
      GameTableSummaryStore().getAll(),
      ScenarioSummaryStore().getAll(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return FutureBuilder(
      future: buildFuture,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        Widget dialogContent;

        if (snapshot.connectionState == ConnectionState.waiting) {
          dialogContent = const CircularProgressIndicator();
        }
        else if(!snapshot.hasData) {
          dialogContent = const Center(child: Text('Erreur en chargeant les données de session'));
        }
        else {
          tables = snapshot.data![0];
          scenarios = snapshot.data[1];

          dialogContent = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownMenu(
                controller: tableController,
                label: const Text('Table'),
                expandedInsets: EdgeInsets.zero,
                onSelected: (GameTableSummary? t) async {
                  table = t;
                },
                dropdownMenuEntries:
                  tables
                    .map((GameTableSummary t) => DropdownMenuEntry(value: t, label: t.name))
                    .toList(),
              ),
              const SizedBox(height: 12.0),
              DropdownMenu(
                controller: scenarioController,
                label: const Text('Scénario'),
                expandedInsets: EdgeInsets.zero,
                onSelected: (ScenarioSummary? s) {
                  scenario = s;
                },
                dropdownMenuEntries:
                  scenarios
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
                      controller: dateController,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  IconButton(
                    icon: const Icon(Icons.edit_calendar),
                    onPressed: () async {
                      var date = await showKorDatePicker(
                        context: context,
                        initialDate: startDate ?? KorDate(year: 1299, cycle: KorCycle.blanc, week: 1, day: WeekDay.roc),
                      );
                      if(date == null) return;
                      startDate = date;
                      dateController.text = startDate!.toCompactString();
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
                          if(table == null) return;
                          if(scenario == null) return;
                          if(startDate == null) return;

                          var t = await GameTableStore().get(table!.uuid);
                          var s = await ScenarioStore().get(scenario!.uuid);

                          var session = GameSession(
                              table: t!,
                              scenario: s!,
                              startDate: startDate!,
                          );

                          if(!context.mounted) return;
                          Navigator.of(context, rootNavigator: true).pop(session);
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
