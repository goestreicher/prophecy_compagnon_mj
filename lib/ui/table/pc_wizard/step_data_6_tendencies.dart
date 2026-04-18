import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../classes/character/tendencies.dart';
import '../../../classes/place.dart';
import '../../utils/num_input_widget.dart';
import '../../utils/place/place_display_widget.dart';
import 'enums.dart';
import 'model.dart';
import 'step_data.dart';

class PlayerCharacterWizardStepDataTendencies extends PlayerCharacterWizardStepData {
  PlayerCharacterWizardStepDataTendencies({
    this.origin,
    this.dragon,
    this.human,
    this.fatality,
    this.free,
  })
    : currentOrigin = origin,
      currentDragon = dragon,
      currentHuman = human,
      currentFatality = fatality,
      super(title: 'Tendances');

  String? origin;
  String? currentOrigin;
  int? dragon;
  int? currentDragon;
  int? human;
  int? currentHuman;
  int? fatality;
  int? currentFatality;
  int? free;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget overviewWidget(BuildContext context) {
    var theme = Theme.of(context);
    var model = context.read<PlayerCharacterWizardModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Dragon : ',
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: model.tendencyDragon.toString(),
              ),
            ]
          )
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Homme : ',
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: model.tendencyHuman.toString(),
              ),
            ]
          )
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Fatalité : ',
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: model.tendencyFatality.toString(),
              ),
            ]
          )
        ),
      ],
    );
  }

  @override
  List<Widget> stepWidget(BuildContext context) {
    return [sliverWrap([Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
        children: [
          Text(
            "Le caractère d’un personnage doit prendre en compte la vision qu'il a d’un monde partagé entre le respect des Grands Dragons, l'esprit de révolte typiquement humain et la soif de pouvoir propre aux esprits les plus vils. Les Tendances interprètent donc à la fois la philosophie du personnage, son mode de pensée, et sa conviction en l’une des différentes forces du monde.\n Depuis leur création, les hommes sont tiraillés entre plusieurs forces primordiales qui sont susceptibles de modifier leur comportement, leurs choix et leurs actions. Ces forces sont liées aux trois grandes Tendances : le Dragon, l'Homme et la Fatalité, qui se disputent le contrôle de chaque être humain.\nÀ la création, chaque joueur choisit le type de nation dont son personnage provient. Sans modifier son profil technique, cette origine va déterminer son type de mentalité. Selon les informations présentées dans le chapitre consacré aux nations de Kor, le joueur a pu saisir les orientations générales de la conscience populaire. Selon ces orientations, certaines nations ont des mentalités très proches alors que d’autres ont des styles si particuliers qu’ils représentent une catégorie à eux seuls.\nSelon son âge, le personnage disposera de plus ou moins de Points de Tendance lors de sa création. Les enfants disposent de moins de points car leur caractère personnel est encore peu construit, tout juste imprégné des valeurs de leurs parents et voisins. À l’inverse, les anciens et les vénérables ont des opinions bien trempées, souvent confortées par des années de réflexion. Certains points sont imposés, et d’autres libres, en fonction de l’idée que chaque joueur se fera de son personnage. Ne négligez pas ces valeurs, car en plus de déterminer le caractère et les motivations d’un personnage, les Tendances jouent un rôle essentiel dans le processus d’évolution et de progression - au sein d’une caste, d’une école de magie ou d’un Lien draconique."
          ),
          _TendenciesEditWidget(
            originUuid: currentOrigin ?? origin,
            onOriginUuidChanged: (String? u) {
              currentOrigin = u;
              changed = _checkChanged();
            },
            dragon: currentDragon ?? dragon,
            onDragonChanged: (int v) {
              currentDragon = v;
              changed = _checkChanged();
            },
            human: currentHuman ?? human,
            onHumanChanged: (int v) {
              currentHuman = v;
              changed = _checkChanged();
            },
            fatality: currentFatality ?? fatality,
            onFatalityChanged: (int v) {
              currentFatality = v;
              changed = _checkChanged();
            },
            free: free,
            onFreeChanged: (int v) => free = v,
          ),
        ],
      ),
    )])];
  }

  bool _checkChanged() =>
      currentOrigin != origin
      || currentDragon != dragon
      || currentHuman != human
      || currentFatality != fatality;

  @override
  bool validate(PlayerCharacterWizardModel model, BuildContext context) => formKey.currentState!.validate();

  @override
  void init(PlayerCharacterWizardModel model) {
  }

  @override
  void reset(PlayerCharacterWizardModel model) {
    currentOrigin = origin = null;
    model.origin = null;
    currentDragon = dragon = null;
    model.tendencyDragon = null;
    currentHuman = human = null;
    model.tendencyHuman = null;
    currentFatality = fatality = null;
    model.tendencyFatality = null;
  }

  @override
  void clear() {
    currentOrigin = origin;
    currentDragon = dragon;
    currentHuman = human;
    currentFatality = fatality;
  }

  @override
  void save(PlayerCharacterWizardModel model) {
    origin = currentOrigin;
    model.origin = origin;
    dragon = currentDragon;
    model.tendencyDragon = dragon;
    human = currentHuman;
    model.tendencyHuman = human;
    fatality = currentFatality;
    model.tendencyFatality = fatality;
  }
}

