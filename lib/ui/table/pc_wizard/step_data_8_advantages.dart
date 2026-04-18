import 'package:flutter/material.dart';
import 'package:prophecy_compagnon_mj/ui/table/pc_wizard/enums.dart';
import 'package:provider/provider.dart';

import '../../../classes/character/advantages.dart';
import '../../../classes/human_character.dart';
import 'model.dart';
import 'step_data.dart';

class PlayerCharacterWizardStepDataAdvantages extends PlayerCharacterWizardStepData {
  PlayerCharacterWizardStepDataAdvantages({
    List<CharacterAdvantage>? advantages,
  })
    : advantages = advantages ?? <CharacterAdvantage>[],
      currentAdvantages = advantages ?? <CharacterAdvantage>[],
      super(title: 'Avantages');

  List<CharacterAdvantage> advantages;
  List<CharacterAdvantage> currentAdvantages;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget overviewWidget(BuildContext context) {
    var theme = Theme.of(context);
    var model = context.read<PlayerCharacterWizardModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.0,
      children: [
        for(var a in (model.advantages ?? <CharacterAdvantage>[]))
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${a.advantage.title} (${a.cost})',
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
              if(a.details.isNotEmpty)
                Text(
                  a.details,
                ),
            ],
          ),
      ],
    );
  }

  @override
  List<Widget> stepWidget(BuildContext context) {
    var model = context.read<PlayerCharacterWizardModel>();
    var maxPoints = 0;
    for(var d in [...model.mandatoryDisadvantages!, ...(model.additionalDisadvantages ?? <CharacterDisadvantage>[])]) {
      maxPoints += d.cost;
    }

    return [sliverWrap([Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 32.0,
        children: [
          Text(
            "Le joueur doit maintenant définir les Avantages et les Désavantages de son personnage. Ces petits détails auront une influence variable sur son comportement, son caractère, ses connaissances et ses chances de réussite. En définitive, tout ce qui peut le rendre différent d’un autre (un secret douloureux, ume aptitude particulière, un objet enchanté ou un ennemi juré) peut être considéré comme un Avantage ou un Désavantage.\nSeuls les Avantages pourront être “achetés” par les joueurs. Ils vont en effet commencer par déterminer aléatoirement un certain nombre de Désavantages qui seront assortis d’un gain de Points d’Avantage. Une fois tous les Désavantages définis, ces points permettront aux joueurs d'acheter les Avantages de leur choix en piochant dans les différentes listes qui leur sont proposées."
          ),
          _AdvantagesFormField(
            maxPoints: maxPoints,
            advantages: currentAdvantages,
            onUpdated: (List<CharacterAdvantage> l) {
              currentAdvantages = l;
              changed = currentAdvantages != advantages;
            },
            validator: (int? v) {
              if(v == null || v > 0) return "Tous les points doivent être dépensés";
              return null;
            },
          ),
        ],
      ),
    )])];
  }

  @override
  bool validate(PlayerCharacterWizardModel model, BuildContext context) => formKey.currentState!.validate();

  @override
  void init(PlayerCharacterWizardModel model) {
  }

  @override
  void reset(PlayerCharacterWizardModel model) {
    currentAdvantages = advantages = <CharacterAdvantage>[];
    model.advantages = null;
  }

  @override
  void clear() {
    currentAdvantages = List.from(advantages);
  }

  @override
  void save(PlayerCharacterWizardModel model) {
    advantages = currentAdvantages;
    model.advantages = advantages;
    currentAdvantages = List.from(advantages);
  }
}

