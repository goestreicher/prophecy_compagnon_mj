import 'package:flutter/material.dart';

import '../../../classes/caste/base.dart';
import '../../../classes/caste/career.dart';
import '../../../classes/caste/interdicts.dart';
import '../../utils/uniform_height_wrap.dart';
import 'model.dart';
import 'step_data.dart';

class PlayerCharacterWizardStepDataCaste extends PlayerCharacterWizardStepData {
  PlayerCharacterWizardStepDataCaste()
    : super(title: "Caste");

  Caste? caste;
  Caste? currentCaste;
  CasteInterdict? interdict;
  CasteInterdict? currentInterdict;
  Career? career;
  Career? currentCareer;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget overviewWidget(BuildContext context) {
    Widget? careerWidget;
    if(career != null) {
      careerWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Carrière envisagée : ${career!.title}'
          ),
          for(var req in career!.requirements)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                '\u2022 ${req.toDisplayString()}',
              ),
            ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(caste!.title),
        Text('Interdit : ${interdict!.title}'),
        ?careerWidget,
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
            "Dans le monde de Prophecy, les huit castes (dirigées par les huit Grands Dragons) sont l’épine dorsale de la société. Chacune d’elle rassemble un grand nombre de corps de métier possédant un tronc commun de Compétences. Faire partie d’une caste est le seul moyen d’accéder à une formation dans Kor, car les castes possèdent le monopole de l’enseignement. Ainsi, dès son plus jeune âge, les plus prometteurs des individus sont pris en charge par une caste qui fera d’eux des citoyens libres et indépendants. Chaque caste possède non seulement une philosophie, mais aussi des Compétences particulières, des Techniques réservées, des Privilèges et un code de conduite (les Interdits) qu’il est impératif de suivre si l’on veut progresser en leur sein.\n\nToutes les professions, de la plus généraliste à la plus spécialisée, requièrent un certain nombre de prédispositions physiques et mentales - autant de valeurs chiffrées que gèrent les Caractéristiques, les Attributs, les Compétences et Techniques. Avant de définir ces valeurs, il faut donc que le joueur sache de quoi son personnage aura besoin. Un combattant aura besoin d’être fort et rapide, un mage appréciera ses capacités de mémoire et de volonté, etc.\n\nComme les différentes Caractéristiques, le Statut d’un personnage au sein de sa caste peut évoluer au fil des aventures. Cette possibilité d’évolution est des plus motivantes car les joueurs verront leur personnage gagner progressivement de l’influence, de la renommée et des responsabilités. Dans certaines castes, la progression est fondée sur les actes et le mérite, dans d’autres, sur le savoir et l’expérience."
          ),
          _CasteSelectionWidget(
            caste: currentCaste ?? caste,
            interdict: currentInterdict ?? interdict,
            career: currentCareer ?? career,
            onSelected: (Caste c) {
              currentCaste = c;
              changed = _checkChanged();
            },
            onInterdictSelected: (CasteInterdict? i) {
              currentInterdict = i;
              changed = _checkChanged();
            },
            onCareerSelected: (Career? c) {
              currentCareer = c;
              changed = _checkChanged();
            },
          )
        ],
      ),
    )])];
  }

  bool _checkChanged() =>
      currentCaste != caste
      || currentInterdict != interdict
      || currentCareer != career;

  @override
  bool validate(PlayerCharacterWizardModel model, BuildContext context) => formKey.currentState!.validate();

  @override
  void init(PlayerCharacterWizardModel model) {
  }

  @override
  void reset(PlayerCharacterWizardModel model) {
    caste = currentCaste = model.caste = null;
    interdict = currentInterdict = model.interdict = null;
    career = currentCareer = model.career = null;
  }

  @override
  void clear() {
    currentCaste = caste;
    currentInterdict = interdict;
    currentCareer = career;
  }

  @override
  void save(PlayerCharacterWizardModel model) {
    caste = currentCaste;
    model.caste = caste;
    interdict = currentInterdict;
    model.interdict = interdict;
    career = currentCareer;
    model.career = career;
  }
}

class _CasteSelectionWidget extends StatefulWidget {
  const _CasteSelectionWidget({
    this.caste,
    this.interdict,
    this.career,
    required this.onSelected,
    required this.onInterdictSelected,
    required this.onCareerSelected,
  });