class _TendenciesEditWidget extends StatefulWidget {
  const _TendenciesEditWidget({
    this.originUuid,
    required this.onOriginUuidChanged,
    this.dragon,
    required this.onDragonChanged,
    this.human,
    required this.onHumanChanged,
    this.fatality,
    required this.onFatalityChanged,
    this.free,
    required this.onFreeChanged,
  });

  final String? originUuid;
  final void Function(String) onOriginUuidChanged;
  final int? dragon;
  final void Function(int) onDragonChanged;
  final int? human;
  final void Function(int) onHumanChanged;
  final int? fatality;
  final void Function(int) onFatalityChanged;
  final int? free;
  final void Function(int) onFreeChanged;

  @override
  State<_TendenciesEditWidget> createState() => _TendenciesEditWidgetState();
}

class _TendenciesEditWidgetState extends State<_TendenciesEditWidget> {
  String? currentOriginUuid;
  int baseDragon = 0;
  late int currentDragon;
  int baseHuman = 0;
  late int currentHuman;
  int baseFatality = 0;
  late int currentFatality;
  int baseFree = 0;
  late int currentFree;
  bool dragonExpanded = false;
  bool humanExpanded = false;
  bool fatalityExpanded = false;

  @override
  void initState() {
    super.initState();

    currentOriginUuid = widget.originUuid;
    currentDragon = widget.dragon ?? 0;
    currentHuman = widget.human ?? 0;
    currentFatality = widget.fatality ?? 0;
    currentFree = widget.free ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final textColumnWidth = 150.0;
    final tendencyInfoWidth = 350.0;
    final philosophyWidth = 550.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20.0,
      children: [
        Row(
          spacing: 8.0,
          children: [
            SizedBox(
              width: textColumnWidth,
              child: Text(
                "Pays d'origine",
                style: theme.textTheme.titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            _OriginSelectionWidget(
              origin: currentOriginUuid,
              onOriginChanged: (String uuid, _OriginTendencies tendencies) {
                setState(() {
                  currentOriginUuid = uuid;
                  baseDragon = tendencies.dragon;
                  currentDragon = tendencies.dragon;
                  baseHuman = tendencies.human;
                  currentHuman = tendencies.human;
                  baseFatality = tendencies.fatality;
                  currentFatality = tendencies.fatality;
                  baseFree = tendencies.free;
                  currentFree = tendencies.free;
                });

                widget.onOriginUuidChanged(currentOriginUuid!);
                widget.onDragonChanged(currentDragon);
                widget.onHumanChanged(currentHuman);
                widget.onFatalityChanged(currentFatality);
                widget.onFreeChanged(currentFree);
              },
            ),
            if(currentOriginUuid != null)
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () async {
                    var place = await PlaceSummary.get(currentOriginUuid!);
                    if(!context.mounted) return;

                    if(place == null) {
                      await showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Lieu non trouvé'),
                            content: Text(
                              "Impossible de trouver le lieu avec l'ID $currentOriginUuid!",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        }
                      );
                    }
                    else {
                      await showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(place.name),
                            content: SizedBox(
                              width: 800,
                              child: SingleChildScrollView(
                                child: PlaceDisplayWidget(placeId: place.id),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                                child: const Text('OK')
                              ),
                            ],
                          );
                        }
                      );
                    }
                  },
                  child: Icon(
                    Icons.info_outline,
                    size: 18.0,
                  ),
                ),
              ),
          ],
        ),
        _TendenciesFreePointsFormField(
          free: currentFree,
          validator: (int? v) {
            if(v != null && v > 0) return 'Tous les points doivent être répartis';
            return null;
          },
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8.0,
          children: [
            Row(
              spacing: 4.0,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => setState(() {
                      dragonExpanded = !dragonExpanded;
                    }),
                    child: Icon(
                      dragonExpanded ? Icons.help : Icons.help_outline,
                      size: 18.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: textColumnWidth,
                  child: Text(
                    'Tendance Dragon',
                    style: theme.textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 80,
              child: NumIntInputWidget(
                collapsed: true,
                initialValue: currentDragon,
                minValue: baseDragon,
                maxValue: min(5, currentDragon + currentFree),
                onChanged: (int v) {
                  var delta = v - currentDragon;
                  setState(() {
                    currentFree -= delta;
                    currentDragon = v;
                  });
                  widget.onFreeChanged(currentFree);
                  widget.onDragonChanged(currentDragon);
                },
              ),
            ),
            if(currentDragon > 0)
              SizedBox(
                width: philosophyWidth,
                child: Text(
                  _tendencyLevelsPhilosophy[Tendency.dragon]![currentDragon]!,
                ),
              ),
          ],
        ),
        if(dragonExpanded)
          SizedBox(
            width: tendencyInfoWidth,
            child: Text("Le Dragon représente la foi que les hommes ont en la race dominante du monde de Prophecy, celle qui les a créés et qui dirige les castes responsables de leur éducation. Plus la Tendance Dragon d’un personnage sera élevée, plus il calquera son comportement sur les valeurs prônées par les huit Grands Dragons. Les Grands Dragons cherchent le bien communautaire, aiment à dispenser leur sagesse envers les humains et apprécient le respect dû à leur nature et à leur puissance créatrice. Chaque Dragon oriente un peu cette Tendance. Le courage, l’abnégation, la sagesse, le labeur, le respect, l'harmonie, la fougue et la croyance en la magie sont autant de valeurs que les Dragons aiment voir développer chez les humains. À l'inverse, plus cette Tendance sera faible, moins le personnage fera confiance aux dragons et plus il s’orientera vers l’une des deux autres forces."),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8.0,
          children: [
            Row(
              spacing: 4.0,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => setState(() {
                      humanExpanded = !humanExpanded;
                    }),
                    child: Icon(
                      humanExpanded ? Icons.help : Icons.help_outline,
                      size: 18.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: textColumnWidth,
                  child: Text(
                    'Tendance Homme',
                    style: theme.textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 80,
              child: NumIntInputWidget(
                initialValue: currentHuman,
                minValue: baseHuman,
                maxValue: min(5, currentHuman + currentFree),
                onChanged: (int v) {
                  var delta = v - currentHuman;
                  setState(() {
                    currentFree -= delta;
                    currentHuman = v;
                  });
                  widget.onFreeChanged(currentFree);
                  widget.onHumanChanged(currentHuman);
                },
              ),
            ),
            if(currentHuman > 0)
              SizedBox(
                width: philosophyWidth,
                child: Text(
                  _tendencyLevelsPhilosophy[Tendency.human]![currentHuman]!,
                ),
              ),
          ],
        ),
        if(humanExpanded)
          SizedBox(
            width: tendencyInfoWidth,
            child: Text("L'Homme représente le côté “rebelle” propre aux humains, leur faculté de dire “non !”, de désobéir et de chercher sans cesse le changement. L'Homme représente aussi la capacité à laisser ses sentiments personnels prendre le pas sur les lois, les dogmes et les interdits quels qu’ils soient pour laisser parler son cœur et sa personnalité. Mais cette Tendance incarne aussi l’esprit de révolte, la recherche du progrès et le goût de l’invention. Poussée à l’extrême, elle donne plus de valeur aux humains et moins aux Dragons, dont les enseignements sembleront alors bien lointains. L'Humanisme, en tant que philosophie réfractaire à l’influence draconique, représente une vision agressive et particulière de cette Tendance lorsqu’elle obscurcit complètement le jugement."),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8.0,
          children: [
            Row(
              spacing: 4.0,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => setState(() {
                      fatalityExpanded = !fatalityExpanded;
                    }),
                    child: Icon(
                      fatalityExpanded ? Icons.help : Icons.help_outline,
                      size: 18.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: textColumnWidth,
                  child: Text(
                    'Tendance Fatalité',
                    style: theme.textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 80,
              child: NumIntInputWidget(
                initialValue: currentFatality,
                minValue: baseFatality,
                maxValue: min(5, currentFatality + currentFree),
                onChanged: (int v) {
                  var delta = v - currentFatality;
                  setState(() {
                    currentFree -= delta;
                    currentFatality = v;
                  });
                  widget.onFreeChanged(currentFree);
                  widget.onFatalityChanged(currentFatality);
                },
              ),
            ),
            if(currentFatality > 0)
              SizedBox(
                width: philosophyWidth,
                child: Text(
                  _tendencyLevelsPhilosophy[Tendency.fatality]![currentFatality]!,
                ),
              ),
          ],
        ),
        if(fatalityExpanded)
          SizedBox(
            width: tendencyInfoWidth,
            child: Text("La Fatalité se cache derrière les aspects les plus vils de l'humanité. Depuis la trahison de Kalimsshar, les hommes oscillent entre le respect des Lois draconiques, la rébellion et la quête de puissance. Plus qu’une hésitation, c’est un mélange de cruauté, de cupidité et de malveillance que représente la Tendance Fatalité. La Fatalité place le personnage au centre de l’existence, sans considération pour son entourage. Ses valeurs sont le plaisir, la rapidité, la facilité, la beauté parfaite, la haine, la violence. Plus sa valeur sera élevée, moins le personnage tiendra compte de l'importance de la vie et des lois qui régissent ses frères humains. À l’inverse, plus elle sera faible, plus le personnage respectera la vie et évitera de commettre des crimes et des actes nuisibles."),
          ),
      ],
    );
  }
}

class _TendenciesFreePointsFormField extends FormField<int> {
  _TendenciesFreePointsFormField({
    required int free,
    super.validator,
  })
    : super(
        initialValue: free,
        builder: (FormFieldState<int> state) {
          if(free != state.value) {
            WidgetsBinding.instance.addPostFrameCallback((_) =>
              state.didChange(free));
          }

          Widget ret = _TendenciesFreePointsWidget(
            free: free
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

class _TendenciesFreePointsWidget extends StatelessWidget {
  const _TendenciesFreePointsWidget({
    required this.free,
  });

  final int free;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      spacing: 8.0,
      children: [
        Text(
          'Points à répartir',
          style: theme.textTheme.titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 80,
          child: Text(
            free.toString(),
          ),
        ),
      ],
    );
  }
}

class _OriginSelectionWidget extends StatefulWidget {
  const _OriginSelectionWidget({
    this.origin,
    required this.onOriginChanged,
  });

  final String? origin;
  final void Function(String, _OriginTendencies) onOriginChanged;

  @override
  State<_OriginSelectionWidget> createState() => _OriginSelectionWidgetState();
}

class _OriginSelectionWidgetState extends State<_OriginSelectionWidget> {
  Map<String, String> placeUuidToName = <String, String>{};
  String? currentOrigin;

  Future<void> _loadPlaces() async {
    for(var pName in _tendenciesByOrigin.keys) {
      PlaceSummary? place = await PlaceSummary.byName(pName);
      if(place == null) {
        throw(ArgumentError('Place named $pName not found}'));
      }
      placeUuidToName[place.uuid] = pName;
    }
  }

  void _notify(String uuid, PlayerCharacterWizardAge age) {
    var pName = placeUuidToName[uuid];
    var tendencies = _tendenciesByOrigin[pName]![age]!;
    widget.onOriginChanged(uuid, tendencies);
  }

  @override
  Widget build(BuildContext context) {
    var model = context.read<PlayerCharacterWizardModel>();

    if(placeUuidToName.isNotEmpty) {
      return SizedBox(
        width: 250,
        child: _OriginSelectionMenu(
          placeUuidToName: placeUuidToName,
          initialSelection: widget.origin,
          onSelected: (String uuid) {
            currentOrigin = uuid;
            _notify(uuid, model.age!);
          }
        ),
      );
    }
    else {
      return SizedBox(
        width: 250,
        child: FutureBuilder(
          future: _loadPlaces(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            var theme = Theme.of(context);
            var model = context.read<PlayerCharacterWizardModel>();

            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: 36.0,
                width: 250,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if(snapshot.hasError) {
              return SizedBox(
                height: 36.0,
                width: 250,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    'Impossible de charger les pays',
                    style: theme.textTheme.bodySmall!
                      .copyWith(color: theme.colorScheme.onPrimary),
                  ),
                ),
              );
            }

            if(widget.origin != null && currentOrigin == null) {
              // Fire a change event with current tendencies
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => _notify(widget.origin!, model.age!)
              );
            }

            return _OriginSelectionMenu(
              placeUuidToName: placeUuidToName,
              initialSelection: widget.origin,
              onSelected: (String uuid) {
                var pName = placeUuidToName[uuid];
                var tendencies = _tendenciesByOrigin[pName]![model.age!]!;
                widget.onOriginChanged(uuid, tendencies);
              }
            );
          }
        ),
      );
    }
  }
}

class _OriginSelectionMenu extends StatelessWidget {
  const _OriginSelectionMenu({
    required this.placeUuidToName,
    this.initialSelection,
    required this.onSelected,
  });

  final Map<String, String> placeUuidToName;
  final String? initialSelection;
  final void Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return DropdownMenuFormField<String>(
      initialSelection: initialSelection,
      requestFocusOnTap: true,
      expandedInsets: EdgeInsets.zero,
      textStyle: theme.textTheme.bodySmall,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        isCollapsed: true,
        constraints: BoxConstraints(maxHeight: 36.0),
        contentPadding: EdgeInsets.all(12.0),
      ),
      dropdownMenuEntries: placeUuidToName.entries
        .map((MapEntry<String, String> e) => DropdownMenuEntry(value: e.key, label: e.value))
        .toList(),
      validator: (String? uuid) {
        if(uuid == null) return 'Valeur manquante';
        return null;
      },
      onSelected: (String? uuid) {
        if(uuid == null) return;
        onSelected(uuid);
      },
    );
  }
}

