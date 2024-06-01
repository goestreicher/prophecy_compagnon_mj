import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../classes/calendar.dart';

Future<KorDate?> showKorDatePicker({
  required BuildContext context,
  required KorDate initialDate,
}) async {
  return showDialog<KorDate>(
    context: context,
    builder: (BuildContext context) => KorDatePickerDialog(initialDate: initialDate),
  );
}

class KorDatePickerDialog extends StatefulWidget {
  const KorDatePickerDialog({ super.key, required this.initialDate });

  final KorDate initialDate;

  @override
  State<KorDatePickerDialog> createState() => _KorDatePickerDialogState();
}

class _KorDatePickerDialogState extends State<KorDatePickerDialog> {
  late KorDate _selectedDate;
  final TextEditingController _yearController = TextEditingController();
  late KorCycle _displayedCycle;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _displayedCycle = _selectedDate.cycle;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    _yearController.text = _selectedDate.year.toString();

    return Dialog(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: viewportConstraints.maxHeight,
                minWidth: 280.0,
              ),
              child: IntrinsicWidth(
                stepWidth: 24.0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Année',
                            style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 4.0),
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              if(_selectedDate.year < 1) return;
                              setState(() {
                                _selectedDate.year = _selectedDate.year - 1;
                              });
                            },
                          ),
                          SizedBox(
                            width: 48.0,
                            child: TextFormField(
                              controller: _yearController,
                              key: GlobalKey<FormFieldState>(),
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (String? value) {
                                if(value == null || value.isEmpty) return 'Valeur manquante';
                                int? input = int.tryParse(value);
                                if(input == null) return 'Pas un nombre';
                                if(input < 0) return 'Nombre >= 0';
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              onChanged: (String? value) {
                                if(value == null || value.isEmpty) return;
                                int? input = int.tryParse(value);
                                if(input == null) return;
                                _selectedDate.year = input;
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                _selectedDate.year = _selectedDate.year + 1;
                              });
                            },
                          ),
                          const SizedBox(width: 4.0),
                          DropdownMenu(
                            initialSelection: _selectedDate.age,
                            textStyle: theme.textTheme.bodyMedium,
                            onSelected: (KorAge? age) {
                              if(age == null) return;
                              setState(() {
                                _selectedDate.age = age;
                              });
                            },
                            dropdownMenuEntries:
                              KorAge.values
                                .map((KorAge a) => DropdownMenuEntry(
                                  value: a,
                                  label: a.shortTitle,
                                  style: MenuItemButton.styleFrom(
                                      textStyle: theme.textTheme.bodyMedium
                                  )))
                                .toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Cycle',
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(width: 8.0),
                          SegmentedButton<KorCycle>(
                            selected: <KorCycle>{_displayedCycle},
                            showSelectedIcon: false,
                            segments:
                              KorCycle.values
                                .map((KorCycle c) => ButtonSegment<KorCycle>(value: c, label: Text(c.shortTitle, style: theme.textTheme.bodySmall)))
                                .toList(),
                            onSelectionChanged: (Set<KorCycle> selection) {
                              setState(() {
                                _displayedCycle = selection.first;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      _KorDatePickerCycle(
                        cycle: _displayedCycle,
                        selected: _selectedDate,
                        onDaySelected: (KorDate newDate) => setState(() { _selectedDate = newDate; }),
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
                                onPressed: () {
                                  Navigator.of(context).pop(_selectedDate);
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
                  ),
                ),
              ),
            ),
          );
        }
      )
    );
  }
}

class _KorDatePickerCycle extends StatelessWidget {
  const _KorDatePickerCycle({
    required this.cycle,
    required this.selected,
    required this.onDaySelected,
  });

  final KorCycle cycle;
  final KorDate selected;
  final void Function(KorDate) onDaySelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _KorDatePickerWeekRow(cycle: cycle, week: 1, selected: selected, onDaySelected: onDaySelected),
        _KorDatePickerWeekRow(cycle: cycle, week: 2, selected: selected, onDaySelected: onDaySelected),
        _KorDatePickerWeekRow(cycle: cycle, week: 3, selected: selected, onDaySelected: onDaySelected),
        _KorDatePickerWeekRow(cycle: cycle, week: 4, selected: selected, onDaySelected: onDaySelected),
        _KorDatePickerWeekRow(cycle: cycle, week: 5, selected: selected, onDaySelected: onDaySelected),
        _KorDatePickerWeekRow(cycle: cycle, week: 6, selected: selected, onDaySelected: onDaySelected),
        _KorDatePickerWeekRow(cycle: cycle, week: 7, selected: selected, onDaySelected: onDaySelected),
        _KorDatePickerWeekRow(cycle: cycle, week: 8, selected: selected, onDaySelected: onDaySelected),
        _KorDatePickerWeekRow(cycle: cycle, week: 9, selected: selected, onDaySelected: onDaySelected),
      ],
    );
  }
}

class _KorDatePickerWeekRow extends StatelessWidget {
  const _KorDatePickerWeekRow({
    required this.cycle,
    required this.week,
    required this.selected,
    required this.onDaySelected,
  });

  final KorCycle cycle;
  final int week;
  final KorDate selected;
  final void Function(KorDate) onDaySelected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Sem. $week', style: theme.textTheme.bodySmall),
          const VerticalDivider(width: 12.0, thickness: 1.0, color: Colors.black54, indent: 0.0, endIndent: 0.0),
          for(var d in WeekDay.values)
            _KorDatePickerDayWidget(cycle: cycle, week: week, day: d, selected: selected, onDaySelected: onDaySelected),
        ],
      ),
    );
  }
}

class _KorDatePickerDayWidget extends StatelessWidget {
  const _KorDatePickerDayWidget({
    required this.cycle,
    required this.week,
    required this.day,
    required this.selected,
    required this.onDaySelected,
  });
  
  final KorCycle cycle;
  final int week;
  final WeekDay day;
  final KorDate selected;
  final void Function(KorDate) onDaySelected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var defaultDayStyle = TextButton.styleFrom(
      minimumSize: Size.zero,
      padding: const EdgeInsets.all(16.0),
      foregroundColor: theme.colorScheme.onBackground,
    );

    var selectedDayStyle = TextButton.styleFrom(
      minimumSize: Size.zero,
      padding: const EdgeInsets.all(16.0),
      foregroundColor: theme.colorScheme.onPrimary,
      backgroundColor: theme.colorScheme.primary,
    );

    var augure = getAugureForDate(KorDate(year: selected.year, cycle: cycle, week: week, day: day));

    return Container(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
              width: 2.0,
              color: augure.color,
            )
        ),
      ),
      child: Tooltip(
        message: '${day.title} / Augure: ${augure.title}',
        child: TextButton(
          style: (selected.cycle == cycle && selected.week == week && selected.day == day)
              ? selectedDayStyle
              : defaultDayStyle,
          onPressed: () {
            var newDate = KorDate(year: selected.year, cycle: cycle, week: week, day: day);
            onDaySelected(newDate);
          },
          child: Text((day.index+1).toString()),
        ),
      ),
    );
  }
}