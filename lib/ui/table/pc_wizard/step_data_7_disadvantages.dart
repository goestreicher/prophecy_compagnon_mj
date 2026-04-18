import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../classes/character/disadvantages.dart';
import '../../../classes/human_character.dart';
import '../../utils/character/background/disadvantage_select_widget.dart';
import 'enums.dart';
import 'model.dart';
import 'step_data.dart';

class PlayerCharacterWizardStepDataDisadvantages extends PlayerCharacterWizardStepData {
  PlayerCharacterWizardStepDataDisadvantages({
    List<CharacterDisadvantage>? mandatory,
    List<CharacterDisadvantage>? additional,
  })
    : mandatory = mandatory ?? <CharacterDisadvantage>[],
      currentMandatory = mandatory ?? <CharacterDisadvantage>[],
      additional = additional ?? <CharacterDisadvantage>[],
      currentAdditional = additional ?? <CharacterDisadvantage>[],
      super(title: 'Désavantages');

  List<CharacterDisadvantage> mandatory;
  List<CharacterDisadvantage> currentMandatory;
  List<CharacterDisadvantage> additional;
  List<CharacterDisadvantage> currentAdditional;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget overviewWidget(BuildContext context) {
    var theme = Theme.of(context);
    var model = context.read<PlayerCharacterWizardModel>();

    var mandatoryWidgets = <Widget>[];
    for(var d in (model.mandatoryDisadvantages ?? <CharacterDisadvantage>[])) {
      mandatoryWidgets.add(
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${d.disadvantage.title} (${d.cost})',
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
              if(d.details.isNotEmpty)
                Text(
                  d.details,
                ),
            ],
          ),
        )
      );
    }

    var additionalWidgets = <Widget>[];
    for(var d in (model.additionalDisadvantages ?? <CharacterDisadvantage>[])) {
      additionalWidgets.add(
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${d.disadvantage.title} (${d.cost})',
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
              if(d.details.isNotEmpty)
                Text(
                  d.details,
                ),
            ],
          ),
        )
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.0,
      children: [
        if(mandatoryWidgets.isNotEmpty)
          Text(
            'Obligatoires',
            style: theme.textTheme.titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
          ),
        ...mandatoryWidgets,
        if(additionalWidgets.isNotEmpty)
          Text(
            'Additionnels',
            style: theme.textTheme.titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
          ),
        ...additionalWidgets,
      ],
    );
  }

  @override
  List<Widget> stepWidget(BuildContext context) {
    return [sliverWrap([Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 32.0,
        children: [
          Text(
            "Le joueur doit maintenant définir les Avantages et les Désavantages de son personnage. Ces petits détails auront une influence variable sur son comportement, son caractère, ses connaissances et ses chances de réussite. En définitive, tout ce qui peut le rendre différent d’un autre (un secret douloureux, ume aptitude particulière, un objet enchanté ou un ennemi juré) peut être considéré comme un Avantage ou un Désavantage.\nSeuls les Avantages pourront être “achetés” par les joueurs. Ils vont en effet commencer par déterminer aléatoirement un certain nombre de Désavantages qui seront assortis d’un gain de Points d’Avantage. Une fois tous les Désavantages définis, ces points permettront aux joueurs d'acheter les Avantages de leur choix en piochant dans les différentes listes qui leur sont proposées."
          ),
          _DisadvantagesWidget(
            mandatory: currentMandatory,
            onMandatoryUpdated: (List<CharacterDisadvantage> l) {
              currentMandatory = l;
              changed = _checkChanged();
            },
            additional: currentAdditional,
            onAdditionalUpdated: (List<CharacterDisadvantage> l) {
              currentAdditional = l;
              changed = _checkChanged();
            },
          ),
        ],
      ),
    )])];
  }

  bool _checkChanged() =>
      currentMandatory != mandatory
      || currentAdditional != additional;

  @override
  bool validate(PlayerCharacterWizardModel model, BuildContext context) => formKey.currentState!.validate();

  @override
  void init(PlayerCharacterWizardModel model) {
  }

  @override
  void reset(PlayerCharacterWizardModel model) {
    currentMandatory = mandatory = <CharacterDisadvantage>[];
    model.mandatoryDisadvantages = null;

    currentAdditional = additional = <CharacterDisadvantage>[];
    model.additionalDisadvantages = null;
  }

  @override
  void clear() {
    currentMandatory = List.from(mandatory);
    currentAdditional = List.from(additional);
  }

  @override
  void save(PlayerCharacterWizardModel model) {
    mandatory = currentMandatory;
    model.mandatoryDisadvantages = mandatory;
    currentMandatory = List.from(mandatory);

    additional = currentAdditional;
    model.additionalDisadvantages = additional;
    currentAdditional = List.from(additional);
  }
}