  final Caste? caste;
  final CasteInterdict? interdict;
  final Career? career;
  final void Function(Caste) onSelected;
  final void Function(CasteInterdict) onInterdictSelected;
  final void Function(Career?) onCareerSelected;

  @override
  State<_CasteSelectionWidget> createState() => _CasteSelectionWidgetState();
}

class _CasteSelectionWidgetState extends State<_CasteSelectionWidget> {
  Caste? selected;
  TextEditingController interdictController = TextEditingController();
  CasteInterdict? interdict;
  Career? career;

  @override
  void initState() {
    super.initState();
    selected = widget.caste;
    interdict = widget.interdict;
    career = widget.career;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.0,
      children: [
        SizedBox(
          width: 250,
          child: DropdownMenuFormField(
            initialSelection: selected,
            requestFocusOnTap: true,
            label: const Text('Caste'),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
            ),
            expandedInsets: EdgeInsets.zero,
            dropdownMenuEntries: Caste.values
                .where((Caste c) => _casteDescriptions.containsKey(c))
                .map((Caste c) => DropdownMenuEntry(value: c, label: c.title))
                .toList(),
            validator: (Caste? c) {
              if(c == null) return 'Valeur manquante';
              return null;
            },
            onSelected: (Caste? c) {
              if(c == null) return;
              setState(() {
                selected = c;
                interdict = null;
                interdictController.clear();
              });
              widget.onSelected(c);
            },
          ),
        ),
        if(selected != null)
          SizedBox(
            width: 250,
            child: DropdownMenuFormField(
              initialSelection: interdict,
              controller: interdictController,
              requestFocusOnTap: true,
              label: const Text('Interdit'),
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
              ),
              expandedInsets: EdgeInsets.zero,
              dropdownMenuEntries: CasteInterdict.values
                  .where((CasteInterdict i) => i.caste == selected!)
                  .map((CasteInterdict i) => DropdownMenuEntry(value: i, label: i.title))
                  .toList(),
              validator: (CasteInterdict? i) {
                if(i == null) return 'Valeur manquante';
                return null;
              },
              onSelected: (CasteInterdict? i) {
                if(i == null) return;
                setState(() {
                  interdict = i;
                });
                widget.onInterdictSelected(i);
              },
            ),
          ),
        if(interdict != null)
          SizedBox(
            width: 500,
            child: Text(
              interdict!.description
            ),
          ),
        if(selected != null)
          _CasteInformationWidget(
            caste: selected!,
            selectedCareer: career,
            onCareerSelected: (Career? c) {
              setState(() {
                career = c;
              });
              widget.onCareerSelected(c);
            },
          ),
      ],
    );
  }
}

class _CasteInformationWidget extends StatelessWidget {
  const _CasteInformationWidget({
    required this.caste,
    this.selectedCareer,
    required this.onCareerSelected,
  });

  final Caste caste;
  final Career? selectedCareer;
  final void Function(Career?) onCareerSelected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var careers = <Widget>[];
    for(var career in Career.values.where((Career c) => c.isStandard && c.castes.contains(caste))) {
      careers.add(
        SizedBox(
          width: 400,
          child: _CareerInformationWidget(
            career: career,
            selected: selectedCareer == career,
            onSelected: () {
              if(selectedCareer == career) {
                onCareerSelected(null);
              }
              else {
                onCareerSelected(career);
              }
            },
          )
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.0,
      children: [
        Text(
          'Description',
          style: theme.textTheme.headlineSmall!
            .copyWith(fontWeight: FontWeight.bold),
        ),
        Text(_casteDescriptions[caste]!.description),
        Text(
          'Carrières',
          style: theme.textTheme.headlineSmall!
            .copyWith(fontWeight: FontWeight.bold),
        ),
        UniformHeightWrap(
          spacing: 16.0,
          runSpacing: 16.0,
          children: careers,
        )
      ],
    );
  }
}

class _CareerInformationWidget extends StatelessWidget {
  const _CareerInformationWidget({
    required this.career,
    this.selected = false,
    required this.onSelected,
  });

  final Career career;
  final bool selected;
  final void Function() onSelected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var reqs = <Widget>[];
    for(var req in career.requirements) {
      reqs.add(
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text('\u2022 ${req.toDisplayString()}'),
        )
      );
    }

