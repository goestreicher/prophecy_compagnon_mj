import 'package:flutter/material.dart';

import '../../../../classes/caste/base.dart';
import '../../../../classes/character/advantages.dart';
import '../../../../classes/human_character.dart';

class AdvantageSelectWidget extends StatefulWidget {
  const AdvantageSelectWidget({
    super.key,
    required this.types,
    this.maxCost,
    this.exclude,
    this.includeReservedForCaste,
    required this.onSelected,
  });

  final List<AdvantageType> types;
  final int? maxCost;
  final List<Advantage>? exclude;
  final Caste? includeReservedForCaste;
  final void Function(CharacterAdvantage?) onSelected;

  @override
  State<AdvantageSelectWidget> createState() => _AdvantageSelectWidgetState();
}

class _AdvantageSelectWidgetState extends State<AdvantageSelectWidget> {
  Advantage? selected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if(selected == null)
          Expanded(
            child: _AdvantageSelectionWidget(
                includeReservedForCaste: widget.includeReservedForCaste,
                types: widget.types,
                maxCost: widget.maxCost,
                exclude: widget.exclude,
                onSelected: (Advantage a) {
                  if(a.cost.length == 1 && !a.requireDetails) {
                    widget.onSelected(
                      CharacterAdvantage(
                        advantage: a,
                        cost: a.cost[0],
                        details: '',
                      )
                    );
                  }
                  else {
                    setState(() {
                      selected = a;
                    });
                  }
                }
            ),
          ),
        if(selected != null)
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12.0,
              children: [
                Expanded(
                  child: _SelectableAdvantageViewWidget(
                    advantage: selected!,
                    onSelected: () {
                      setState(() {
                        selected = null;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: _AdvantageConfigurationWidget(
                    advantage: selected!,
                    costs: selected!.cost
                      .where((int c) => widget.maxCost == null || c <= widget.maxCost!)
                      .toList(),
                    onDone: widget.onSelected,
                  ),
                )
              ],
            ),
          )
      ],
    );
  }
}

class _AdvantageSelectionWidget extends StatefulWidget {
  const _AdvantageSelectionWidget({
    required this.types,
    this.maxCost,
    this.exclude,
    this.includeReservedForCaste,
    required this.onSelected,
  });

  final List<AdvantageType> types;
  final int? maxCost;
  final List<Advantage>? exclude;
  final Caste? includeReservedForCaste;
  final void Function(Advantage) onSelected;

  @override
  State<_AdvantageSelectionWidget> createState() => _AdvantageSelectionWidgetState();
}

class _AdvantageSelectionWidgetState extends State<_AdvantageSelectionWidget> {
  AdvantageType? currentType;
  List<Advantage> advantages = <Advantage>[];
  Advantage? selected;

  @override
  void initState() {
    super.initState();

    currentType = widget.types[0];
    _updateForCurrentType();
  }

  void _updateForCurrentType() {
    advantages.clear();

    if(currentType == null) return;

    advantages.addAll(
      Advantage.values
        .where(
          (Advantage a) =>
            a.type == currentType
            && (widget.maxCost == null || a.cost.any((int c) => c <= widget.maxCost!))
            && !(widget.exclude?.contains(a) ?? false)
            && (
              a.reservedCastes.isEmpty
              || widget.includeReservedForCaste == null
              || a.reservedCastes.contains(widget.includeReservedForCaste)
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12.0,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16.0,
            children: [
              DropdownMenuFormField(
                initialSelection: currentType,
                label: const Text('Type'),
                requestFocusOnTap: true,
                expandedInsets: EdgeInsets.zero,
                onSelected: (AdvantageType? t) {
                  if(t == currentType) return;
                  setState(() {
                    currentType = t;
                    selected = null;
                    _updateForCurrentType();
                  });
                },
                dropdownMenuEntries: AdvantageType.values
                  .map(
                    (AdvantageType t) => DropdownMenuEntry(
                      value: t,
                      label: t.title
                    )
                  )
                  .toList(),
                validator: (AdvantageType? t) {
                  if(t == null) return 'Valeur manquante';
                  return null;
                },
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: advantages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(advantages[index].title),
                      onTap: () => setState(() {
                        selected = advantages[index];
                      }),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => Divider(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: selected == null
            ? SizedBox.shrink()
            : _SelectableAdvantageViewWidget(
                advantage: selected!,
                costs: selected!.cost
                  .where((int c) => widget.maxCost == null || c <= widget.maxCost!)
                  .toList(),
                onSelected: () => widget.onSelected(selected!),
              ),
        ),
      ],
    );
  }
}

class _SelectableAdvantageViewWidget extends StatelessWidget {
  const _SelectableAdvantageViewWidget({
    required this.advantage,
    this.costs,
    required this.onSelected,
  });

  final Advantage advantage;
  final List<int>? costs;
  final void Function() onSelected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => onSelected(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 8.0,
              children: [
                Text(
                  '${advantage.title} (${(costs ?? advantage.cost).join("/")})',
                  style: theme.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  advantage.description,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AdvantageConfigurationWidget extends StatefulWidget {
  const _AdvantageConfigurationWidget({
    required this.advantage,
    this.costs,
    required this.onDone,
  });

  final Advantage advantage;
  final List<int>? costs;
  final void Function(CharacterAdvantage?) onDone;

  @override
  State<_AdvantageConfigurationWidget> createState() => _AdvantageConfigurationWidgetState();
}

class _AdvantageConfigurationWidgetState extends State<_AdvantageConfigurationWidget> {
  late List<int> costs;
  int? cost;
  String? details;

  @override
  void initState() {
    super.initState();

    costs = widget.costs ?? widget.advantage.cost;
    if(costs.length == 1) cost = costs[0];
  }

  bool _canFinish() {
    if(cost == null) return false;
    if(widget.advantage.requireDetails && (details == null || details!.isEmpty)) return false;

    return true;
  }

  void _finish() {
    if(!_canFinish()) {
      widget.onDone(null);
      return;
    }

    widget.onDone(
      CharacterAdvantage(
        advantage: widget.advantage,
        cost: cost ?? costs[0],
        details: details ?? "",
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.0,
      children: [
        Text(
          'Avantage : ${widget.advantage.title}',
          style: theme.textTheme.titleMedium!
            .copyWith(fontWeight: FontWeight.bold),
        ),
        Row(
          spacing: 12.0,
          children: [
            Text(
              'Coût',
              style: theme.textTheme.titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 80,
              child: DropdownMenu<int>(
                initialSelection: cost,
                requestFocusOnTap: true,
                expandedInsets: EdgeInsets.zero,
                textStyle: theme.textTheme.bodySmall,
                inputDecorationTheme: const InputDecorationTheme(
                  border: OutlineInputBorder(),
                  isCollapsed: true,
                  constraints: BoxConstraints(maxHeight: 36.0),
                  contentPadding: EdgeInsets.all(12.0),
                ),
                dropdownMenuEntries: costs
                  .map(
                    (int c) => DropdownMenuEntry(
                      value: c,
                      label: c.toString(),
                    )
                  )
                  .toList(),
                onSelected: (int? v) {
                  setState(() {
                    cost = v;
                    _finish();
                  });
                },
              ),
            )
          ],
        ),
        if(widget.advantage.requireDetails)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8.0,
              children: [
                Text(
                  'Détails',
                  style: theme.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isCollapsed: true,
                      constraints: BoxConstraints(maxHeight: 36.0),
                      contentPadding: EdgeInsets.all(12.0),
                    ),
                    minLines: 1,
                    maxLines: 3,
                    onChanged: (String? v) {
                      setState(() {
                        details = v;
                        _finish();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}