class _DisadvantagesWidget extends StatefulWidget {
  const _DisadvantagesWidget({
    required this.mandatory,
    required this.onMandatoryUpdated,
    required this.additional,
    required this.onAdditionalUpdated,
  });

  final List<CharacterDisadvantage> mandatory;
  final void Function(List<CharacterDisadvantage>) onMandatoryUpdated;
  final List<CharacterDisadvantage> additional;
  final void Function(List<CharacterDisadvantage>) onAdditionalUpdated;

  @override
  State<_DisadvantagesWidget> createState() => _DisadvantagesWidgetState();
}

class _DisadvantagesWidgetState extends State<_DisadvantagesWidget> {
  late List<CharacterDisadvantage> currentMandatory;
  late List<CharacterDisadvantage> currentAdditional;
  Set<Disadvantage> uniqueDisadvantages = <Disadvantage>{};

  @override
  void initState() {
    super.initState();

    currentMandatory = List.from(widget.mandatory);
    currentAdditional = List.from(widget.additional);
    updateUniqueDisadvantages();
  }

  void updateUniqueDisadvantages() {
    uniqueDisadvantages.clear();
    for(var d in [...currentMandatory, ...currentAdditional]) {
      if(d.disadvantage.unique) {
        uniqueDisadvantages.add(d.disadvantage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 32.0,
      children: [
        _MandatoryDisadvantagesWidget(
          disadvantages: widget.mandatory,
          exclude: uniqueDisadvantages.toList(),
          onUpdated: (List<CharacterDisadvantage> l) {
            widget.onMandatoryUpdated(l);
            currentMandatory = l;
            setState(() {
              updateUniqueDisadvantages();
            });
          },
        ),
        _AdditionalDisadvantagesWidget(
          disadvantages: widget.additional,
          exclude: uniqueDisadvantages.toList(),
          onUpdated: (List<CharacterDisadvantage> l) {
            widget.onAdditionalUpdated(l);
            currentAdditional = l;
            setState(() {
              updateUniqueDisadvantages();
            });
          },
        )
      ],
    );
  }
}

class _MandatoryDisadvantagesWidget extends StatelessWidget {
  const _MandatoryDisadvantagesWidget({
    required this.disadvantages,
    required this.exclude,
    required this.onUpdated,
  });

  final List<CharacterDisadvantage> disadvantages;
  final List<Disadvantage> exclude;
  final void Function(List<CharacterDisadvantage>) onUpdated;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var model = context.read<PlayerCharacterWizardModel>();
    var mandatory = _disadvantagesPerAge[model.age!]![_DisadvantageSelectionType.mandatory]!;

    var mandatoryWidgets = <Widget>[];
    for(var type in mandatory.keys) {
      mandatoryWidgets.add(
        _DisadvantageTypeSelectionFormField(
          selectionType: _DisadvantageSelectionType.mandatory,
          type: type,
          count: mandatory[type]!,
          disadvantages: disadvantages
            .where((CharacterDisadvantage d) => d.disadvantage.type == type)
            .toList(),
          exclude: exclude,
          onUpdated: (List<CharacterDisadvantage> l) {
            var updated = l;
            for(var d in disadvantages) {
              if(d.disadvantage.type != type) {
                updated.add(d);
              }
            }
            onUpdated(updated);
          },
          validator: (int? v) {
            if(v == null || v != mandatory[type]!) return 'Désavantages manquants';
            return null;
          },
        )
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.0,
      children: [
        Text(
          "Désavantages obligatoires",
          style: theme.textTheme.headlineMedium!
            .copyWith(fontWeight: FontWeight.bold),
        ),
        ...mandatoryWidgets,
      ],
    );
  }
}

class _AdditionalDisadvantagesWidget extends StatefulWidget {
  const _AdditionalDisadvantagesWidget({
    required this.disadvantages,
    required this.exclude,
    required this.onUpdated,
  });

  final List<CharacterDisadvantage> disadvantages;
  final List<Disadvantage> exclude;
  final void Function(List<CharacterDisadvantage>) onUpdated;

  @override
  State<_AdditionalDisadvantagesWidget> createState() => _AdditionalDisadvantagesWidgetState();
}

class _AdditionalDisadvantagesWidgetState extends State<_AdditionalDisadvantagesWidget> {
  Map<DisadvantageType, List<CharacterDisadvantage>> current = <DisadvantageType, List<CharacterDisadvantage>>{};

  @override
  void initState() {
    super.initState();

    for(var t in DisadvantageType.values) {
      current[t] = <CharacterDisadvantage>[];
    }

    for(var v in widget.disadvantages) {
      current[v.disadvantage.type]!.add(v);
    }
  }

  void mergeAndNotify() {
    var l = <CharacterDisadvantage>[];
    for(var v in current.values) {
      l.addAll(v);
    }
    widget.onUpdated(l);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var model = context.read<PlayerCharacterWizardModel>();
    var additional = _disadvantagesPerAge[model.age!]![_DisadvantageSelectionType.additional]!;

    var additionalWidgets = <Widget>[];
    for(var type in additional.keys) {
      additionalWidgets.add(
        _DisadvantageTypeSelectionWidget(
          selectionType: _DisadvantageSelectionType.additional,
          type: type,
          count: additional[type]!,
          disadvantages: current[type]!,
          exclude: widget.exclude,
          onUpdated: (List<CharacterDisadvantage> l) {
            setState(() {
              current[type] = l;
            });
            mergeAndNotify();
          }
        )
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.0,
      children: [
        Text(
          "Désavantages additionnels",
          style: theme.textTheme.headlineMedium!
            .copyWith(fontWeight: FontWeight.bold),
        ),
        ...additionalWidgets,
      ],
    );
  }
}

class _DisadvantageTypeSelectionFormField extends FormField<int> {
  _DisadvantageTypeSelectionFormField({
    required _DisadvantageSelectionType selectionType,
    required DisadvantageType type,
    required int count,
    required List<CharacterDisadvantage> disadvantages,
    required List<Disadvantage> exclude,
    required void Function(List<CharacterDisadvantage>) onUpdated,
    super.validator,
  })
    : super(
        initialValue: disadvantages.length,
        builder: (FormFieldState<int> state) {
          Widget ret = _DisadvantageTypeSelectionWidget(
            selectionType: selectionType,
            type: type,
            count: count,
            disadvantages: disadvantages,
            exclude: exclude,
            onUpdated: (List<CharacterDisadvantage> l) {
              state.didChange(l.length);
              onUpdated(l);
            }
          );

          if(state.hasError) {
            ret = Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ret,
              ),
            );
          }

          return ret;
        }
      );
}

class _DisadvantageTypeSelectionWidget extends StatefulWidget {
  const _DisadvantageTypeSelectionWidget({
    required this.selectionType,
    required this.type,
    required this.count,
    required this.disadvantages,
    required this.exclude,
    required this.onUpdated,
  });