class _AdvantagesFormField extends FormField<int> {
  _AdvantagesFormField({
    required int maxPoints,
    required List<CharacterAdvantage> advantages,
    required void Function(List<CharacterAdvantage>) onUpdated,
    super.validator,
  })
    : super(
        initialValue: maxPoints - (advantages.isEmpty ? 0 : advantages
            .map((CharacterAdvantage a) => a.cost)
            .reduce((int v, int e) => v + e)),
        builder: (FormFieldState<int> state) {
          Widget ret = _AdvantagesWidget(
            maxPoints: maxPoints,
            advantages: advantages,
            onUpdated: (List<CharacterAdvantage> l) {
              var used = (l.isEmpty ? 0 : l
                .map((CharacterAdvantage a) => a.cost)
                .reduce((int v, int e) => v + e));
              state.didChange(maxPoints - used);
              onUpdated(l);
            },
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

class _AdvantagesWidget extends StatefulWidget {
  const _AdvantagesWidget({
    required this.maxPoints,
    required this.advantages,
    required this.onUpdated,
  });

  final int maxPoints;
  final List<CharacterAdvantage> advantages;
  final void Function(List<CharacterAdvantage>) onUpdated;

  @override
  State<_AdvantagesWidget> createState() => _AdvantagesWidgetState();
}

class _AdvantagesWidgetState extends State<_AdvantagesWidget> {
  late List<CharacterAdvantage> current;
  Set<Advantage> uniqueAdvantages = <Advantage>{};

  @override
  void initState() {
    super.initState();

    current = List.from(widget.advantages);
    updateUniqueAdvantages();
  }

  void updateUniqueAdvantages() {
    uniqueAdvantages.clear();
    for(var a in current) {
      if(a.advantage.unique) {
        uniqueAdvantages.add(a.advantage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var model = context.read<PlayerCharacterWizardModel>();

    var remainingPoints = widget.maxPoints;
    for(var a in current) {
      remainingPoints -= a.cost;
    }

    var types = [AdvantageType.general];
    var age = model.age!;
    if(age == PlayerCharacterWizardAge.enfant || age == PlayerCharacterWizardAge.adolescent) {
      types.add(AdvantageType.enfant);
    }
    else if(age == PlayerCharacterWizardAge.ancien || age == PlayerCharacterWizardAge.venerable) {
      types.add(AdvantageType.ancien);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 32.0,
      children: [
        Text(
          'Points restant : ${remainingPoints.toString()}',
          style: theme.textTheme.headlineSmall!
            .copyWith(fontWeight: FontWeight.bold),
        ),
        Row(
          spacing: 12.0,
          children: [
            for(var a in current)
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
                              '${a.advantage.title} (${a.cost.toString()})',
                              style: theme.textTheme.bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            if(a.details.isNotEmpty)
                              Text(
                                a.details,
                              ),
                          ],
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              current.remove(a);
                            });
                            updateUniqueAdvantages();
                            widget.onUpdated(current);
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
            if(remainingPoints > 0)
              IconButton.filled(
                onPressed: () async {
                  var a = await showDialog<CharacterAdvantage>(
                    context: context,
                    builder: (BuildContext context) =>
                        _AdvantageSelectionDialog(
                          types: types,
                          maxCost: remainingPoints,
                          exclude: uniqueAdvantages.toList(),
                        ),
                  );
                  if(a == null) return;
                  if(!context.mounted) return;

                  setState(() {
                    current.add(a);
                  });
                  updateUniqueAdvantages();
                  widget.onUpdated(current);
                },
                iconSize: 18.0,
                padding: const EdgeInsets.all(8.0),
                constraints: BoxConstraints(),
                icon: Icon(Icons.add),
              ),
          ],
        ),
      ],
    );
  }
}

class _AdvantageSelectionDialog extends StatefulWidget {
  const _AdvantageSelectionDialog({
    required this.types,
    required this.maxCost,
    required this.exclude,
  });

  final List<AdvantageType> types;
  final int maxCost;
  final List<Advantage> exclude;

  @override
  State<_AdvantageSelectionDialog> createState() => _AdvantageSelectionDialogState();
}

class _AdvantageSelectionDialogState extends State<_AdvantageSelectionDialog> {
  late List<Advantage> advantages;
  Advantage? viewing;
  Advantage? advantage;
  List<int> costs = <int>[];
  int? cost;
  String? details;
  CharacterAdvantage? selected;

  @override
  void initState() {
    super.initState();

    advantages = Advantage.values
      .where(
        (Advantage a) =>
          widget.types.contains(a.type)
          && a.cost.any((int c) => c <= widget.maxCost)
          && !widget.exclude.contains(a)
      )
      .toList();
  }

  bool _canFinish() {
    if(advantage == null) return false;
    if(costs.isEmpty) return false;
    if(cost == null && costs.length > 1) return false;
    if(advantage!.requireDetails && details == null) return false;

    return true;
  }

  void _prepareFinish() {
    if(!_canFinish()) return;

    selected = CharacterAdvantage(
      advantage: advantage!,
      cost: cost ?? costs[0],
      details: details ?? "",
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text("Choix de l'Avantage"),
      content: SizedBox(
        width: 800,
        height: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(advantage == null)
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12.0,
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemCount: advantages.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(advantages[index].title),
                            onTap: () => setState(() {
                              viewing = advantages[index];
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
                      child: viewing == null
                        ? SizedBox.shrink()
                        : _AdvantageSelectionWidget(
                            advantage: viewing!,
                            onSelected: () => setState(() {
                              advantage = viewing;
                              costs = advantage!.cost
                                .where((int c) => c <= widget.maxCost)
                                .toList();

                              if(_canFinish()) {
                                _prepareFinish();
                                Navigator.of(context, rootNavigator: true).pop(selected!);
                              }
                            }),
                          ),
                    ),
                  ],
                ),
              ),
            if(advantage != null && (costs.isNotEmpty || advantage!.requireDetails))
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12.0,
                  children: [
                    Expanded(
                      child: _AdvantageSelectionWidget(
                        advantage: viewing!,
                        costs: costs,
                        onSelected: () {},
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16.0,
                        children: [
                          Text(
                            'Avantage : ${advantage!.title}',
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
                                  initialSelection: costs.length == 1
                                    ? costs[0]
                                    : null,
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
                                    .where((int c) => c <= widget.maxCost)
                                    .map(
                                      (int c) => DropdownMenuEntry(
                                        value: c, label: c.toString()
                                      )
                                    )
                                    .toList(),
                                  onSelected: (int? v) {
                                    if(v == null) return;
                                    setState(() {
                                      cost = v;
                                      _prepareFinish();
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                          if(advantage!.requireDetails)
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
                                        if(v == null || v.isEmpty) return;
                                        setState(() {
                                          details = v;
                                          _prepareFinish();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
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

class _AdvantageSelectionWidget extends StatelessWidget {
  const _AdvantageSelectionWidget({
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