class _OriginTendencies {
  const _OriginTendencies({
    this.dragon = 0,
    this.human = 0,
    this.fatality = 0,
    this.free = 0,
  });

  final int dragon;
  final int human;
  final int fatality;
  final int free;
}

const _tendenciesByOrigin = <String, Map<PlayerCharacterWizardAge, _OriginTendencies>>{
  "Empire de Solyr": {
    PlayerCharacterWizardAge.enfant: _OriginTendencies(
      human: 1,
      free: 1,
    ),
    PlayerCharacterWizardAge.adolescent: _OriginTendencies(
      dragon: 1,
      human: 1,
      free: 1,
    ),
    PlayerCharacterWizardAge.adulte: _OriginTendencies(
      dragon: 2,
      human: 2,
    ),
    PlayerCharacterWizardAge.ancien: _OriginTendencies(
      dragon: 2,
      human: 2,
      free: 1,
    ),
    PlayerCharacterWizardAge.venerable: _OriginTendencies(
      dragon: 2,
      human: 2,
      free: 1,
    ),
  },
  "Kar": {
    PlayerCharacterWizardAge.enfant: _OriginTendencies(
      dragon: 2,
    ),
    PlayerCharacterWizardAge.adolescent: _OriginTendencies(
      dragon: 1,
      free: 2,
    ),
    PlayerCharacterWizardAge.adulte: _OriginTendencies(
      dragon: 2,
      free: 2,
    ),
    PlayerCharacterWizardAge.ancien: _OriginTendencies(
      dragon: 3,
      free: 2,
    ),
    PlayerCharacterWizardAge.venerable: _OriginTendencies(
      dragon: 4,
      free: 1,
    ),
  },
  "Kali": {
    PlayerCharacterWizardAge.enfant: _OriginTendencies(
      human: 1,
      fatality: 1,
    ),
    PlayerCharacterWizardAge.adolescent: _OriginTendencies(
      human: 1,
      fatality: 1,
      free: 1,
    ),
    PlayerCharacterWizardAge.adulte: _OriginTendencies(
      fatality: 2,
      free: 2,
    ),
    PlayerCharacterWizardAge.ancien: _OriginTendencies(
      fatality: 3,
      free: 2,
    ),
    PlayerCharacterWizardAge.venerable: _OriginTendencies(
      fatality: 4,
      free: 1,
    ),
  },
  "Forêt Mère": {
    PlayerCharacterWizardAge.enfant: _OriginTendencies(
      dragon: 2,
    ),
    PlayerCharacterWizardAge.adolescent: _OriginTendencies(
      dragon: 2,
      human: 1,
    ),
    PlayerCharacterWizardAge.adulte: _OriginTendencies(
      dragon: 3,
      free: 1,
    ),
    PlayerCharacterWizardAge.ancien: _OriginTendencies(
      dragon: 4,
      free: 1,
    ),
    PlayerCharacterWizardAge.venerable: _OriginTendencies(
      dragon: 5,
    ),
  },
  "Royaume des Fleurs": {
    PlayerCharacterWizardAge.enfant: _OriginTendencies(
      dragon: 2,
    ),
    PlayerCharacterWizardAge.adolescent: _OriginTendencies(
      dragon: 2,
      human: 1,
    ),
    PlayerCharacterWizardAge.adulte: _OriginTendencies(
      dragon: 3,
      free: 1,
    ),
    PlayerCharacterWizardAge.ancien: _OriginTendencies(
      dragon: 4,
      free: 1,
    ),
    PlayerCharacterWizardAge.venerable: _OriginTendencies(
      dragon: 5,
    ),
  },
  "Empire Nésora": {
    PlayerCharacterWizardAge.enfant: _OriginTendencies(
      human: 1,
      free: 1,
    ),
    PlayerCharacterWizardAge.adolescent: _OriginTendencies(
      human: 2,
      free: 1,
    ),
    PlayerCharacterWizardAge.adulte: _OriginTendencies(
      human: 3,
      free: 1,
    ),
    PlayerCharacterWizardAge.ancien: _OriginTendencies(
      human: 3,
      free: 2,
    ),
    PlayerCharacterWizardAge.venerable: _OriginTendencies(
      human: 4,
      free: 1,
    ),
  },
  "Pomyrie": {
    PlayerCharacterWizardAge.enfant: _OriginTendencies(
      dragon: 1,
      human: 1,
    ),
    PlayerCharacterWizardAge.adolescent: _OriginTendencies(
      dragon: 2,
      free: 1,
    ),
    PlayerCharacterWizardAge.adulte: _OriginTendencies(
      dragon: 2,
      free: 2,
    ),
    PlayerCharacterWizardAge.ancien: _OriginTendencies(
      dragon: 3,
      free: 2,
    ),
    PlayerCharacterWizardAge.venerable: _OriginTendencies(
      dragon: 3,
      free: 2,
    ),
  },
  "Kern": {
    PlayerCharacterWizardAge.enfant: _OriginTendencies(
      dragon: 2,
    ),
    PlayerCharacterWizardAge.adolescent: _OriginTendencies(
      dragon: 2,
      free: 1,
    ),
    PlayerCharacterWizardAge.adulte: _OriginTendencies(
      dragon: 3,
      free: 1,
    ),
    PlayerCharacterWizardAge.ancien: _OriginTendencies(
      dragon: 3,
      free: 2,
    ),
    PlayerCharacterWizardAge.venerable: _OriginTendencies(
      dragon: 4,
      free: 1,
    ),
  },
  "Ysmir": {
    PlayerCharacterWizardAge.enfant: _OriginTendencies(
      dragon: 1,
      human: 1,
    ),
    PlayerCharacterWizardAge.adolescent: _OriginTendencies(
      dragon: 1,
      human: 1,
      free: 1,
    ),
    PlayerCharacterWizardAge.adulte: _OriginTendencies(
      dragon: 2,
      human: 1,
      free: 1,
    ),
    PlayerCharacterWizardAge.ancien: _OriginTendencies(
      dragon: 3,
      human: 1,
      free: 1,
    ),
    PlayerCharacterWizardAge.venerable: _OriginTendencies(
      dragon: 4,
      human: 1,
    ),
  },
  "Terres Galyrs": {
    PlayerCharacterWizardAge.enfant: _OriginTendencies(
      dragon: 1,
      human: 1,
    ),
    PlayerCharacterWizardAge.adolescent: _OriginTendencies(
      dragon: 1,
      human: 1,
      free: 1,
    ),
    PlayerCharacterWizardAge.adulte: _OriginTendencies(
      dragon: 2,
      human: 1,
      free: 1,
    ),
    PlayerCharacterWizardAge.ancien: _OriginTendencies(
      dragon: 3,
      human: 1,
      free: 1,
    ),
    PlayerCharacterWizardAge.venerable: _OriginTendencies(
      dragon: 4,
      human: 1,
    ),
  },
  "Principauté de Marne": {
    PlayerCharacterWizardAge.enfant: _OriginTendencies(
      dragon: 1,
      human: 1,
    ),
    PlayerCharacterWizardAge.adolescent: _OriginTendencies(
      dragon: 1,
      free: 2,
    ),
    PlayerCharacterWizardAge.adulte: _OriginTendencies(
      dragon: 1,
      fatality: 1,
      free: 2,
    ),
    PlayerCharacterWizardAge.ancien: _OriginTendencies(
      dragon: 2,
      fatality: 1,
      free: 1,
    ),
    PlayerCharacterWizardAge.venerable: _OriginTendencies(
      dragon: 3,
      fatality: 1,
      free: 1,
    ),
  },
  "Jaspor": {
    PlayerCharacterWizardAge.enfant: _OriginTendencies(
      dragon: 1,
      human: 1,
    ),
    PlayerCharacterWizardAge.adolescent: _OriginTendencies(
      dragon: 1,
      free: 2,
    ),
    PlayerCharacterWizardAge.adulte: _OriginTendencies(
      dragon: 1,
      fatality: 1,
      free: 2,
    ),
    PlayerCharacterWizardAge.ancien: _OriginTendencies(
      dragon: 2,
      fatality: 1,
      free: 2,
    ),
    PlayerCharacterWizardAge.venerable: _OriginTendencies(
      dragon: 3,
      fatality: 1,
      free: 1,
    ),
  },
  "Empire Zûl": {
    PlayerCharacterWizardAge.enfant: _OriginTendencies(
      dragon: 1,
      human: 1,
    ),
    PlayerCharacterWizardAge.adolescent: _OriginTendencies(
      dragon: 2,
      free: 1,
    ),
    PlayerCharacterWizardAge.adulte: _OriginTendencies(
      dragon: 3,
      free: 1,
    ),
    PlayerCharacterWizardAge.ancien: _OriginTendencies(
      dragon: 4,
      free: 1,
    ),
    PlayerCharacterWizardAge.venerable: _OriginTendencies(
      dragon: 4,
      free: 1,
    ),
  },
  "Marches Alyzées": {
    PlayerCharacterWizardAge.enfant: _OriginTendencies(
      free: 2,
    ),
    PlayerCharacterWizardAge.adolescent: _OriginTendencies(
      free: 3,
    ),
    PlayerCharacterWizardAge.adulte: _OriginTendencies(
      free: 4,
    ),
    PlayerCharacterWizardAge.ancien: _OriginTendencies(
      free: 5,
    ),
    PlayerCharacterWizardAge.venerable: _OriginTendencies(
      free: 5,
    ),
  },
  "Cité de Griff": {
    PlayerCharacterWizardAge.enfant: _OriginTendencies(
      free: 2,
    ),
    PlayerCharacterWizardAge.adolescent: _OriginTendencies(
      free: 3,
    ),
    PlayerCharacterWizardAge.adulte: _OriginTendencies(
      free: 4,
    ),
    PlayerCharacterWizardAge.ancien: _OriginTendencies(
      free: 5,
    ),
    PlayerCharacterWizardAge.venerable: _OriginTendencies(
      free: 5,
    ),
  },
};