  final _DisadvantageSelectionType selectionType;
  final DisadvantageType type;
  final int count;
  final List<CharacterDisadvantage> disadvantages;
  final List<Disadvantage> exclude;
  final void Function(List<CharacterDisadvantage>) onUpdated;

  @override
  State<_DisadvantageTypeSelectionWidget> createState() => _DisadvantageTypeSelectionWidgetState();
}

class _DisadvantageTypeSelectionWidgetState extends State<_DisadvantageTypeSelectionWidget> {
  late List<CharacterDisadvantage> selected;

  @override
  void initState() {
    super.initState();

    selected = List.from(widget.disadvantages);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12.0,
      children: [
        Text(
          widget.type.title,
          style: theme.textTheme.headlineSmall!
            .copyWith(fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            spacing: 12.0,
            children: [
              for(var d in selected)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      spacing: 8.0,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 150,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${d.disadvantage.title} (${d.cost.toString()})',
                                style: theme.textTheme.bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                              ),
                              if(d.details.isNotEmpty)
                                Text(
                                  d.details,
                                ),
                            ],
                          ),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selected.remove(d);
                              });
                              widget.onUpdated(selected);
                            },
                            child: Icon(
                              Icons.cancel,
                              size: 18.0,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              if(selected.length < widget.count)
                IconButton.filled(
                  onPressed: () async {
                    var d = await showDialog<CharacterDisadvantage>(
                      context: context,
                      builder: (BuildContext context) =>
                        _DisadvantageSelectionDialog(
                          type: widget.type,
                          isAdditional: widget.selectionType == _DisadvantageSelectionType.additional,
                          exclude: widget.exclude,
                        ),
                    );
                    if(d == null) return;
                    if(!context.mounted) return;

                    setState(() {
                      selected.add(d);
                    });
                    widget.onUpdated(selected);
                  },
                  iconSize: 18.0,
                  padding: const EdgeInsets.all(8.0),
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.add),
                ),
            ],
          ),
        )
      ],
    );
  }
}

