import 'package:flutter/material.dart';

import '../../../../classes/caste/base.dart';
import '../../../../classes/character/disadvantages.dart';
import '../../../../classes/human_character.dart';

class DisadvantageSelectWidget extends StatefulWidget {
  const DisadvantageSelectWidget({
    super.key,
    this.includeReservedForCaste,
    this.limitToType,
    this.exclude,
    required this.onSelected,
  });

  final Caste? includeReservedForCaste;
  final DisadvantageType? limitToType;
  final List<Disadvantage>? exclude;
  final void Function(CharacterDisadvantage?) onSelected;

  @override
  State<DisadvantageSelectWidget> createState() => _DisadvantageSelectWidgetState();
}

class _DisadvantageSelectWidgetState extends State<DisadvantageSelectWidget> {
  Disadvantage? selected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if(selected == null)
          Expanded(
            child: DisadvantageSelectionWidget(
              includeReservedForCaste: widget.includeReservedForCaste,
              limitToType: widget.limitToType,
              exclude: widget.exclude,
              onSelected: (Disadvantage d) {
                if(d.cost.length == 1 && !d.requireDetails) {
                  widget.onSelected(
                    CharacterDisadvantage(
                      disadvantage: d,
                      cost: d.cost[0],
                      details: ''
                    )
                  );
                }
                else {
                  setState(() {
                    selected = d;
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
                  child: SelectableDisadvantageViewWidget(
                    disadvantage: selected!,
                    onSelected: () {
                      setState(() {
                        selected = null;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: DisadvantageConfigurationWidget(
                    disadvantage: selected!,
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

class DisadvantageSelectionWidget extends StatefulWidget {
  const DisadvantageSelectionWidget({
    super.key,
    this.includeReservedForCaste,
    this.limitToType,
    this.exclude,
    required this.onSelected,
  });

  final Caste? includeReservedForCaste;
  final DisadvantageType? limitToType;
  final List<Disadvantage>? exclude;
  final void Function(Disadvantage) onSelected;

  @override
  State<DisadvantageSelectionWidget> createState() => _DisadvantageSelectionWidgetState();
}

class _DisadvantageSelectionWidgetState extends State<DisadvantageSelectionWidget> {
  DisadvantageType? currentType;
  List<Disadvantage> disadvantages = <Disadvantage>[];
  Disadvantage? selected;

  @override
  void initState() {
    super.initState();

    currentType = widget.limitToType;
    _updateForCurrentType();
  }

  void _updateForCurrentType() {
    disadvantages.clear();

    if(currentType == null) return;

    disadvantages.addAll(
      Disadvantage.values
        .where(
          (Disadvantage d) =>
            d.type == currentType
            && !(widget.exclude?.contains(d) ?? false)
            && (
              d.reservedCastes.isEmpty
              || widget.includeReservedForCaste == null
              || d.reservedCastes.contains(widget.includeReservedForCaste)
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
              if(widget.limitToType == null)
                DropdownMenuFormField(
                  initialSelection: currentType,
                  label: const Text('Type'),
                  requestFocusOnTap: true,
                  expandedInsets: EdgeInsets.zero,
                  onSelected: (DisadvantageType? t) {
                    if(t == currentType) return;
                    setState(() {
                      currentType = t;
                      selected = null;
                      _updateForCurrentType();
                    });
                  },
                  dropdownMenuEntries: DisadvantageType.values
                    .map(
                      (DisadvantageType t) => DropdownMenuEntry(
                        value: t,
                        label: t.title
                      )
                    )
                    .toList(),
                  validator: (DisadvantageType? t) {
                    if(t == null) return 'Valeur manquante';
                    return null;
                  },
                ),
              Expanded(
                child: ListView.separated(
                  itemCount: disadvantages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(disadvantages[index].title),
                      onTap: () => setState(() {
                        selected = disadvantages[index];
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
        if(selected != null)
          Expanded(
            child: SelectableDisadvantageViewWidget(
              disadvantage: selected!,
              onSelected: () => widget.onSelected(selected!),
            ),
          ),
      ],
    );
  }
}

class SelectableDisadvantageViewWidget extends StatelessWidget {
  const SelectableDisadvantageViewWidget({
    super.key,
    required this.disadvantage,
    this.costs,
    required this.onSelected,
  });

  final Disadvantage disadvantage;
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
                  '${disadvantage.title} (${(costs ?? disadvantage.cost).join("/")})',
                  style: theme.textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  disadvantage.description,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DisadvantageConfigurationWidget extends StatefulWidget {
  const DisadvantageConfigurationWidget({
    super.key,
    required this.disadvantage,
    this.costs,
    required this.onDone,
  });

  final Disadvantage disadvantage;
  final List<int>? costs;
  final void Function(CharacterDisadvantage?) onDone;

  @override
  State<DisadvantageConfigurationWidget> createState() => _DisadvantageConfigurationWidgetState();
}

class _DisadvantageConfigurationWidgetState extends State<DisadvantageConfigurationWidget> {
  TextEditingController detailsController = TextEditingController();
  FocusNode detailsFocusNode = FocusNode();
  GlobalKey detailsAutocompleteKey = GlobalKey();

  late List<int> costs;
  int? cost;
  String? details;
  
  @override
  void initState() {
    super.initState();
    
    costs = widget.costs ?? widget.disadvantage.cost;
    if(costs.length == 1) cost = costs[0];
  }

  bool _canFinish() {
    if(cost == null) return false;
    if(widget.disadvantage.requireDetails && (details == null || details!.isEmpty)) return false;

    return true;
  }

  void _finish() {
    if(!_canFinish()) {
      widget.onDone(null);
      return;
    }

    widget.onDone(
      CharacterDisadvantage(
        disadvantage: widget.disadvantage,
        cost: cost ?? costs[0],
        details: details ?? "",
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Widget? autocompleteWidget;
    var autocompleteOptions = (widget.disadvantage.detailsGenerator?.call() ?? <String>[]);
    if(autocompleteOptions.isNotEmpty) {
      autocompleteWidget = RawAutocomplete<String>(
        textEditingController: detailsController,
        focusNode: detailsFocusNode,
        key: detailsAutocompleteKey,
        onSelected: (String v) {
          details = v;
          _finish();
        },
        optionsBuilder: (TextEditingValue value) {
          if(value.text.isEmpty) {
            return const Iterable<String>.empty();
          }
          return autocompleteOptions
              .where((String w) => w.toLowerCase().contains(value.text.toLowerCase()));
        },
        optionsViewBuilder:
            (
            BuildContext context,
            AutocompleteOnSelected<String> onSelected,
            Iterable<String> options,
            ) {
          return Material(
            elevation: 4.0,
            child: ListView(
              shrinkWrap: true,
              children: options
                  .map(
                    (String option) => GestureDetector(
                  onTap: () {
                    onSelected(option);
                  },
                  child: ListTile(title: Text(option)),
                ),
              )
                  .toList(),
            ),
          );
        },
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.0,
      children: [
        Text(
          'Désavantage : ${widget.disadvantage.title}',
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
        if(widget.disadvantage.requireDetails)
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
                TextField(
                  controller: detailsController,
                  focusNode: detailsFocusNode,
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
                ?autocompleteWidget,
              ],
            ),
          ),
      ],
    );
  }
}