const _tendencyLevelsPhilosophy = <Tendency, Map<int, String>>{
  Tendency.dragon: {
    1: "La confiance : les dragons et les hommes vivent en harmonie depuis des siècles. Comment ignorer leur sagesse ?",
    2: "Le respect : nous devons tant de choses aux Dragons ! La voie de la magie, l’évolution de notre race… Il n’y a guère que les fous et les insolents pour refuser d’admettre leur souveraineté.",
    3: "La fascination : le Lien qui nous unit aux dragons est plus précieux que la vie qui nous anime. Sans lui, nous serions comme ces primitifs qui errent de par le monde : pauvres, faibles et ignorants.",
    4: "La ferveur : ceux qui croient encore que les Dragons “vivent” sur notre monde mourront dans l’ignorance. Les Dragons “sont” notre monde.",
    5: "Le fanatisme : de quel droit oses-tu mettre en doute la parole de tes Maîtres ? Cette liberté que tu réclames n’est rien qu’un battement de cils dans l’œil des Puissants !",
  },
  Tendency.human: {
    1: "La conscience : je pense donc je suis…",
    2: "Le choix : j'ai mûrement pesé ma décision. En mon âme et conscience, je sais ce que je dois faire et j'en assumerai les conséquences…",
    3: "L'équilibre : le sourire d’un bébé ou la gratitude d’un vieillard ont autant de valeur pour moi que l’estime des Dragons.",
    4: "Le doute : même les Lois draconiques ont leurs limites. Notre esprit est puissant et doit interpréter ce qu’ont vraiment voulu dire les Dragons. Sachons rectifier humblement leurs erreurs.",
    5: "L'indépendance : les Dragons n’ont pas le monopole de la sagesse. Que penser d'eux au regard de toutes leurs erreurs. Nous ne sommes que des hommes, mais notre union est notre force et notre voix aussi a sa valeur !",
  },
  Tendency.fatality: {
    1: "L’ironie : dans leur infinie bonté, les Dragons nous ont laissé le choix entre la régression et la servitude. Un choix difficile, n'est-ce pas ?",
    2: "Le mépris : prie-les si tu veux, mon ami. Réclame leur puissance, gave-toi de magie. Mais ne viens pas te plaindre que leur grandeur te pèse.",
    3: "La désillusion : le Lien vous a transformés en autant de fourmis misérables et dociles. Et pour quelle récompense ? Quelques poignées de sucre que vous appelez “magie” ?",
    4: "Le fatalisme : vous pensez “évoluer” alors que votre vie se limite à la parodie d’existence que les Dragons vous ont accordée… Je préférerai la mort à un tel sursis.",
    5: "L'oubli : il est certaines vérités que seul un aveugle peut appréhender. Tu comprendras, toi aussi, même si je dois te crever les yeux.",
  },
};