class _DisadvantageSelectionDialog extends StatefulWidget {
  const _DisadvantageSelectionDialog({
    required this.type,
    this.isAdditional = false,
    required this.exclude,
  });

  final DisadvantageType type;
  final bool isAdditional;
  final List<Disadvantage> exclude;

  @override
  State<_DisadvantageSelectionDialog> createState() => _DisadvantageSelectionDialogState();
}

class _DisadvantageSelectionDialogState extends State<_DisadvantageSelectionDialog> {
  bool niceDM = false;
  late _RandomDisadvantageEntry first;
  _RandomDisadvantageEntry? second;
  Disadvantage? disadvantage;
  List<int> costs = <int>[];
  int? cost;
  String? details;
  CharacterDisadvantage? selected;

  @override
  void initState() {
    super.initState();

    first = _getRandomDisadvantage();
    while(widget.exclude.contains(first.disadvantage)) {
      first = _getRandomDisadvantage();
    }

    if(!widget.isAdditional) {
      second = _getRandomDisadvantage();
      while(
          second!.disadvantage == first.disadvantage
          || widget.exclude.contains(second!.disadvantage)
      ) {
        second = _getRandomDisadvantage();
      }
    }
  }

  _RandomDisadvantageEntry _getRandomDisadvantage() {
    var rand = Random().nextInt(10) + 1;
    if(widget.type == DisadvantageType.commun || widget.type == DisadvantageType.rare) {
      rand += Random().nextInt(10) + 1;
    }
    return _randomDisadvantagesTable[widget.type]![rand]!;
  }

  bool _canFinish() {
    if(disadvantage == null) return false;
    if(costs.isEmpty) return false;
    if(cost == null && costs.length > 1) return false;
    if(disadvantage!.requireDetails && details == null) return false;

    return true;
  }