    return Card(
      clipBehavior: Clip.hardEdge,
      color: selected ? theme.colorScheme.secondaryFixedDim : null,
      child: InkWell(
        onTap: () => onSelected(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4.0,
            children: [
              Text(
                career.title,
                style: theme.textTheme.titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Devise : ',
                      style: theme.textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: career.motto,
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Motivations : ',
                      style: theme.textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: career.motivations,
                    ),
                  ],
                ),
              ),
              Text(
                'Description',
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  career.description,
                ),
              ),
              Text(
                'Pré-requis',
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
              ...reqs,
              Text(
                'Bénéfice : ${career.benefit.title}',
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  career.benefit.description,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CasteInformation {
  const _CasteInformation({
    required this.description,
  });

  final String description;
}

const _casteDescriptions = <Caste, _CasteInformation>{
  Caste.artisan: _CasteInformation(
    description: "Certains prétendent que ce sont les soldats qui font gagner les batailles… Mais que devient un combattant privé de son arme ? Un protecteur sans son armure ? Un riche commerçant sans ses parures ? Artistes de la forge, magiciens de la création, virtuoses de l’enchantement, les artisans sont les sculpteurs d’un monde où tout, de la plus vile des peaux à la plus pure des gemmes, peut être transformé en un objet magique et merveilleux.\nLes artisans doivent posséder la meilleure Coordination possible, ainsi qu'un score élevé en Perception et en Intelligence, car leur Attribut Manuel est presque aussi important que leurs facultés d'apprentissage et de mémoire. La Maîtrise est très importante pour ces personnages, qui devront se spécialiser dans leurs Compétences s’ils veulent atteindre les Statuts les plus élevés et s'initier aux arcanes de la magie pour ensorceler leurs créations.",
  ),
  Caste.combattant: _CasteInformation(
    description: "Cette caste hautement martiale forme les combattants solitaires, les maîtres d'armes et les aventuriers dont les hauts faits guerriers resteront gravés dans les légendes de Kor. On dit qu’il suffit d’une arme et d’un peu de courage pour apprendre l’art du combat, mais la voie de la perfection exige bien d’autres qualités, comme la souplesse, la force, le sang-froid, le sens du devoir et du sacrifice, etc.\nPour créer un bon combattant, il est donc important de développer les Caractéristiques physiques du personnage, notamment la Force et la Résistance, la Coordination et la Perception car elles influencent respectivement sur l’Attribut Physique et la valeur d’Initiative qui seront utilisés lors des combats. Un bon score de Maîtrise ou de Chance sera également le bienvenu et la Coordination permettra un choix conséquent d’armes. L'âge n’a guère d'importance, mais les personnages les plus vieux risquent de se trouver confrontés à quelques problèmes d’ordre physique, car la vigueur et les réflexes se dégradent progressivement avec l’âge.",
  ),
  Caste.commercant: _CasteInformation(
    description: "Avec le développement des hommes, les cités ont découvert le commerce et la prospérité, mais aussi la convoitise, la luxure et l’art du compromis. Les commerçants de la caste de Khy sont à l’image de cette société, où les simples vendeurs d’étoffes côtoient les voleurs de bourse, les assassins, les diplomates et les contrebandiers de tous horizons. Dans ce dédale de mensonges et d’apparences trompeuses, comment reconnaître un honnête marchand d’un vulgaire coupe-jarret ?\nIl existe donc deux types de commerçants : ceux qui auront besoin de Caractéristiques mentales et d’un Attribut Social élevés - pour négocier, vendre et convaincre - et ceux pour qui la Coordination, la Chance, l’Attribut Manuel et les Compétences de Manipulation seront beaucoup plus utiles, pour fouiller les poches et se dissimuler dans l’ombre.",
  ),
  Caste.erudit: _CasteInformation(
    description: "Les protégés du Grand Dragon des Océans, mère de tous les secrets du monde, se considèrent eux-mêmes comme les ouvrages d’une gigantesque bibliothèque : à la fois dépareillés et complémentaires, uniques et indissociables. Chaque érudit progresse sur la voie qu’il s’est choisie. Pour certains, la théorie est le plus important des savoirs ; pour d’autres, l'expérience de la vie est la seule véritable leçon.\nLes érudits sont de loin les moins “physiques” des personnages de Prophecy. Leur force vient de leur mémoire, de leur rapidité de réflexion et de leur capacité à comprendre. Les Caractéristiques mentales, les Compêtences Théoriques et Pratiques, ainsi que quelques Avantages bien choisis, seront donc indispensables à la création d’un bon érudit.",
  ),
  Caste.mage: _CasteInformation(
    description: "Éclairs foudroyants, murs de flammes, guérisons miraculeuses, boucliers d’énergie… Les pouvoirs dont disposent les mages semblent n’avoir aucune limite - si ce n’est celle que leur imposent parfois les Grands Dragons dont sont nées les neuf Sphères élémentaires. Aussi, qu’il ait été bienveillant ou cruel, sage ou destructeur, est-il rare que le nom d’un mage soit oublié par les légendes que colportent les baladins.\nUn bon mage a besoin d’Intelligence, de Volonté et d’Empathie, car il utilisera les valeurs de ces trois Caractéristiques afin de lancer des sortilèges, en calculer les effets, résister aux effets des autres sorts et aux effets secondaires. Comme pour les autres castes, le choix des Compétences sera primordial et l’achat d’Avantages jouera un rôle non négligeable dans les perspectives d'évolution du personnage. Il n’est pas déconseillé de créer des mages trop jeunes, mais les anciens et les vénérables auront certainement plus de facilité à utiliser leurs pouvoirs.",
  ),
  Caste.prodige: _CasteInformation(
    description: "En acceptant de perdre leur immortalité pour devenir féconds, les hommes perdirent aussi le Lien des Grands Dragons pendant plusieurs siècles, jusqu’au jour où l’un d'entre eux parvint à émouvoir Heyra, Mère de la Nature. Ainsi naquit la caste des Prodiges, premiers et véritables Élus des Dragons, dont le nom symbolise encore aujourd’hui le don de soi, la protection de la vie et la sagesse enseignée par les Grands Ailés.\nSous leurs allures monastiques, les Prodiges sont tout de même de redoutables combattants. Ils ont donc besoin de Caractéristiques physiques développées, de réflexes et de Compétences de Combat. Un Attribut Mental élevé sera aussi appréciable, la force n'étant rien sans un esprit sage pour la guider. Il n’y a pas d'âge pour défendre la nature, mais les plus jeunes risquent d’être légèrement désavantagés lors des combats les plus rudes. Cependant, leur chance et leur adresse seront en mesure de compenser cette relative faiblesse physique.",
  ),
  Caste.protecteur: _CasteInformation(
    description: "De toutes les castes draconiques, celle des protecteurs forme sûrement la plus noble et la plus impressionnante d’entre elles. Engoncés dans leurs lourdes armures, ces combattants affiliés à Brorne sont aussi à l’aise dans le chaos des cités qu’ils régissent que sur les champs de bataille où leurs armées déferlent au fil des guerres. Fidèles à leurs convictions, respectueux de l’autorité sous toutes ses formes, les protecteurs sont à les fois les soldats et les miliciens du monde.\nLa lourde responsabilité des protecteurs les oblige à développer leurs Caractéristiques physiques, leur Attribut Social, leurs Compétences de Combat et d'Influence, ainsi que leur Tendance Dragon - car les récompenses accordées par les représentants des Grands Dragons se fondent autant sur le mérite que sur la conviction des soldats.",
  ),
  Caste.voyageur: _CasteInformation(
    description: "Chaque royaume a ses frontières, chaque pays ses limites, chaque monde ses aventuriers. Armés d’une carte, d’une paire de bottes et d’un sac, les voyageurs sillonnent les plaines et les forêts, à la recherche de nouvelles routes, de cités inconnues et de rencontres inédites. Ils sont la mémoire vivante de ce monde insolite où l'héritage des Dragons côtoie les découvertes faites par les hommes.\nPour faire face aux aléas de ses voyages, l’aventurier a besoin d’une Perception accrue, d'un esprit vif et d’un corps résistant. La caste des voyageurs n’impose aucun profil à ses citoyens. Reste à voir s’il s'agira plutôt d’un archer, d’un cavalier, d’un explorateur, d’un guide, d’un chasseur, etc.",
  ),
};