  void _prepareFinish() {
    if(!_canFinish()) return;

    selected = CharacterDisadvantage(
      disadvantage: disadvantage!,
      cost: cost ?? costs[0],
      details: details ?? "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Choix du désavantage"),
      content: SizedBox(
        width: 800,
        height: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(disadvantage == null)
              Row(
                children: [
                  Checkbox(
                    value: niceDM,
                    onChanged: (bool? v) => setState(() {
                      niceDM = v!;
                    }),
                  ),
                  GestureDetector(
                    onTap: () => setState(() {
                      niceDM = !niceDM;
                    }),
                    child: Text(
                      "Mon MJ est sympa et me laisse choisir mes Désavantages"
                    ),
                  )
                ],
              ),
            if(disadvantage == null && !niceDM)
              Expanded(
                child: _DisadvantageRandomSelectionWidget(
                  first: first,
                  second: second,
                  onSelected: (_RandomDisadvantageEntry d) => setState(() {
                    disadvantage = d.disadvantage;
                    costs = d.costs;

                    if(_canFinish()) {
                      _prepareFinish();
                      Navigator.of(context, rootNavigator: true).pop(selected!);
                    }
                  }),
                ),
              ),
            if(disadvantage == null && niceDM)
              Expanded(
                child: DisadvantageSelectionWidget(
                  limitToType: widget.type,
                  exclude: widget.exclude,
                  onSelected: (Disadvantage d) => setState(() {
                    disadvantage = d;
                    costs = d.cost;

                    if(_canFinish()) {
                      _prepareFinish();
                      Navigator.of(context, rootNavigator: true).pop(selected!);
                    }
                  }),
                ),
              ),
            if(disadvantage != null && (costs.isNotEmpty || disadvantage!.requireDetails))
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12.0,
                  children: [
                    Expanded(
                      child: SelectableDisadvantageViewWidget(
                        disadvantage: disadvantage!,
                        onSelected: () {
                          setState(() {
                            disadvantage = null;
                            cost = null;
                            details = null;
                          });
                        },
                      )
                    ),
                    Expanded(
                      child: DisadvantageConfigurationWidget(
                        disadvantage: disadvantage!,
                        onDone: (CharacterDisadvantage? d) {
                          setState(() {
                            cost = d?.cost;
                            details = d?.details;
                          });
                          _prepareFinish();
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: selected == null ? null : () {
            Navigator.of(context, rootNavigator: true).pop(selected!);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class _DisadvantageRandomSelectionWidget extends StatelessWidget {
  const _DisadvantageRandomSelectionWidget({
    required this.first,
    this.second,
    required this.onSelected,
  });

  final _RandomDisadvantageEntry first;
  final _RandomDisadvantageEntry? second;
  final void Function(_RandomDisadvantageEntry) onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12.0,
      children: [
        Expanded(
          child: _SingleDisadvantageSelectionWidget(
            disadvantage: first.disadvantage,
            costs: first.costs,
            onSelected: () => onSelected(first),
          ),
        ),
        if(second != null)
          Expanded(
            child: _SingleDisadvantageSelectionWidget(
              disadvantage: second!.disadvantage,
              costs: second!.costs,
              onSelected: () => onSelected(second!),
            ),
          ),
      ],
    );
  }
}

class _DisadvantageFreeSelectionWidget extends StatefulWidget {
  const _DisadvantageFreeSelectionWidget({
    required this.type,
    required this.exclude,
    required this.onSelected,
  });

  final DisadvantageType type;
  final List<Disadvantage> exclude;
  final void Function(Disadvantage) onSelected;

  @override
  State<_DisadvantageFreeSelectionWidget> createState() => _DisadvantageFreeSelectionWidgetState();
}

class _DisadvantageFreeSelectionWidgetState extends State<_DisadvantageFreeSelectionWidget> {
  late List<Disadvantage> disadvantages;
  Disadvantage? selected;

  @override
  void initState() {
    super.initState();

    disadvantages = Disadvantage.values
      .where((Disadvantage d) => !widget.exclude.contains(d) && d.type == widget.type)
      .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12.0,
      children: [
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
        Expanded(
          child: selected == null
            ? SizedBox.shrink()
            : _SingleDisadvantageSelectionWidget(
                disadvantage: selected!,
                onSelected: () => widget.onSelected(selected!),
              ),
        ),
      ],
    );
  }
}

class _SingleDisadvantageSelectionWidget extends StatelessWidget {
  const _SingleDisadvantageSelectionWidget({
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

enum _DisadvantageSelectionType {
  mandatory,
  additional,
}

const _disadvantagesPerAge =
  <PlayerCharacterWizardAge, Map<_DisadvantageSelectionType, Map<DisadvantageType, int>>>{
    PlayerCharacterWizardAge.enfant: {
      _DisadvantageSelectionType.mandatory: {
        DisadvantageType.enfant: 1,
      },
      _DisadvantageSelectionType.additional: {
        DisadvantageType.enfant: 1,
        DisadvantageType.commun: 1,
      },
    },
    PlayerCharacterWizardAge.adolescent: {
      _DisadvantageSelectionType.mandatory: {
        DisadvantageType.commun: 1,
      },
      _DisadvantageSelectionType.additional: {
        DisadvantageType.commun: 2,
      },
    },
    PlayerCharacterWizardAge.adulte: {
      _DisadvantageSelectionType.mandatory: {
        DisadvantageType.commun: 1,
      },
      _DisadvantageSelectionType.additional: {
        DisadvantageType.commun: 2,
        DisadvantageType.rare: 1,
      },
    },
    PlayerCharacterWizardAge.ancien: {
      _DisadvantageSelectionType.mandatory: {
        DisadvantageType.commun: 1,
        DisadvantageType.ancien: 1,
      },
      _DisadvantageSelectionType.additional: {
        DisadvantageType.commun: 2,
        DisadvantageType.rare: 2,
      },
    },
    PlayerCharacterWizardAge.venerable: {
      _DisadvantageSelectionType.mandatory: {
        DisadvantageType.commun: 1,
        DisadvantageType.ancien: 2,
      },
      _DisadvantageSelectionType.additional: {
        DisadvantageType.commun: 1,
        DisadvantageType.rare: 1,
        DisadvantageType.ancien: 1,
      },
    },
  };

class _RandomDisadvantageEntry {
  const _RandomDisadvantageEntry({ required this.disadvantage, required this.costs });
  final Disadvantage disadvantage;
  final List<int> costs;
}

const _randomDisadvantagesTable =
  <DisadvantageType, Map<int, _RandomDisadvantageEntry>> {
    DisadvantageType.commun: {
      2: _RandomDisadvantageEntry(disadvantage: Disadvantage.complexeDInferiorite, costs: [3]),
      3: _RandomDisadvantageEntry(disadvantage: Disadvantage.complexeDInferiorite, costs: [3]),
      4: _RandomDisadvantageEntry(disadvantage: Disadvantage.complexeDInferiorite, costs: [3]),
      5: _RandomDisadvantageEntry(disadvantage: Disadvantage.interdit, costs: [3]),
      6: _RandomDisadvantageEntry(disadvantage: Disadvantage.echec, costs: [3]),
      7: _RandomDisadvantageEntry(disadvantage: Disadvantage.emotif, costs: [3]),
      8: _RandomDisadvantageEntry(disadvantage: Disadvantage.serment, costs: [2]),
      9: _RandomDisadvantageEntry(disadvantage: Disadvantage.faiblesse, costs: [2]),
      10: _RandomDisadvantageEntry(disadvantage: Disadvantage.phobie, costs: [1, 3, 5]),
      11: _RandomDisadvantageEntry(disadvantage: Disadvantage.maladie, costs: [1, 3, 5]),
      12: _RandomDisadvantageEntry(disadvantage: Disadvantage.manie, costs: [1]),
      13: _RandomDisadvantageEntry(disadvantage: Disadvantage.dette, costs: [1, 2]),
      14: _RandomDisadvantageEntry(disadvantage: Disadvantage.ennemi, costs: [3]),
      15: _RandomDisadvantageEntry(disadvantage: Disadvantage.obsession, costs: [3]),
      16: _RandomDisadvantageEntry(disadvantage: Disadvantage.anomalie, costs: [2]),
      17: _RandomDisadvantageEntry(disadvantage: Disadvantage.malchance, costs: [3]),
      18: _RandomDisadvantageEntry(disadvantage: Disadvantage.fragilite, costs: [2]),
      19: _RandomDisadvantageEntry(disadvantage: Disadvantage.fragilite, costs: [2]),
      20: _RandomDisadvantageEntry(disadvantage: Disadvantage.fragilite, costs: [2]),
    },
    DisadvantageType.rare: {
      2: _RandomDisadvantageEntry(disadvantage: Disadvantage.incompetence, costs: [5]),
      3: _RandomDisadvantageEntry(disadvantage: Disadvantage.incompetence, costs: [5]),
      4: _RandomDisadvantageEntry(disadvantage: Disadvantage.incompetence, costs: [5]),
      5: _RandomDisadvantageEntry(disadvantage: Disadvantage.amnesie, costs: [3]),
      6: _RandomDisadvantageEntry(disadvantage: Disadvantage.regardDesDragons, costs: [3, 5]),
      7: _RandomDisadvantageEntry(disadvantage: Disadvantage.blessure, costs: [5]),
      8: _RandomDisadvantageEntry(disadvantage: Disadvantage.infirmite, costs: [1, 3, 5]),
      9: _RandomDisadvantageEntry(disadvantage: Disadvantage.mauvaisOeil, costs: [3]),
      10: _RandomDisadvantageEntry(disadvantage: Disadvantage.maladresse, costs: [2]),
      11: _RandomDisadvantageEntry(disadvantage: Disadvantage.deviance, costs: [3]),
      12: _RandomDisadvantageEntry(disadvantage: Disadvantage.dependance, costs: [3]),
      13: _RandomDisadvantageEntry(disadvantage: Disadvantage.ennemi, costs: [5]),
      14: _RandomDisadvantageEntry(disadvantage: Disadvantage.marqueAuFer, costs: [3]),
      15: _RandomDisadvantageEntry(disadvantage: Disadvantage.echec, costs: [5]),
      16: _RandomDisadvantageEntry(disadvantage: Disadvantage.troubleMental, costs: [3]),
      17: _RandomDisadvantageEntry(disadvantage: Disadvantage.appelDeLaBete, costs: [5]),
      18: _RandomDisadvantageEntry(disadvantage: Disadvantage.personneACharge, costs: [2]),
      19: _RandomDisadvantageEntry(disadvantage: Disadvantage.personneACharge, costs: [2]),
      20: _RandomDisadvantageEntry(disadvantage: Disadvantage.personneACharge, costs: [2]),
    },
    DisadvantageType.enfant: {
      1: _RandomDisadvantageEntry(disadvantage: Disadvantage.chetif, costs: [5]),
      2: _RandomDisadvantageEntry(disadvantage: Disadvantage.curiosite, costs: [3]),
      3: _RandomDisadvantageEntry(disadvantage: Disadvantage.illusions, costs: [2]),
      4: _RandomDisadvantageEntry(disadvantage: Disadvantage.insignifiant, costs: [1]),
      5: _RandomDisadvantageEntry(disadvantage: Disadvantage.lassitude, costs: [2]),
      6: _RandomDisadvantageEntry(disadvantage: Disadvantage.mensongesInfantiles, costs: [1]),
      7: _RandomDisadvantageEntry(disadvantage: Disadvantage.naivete, costs: [2]),
      8: _RandomDisadvantageEntry(disadvantage: Disadvantage.revolte, costs: [2]),
      9: _RandomDisadvantageEntry(disadvantage: Disadvantage.transfert, costs: [2]),
      10: _RandomDisadvantageEntry(disadvantage: Disadvantage.versatilite, costs: [3]),
    },
    DisadvantageType.ancien: {
      1: _RandomDisadvantageEntry(disadvantage: Disadvantage.cardiaque, costs: [4]),
      2: _RandomDisadvantageEntry(disadvantage: Disadvantage.edente, costs: [3]),
      3: _RandomDisadvantageEntry(disadvantage: Disadvantage.grincheux, costs: [2]),
      4: _RandomDisadvantageEntry(disadvantage: Disadvantage.impotent, costs: [4]),
      5: _RandomDisadvantageEntry(disadvantage: Disadvantage.maladeImaginaire, costs: [2]),
      6: _RandomDisadvantageEntry(disadvantage: Disadvantage.nostalgieObsessionnelle, costs: [2]),
      7: _RandomDisadvantageEntry(disadvantage: Disadvantage.rhumatismes, costs: [3]),
      8: _RandomDisadvantageEntry(disadvantage: Disadvantage.senile, costs: [4]),
      9: _RandomDisadvantageEntry(disadvantage: Disadvantage.surdite, costs: [3]),
      10: _RandomDisadvantageEntry(disadvantage: Disadvantage.vueDefaillante, costs: [2]),
    },
  };