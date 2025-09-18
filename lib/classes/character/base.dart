import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

part 'base.g.dart';

enum Ability {
  force(title: "Force"),
  intelligence(title: "Intelligence"),
  coordination(title: "Coordination"),
  presence(title: "Présence"),
  resistance(title: "Résistance"),
  volonte(title: "Volonté"),
  perception(title: "Perception"),
  empathie(title: "Empathie");

  const Ability({
    required this.title,
  });

  final String title;
}

enum Attribute {
  physique(title: "Physique"),
  mental(title: "Mental"),
  manuel(title: "Manuel"),
  social(title: "Social");

  const Attribute({
    required this.title,
  });

  final String title;
}

enum CasteStatus {
  none,
  apprenti,
  initie,
  expert,
  maitre,
  grandMaitre,
}

class CasteTechnique{
  CasteTechnique({ required this.title, required this.description });

  final String title;
  final String description;
}

enum Caste {
  sansCaste(title: 'Sans caste'),
  artisan(title: 'Artisan'),
  combattant(title: 'Combattant'),
  commercant(title: 'Commerçant'),
  erudit(title: 'Érudit'),
  mage(title: 'Mage'),
  prodige(title: 'Prodige'),
  protecteur(title: 'Protecteur'),
  voyageur(title: 'Voyageur');

  const Caste({
    required this.title,
  });

  final String title;

  static Caste? byTitle(String descr) {
    Caste? ret;
    for(var caste in Caste.values) {
      if(caste.title == descr) ret = caste;
    }
    return ret;
  }

  static String statusName(Caste c, CasteStatus s) {
    String ret = 'Sans statut';
    if(_statusNames.containsKey(c) && _statusNames[c]!.containsKey(s)) {
      ret = _statusNames[c]![s]!;
    }
    return ret;
  }

  static List<String> benefits(Caste c, CasteStatus s) {
    var ret = <String>[];
    if(_benefits.containsKey(c)) {
      for(var i = CasteStatus.apprenti.index; i <= s.index; ++i) {
        var status = CasteStatus.values[i];
        if(_benefits[c]!.containsKey(status)) {
          ret.add(_benefits[c]![status]!);
        }
      }
    }
    return ret;
  }

  static List<CasteTechnique> techniques(Caste c, CasteStatus s) {
    var ret = <CasteTechnique>[];
    if(_techniques.containsKey(c)) {
      for(var i = CasteStatus.apprenti.index; i <= s.index; ++i) {
        var status = CasteStatus.values[i];
        if(_techniques[c]!.containsKey(status)) {
          ret.add(_techniques[c]![status]!);
        }
      }
    }
    return ret;
  }

  static final Map<Caste, Map<CasteStatus, String>> _statusNames = {
    Caste.artisan: {
      CasteStatus.apprenti: 'Apprenti',
      CasteStatus.initie: 'Compagnon',
      CasteStatus.expert: 'Artisan',
      CasteStatus.maitre: 'Maître artisan',
      CasteStatus.grandMaitre: 'Grand maître artisan',
    },
    Caste.combattant: {
      CasteStatus.apprenti: 'Apprenti',
      CasteStatus.initie: 'Spadassin',
      CasteStatus.expert: 'Combattant',
      CasteStatus.maitre: "Maître d'armes",
      CasteStatus.grandMaitre: "Grand maître d'armes",
    },
    Caste.commercant: {
      CasteStatus.apprenti: 'Marchand',
      CasteStatus.initie: 'Commerçant',
      CasteStatus.expert: 'Négociant',
      CasteStatus.maitre: 'Dignitaire',
      CasteStatus.grandMaitre: 'Prince marchand',
    },
    Caste.erudit: {
      CasteStatus.apprenti: 'Apprenti',
      CasteStatus.initie: 'Initié',
      CasteStatus.expert: 'Érudit',
      CasteStatus.maitre: 'Sage',
      CasteStatus.grandMaitre: 'Prophète',
    },
    Caste.mage: {
      CasteStatus.apprenti: 'Apprenti',
      CasteStatus.initie: 'Initié',
      CasteStatus.expert: 'Mage',
      CasteStatus.maitre: 'Grand mage',
      CasteStatus.grandMaitre: 'Grand maître',
    },
    Caste.prodige: {
      CasteStatus.apprenti: 'Premier statut',
      CasteStatus.initie: 'Deuxième statut',
      CasteStatus.expert: 'Troisème statut',
      CasteStatus.maitre: 'Quatrième statut',
      CasteStatus.grandMaitre: 'Cinquième statut',
    },
    Caste.protecteur: {
      CasteStatus.apprenti: 'Soldat',
      CasteStatus.initie: 'Lieutenant',
      CasteStatus.expert: 'Capitaine',
      CasteStatus.maitre: 'Commandeur',
      CasteStatus.grandMaitre: 'Commandeur-Dragon',
    },
    Caste.voyageur: {
      CasteStatus.apprenti: 'Marcheur',
      CasteStatus.initie: 'Pisteur',
      CasteStatus.expert: 'Voyageur',
      CasteStatus.maitre: 'Solitaire',
      CasteStatus.grandMaitre: 'Orphelin',
    },
  };

  static final Map<Caste, Map<CasteStatus, String>> _benefits = {
    Caste.artisan: {
      CasteStatus.apprenti: "Le personnage peut développer une Spécialisation de Technique.",
      CasteStatus.initie: "Le personnage peut développer la Discipline de magie, Sorcellerie, comme si elle lui était réservée ainsi qu'une Sphère en rapport avec son artisanat principal, du moment qu’il trouve un professeur.",
      CasteStatus.expert: "Chaque fois qu’il fait appel aux Tendances, le personnagep eut dépenser 1 Point de Chance pour relancer le dé de l'Homme.",
      CasteStatus.maitre: "Le personnage peut apprendre les sorts de Magie instinctive et de Sorcellerie au même coût que les mages.",
      CasteStatus.grandMaitre: "À chacun de ses jets, le personnage lance et conserve un dé supplémentaire de l'Homme qui ne lui rapporte aucun Point de Tendance, et ce quelle que soit son affiliation.",
    },
    Caste.combattant: {
      CasteStatus.apprenti: "Le personnage peut développer une Spécialisation de Combat.",
      CasteStatus.initie: "Le personnage peut posséder jusqu’à trois Spécialisations : deux de Combat et une d’une autre catégorie.",
      CasteStatus.expert: "Le personnage peut porter une attaque supplémentaire sans pénalité à chaque tour de combat.",
      CasteStatus.maitre: "Lorsqu’il combat un adversaire maniant une arme utilisant la même Compétence que celle dans laquelle (ou lesquelles) il s’est spécialisé, le personnage gagne un bonus de 2 à tous ses jets d'attaque et de parade.",
      CasteStatus.grandMaitre: "La Difficulté de tous les jets de combat est réduite de 5 lorsque le personnage utilise son arme de prédilection. De plus, il ne peut être ni désarmé, ni abusé par une feinte d’arme de la même famille que la sienne.",
    },
    Caste.commercant: {
      CasteStatus.apprenti: "Le personnage débute sa carrière avec une somme de 500 dracs d'argent et peut développer une Spécialisation de Communication ou de Manipulation.",
      CasteStatus.initie: "Le personnage dispose d'un petit comptoir marchand, situé dans ume cité de son choix, et de quelques apprentis capables de gérer son commerce en son absence.",
      CasteStatus.expert: "Le personnage connaît le nom et les principales caractéristiques de toutes les compagnies commerciales, guildes et factions marchandes de son royaume. Dans le cas d’un groupe récemment créé, il peut effectuer un jet de Social + Vie en cité contre une Difficulté de 15, ou de 20, dans le cas d'une compagnie secrète, pour obtenir ces mêmes informations.",
      CasteStatus.maitre: "Pour tous ses jets de Social ou de Manuel, le personnage lance un dé supplémentaire de l'Homme qu'il peut choisir de conserver à la place de n'importe quel autre. De plus, il gagne un bonus de 1 à tous ses jets de Social effectués dans sa cité d’origine, ou dans celle où se trouve son comptoir principal.",
      CasteStatus.grandMaitre: "Le personnage est à ce point psychologue qu’il sait toujours si on lui ment. En réussissant un jet de Social + Empathie contre une Difficulté de 15, ou de 20 pour un dragon, il peut également apprendre la vérité sans le montrer à son interlocuteur.",
    },
    Caste.erudit: {
      CasteStatus.apprenti: "Le personnage peut se spécialiser dans une Compétence Mentale de son choix.",
      CasteStatus.initie: "Le personnage dispose d'un certain prestige et peut influer sur les convictions des citoyens de statut inférieur ou égal au sien. En engageant une discussion philosophique d’une heure, il peut dépenser deux cercles d’une Tendance pour déplacer chez son interlocuteur un cercle d’une Tendance vers celle qu’il a dépensé.",
      CasteStatus.expert: "Le personnage lance pour tous ses jets de Mental un dé neutre supplémentaire qu’il rajoute au résultat du dé choisi.",
      CasteStatus.maitre: "Le personnage est considéré comme un disciple d'Ozyr. À ce titre, il représente la sagesse et la connaissance du Grand Dragon des Océans, et peut être consulté lors des discussions de la plus grande importance - conseils de guerre, alliances politiques, etc.",
      CasteStatus.grandMaitre: "Le personnage est autorisé à consulter les écrits de n’importe quelle bibliothèque draconique. Lorsqu'il y fait des recherches, la Difficulté de tous les jets impliquant des Compétences Théoriques est réduite de 5.",
    },
    Caste.mage: {
      CasteStatus.apprenti: "Le personnage peut lire les matrices magiques et déchiffrer les bracelets de mage pour en reconnaître les domaines d’influence grâce à leurs couleurs, leurs matières, leurs gravures, etc. Il peut développer une Spécialisation de Combat ou de Théorie.",
      CasteStatus.initie: "En réussissant un jet de Mental + Intelligence contre une Difficulté de 15, le personnage peut reconnaître un sort lancé par un autre mage. Si le sort utilise sa Sphère privilégiée, la Difficulté de ce jet est réduite de 5.",
      CasteStatus.expert: "Le personnage est désormais autorisé à concevoir ses propres sorts, à les enseigner et à créer des matrices magiques pour répandre son savoir. Ce bénéfice évite ainsi que de trop jeunes mages ne s'essayent à la dangereuse conception d'un sort.",
      CasteStatus.maitre: "Le personnage ajoute le niveau de chacune de ses Sphères à tous ses jets de défense contre des sorts utilisant la Sphère correspondante.",
      CasteStatus.grandMaitre: "Le personnage est immunisé aux effets des sorts de niveau 1 de sa Sphère privilégiée (à choisir lors de son accession à ce Statut parmi les Sphères ayant le score le plus haut).",
    },
    Caste.prodige: {
      CasteStatus.apprenti: "Le personnage est capable de communiquer par télépathie avec n'importe quelle créature draconique et peut développer une Spécialisation de son choix.",
      CasteStatus.initie: "Du moment qu’il peut plonger son regard dans les yeux d’un être vivant, le personnage peut définir avec précision la valeur de sa Tendance Dragon. Aucun jet n’est nécessaire, mais le personnage doit pouvoir établir un contact visuel suffisant.",
      CasteStatus.expert: "Lorsqu'il est confronté à un dragon, le personnage est toujours capable de déterminer avec précision sa tranche d'âge, sa lignée et ses principaux traits de caractère. Si le dragon est sous forme humaine, le personnage doit effectuer un jet de Mental + Empathie contre une Difficulté de 15 pour comprendre.",
      CasteStatus.maitre: "Porteur de l'héritage de Solyr, le premier Prodige, le personnage est à ce point respecté qu’aucun dragon n’ose plus s'attaquer physiquement à lui - excepté les fils de Kalimsshar. Cette relative “immunité” n'exclut pas le fait qu'un dragon tente de lui nuire, de façon beaucoup plus subtile, ou de s'en prendre à ses compagnons.",
      CasteStatus.grandMaitre: "Une fois par jour, en procédant à une méditation collective, le personnage peut effacer tous ses cercles de Tendance Dragon pour réduire à zéro la Tendance Homme ou Fatalité d’un individu consentant.",
    },
    Caste.protecteur: {
      CasteStatus.apprenti: "Le personnage peut porter un bouclier dragon et développer une spécialisation de Combat.",
      CasteStatus.initie: "Le personnage peut donner des ordres aux protecteurs de Statut inférieur et demander l'octroi d'hommes de troupe pour effectuer des missions précises. Le nombre maximum de ces renforts est égal à deux fois la Compétence Commandement du personnage, et il ne peut s'agir que de protecteurs de Statut strictement inférieur.",
      CasteStatus.expert: "Le personnage est autorisé à prendre les mesures qu’il juge nécessaires pour faire respecter les Lois draconiques au sein d’une cité.",
      CasteStatus.maitre: "Le personnage est chargé de l'autorité draconique et peut faire appliquer la loi sur l’ensemble de Kor. De plus, lorsqu'il prend le commandement d’une unité, tous les hommes qui suivent ses ordres gagnent un bonus de 2 à toutes leurs actions de combat. Ce bonus n’est applicable que si le personnage participe activement au combat.",
      CasteStatus.grandMaitre: "L'importance du personnage aux yeux de Brorne lui permet de monter n'importe quel dragon de pierre à qui il en fait la demande, du moment que la raison de cette demande est fondée. S'il participe à une bataille à dos de dragon, tous les hommes que compte son armée gagnent un bonus de 8 à leurs actions de combat.",
    },
    Caste.voyageur: {
      CasteStatus.apprenti: "S’il dispose d’une carte, le personnage peut déterminer le meilleur itinéraire pour relier deux points, estimer la durée du voyage et la présence possible d’auberges et de haltes. Le personnage peut développer une Spécialisation de Mouvement ou de Théorie.",
      CasteStatus.initie: "Du moment qu’il a déjà visité un endroit ou emprunté une route, le personnage est capable de se repérer sans aucun risque de se perdre - les conditions de voyage extrêmes ne feront que ralentir sa progression.",
      CasteStatus.expert: "Chaque fois qu’il entre en territoire inconnu (cité, région, fleuve, etc.), le personnage comprend d'instinct certaines caractéristiques propres à ce lieu. En réussissant un jet de Mental + Empathie contre une Difficulté de 5, il peut apprendre une information par NR (type de gouvernement, présence de dragons, cavités souterraines, etc.). Ce bénéfice ne peut être utilisé que pour des zones géographiques relativement vastes - et non des habitations ou des structures réduites.",
      CasteStatus.maitre: "Le personnage est tellement habitué aux voyages que sa présence n’est plus considérée comme une menace par les animaux sauvages - qui ne l’attaquent plus. Au sein d'un groupe, la présence du personnage suffira à tenir en respect des prédateurs et des meutes. Cet avantage ne concerne pas les créatures magiques et/ou intelligentes.",
      CasteStatus.grandMaitre: "Le personnage ne dort jamais que d’un œil, mais son sommeil est incroyablement réparateur. Le moindre bruit suffit à le réveiller et une simple impression de danger mettra instantanément ses sens en alerte. Après une nuit de sommeil complète, le personnage peut dépenser des Points de Chance pour effacer autant de cases de blessure de n'importe quel type. Ces Points de Chance ne peuvent être regagnés avant d’avoir passé une seconde nuit de sommeil.",
    },
  };

  static final Map<Caste, Map<CasteStatus, CasteTechnique>> _techniques = {
    Caste.artisan: {
      CasteStatus.apprenti: CasteTechnique(
        title: "D'un compagnon à l'autre",
        description: "En réussissant un jet de Mental + Artisanat approprié contre une Difficulté de 10, le personnage peut déterminer l’âge, la qualité et le mode de fonctionnement de tout objet manufacturé. Chaque NR lui confère une information supplémentaire.",
      ),
      CasteStatus.initie: CasteTechnique(
        title: "La voie du progrès",
        description: "En réussissant un jet de Mental + Coordination contre une Difficulté de 10, le personnage peut comprendre le fonctionnement et utiliser n'importe quel objet mécanique comme s'il possédait la Compétence appropriée à un niveau égal à la moitié de son Attribut Manuel (arrondi au supérieur).",
      ),
      CasteStatus.expert: CasteTechnique(
        title: "L'essence de l'art",
        description: "Le personnage à la capacité d'améliorer des objets manufacturés dont il possède une connaissance précise. Il doit tout d’abord effectuer un jet d’Intelligence + Artisanat approprié contre une Difficulté de 5 pour déterminer le temps de travail nécessaire.\nLa durée initiale est de 30 + 1D10 jours, mais chaque NR réduit ce délai de 10 jours. Ensuite, il doit réussir un jet de Manuel + Empathie contre une Difficulté de 15 pour conférer à l’objet un bonus définitif égal à 1 + nombre de NR. Ce bonus peut s'appliquer à l’efficacité ou à la maniabilité d’une arme (bonus aux dommages ou au toucher), ainsi qu’à toutes sortes d'outils, d'instruments et de mécanismes connus du personnage. Une seule amélioration du même type est possible par arme, et chaque nouvelle amélioration augmente de 5 la Difficulté des deux jets.",
      ),
      CasteStatus.maitre: CasteTechnique(
        title: "L'esquisse du destin",
        description: "La maîtrise du personnage est telle qu’il peut inventer des méthodes de travail auxquelles nul n'aurait jamais songé. Il doit pour cela réussir un jet d’Intelligence + Compétence contre une Difficulté de 15 pour chaque Compétence nécessaire à la réalisation de l'objet (par exemple, Armes mécaniques et Forge pour créer une arbalète). La somme de tous les NR vient ensuite s'ajouter en bonus au jet de Manuel + Compétence d'Artisanat que 1e joueur doit réussir contre une Difficulté variant en fonction de la complexité, de la taille et de l'efficacité de l'objet. Si un seul de ces jets est raté, la création échoue.",
      ),
      CasteStatus.grandMaitre: CasteTechnique(
        title: "La force du rouage",
        description: "En dépensant 1 Point de Maîtrise, le personnage peut utiliser son Attribut Manuel à la place de n'importe quel autre Attribut. Si le jet est réussi, il ne regagne aucun Point de Maîtrise.",
      ),
    },
    Caste.combattant: {
      CasteStatus.apprenti: CasteTechnique(
        title: "L'œil du maître",
        description: "En réussissant un jet de Mental + Compétence d’arme de l'adversaire contre une Difficulté de 10, le personnage peut déterminer si le niveau de Compétence de son adversaire est inférieur, supérieur où égal au sien. Chaque Niveau de Réussite peut lui donner une indication sur la technique utilisée (botte secrète, Technique spéciale, etc.).",
      ),
      CasteStatus.initie: CasteTechnique(
        title: "La main du maître",
        description: "Une fois par combat, le personnage peut ajouter la valeur de son Attribut Physique au résultat de l’un de ses dés d’Initiative, du moment qu’il annonce l’utilisation de cette Technique avant de lancer ses dés.",
      ),
      CasteStatus.expert: CasteTechnique(
        title: "La puissance du maître",
        description: "Lorsqu'il combat avec une arme dans laquelle il s’est spécialisé, le personnage lance un dé supplémentaire pour déterminer les dommages.",
      ),
      CasteStatus.maitre: CasteTechnique(
        title: "La voie du maître",
        description: "Lorsqu'il combat, le personnage n’est pas soumis à la règle des Tendances et peut conserver n'importe quel dé sans gagner ni perdre de Points de Tendance (sauf dans le cas d'une réussite critique).",
      ),
      CasteStatus.grandMaitre: CasteTechnique(
        title: "La maîtrise parfaite",
        description: "Le personnage ne peut subir d’échec critique lorsqu'il utilise son arme de prédilection. Tous les “1” obtenus sur un jet de combat sont donc relancés.",
      ),
    },
    Caste.commercant: {
      CasteStatus.apprenti: CasteTechnique(
        title: "Le sourire accueillant",
        description: "En réussissant um jet de Social + Empathie contre une Difficulté de 15, le personnage peut deviner ce qui amène un individu dans la ville où il se trouve. Si cette raison est secrète, le personnage doit réussir un jet de Social + Présence contre une Difficulté de 20 pour obtenir la même information.",
      ),
      CasteStatus.initie: CasteTechnique(
        title: "Reconnaître son erreur",
        description: "Une fois par jour, en dépensant tous ses Points de Chance restants (minimum 1), le personnage peut transformer un échec critique en un échec simple.",
      ),
      CasteStatus.expert: CasteTechnique(
        title: "L'examen de conscience",
        description: "Chaque fois qu’il le désire, le personnage peut effacer tous ses cercles de Tendance, du moment qu’il vient de faire une bonne affaire.",
      ),
      CasteStatus.maitre: CasteTechnique(
        title: "Une technique éprouvée",
        description: "Une fois par jour, en dépensant 3 Points de Chance, le personnage peut doubler la valeur de son Attribut Manuel ou Social pour effectuer une action. Aucun Point de Maîtrise ou de Chance ne peut être regagné de cette façon.",
      ),
      CasteStatus.grandMaitre: CasteTechnique(
        title: "Le bénéfice du doute",
        description: "Une fois par jour, le personnage peut effacer de la mémoire d’un individu tout souvenir le concernant, du moment qu’il n'a eu aucun contact physique avec cette personne. La durée du souvenir ne peut excéder un nombre de minutes égal à la valeur de l’Attribut Social du personnage. Une fois “l’entretien” terminé, l'individu ne se doute même pas qu’il a rencontré le personnage.",
      ),
    },
    Caste.erudit: {
      CasteStatus.apprenti: CasteTechnique(
        title: "La lettre et le nom",
        description: "Du moment qu’il a déjà lu un écrit, le personnage est capable d’en reconnaître l'auteur sans effectuer le moindre jet.",
      ),
      CasteStatus.initie: CasteTechnique(
        title: "La rune et le secret",
        description: "En réussissant un jet de Mental + Lire et écrire contre une Difficulté de 15, le personnage peut déterminer l'origine, la date ou le sens général de n'importe quel ouvrage écrit y compris les symboles, les runes et les motifs divers). Chaque NR lui donne une de ces trois informations.",
      ),
      CasteStatus.expert: CasteTechnique(
        title: "L'homme et l'Étoile",
        description: "Par son seul regard, le personnage peut déterminer siun individu est touché par une Étoile. En réussissant un jet de Mental + Empathie contre une Difficulté de 10, il peut découvrir une des Motivations de l’Étoile pour chaque NR.",
      ),
      CasteStatus.maitre: CasteTechnique(
        title: "Le livre et le temps",
        description: "Une fois par jour, en réussissant un jet de Mental + Chance contre une Difficulté de 15, le personnage peut se souvenir d’un texte et obtenir des informations sur n'importe quel sujet traité par l'écrit (histoire, légende, géographie, science, etc.).",
      ),
      CasteStatus.grandMaitre: CasteTechnique(
        title: "L'homme et le destin",
        description: "Le personnage est tellement en phase avec le monde qu'il peut lire dans le destin comme dans un livre. Une fois par jour, il peut interroger les astres pour obtenir une réponse à l'une des questions qu'il se pose sur son avenir ou celui de ses compagnons.",
      ),
    },
    Caste.mage: {
      CasteStatus.apprenti: CasteTechnique(
        title: "La matière",
        description: "Pour chaque Sphère qu'il maîtrise, le personnage peut faire apparaître, une fois par jour, un petit volume d’élément qu’il pourra ensuite façonner ou utiliser à sa guise. Il peut s'agir d’une petite flamme, d'une poignée de terre, d’un litre d’eau pure, etc.",
      ),
      CasteStatus.initie: CasteTechnique(
        title: "L'esprit",
        description: "Chaque jour, le personnage dispose de deux NR gratuits qu’il peut utiliser pour augmenter les effets de n'importe quel sort (portée, dommages, précision, etc.). Ces bonus peuvent s'appliquer sur deux sorts différents ou pour améliorer deux effets d’un même sort. S'ils ne sont pas dépensés, ils sont tout simplement perdus.",
      ),
      CasteStatus.expert: CasteTechnique(
        title: "La volonté",
        description: "En dépensant 2 Points de Maîtrise et 2 Points de Magie, le personnage peut lancer et conserver un dé supplémentaire pour effectuer n'importe quel jet de Discipline magique. Ce dé neutre n’est pas concerné par la règle des Tendances.",
      ),
      CasteStatus.maitre: CasteTechnique(
        title: "La flamme",
        description: "Une fois par combat, le personnage peut lancer un sort de Magie instinctive sans dépenser aucun Point de Magie.",
      ),
      CasteStatus.grandMaitre: CasteTechnique(
        title: "La source",
        description: "Une fois par jour, le personnage peut puiser dans sa Réserve personnelle de Points de Magie pour soigner des blessures, à raison d’une case de blessure par Point de Magie. Les points dépensés de cette façon ne peuvent être regagnés avant le prochain lever du soleil - quel que soit le moyen utilisé (méditation, rituel, etc.).",
      ),
    },
    Caste.prodige: {
      CasteStatus.apprenti: CasteTechnique(
        title: "La source de vie",
        description: "Une fois par jour, en imposant ses mains sur les plaies, le personnage peut soigner toutes les blessures légères d'un être humain ou d’un animal. Aucun jet n’est nécessaire, mais il faut quelques minutes avant que les maux ne disparaissent totalement.",
      ),
      CasteStatus.initie: CasteTechnique(
        title: "Le feu intérieur",
        description: "Une fois par tour, lorsqu'il combat à mains nues ou avec une arme contondante, le personnage peut ajouter le triple de la valeur de sa Tendance Dragon aux dommages d’une de ses attaques.",
      ),
      CasteStatus.expert: CasteTechnique(
        title: "La clarté de l'esprit",
        description: "Chaque fois qu’il est victime d’un sort offensif, le personnage peut tenter de résister à tous les effets en réussissant un jet de Mental + Volonté contre une Difficulté de 10 + 5 par niveau du sort.",
      ),
      CasteStatus.maitre: CasteTechnique(
        title: "Le cycle primordial",
        description: "En dépensant définitivement 1 point de Résistance ou de Volonté, le personnage peut (se) faire repousser miraculeusement un membre détruit ou coupé. Il est impossible de faire repousser une tête de cette façon.",
      ),
      CasteStatus.grandMaitre: CasteTechnique(
        title: "Le serment de la Terre",
        description: "En perdant définitivement 1 Point de Tendance Dragon, le personnage peut détruire une créature vivante corrompue par Kalimsshar ou l’Humanisme, qu’il s'agisse d'un être humain, d’un monstre ou d'un dragon. Le Prodige doit impérativement établir un contact physique avec la créature visée. Une fois dépensé, le Point de Tendance ne peut être regagné qu’au prix de longues quêtes et d'épreuves draconiques supervisées par un fils de Heyra - ou le dragon auquel est lié le personnage.",
      ),
    },
    Caste.protecteur: {
      CasteStatus.apprenti: CasteTechnique(
        title: "L'écaille du dragon",
        description: "Si son jet de parade au bouclier est réussi contre la Difficulté de base, le personnage gagne automatiquement un Niveau de Réussite supplémentaire.",
      ),
      CasteStatus.initie: CasteTechnique(
        title: "La cuirasse du dragon",
        description: "Chaque fois qu’il effectue une parade au bouclier, le personnage peut dépenser des Points de Maîtrise APRÈS son jet pour réussir sa défense, mais ne peut obtenir au maximum qu’autant de NR que l'attaquant.",
      ),
      CasteStatus.expert: CasteTechnique(
        title: "Le souffle du dragon",
        description: "Lorsque le personnage choisit le dé du Dragon au cours d'un combat, il gagne automatiquement un NR supplémentaire, et ce, quelle que soit l’action, si son jet est réussi.",
      ),
      CasteStatus.maitre: CasteTechnique(
        title: "Le sang du dragon",
        description: "Deux fois par jour, le personnage peut effectuer un jet d'Empathie + 1D10 contre une Difficulté de 0 pour guérir une case de blessure (de son choix) par NR à lui ou une cible de son choix, tant que cette dernière peut entendre ses exhortations et ses encouragements.",
      ),
      CasteStatus.grandMaitre: CasteTechnique(
        title: "Le don draconique",
        description: "En dépensant définitivement 1 point de Résistance, le personnage peut rappeler à la vie n'importe quel être humain possédant au moins 3 en Tendance Dragon.",
      ),
    },
    Caste.voyageur: {
      CasteStatus.apprenti: CasteTechnique(
        title: "À la croisée des chemins",
        description: "En réussissant un jet de Mental + Empathie contre une Difficulté de 10, le personnage peut comprendre le sens général de n'importe quelle phrase prononcée en langue inconnue. De plus, en réussissant un second jet, identique, il peut faire comprendre quelques mots à son interlocuteur et échanger de brèves informations.",
      ),
      CasteStatus.initie: CasteTechnique(
        title: "Porté par le vent",
        description: "En dépensant tous ses Points de Chance restant (minimum 1), le personnage peut se jeter à terre et éviter n'importe quelle attaque. La Difficulté de toutes ses actions pour le tour suivant sera augmentée de 5 et le personnage ne pourra regagner aucun Point de Chance durant le reste du combat.",
      ),
      CasteStatus.expert: CasteTechnique(
        title: "Projectile cardinal",
        description: "Une fois par tour, s’il utilise une arme de distance (de jet ou à projectiles), le personnage peut renoncer à ses actions pour ne lancer qu’un seul projectile, dont les dommages seront doublés. Pour bénéficier de cet avantage, le personnage doit annoncer l’utilisation de sa Technique avant de déterminer son Initiative. Il conserve ensuite ses dés d'actions devant lui jusqu’à ce qu’il décide de lancer son projectile. Aucune action de défense n’est possible durant ce tour.",
      ),
      CasteStatus.maitre: CasteTechnique(
        title: "Le couvert de la nuit",
        description: "En utilisant les éléments de décor environnants, le personnage peut se rendre si discret que nul ne remarquera sa présence. S'il reste immobile, aucun jet n’est nécessaire. S'il se déplace, sa progression est limitée à sa Coordination en mêtres par tour et tous les individus présents dans un rayon de 15 mètres ont droit à un jet de Mental + Perception contre une Difficulté de 20 pour tenter de repérer la présence du personnage. Ce jet doit être effectué à chaque tour où le personnage se déplace. La Difficulté de ce jet peut être augmentée ou diminuée de 5 en fonction du décor. Le personnage est immédiatement repéré s’il effectue une action agressive ou bruyante, mais s’il parvient à moins de 5 mètres d’un adversaire, il peut porter une attaque dont la Difficulté sera réduite de 10. Aucune défense n’est possible.",
      ),
      CasteStatus.grandMaitre: CasteTechnique(
        title: "L'œil du fou",
        description: "Sans modifier son apparence, le personnage est capable de tromper n'importe quel interlocuteur humain en se faisant passer pour un individu qu’il connaît - ou qu’il invente. La victime de l'illusion est persuadée de faire face à l’homme ou la femme incarnée par le personnage. Aucun jet n'est possible pour deviner la supercherie.",
      ),
    },
  };
}

enum CasteInterdict {
  loiDuCompagnon(
    caste: Caste.artisan,
    title: 'La Loi du Compagnon',
    description: "Tu transmettras ton savoir. S'il est bien un point sur lequel artisans et érudits peuvent s'entendre, c’est la nécessité de la transmission du savoir et l’enseignement des techniques qu'ils utilisent chaque jour. Ainsi, on attend toujours d’un artisan qu’il apporte des explications sur ce qu'il fait et la façon dont il le fait.",
  ),
  loiDeLaPerfection(
    caste: Caste.artisan,
    title: 'La Loi de la Perfection',
    description: "Tu rechercheras toujours l’œuvre ultime. Tout artisan ne recherchant pas la perfection dans son œuvre perd peu à peu son lien avec la matière et ne pourra plus jamais créer d'œuvres exceptionnelles et encore moins enchantées.",
  ),
  loiDuRespect(
    caste: Caste.artisan,
    title: 'La Loi du Respect',
    description: "Tu respecteras la matière que tu travailles et les œuvres d’autrui. Il est bien entendu essentiel d'aimer la matière. Au fur et à mesure qu’un artisan se désintéresse du produit qu’il façonne, la matière devient de plus en plus difficile à travailler et prend des formes de plus en plus laides. On raconte que certains artisans et sorciers de l'ombre transgresseraient cette Loi volontairement pour donner à leurs œuvres un aspect tourmenté.",
  ),
  loiDeLArme(
    caste: Caste.combattant,
    title: "La Loi de l'Arme",
    description: "Tu respecteras ton Statut. La plus ancienne des traditions de la caste interdit aux combattants de porter plus d'armes que ne leur permet leur rang - c’est-à-dire une arme par Statut obtenu.",
  ),
  loiDeLHonneur(
    caste: Caste.combattant,
    title: "La Loi de l'Honneur",
    description: "Tu honoreras ton arme. La notion du respect s'applique autant à l’arme que manie le combattant qu'à son adversaire. Il est donc interdit de se mesurer à plus faible que soi et de compromettre son arme dans un combat non équitable.",
  ),
  loiDuSangCombattant(
    caste: Caste.combattant,
    title: 'La Loi du Sang (Combattant)',
    description: "Tu ne chercheras que la victoire. Le code de l'honneur des combattants interdit aux membres de la caste d'achever un adversaire qui a d’ores et déjà perdu un combat, qu’il s'agisse d’un duel comme d’une véritable bataille.",
  ),
  loiDuCoeur(
    caste: Caste.commercant,
    title: 'La Loi du Cœur',
    description: "Tu respecteras la parole donnée. Bien qu'habitués à mentir, ou tout du moins à présenter certains éléments sous leur jour le plus attrayant, les commerçants ont pour tradition de respecter leurs engagements une fois pris et d'honorer la confiance qu'on leur témoigne.",
  ),
  loiDeLOrdre(
    caste: Caste.commercant,
    title: "La Loi de l'Ordre",
    description: "Tu respecteras l’ordre établi. Sans ordre, il n’y a pas de prospérité possible. Il est nécessaire de lutter contre l’anarchie et, donc, contre tous ceux qui voudraient développer des activités commerciales indépendantes des organisations.",
  ),
  loiDuProgres(
    caste: Caste.commercant,
    title: 'La Loi du Progrès',
    description: "Tu ne manqueras aucune occasion de faire progresser la société. Une société qui stagne est une société mourante. Un commerçant se doit de ne jamais repousser une idée. Il se doit de toujours trouver comment améliorer ses affaires et celles des autres.",
  ),
  loiDuSavoir(
    caste: Caste.erudit,
    title: 'La Loi du Savoir',
    description: "Tu partageras tes découvertes. La tradition primordiale de la caste pousse les érudits à mettre leurs connaissances en commun, à comparer leurs découvertes et à aider leurs confrères à évoluer dans la voie qu'ils ont choisie. De ce fait, un personnage ne peut refuser de révéler ce qu’il sait à un autre érudit qui lui en fait la demande. Cet Interdit ne concerne bien évidemment que les découvertes “académiques” du personnage, et non ses secrets personnels.",
  ),
  loiDuCollege(
    caste: Caste.erudit,
    title: 'La Loi du Collège',
    description: "Tu agiras dans la concertation. L'habitude qu'ont les érudits de débattre continuellement avec leurs confrères se traduit, chez ceux qui quittent un jour les académies où îls ont parfait leur éducation, par une incapacité de prendre des initiatives sans demander conseil. Le personnage devra donc référer à ses compagnons des moindres actions qu’il souhaite entreprendre et, d’une façon plus générale, ne cacher aucune de ses découvertes susceptibles d’orienter la conduite de son groupe.",
  ),
  loiDuSecret(
    caste: Caste.erudit,
    title: 'La Loi du Secret',
    description: "Tu ne partageras pas l’art interdit. Si tous les érudits s'intéressent de près ou de loin au développement des sciences chiffrées, qui sont l'apanage des Humanistes, rares sont ceux qui tolèrent leur enseignement au commun des mortels. Cet Interdit empêche le personnage de divulguer les secrets des techniques proscrites par les Dragons : sciences, art du mécanisme, conception d'explosifs, etc.",
  ),
  loiDuPacte(
    caste: Caste.mage,
    title: 'La Loi du Pacte',
    description: "Tu n'abuseras pas de ta force. La plus ancienne tradition des mages est de louer le don de Nenya, le Grand Dragon de la Magie, en n’utilisant leurs terribles pouvoirs qu’en cas de nécessité. De ce fait, un mage qui abuse outrageusement de sa magie risque de s’attirer les foudres de son collège, ainsi que de tous les autres mages, pour qui la discrétion est mère d’humilité.",
  ),
  loiDuPartage(
    caste: Caste.mage,
    title: 'La Loi du Partage',
    description: "Tu dois transmettre ton savoir. La magie est un art demandant une grande coopération entre ceux qui l’étudient. Les mages se doivent de partager leurs découvertes avec leurs confrères mais aussi de transmettre leurs connaissances à des apprentis. Ceux qui se montrent trop secrets et trop égoïstes, ne recherchant bien souvent que le pouvoir pour servir leurs propres intérêts, sont dangereux pour la société et peuvent être traités comme des criminels.",
  ),
  loiDeLaPrudence(
    caste: Caste.mage,
    title: 'La Loi de la Prudence',
    description: "Tu te dois d'être vigilant. La magie est une force dangereuse qui nécessite une très grande prudence pour ne pas mettre en danger des innocents. Ainsi, un mage ne doit pas tenter d’expériences dangereuses dans des endroits peuplés et doit assumer toutes les conséquences de ses actes. Ceux qui pratiquent la magie sans se soucier des conséquences que leur art peut entraîner chez les autres peuvent être bannis des écoles.",
  ),
  loiDeLaMeditation(
    caste: Caste.prodige,
    title: 'La Loi de la Méditation',
    description: "Tu te dois de réfléchir à ce que tu vois et à ce que tu fais. Le Prodige se doit de réfléchir à ce que lui ou un autre fait, a fait et fera. Toute action entraîne obligatoirement une réaction. Il faut donc penser avant d'agir mais aussi assumer toutes les conséquences d’une décision. Les actes irréfléchis rompent le lien qui existe entre un Prodige et la nature.",
  ),
  loiDeLaNature(
    caste: Caste.prodige,
    title: 'La Loi de la Nature',
    description: "Tu te dois de respecter la nature sous toutes ses formes, animées ou inanimées. La nature se comprend dans sa globalité. Montagnes, fleuves, forêts et plaines en sont une partie intégrante au même titre que l’homme, le dragon ou l'animal. Ne voir qu’un aspect de la nature en ignorant les autres revient à ne plus percevoir l’œuvre de Heyra.",
  ),
  loiDuSangProdige(
    caste: Caste.prodige,
    title: 'La Loi du Sang (Prodige)',
    description: "Tu ne verseras pas le sang. La plus ancienne tradition de Heyra interdit à ses fidèles de souiller la Terre du sang de toute forme de vie consciente, qu’il s'agisse d’un être humain ou d’un animal. C’est sans doute pourquoi la majorité des Prodiges manient les armes contondantes et usent de leur force physique pour se défendre des dangers quotidiens.",
  ),
  loiDuLien(
    caste: Caste.protecteur,
    title: 'La Loi du Lien',
    description: "Tu ne trahiras pas les Grands Dragons. Fidèles aux Lois draconiques, les protecteurs sont soumis à l’autorité directe des Grands Dragons et de leurs représentants. C’est pourquoi ils ne peuvent ni mentir, ni désobéir, ni cacher des informations ou tenter quelque action néfaste que ce soit à l'encontre des dragons et de leurs émissaires.",
  ),
  loiDuSacrifice(
    caste: Caste.protecteur,
    title: 'La Loi du Sacrifice',
    description: "Tu ne craindras pas la mort. On ne demande pas aux protecteurs de mourir en lieu et place d’un autre citoyen de Kor, mais uniquement de se porter au devant d’un danger le menaçant. Leur rôle de défenseur du royaume et de garant de la bonne marche des cités les contraint effectivement à courir le risque de mourir en combattant un danger qui ne leur était pas initialement destiné.",
  ),
  loiDuSangProtecteur(
    caste: Caste.protecteur,
    title: 'La Loi du Sang (Protecteur)',
    description: "Tu préserveras la vie. Chargés d'assurer la sécurité des cités, des routes, et des habitants de Kor, les protecteurs ont pour tradition de n'user de la force qu’en cas de nécessité absolue et, lorsque cette solution est encore possible, de lui préférer le dialogue et la conciliation. Cet Interdit n’est pas brisé lorsqu’un protecteur se défend d’une attaque, mais à chaque fois qu'il sort son arme avant d’avoir tenté de raisonner et d'arrêter officiellement un individu.",
  ),
  loiDeLAmitie(
    caste: Caste.voyageur,
    title: "La Loi de l'Amitié",
    description: "Tu ne refuseras pas ton aide. Habitués à la solitude de leurs errances, les voyageurs ont pour tradition de ne jamais refuser leur aide à un compagnon dans le besoin, qu’il s’agisse d'un membre de leur caste, d’un autre citoyen ou de n'importe quel être humain.",
  ),
  loiDeLaDecouverte(
    caste: Caste.voyageur,
    title: 'La Loi de la Découverte',
    description: "Tu te dois d'explorer l'inconnu. Un voyageur ne peut rester insensible à l’appel de l’inconnu. S'il entend parler d’un endroit inexploré, d'un vallon isolé ou d’un site légendaire, il se doit de tenter de le découvrir. C’est sa nature et, s’il n'y obéit pas, il perdra son Statut de voyageur.",
  ),
  loiDeLaLiberte(
    caste: Caste.voyageur,
    title: 'La Loi de la Liberté',
    description: "Tu dois refuser d’être enfermé. Un voyageur contraint à rester dans un même endroit meurt peu à peu. Il a besoin de liberté et de se déplacer. Emprisonné, enchaîné, il perd toute raison de vivre et dépérit.",
  ),
  ;

  final Caste caste;
  final String title;
  final String description;

  const CasteInterdict({ required this.caste, required this.title, required this.description });
}

enum CastePrivilege {
  apprenti(
    caste: Caste.artisan,
    title: 'Apprenti',
    description: "Permet de disposer d’un apprenti artisan qui, en plus de rendre de menus services au personnage, pourra s’occuper de son atelier en son absence, porter des messages, colporter des rumeurs et effectuer certaines tâches de base. L'apprenti doit être instruit et demandera un peu de temps et d’attention de la part de son maître. Au bout de quelques années, l’apprenti quittera le personnage pour se lancer seul.",
    cost: 3
  ),
  autorisation(
    caste: Caste.artisan,
    title: 'Autorisation',
    description: "Permet de pratiquer la mécanique pour réaliser des objets ou des machines d’intérêt public (engins de levage, horloges, roues de moulins, etc.). Ce Privilège ne permet pas de connaître la Compétence Mécanique (qui doit être apprise avec l’Avantage Art Interdit) mais simplement de la pratiquer de façon relativement libre. Le personnage dispose d’un sceau conféré par les maîtres de sa caste qui lui servira à marquer visiblement l’objet. Tous ses travaux dépendant de cette autorisation seront toujours validés par une commande transmise par la caste et validée par l’Inquisition.",
    cost: 4
  ),
  charteDAtelier(
    caste: Caste.artisan,
    title: "Charte d'atelier",
    description: "Permet de disposer d’une autorisation d'accès aux ateliers des artisans résidents. Elle se présente sous la forme d’une série de broderies apposées sur son tablier de sortie. Elles lui garantissent un accueil favorable chez ses confrères qui lui demanderont alors un dédommagement plus modique pour prêter un établi et quelques outils. Ce Privilège permet évidemment d’éviter les hausses de Difficulté dues à un matériel insuffisant. De plus, le personnage ne subira pas les allongements de délai de création dus au travail solitaire.",
    cost: 4
  ),
  ecole(
    caste: Caste.artisan,
    title: "École",
    description: "Permet au personnage d’avoir été formé dans une école réputée pour un type d’artisanat particulier. En choisissant ce Privilège, le personnage doit nommer un type précis d’objet - lames courtes, bagues, engrenages, etc. - dont la qualité de base sera toujours bonne, au minimum, lors de ses jets de Confection. Ainsi, le personnage gagne 2 Niveaux de Réussite “virtuels”, qui ne lui servent qu’à déterminer la qualité de sa création - mais qui modifient sensiblement le prix de vente et l’ajout d’éventuels enchantements.",
    cost: 4,
    unique: false,
    requireDetails: true
  ),
  elementalisme(
    caste: Caste.artisan,
    title: "Élémentalisme",
    description: "Permet au personnage de développer une affinité unique avec une Sphère de magie élémentaire de son choix. Contrairement aux citoyens de toutes les autres castes, ce personnage peut exceptionnellement développer son niveau de maîtrise d’une Sphère sans subir les multiplicateurs de Points d’Expérience - comme s’il était membre de la caste des mages. Ce Privilège n’est valable que pour une seule et unique Sphère et ne permet d’ignorer les multiplicateurs que jusqu’à un niveau égal à l’Attribut Mental du personnage + 2. Au-delà de cette valeur, le personnage peut continuer à développer cette Compétence, mais il subit les multiplicateurs.\nCe Privilège ne peut être choisi qu’une fois et ne peut pas se cumuler avec l’Avantage Magie naturelle pour une autre Sphère.",
    cost: 6,
    requireDetails: true
  ),
  familier(
    caste: Caste.artisan,
    title: 'Familier',
    description: "Permet de posséder un petit animal intelligent, généralement un oiseau ou un mammifère, capable d’échanger des émotions et des informations sommaires avec le personnage et de lui rendre quelques menus services (porter un outil, maintenir deux pièces ensemble, etc.).",
    cost: 1,
    unique: false,
    requireDetails: true
  ),
  notable(
    caste: Caste.artisan,
    title: 'Notable',
    description: "Permet de disposer d’une réputation et d’une clientèle de choix, de pouvoir compter sur l’aide de dignitaires locaux et d’être bien vu par un grand nombre de personnalités importantes de la ville et de ses environs.",
    cost: 3,
    requireDetails: true
  ),
  outils(
    caste: Caste.artisan,
    title: 'Outils',
    description: "Permet au personnage de disposer d'outils particulièrement efficaces et utilisés depuis longtemps, qui lui confèrent un bonus de 2 à toutes les actions en rapport avec son métier. Il appartient au meneur de jeu de restreindre les applications de ces outils, qui doivent logiquement être utilisables par un membre de la caste des artisans. Ils seront donc prioritairement utilisables avec des Compétences d'artisanat ou, plus largement, manuelles.",
    cost: 4
  ),
  psychometrie(
    caste: Caste.artisan,
    title: 'Psychométrie',
    description: "Permet, rien qu’en touchant un objet, d’en découvrir automatiquement la fonction, l’âge, l’origine géographique et le sexe du dernier propriétaire en date. En réussissant un jet de Manuel + Empathie contre une Difficulté de 10, le personnage peut obtenir, pour chaque NR, une réponse à une question supplémentaire concernant l’objet (nature magique de l’objet, dernière utilisation, etc.).",
    cost: 5
  ),
  reparationDeRoutine(
    caste: Caste.artisan,
    title: 'Réparation de routine',
    description: "Permet d’improviser une réparation de fortune pour les objets courants. Le personnage est habitué à utiliser les moyens du bord et s’en sortira même s’il lui manque certains matériaux. En effectuant un jet de Manuel + Coordination, il improvise une solution qui durera 1 + NR jours. Toute réparation de routine sur un objet en ayant déjà bénéficié se verra infliger un malus cumulatif de 5.",
    cost: 4
  ),
  symbiose1(
    caste: Caste.artisan,
    title: "Symbiose (trois conditions)",
    description: "Permet au personnage d’avoir appris à tirer profit de son environnement et de son cadre de travail pour créer dans les meilleures conditions de concentration possibles. Lorsqu’il choisit ce Privilège, le joueur doit choisir de dépenser 1, 3 ou 5 points, et nommer un certain nombre de “conditions”, en accord avec le meneur de jeu. Il en nomme trois pour 1 point, deux pour 3 points et une seule pour 5 points. Ensuite, chaque fois que toutes ces conditions seront réunies, le personnage pourra choisir de gagner automatiquement 1 Niveau de Réussite sur un jet réussi ou de disposer, avant d’effectuer son jet, d’un nombre de Points de Maîtrise gratuits égal à la valeur de son Attribut Manuel. Par “conditions”, on entend par exemple la proximité d’un cours d’eau, le silence absolu, l’exposition à l’air libre, l’obscurité totale, pour certaines formes de magie, etc.",
    cost: 1,
    requireDetails: true
  ),
  symbiose3(
    caste: Caste.artisan,
    title: "Symbiose (deux conditions)",
    description: "Permet au personnage d’avoir appris à tirer profit de son environnement et de son cadre de travail pour créer dans les meilleures conditions de concentration possibles. Lorsqu’il choisit ce Privilège, le joueur doit choisir de dépenser 1, 3 ou 5 points, et nommer un certain nombre de “conditions”, en accord avec le meneur de jeu. Il en nomme trois pour 1 point, deux pour 3 points et une seule pour 5 points. Ensuite, chaque fois que toutes ces conditions seront réunies, le personnage pourra choisir de gagner automatiquement 1 Niveau de Réussite sur un jet réussi ou de disposer, avant d’effectuer son jet, d’un nombre de Points de Maîtrise gratuits égal à la valeur de son Attribut Manuel. Par “conditions”, on entend par exemple la proximité d’un cours d’eau, le silence absolu, l’exposition à l’air libre, l’obscurité totale, pour certaines formes de magie, etc.",
    cost: 3,
    requireDetails: true
  ),
  symbiose5(
    caste: Caste.artisan,
    title: "Symbiose (une condition)",
    description: "Permet au personnage d’avoir appris à tirer profit de son environnement et de son cadre de travail pour créer dans les meilleures conditions de concentration possibles. Lorsqu’il choisit ce Privilège, le joueur doit choisir de dépenser 1, 3 ou 5 points, et nommer un certain nombre de “conditions”, en accord avec le meneur de jeu. Il en nomme trois pour 1 point, deux pour 3 points et une seule pour 5 points. Ensuite, chaque fois que toutes ces conditions seront réunies, le personnage pourra choisir de gagner automatiquement 1 Niveau de Réussite sur un jet réussi ou de disposer, avant d’effectuer son jet, d’un nombre de Points de Maîtrise gratuits égal à la valeur de son Attribut Manuel. Par “conditions”, on entend par exemple la proximité d’un cours d’eau, le silence absolu, l’exposition à l’air libre, l’obscurité totale, pour certaines formes de magie, etc.",
    cost: 5,
    requireDetails: true
  ),
  expertiseArtisan(
    caste: Caste.artisan,
    title: 'Expertise',
    description: "Permet de confirmer ou d’infirmer l’authenticité de n'importe quel objet.",
    cost: 4
  ),
  faveurPolitiqueArtisan(
    caste: Caste.artisan,
    title: 'Faveur politique',
    description: "Permet d’avoir tissé un réseau de relations politiques au sein des principales villes d’un royaume. Ce réseau s'appuie sur des amitiés, des pots de vin et des services mutuels. Le personnage pourra obtenir plus facilement certaines informations (dates, projets de lois, ragots, etc.). Ce Privilège peut être choisi plusieurs fois et s’applique à un pays à chaque fois.",
    cost: 4,
    unique: false,
    requireDetails: true
  ),
  tuteurArtisan(
    caste: Caste.artisan,
    title: 'Tuteur',
    description: "Permet de bénéficier de l’aide et de la bienveillance d’un mage de Statut égal au sien, que l'artisan a connu en s’intéressant à la la magie et à la sorcellerie au sein d’une académie. Si ce mage n’est pas censé intervenir directement lors des aventures, il peut prodiguer des conseils, des enseignements ou lancer pour le personnage quelques sorts mineurs - en échange de petits services.",
    cost: 8,
    requireDetails: true
  ),

  adaptation(
    caste: Caste.combattant,
    title: 'Adaptation',
    description: "Permet d’improviser une technique de combat avec des armes de fortune (chaises, bâtons, pierres) ou des armes dont il ne possède pas la Compétence. Il faut pour cela réussir un jet de Mental + Coordination + niveau de Statut contre une Difficulté de 5 (si l’arme est relativement simple d'usage) ou de 10 (si elle est incongrue ou délicate à manier). Pour la durée du combat, le personnage gagne un niveau de Compétence égal à 1 + nombre de NR. Il est nécessaire d'effectuer un jet pour chaque type d’arme et pour chaque combat.",
    cost: 3
  ),
  anticipation(
    caste: Caste.combattant,
    title: 'Anticipation',
    description: "Permet au personnage, au début de chaque tour, d’évaluer la rapidité d’action d’un de ses adversaires directs - c’est-à-dire un adversaire contre lequel il est personnellement engagé en combat. Pour cela, le personnage effectue un jet de Mental + Perception + niveau de Statut contre une Difficulté de 5. Pour chaque Niveau de Réussite obtenu, il peut exiger du meneur de jeu qu’il lui communique le rang d'action d’un dé d’Initiative de son adversaire, incluant les bonus éventuels dont celui-ci bénéficie. Par Niveau de Réussite, le personnage sait donc exactement à quel rang son adversaire peut porter une action. Il est impossible d’utiliser ce Privilège pour deux adversaires différents au début du même tour.",
    cost: 5
  ),
  argotCombattant(
    caste: Caste.combattant,
    title: 'Argot combattant',
    description: "Permet de manier un langage basé sur les signes, le mouvement des yeux et les postures, afin de communiquer silencieusement des informations. Il n’y aucun jet à effectuer, mais les informations doivent être simples (couvre-moi, attaque par le flanc, j'en vois deux, etc.) et l'interlocuteur du personnage doit obligatoirement posséder ce Privilège pour le comprendre.",
    cost: 2
  ),
  botteSecrete(
    caste: Caste.combattant,
    title: 'Botte secrète',
    description: "Permet de maîtriser un coup vicieux et imprévisible qui déroutera sensiblement son adversaire. Le joueur doit préciser la nature de ce coup : coup visé, attaque précise, charge, etc. Il peut s'agir d’un coup existant (voir Système de jeu) ou d’un coup rare apprécié par le personnage.\nLorsqu'il utilise ce coup, les jets de parade ou d’esquive de l'adversaire voient leur Difficulté augmenter de 5. Ce dernier peut cependant effectuer un jet de Mental + Compétence d'arme concernée contre une Difficulté de 20 pour comprendre la manœuvre et annuler la Difficulté supplémentaire. La Difficulté de ce jet est réduite de 5 à chaque nouveau jet.",
    cost: 5,
    unique: false,
    requireDetails: true
  ),
  convictionSuperieure(
    caste: Caste.combattant,
    title: 'Conviction supérieure',
    description: "Permet au personnage d’être tellement habitué aux horreurs de la guerre qu’il ne gagne plus aucun Cercle de Fatalité lorsqu'il conserve ce dé. Cependant, s’il commet une action particulièrement vicieuse, ou susceptible de lui faire gagner des Cercles, il les gagne tout de même.\nUn personnage qui possède ce Privilège ne peut jamais dépasser 1 en Tendance Homme, mais il est possible d’y renoncer à tout moment, pour peu que la Tendance Fatalité du personnage ne soit pas supérieure de 2.",
    cost: 5
  ),
  doubleAttaque(
    caste: Caste.combattant,
    title: 'Double attaque',
    description: "Permet d'effectuer, une fois par tour de combat, une deuxième attaque lors d'un même rang d’action et ce, sans subir de Difficulté supplémentaire. La première attaque s'effectue normalement, mais la seconde voit ses dommages amputés d’un dé. Aucune manœuvre n’est possible sur cette nouvelle attaque.",
    cost: 6
  ),
  engagement(
    caste: Caste.combattant,
    title: 'Engagement',
    description: "Permet d’ignorer, une fois par combat et pendant un tour complet, tous les malus découlant de ses blessures. Les malus reviennent normalement au début du tour suivant.",
    cost: 4
  ),
  feinte(
    caste: Caste.combattant,
    title: 'Feinte',
    description: "Permet de porter un coup simulé que l’adversaire tentera de parer ou d’esquiver. Cette technique, particulièrement efficace, a pour effet principal d'augmenter la Difficulté des jets suivants de l’adversaire car, si la feinte ne compte pas comme une action, la parade et/ou l’esquive le sont bel et bien. Le personnage peut donc feindre une attaque, contraindre à la défense et porter une véritable attaque sans aucun malus. Une seule feinte est possible lors d’un même tour. Après la première feinte, l'adversaire a droit à un jet de Mental + Compétence d’arme concernée contre une Difficulté de 15 pour comprendre qu’il ne s’agit pas d’une véritable attaque. La Difficulté de ce jet est réduite de 5 à chaque nouvelle feinte. Un personnage disposant de ce Privilège sur le point de subir une feinte peut directement effectuer le jet de Mental + Compétence d’arme concernée pour deviner la feinte (il n’est pas obligé d'attendre APRÈS l’avoir subie une fois). La Difficulté reste inchangée.",
    cost: 6
  ),
  recuperation(
    caste: Caste.combattant,
    title: 'Récupération',
    description: "Permet au personnage, après une nuit de sommeil, d'effacer toutes ses Égratignures, une Blessure Légère ou une Blessure Grave, au choix. De plus, sur lui, tous les jets de Médecine et de Premiers soins voient leur Difficulté réduite de 5.",
    cost: 6
  ),
  riposte(
    caste: Caste.combattant,
    title: 'Riposte',
    description: "Permet d'effectuer une contre-attaque immédiatement après avoir paré ou esquivé un coup et ce, quel que soit son nombre de NR. Il est impossible d’effectuer une manœuvre. La Difficulté reste inchangée, mais les dommages de l’attaque sont réduits d'un dé. Une seule riposte est possible par tour.",
    cost: 5
  ),
  sommeilLeger(
    caste: Caste.combattant,
    title: 'Sommeil léger',
    description: "Permet au personnage de ne jamais dormir que d’un œil et de voir la Difficulté de tous ses jets de Perception, de Réaction et d’Initiative diminuée de 5, lorsqu'il est question de se réveiller. Passé le premier tour de surprise, le personnage se réveille quoi qu’il arrive, même si ses jets sont ratés, du moment que quelque chose d’inhabituel se passe dans son rayon de sécurité. On estime par exemple qu’un rayon de 50 mètres autour du feu de camp correspond au périmètre de sécurité de tout bon aventurier.",
    cost: 3
  ),
  vigilanceCombattant(
    caste: Caste.combattant,
    title: 'Vigilance',
    description: "Permet de deviner le comportement de son adversaire au début d’un tour de combat. Il faut pour cela réussir un jet de Mental + Compétence de l’arme utilisée par l'adversaire contre une Difficulté de 15. Si l'adversaire ne compte pas attaquer, sa Compétence d’arme est remplacée par la Compétence ou la Caractéristique qu’il va utiliser (Coordination s’il s’agit d’une fuite ou d’un mouvement, par exemple). Le personnage gagne un bonus égal au nombre de NR sur une parade, une esquive ou le rang de l’un de ses dés d’Initiative. Il est possible d'attaquer avant l’adversaire si l'Initiative du personnage devient supérieure grâce à ce bonus.",
    cost: 4
  ),
  alliesMercenairesCombattant(
    caste: Caste.combattant,
    title: 'Alliés mercenaires',
    description: "Permet de disposer d’un réseau d’anciens compagnons d'armes capables de lui apporter une aide non négligeable. Ce Privilège peut permettre d'obtenir des informations, de demander un soutien actif ou de disposer d’un petit nombre d'hommes de main en peu de temps. Il n’est applicable qu’au sein d’une cité comptant des groupes de mercenaires respectueux des enseignements de Kroryn.",
    cost: 6,
    unique: false,
    requireDetails: true
  ),
  compagnonsDeBatailleCombattant(
    caste: Caste.combattant,
    title: 'Compagnons de bataille',
    description: "Permet de disposer d'un vieux compagnon de campagnes dans n’importe quelle cité comptant plus de cinq mille habitants. Cet ami pourra rendre des services, fournir des renseignements ou apporter une aide variée - hébergement, prêt de matériel, etc.",
    cost: 6,
    unique: false,
    requireDetails: true
  ),
  maitriseDArmureCombattant(
    caste: Caste.combattant,
    title: "Maîtrise d'armure",
    description: "Permet de rendre son armure particulièrement résistante à un type d’attaque précis. Pour utiliser ce Privilège, le personnage doit obligatoirement être spécialisé dans l’arme contre laquelle il souhaite renforcer son armure. L'Indice de protection augmente de 10 face à ce type d’attaque.",
    cost: 10
  ),

  bonneFoi(
    caste: Caste.commercant,
    title: 'Bonne foi',
    description: "Permet au personnage de sembler de bonne foi à ses interlocuteurs et de s'attirer un a priori favorable, même lorsqu'il ment ou tente d'influencer un jugement. Cet Avantage confère au personnage un Niveau de Réussite supplémentaire gratuit sur tout jet de Social réussi basé sur le mensonge ou la crédibilité et augmente de 5 la Difficulté des interlocuteurs du personnage pour tenter de le percer à jour, en cas de mensonge.",
    cost: 4
  ),
  bonneFortune(
    caste: Caste.commercant,
    title: 'Bonne fortune',
    description: "Permet, une fois par jour, de relancer un jet de dés impliquant l’Attribut Manuel ou Social.",
    cost: 5
  ),
  expertise(
    caste: Caste.commercant,
    title: 'Expertise',
    description: "Permet de confirmer ou d’infirmer l’authenticité de n'importe quel objet.",
    cost: 2
  ),
  faveurPolitique(
    caste: Caste.commercant,
    title: 'Faveur politique',
    description: "Permet d’avoir su tisser un réseau de relations politiques au sein des principales villes d’un royaume. Ce réseau s'appuie sur des amitiés, des pots-de-vin et des services mutuels. Le personnage pourra obtenir plus facilement certaines informations (dates, projets de lois, ragots, etc.). Ce Privilège peut être choisi plusieurs fois et s'applique à un pays à chaque fois.",
    cost: 2,
    unique: false,
    requireDetails: true
  ),
  fournisseurDePoisons(
    caste: Caste.commercant,
    title: 'Fournisseur de poisons',
    description: "Permet de savoir comment entrer en contact avec des intermédiaires douteux pouvant lui fournir du poison. Le meneur de jeu reste libre quant aux poisons qu’il souhaite fournir au personnage. De plus, ce Privilège est rare et ses pairs se déchargent sur lui des affaires douteuses. Si le personnage est considéré comme un criminel par les autorités, sa caste interviendra tout de même pour étouffer les poursuites mineures dont il pourra faire l’objet.",
    cost: 5,
    requireDetails: true
  ),
  notorieteCommercant(
    caste: Caste.commercant,
    title: 'Notoriété',
    description: "Permet de s'être forgé une bonne réputation au sein d’une cité ou d’une région de petite taille. La Renommée du personnage est augmentée de 1 une fois qu’il est reconnu. Le personnage gagne un bonus de 3 à toutes ses actions sociales effectuées à l’intérieur de cette cité ou région. Ce Privilège peut être acheté plusieurs fois et s'applique à une cité ou à une petite région à chaque fois.",
    cost: 2,
    unique: false,
    requireDetails: true
  ),
  paria(
      caste: Caste.commercant,
      title: 'Paria',
      description: "Ce “Privilège” est irréversible et une fois choisi, il ne peut plus disparaître. Le personnage fait alors partie de la frange la moins honorable des Commerçants et interdit tout retour aux carrières autres que celles de Paria. Bien que citoyen, le Paria est dévalorisé au sein de sa caste et sera traité en inférieur dans une assemblée de commerçants (mais jamais en public ou devant d’autres citoyens, c’est une affaire interne à la caste). Le Privilège Fournisseur de poisons a alors un coût de 2 et peut changer de nom pour évoquer d’autres marchandises honteuses. Le Privilège Surprise a un coût de 4. Le personnage ne peut posséder le Privilège Notoriété et subit un malus de 5 à toutes ses actions sociales entreprises avec d’autres Commerçants n’ayant pas ce Privilège. Les Parias ne peuvent atteindre le 5e Statut, ni devenir Maître de la caste et ce depuis toujours. Mais après tout, cela leur est souvent égal…",
      cost: 0,
      unique: true,
  ),
  psychologie(
    caste: Caste.commercant,
    title: 'Psychologie',
    description: "Permet, après quelques minutes d’observation, de deviner l’état d’esprit d’un individu. Ce Privilège ne donne que des renseignements vagues et généraux, mais il permet tout de même de ressentir la colère, la joie, la tristesse, la fourberie, etc.",
    cost: 2
  ),
  reflexesDeFuite(
    caste: Caste.commercant,
    title: 'Réflexes de fuite',
    description: "Permet, une fois par combat, de bénéficier d’une esquive gratuite, dont la Difficulté est toujours de 15.",
    cost: 3
  ),
  reseau(
    caste: Caste.commercant,
    title: 'Réseau',
    description: "Permet au personnage de se tenir informé des alliances, opérations clandestines, fomentations de “coups” et autres activités organisées par des réseaux et groupuscules - en réussissant un jet de Social + Vie en cité contre une Difficulté égale à 10 de base, plus un malus ou un bonus variant de 5 à 10 en fonction de l'importance de l'événement et de la puissance de ses auteurs.",
    cost: 4
  ),
  ressources(
    caste: Caste.commercant,
    title: 'Ressources',
    description: "Permet de connaître des astuces, paris, expertises et de pratiquer des ventes mineures pour s'assurer un revenu régulier. Le personnage obtient 50 dracs de fer par niveau de Statut et par semaine. Il lui suffit de consacrer une heure par jour à ses menues affaires pour justifier ce revenu. Ce Privilège est suspendu lors de longs voyages en terres dépeuplées (déserts, marais, montagnes, etc.).",
    cost: 3
  ),
  rumeurs(
    caste: Caste.commercant,
    title: 'Rumeurs',
    description: "Permet au personnage, lorsqu'il entre dans une cité ou tout autre lieu de vie et d'activité humaine, d'apprendre rapidement les principales rumeurs locales. En réussissant un jet de Social + Vie en cité + niveau de Statut contre une Difficulté de 5, il obtient une information par Niveau de Réussite - au choix du meneur de jeu et par priorité croissante d'importance, de la plus anodine à la plus secrète.",
    cost: 3
  ),
  surprise(
      caste: Caste.commercant,
      title: 'Surprise',
      description: "Permet au personnage de gagner un bonus de +5 sur le jet de sa première action d’un tour, ou, au contraire, d’imposer un malus de +5 à la Difficulté du premier jet d’action de son adversaire. Ce Privilège n’est applicable que sur le jet correspondant à la première action du personnage ou de son adversaire - une seule fois par combat, donc. Il peut s’utiliser plusieurs fois sur une même personne, mais toujours seulement une fois par combat (à la première action).",
      cost: 6
  ),
  connaissanceDuMondeCommercant(
    caste: Caste.commercant,
    title: 'Connaissance du monde',
    description: "Permet de déterminer la provenance de n'importe quel objet, vêtement, animal ou être humain, rien qu’en l’observant. De simples détails suffisent au personnage pour définir avec précision la région d’origine de ce qu’il observe.",
    cost: 6
  ),
  messagerCommercant(
    caste: Caste.commercant,
    title: 'Messager',
    description: "Permet de disposer d’un oiseau, d’un petit animal ou d’un serviteur capable de porter des messages vers un endroit déterminé.\nCe Privilège ne permet pas de communiquer, mais juste de faire acheminer des messages, écrits ou oraux, du personnage à un lieu ou à un correspondant fixe.",
    cost: 4,
    unique: false,
    requireDetails: true
  ),
  relationsDAffairesCommercant(
    caste: Caste.commercant,
    title: "Relations d'affaires",
    description: "Permet de disposer d’une connaissance amicale dans n'importe quelle cité comptant plus de cinq mille habitants. Cet ami a commercé fructueusement avec le personnage et pourra lui rendre des services, fournir des renseignements ou apporter une aide variée : hébergement, prêt de matériel, etc.",
    cost: 6,
    unique: false,
    requireDetails: true
  ),

  ambassade(
    caste: Caste.erudit,
    title: 'Ambassade',
    description: "Permet de disposer d’un sceau, d’un sauf-conduit ou d’un laissez-passer officiel qui lui ouvrira les portes de nombreuses cités de Kor. En choisissant ce Privilège, le joueur doit préciser l’origine de son mandat, car il est évident qu’un document émanant de l’Empire de Solyr n'aura que peu d'influence en plein désert zûl… Les applications de ce Privilège sont laissées à la discrétion du meneur de jeu. En contrepartie de certains avantages, le personnage peut également avoir à rendre des services ou à servir de messager officiel entre deux États.",
    cost: 3,
    unique: false,
    requireDetails: true
  ),
  aplomb(
    caste: Caste.erudit,
    title: 'Aplomb',
    description: "Permet de contrôler ses émotions et de faire prévaloir sa condition d’érudit en toutes circonstances, aidant le personnage à éviter un combat, à engager une discussion posée ou à bénéficier du respect dû à sa caste. Le personnage peut alors ajouter son Statut à son premier jet destiné à bloquer une situation en train de dégénérer. Cela peut être un jet de Diplomatie dans le cas d’une négociation tendue ou de Commandement dans le cas d’un combat sur le point de débuter.",
    cost: 1
  ),
  avalDraconique(
    caste: Caste.erudit,
    title: 'Aval draconique',
    description: "Permet d’être autorisé à effectuer des recherches sur l'UNE des Compétences interdites sans risque d'être inquiété. Il peut ainsi s’adonner à la Chirurgie ou la Mécanique ou toute autre forme de Compétence interdite par les Dragons. Il est toujours nécessaire de posséder l’Avantage Art interdit pour développer la Compétence.",
    cost: 6,
    unique: false,
    requireDetails: true
  ),
  calligraphieOfficielle(
    caste: Caste.erudit,
    title: 'Calligraphie officielle',
    description: "Permet de rédiger des écrits très précis sur des faits ou des connaissances particulières. Ces textes enluminés selon une charte immuable ont force de preuves ou de références pour les lecteurs suivants : juristes, inquisiteurs, érudits… Ce Privilège est indispensable pour prétendre rédiger un ouvrage destiné aux générations futures et le faire figurer dans une bibliothèque. Tout autre écrit rédigé sans ce Privilège sera toujours considéré comme “douteux” par la caste des érudits. L'usage qui sera fait de ces écrits engage la réputation de toute la caste et peut entraîner des remontrances en cas d'abus.",
    cost: 4
  ),
  demagogie(
    caste: Caste.erudit,
    title: 'Démagogie',
    description: "Permet au personnage de mettre en avant son statut d’érudit, représentant des traditions draconiques et porteur de l’héritage du Grand Dragon des Océans, dans toute circonstance où sa parole peut l’aider à convaincre, à rallier ou à créer des mouvements de foule. Très utile aux prédicateurs, ce Privilège permet au personnage d’ajouter son niveau de Statut au résultat de son jet de Social + Éloquence, Baratin, Psychologie, etc. Tous les citoyens d’un Statut inférieur au sien voient de plus la Difficulté de leurs propres jets augmentée de 5 - des jets de Mental + Psychologie ou Volonté contre une Difficulté variant de 10 à 25 peuvent être autorisés pour “résister” aux arguments de l’érudit.",
    cost: 3
  ),
  ecritTechnique(
    caste: Caste.erudit,
    title: 'Écrit technique',
    description: "Permet au personnage de connaître les formes si particulières du langage écrit technique, utilisé par de nombreux artisans et érudits versés dans les arts modernes et précis. Calcul, mesure, chiffres et repères sont alors à la portée du personnage, qui peut comprendre tout écrit technique en réussissant un jet de Mental + Intelligence contre une Difficulté de base de 15 - susceptible d’être modifiée par la nature de l’écrit - et rédiger ses propres écrits et plans.\nCe Privilège permet de comprendre le langage des Humanistes.",
    cost: 4
  ),
  garantErudit(
    caste: Caste.erudit,
    title: 'Garant',
    description: "Permet au personnage de faire prévaloir son statut d’érudit lors d’un litige, de conflits et de différents susceptibles de se régler en duel - qu’il s'agisse d’un duel physique ou d’une joute de toute autre nature. De par sa position, le personnage peut rappeler les lois en vigueur et proposer un affrontement conforme aux préceptes draconiques, qui ne saurait être refusé par un citoyen. Le personnage devient alors seul “juge” de l’issue du duel, de son vainqueur, des réparations requises, etc.\nCe Privilège peut s’appliquer à un duel impliquant le personnage, mais les érudits ont généralement pour coutume de désigner des champions.",
    cost: 3
  ),
  illumine(
      caste: Caste.erudit,
      title: 'Illuminé',
      description: "Permet au personnage d’utiliser son Attribut Mental à la place de l’Attribut Social chaque fois qu’il tente d’expliquer, de justifier ou de présenter certains aspects de son sujet d’étude de prédilection. Convaincu et passionné, le personnage peut ainsi motiver ses explications en trouvant les mots adéquats - et convaincre plus aisément un Inquisiteur que l’astronomie n’a rien d’une pratique hérétique…\nLe personnage définit un sujet de prédilection, lorsqu’il choisit cet Avantage. Par exemple, il peut choisir de travailler sur l’implication des Étoiles dans l’histoire de Kor, les raisons fondamentales de l’Humanisme, l’art de la guerre au fil des âges, etc. Ce bénéfice peut s’appliquer à tous les jets concernant des Compétences de Théorie et de Pratique que le personnage possède et qu’il utilise en relation avec ce sujet.",
      cost: 3
  ),
  linguistique(
    caste: Caste.erudit,
    title: 'Linguistique',
    description: "Permet de maîtriser les rudiments de suffisamment de dialectes issus du langage draconique pour comprendre et se faire comprendre dans la majorité des régions de Kor sans passer de longues journées à étudier les variations locales. Ce Privilège ne permet pas de poursuivre une discussion soutenue, mais au moins d'éviter tout malentendu.",
    cost: 2
  ),
  memoire(
    caste: Caste.erudit,
    title: 'Mémoire',
    description: "Permet à un Personnage de se remémorer un nom, une date, un événement ou une information oubliée du joueur qui l’incarne. Grâce à ce Privilège, le joueur peut demander au meneur de jeu de lui rappeler un détail vieux d’un mois à un an (en temps de jeu), selon l’importance de l'information.",
    cost: 4
  ),
  notorieteErudit(
    caste: Caste.erudit,
    title: 'Notoriété',
    description: "Permet de disposer des bonnes grâces d’un certain milieu social, de compter des amis fidèles au sein de la noblesse et de prétendre à certains égards liés à sa condition d’érudit. Il pourra ainsi être invité à des réunions privées, des soirées mondaines, etc.\nLorsque le personnage cherche à se faire reconnaître dans son pays d’origine, il peut ajouter son Statut à sa Renommée.",
    cost: 4
  ),
  faveurPolitiqueErudit(
    caste: Caste.erudit,
    title: 'Faveur politique',
    description: "Permet d'avoir su tisser un réseau de relations politiques au sein des principales villes d’un royaume. Ce réseau s'appuie sur des amitiés, du respect et des services mutuels. Le personnage pourra obtenir plus facilement certaines informations (dates, projets de lois, ragots, etc.). Ce Privilège peut être choisi plusieurs fois et s'applique à un Pays à chaque fois.",
    cost: 4,
    unique: false,
    requireDetails: true
  ),
  messagerErudit(
    caste: Caste.erudit,
    title: 'Messager',
    description: "Permet de disposer d’un oiseau, d’un petit animal dressé ou d’un serviteur capable de porter des messages vers un endroit déterminé. Ce Privilège ne permet pas de communiquer, mais juste de faire acheminer des messages écrits ou oraux, du personnage à un lieu ou à un correspondant fixe.",
    cost: 4,
    unique: false,
    requireDetails: true
  ),
  psychologieErudit(
    caste: Caste.erudit,
    title: 'Psychologie',
    description: "Permet, après quelques minutes d’observation, de deviner l’état d'esprit d’un individu. Ce Privilège ne donne que des renseignements vagues et généraux, mais il permet tout de même de ressentir la colère, la joie, la tristesse, la fourberie, etc.",
    cost: 4
  ),

  anonymat(
      caste: Caste.mage,
      title: 'Anonymat',
      description: "Permet de dissimuler les marques d’appartenance à une école de magie et de bouleverser sa propre trame élémentaire pour la rendre plus difficile à ressentir. Le personnage peut passer pour un membre d'une autre caste - commerçants, voyageurs, érudits ou artisans, dans la plupart des cas - ce qui peut être très utile dans certaines régions hostiles aux initiés des arcanes.\nToute tentative magique pour localiser le personnage ou deviner ses émotions voit sa Difficulté augmenter de 5. Pour tenter de percer à jour cette couverture, l'interlocuteur du personnage doit réussir un jet de Social + Empathie contre une Difficulté de 20.\nCe Privilège ne permet pas de connaître exactement les coutumes et usages de la caste ainsi interprétée, ce qui est du ressort de la Compétence Castes…",
      cost: 4
  ),
  approvisionnement(
    caste: Caste.mage,
    title: 'Approvisionnement (Mage des Cités)',
    description: "Ce Privilège, utilisable uniquement au sein des grandes cités, permet au mage de trouver la bonne échoppe où se fournir en matériel et en ressources magiques (ingrédients, clés de magie, équipement de voyage, armes, herbes…). Les noms des marchands et des vendeurs lui viennent rapidement en mémoire et il peut vite les y trouver. En cas de négociation avec un marchand trouvé de cette façon, le personnage gagne un bonus à tous ses jets de Social égal à son niveau de Statut de mage.",
    cost: 3
  ),
  aura(
    caste: Caste.mage,
    title: 'Aura',
    description: "Permet au personnage de posséder une aura magique, visible uniquement par les membres de sa caste et les créatures féeriques, qui traduit par des nuances de couleurs le niveau de sa puissance, son Statut, ses Disciplines et Sphères de prédilection, ainsi que ses particularités magiques — pouvoirs spéciaux, Lien, etc. Tant qu’il ne précise pas le contraire, cette aura peut être sondée et observée par tous les mages. Dans ce cas, elle confère au personnage un bonus égal à son Statut pour tous les jets de Social qui concernent sa situation hiérarchique, ainsi que lors des rencontres avec des créatures élémentaires. Pour tenter de la masquer, il faut réussir un jet d’opposition Mental + Volonté contre Mental + Empathie de l’observateur.",
    cost: 3
  ),
  bourreau(
    caste: Caste.mage,
    title: 'Bourreau (Mage Questeur blanc)',
    description: "Le mage est autorisé par Nenya à appliquer le châtiment suprême destiné à un mage ayant enfreint les Interdits de la Chimère : la lobotomie. Le Grand Dragon lui a enseigné le sort Lobotomie (sans jet d'apprentissage ou dépense de points d'Expérience) et il a toute latitude pour l'administrer… dans le cadre des Interdits de Nenya.",
    cost: 6
  ),
  cotation(
    caste: Caste.mage,
    title: 'Cotation (Mage des Cités)',
    description: "Le Mage peut non seulement estimer la valeur d’une marchandise - tout comme l’avantage Expertise - mais en plus, il est capable de donner le nom du meilleur acheteur dans la ville ou le quartier le plus proche. Ce privilège ne fonctionne que dans une ville où le personnage a déjà quelques connaissances (minimum deux jours de présence).",
    cost: 3
  ),
  detachement(
    caste: Caste.mage,
    title: 'Détachement (Mage des Océans)',
    description: "Ce Privilège permet au mage de se plonger dans une transe profonde qui lui fait ressentir l’immensité de la sagesse d’Ozyr. Il y puise alors une force de caractère et une solidité mentale qui lui permettent de résister aux idées les plus terribles. Il peut ainsi surmonter l’horreur de la vision d’un dragon de l’ombre en pleine nuit dans un marécage, assister à des actes révoltants comme des exécutions sommaires ou des actes de torture ou bien consulter un ouvrage hérétique dangereux pour l'esprit. Durant cette période, il reste conscient de son environnement et peut se mouvoir normalement, mais il ne parle que difficilement, d’une voix atone. Il peut alors déplacer temporairement des points d’Empathie vers sa Volonté, ajustant ses Attributs au début de sa transe (permet au maximum de doubler sa Volonté et de dépasser temporairement 10). Durant celle-ci, le mage est détaché de toute émotion marquée et ne garde pas de séquelle mentale de ce dont il a été témoin. L'usage de ce Privilège est limité à une fois par jour, pour une durée d’un quart d’heure par point en Tendance Dragon.",
    cost: 3
  ),
  duelliste(
    caste: Caste.mage,
    title: 'Duelliste (Mage du Feu)',
    description: "L’obtention de ce privilège et du titre de Duelliste nécessite trois Compétences de combat à 7, deux Expertises liées à la magie (Disciplines ou Sphères) et le statut de Grand Mage. Le personnage obtient alors une Renommée de 6 (ou +1 s’il a dépassé 6) et peut utiliser sa technique de “La Flamme” autant de fois par jour que son Statut. Ce Privilège est surtout social, puisque la réputation de héros précède toujours les Duellistes. Le mage sera donc craint et respecté - mais rarement écouté.\nCe Privilège nécessite d'avoir le Désavantage “Malédiction de Nenya“.",
    cost: 4
  ),
  empathieAquatique(
    caste: Caste.mage,
    title: 'Empathie aquatique (Mage des Océans)',
    description: "En goûtant une eau après y avoir plongé un doigt, le mage peut en déterminer l’origine approximative, les éventuels éléments qui y ont été ajoutés et la dangerosité de sa consommation. En effectuant un jet de Mental + Empathie contre une Difficulté de 15, il peut déterminer les circonstances particulières qui ont marqué l’eau durant son passage. Par exemple, il pourra sentir la violence et la haine d’un étang ayant servi à noyer un condamné, l’amour profond d’un couple marié au bord d’une rivière ou encore le désespoir d’un amant décidé à mettre fin à ses jours du haut d’un pont. La distance et l’ancienneté ne sont pas prises en compte, seule l’impression dominante restant imprégnée. Le mage est immunisé contre la dangerosité d’une eau non potable, mais peut toutefois subir les effets d’un poisen, si la proportion de ce dernier dans le liquide est importante.",
    cost: 2
  ),
  empathieElementaire(
    caste: Caste.mage,
    title: 'Empathie élémentaire',
    description: "Permet au personnage d’être tellement en phase avec les courants élémentaires qu’il peut, en effectuant un simple rituel, puiser dans l’énergie magique d’un lieu pour regagner des Points de Magie. En effectuant un jet de Mental + Empathie contre une Difficulté de 10, le personnage regagne 3 + 2/NR Point de Magie. Ces points sont ajoutés à la réserve élémentaire correspondant à la Sphère invoquée par le mage, qui doit clairement énoncer l’élément avec lequel il souhaite entrer en contact. De fait, la Difficulté du jet peut être augmentée ou diminuée en fonction de la puissance de cet élément aux alentours. Utilisable autant de fois par jour que son Statut.",
    cost: 5
  ),
  familierMagique(
    caste: Caste.mage,
    title: 'Familier magique (Mage du Métal)',
    description: "Les mages du métal ont parfois apprivoisé de petites créatures magiques rencontrées dans les Eeries dévastées de Kezyr. Leur forme peut varier du tout au tout - du petit lézard métallique au simple caillou empathique. Le joueur est invité à se mettre d’accord avec le meneur de jeu pour déterminer la forme et les capacités du familier, ainsi que les conditions de son acquisition.",
    cost: 3,
    unique: false,
    requireDetails: true
  ),
  immuniteContreLElectricite(
    caste: Caste.mage,
    title: 'Immunité contre l\'électricité (Mage du Feu)',
    description: "Ce privilège immunise le personnage à la foudre naturelle. Si cette dernière provient d’un sortilège ou d’un effet d’un sort, les NR sont réduits du Statut du mage. Si le sort obtient zéro NR, il est lancé mais n’affecte plus le mage (mais pas son équipement ou ses compagnons) d’aucune façon.",
    cost: 4
  ),
  insensibiliteALaChaleur(
    caste: Caste.mage,
    title: 'Insensibilité à la chaleur',
    description: "Contrairement au Privilège “Immunité contre l'électricité“, le mage subit physiquement les blessures causées par le feu, mais il n’en souffre pas - ses terminaisons nerveuses ne répondant pas à ce stimulus, sa peau se marque, mais ne lui cause aucun dommage. Cela permet, dans des conditions extrêmes, de ne pas perdre connaissance à cause de la douleur.\nCe Privilège nécessite d'avoir le Désavantage “Malédiction de Nenya“.",
    cost: 4
  ),
  intellectualisation(
    caste: Caste.mage,
    title: 'Intellectualisation (Mage des Océans)',
    description: "Durant son enseignement, le mage a fréquenté des érudits et a formé son esprit à une analyse logique dénuée de tout sentiment. Il fait preuve d’une extrême précision dans son éloquence et analyses les idées avec un détachement inquiétant. Il peut alors doubler son attribut Mental pour un nombre de tours égal à sa Tendance Dragon, et ce autant de fois par jour que son niveau de Statut. Durant ces périodes, il subit un malus de 5 à toutes ses actions sociales, habité par un esprit froid et méthodique plus qu’inquiétant pour ses interlocuteurs.",
    cost: 2
  ),
  laboratoire(
    caste: Caste.mage,
    title: 'Laboratoire',
    description: "Permet de disposer d’un accès privilégié aux études et aux salles d'essai des académies de magie. Le mage se fait reconnaître par le biais de ses bracelets de caste dont les gravures sont particulières. Cet accès lui permet de bénéficier d’un bonus de 3 lors de ses apprentissages de sorts et de récupérer aisément des Clés banales (minéraux, métaux vulgaires, pigments, plantes, portions d’animaux…).",
    cost: 5
  ),
  langageTechnique(
    caste: Caste.mage,
    title: 'Langage technique (Mage du Métal)',
    description: "Permet au mage du métal de communiquer en des termes simples et précis des notions de mécanique assez complexes. Cela peut avoir de l’importance lorsque le personnage se trouve confronté à un problème mécanique sans qu’il puisse intervenir lui-même - indiquer comment crocheter une serrure, construire une machine de guerre, etc.\nCe Privilège permet aussi de dessiner des plans techniques compréhensibles de tous.",
    cost: 2
  ),
  leurre(
    caste: Caste.mage,
    title: 'Leurre',
    description: "Permet de générer de façon illusoire le lancement d’un sort. Ce Privilège peut être utilisé autant de fois par jour que son niveau de Statut. Le sort simulé devra être un sort de Magie instinctive et ne fonctionnera que sur UNE cible. Le mage effectue un jet de Mental + Magie instinctive contre une Difficulté égale à Mental + Volonté de la cible. Chaque NR simule les effets normaux du sort pour un tour, pour cette cible et elle seule, cette dernière étant convaincue de voir les effets du sort. Le leurre ne coûte pas de Point de Magie, utilise autant d'actions pour être lancé et se résout comme le sort simulé. À la fin de l’effet, la cible perce l'illusion, les effets n'ayant jamais réellement existé. Le mage ne peut pas utiliser ce Privilège sur lui-même.",
    cost: 3
  ),
  maitreInstructeurDeMagie(
      caste: Caste.mage,
      title: 'Maître-Instructeur de magie',
      description: "Par ce Privilège, le mage peut exprimer son savoir magique et le transmettre plus facilement. Lorsqu’il veut instruire un personnage dans une Discipline, il réduit la durée nécessaire (à discrétion du MJ selon l’expérience du personnage) de 10% par degré de Statut qu’il possède. Lors de l’apprentissage des sorts, il peut effectuer un jet de Social + Éloquence contre une Difficulté de 10 +5/Niveau de sort. Chaque NR réduit temporairement la Complexité du sort de 5 + 5/NR. Cette Complexité adaptée sera utilisée pour calculer le temps d’apprentissage, mais aussi le coût en points d’Expérience du sort. Ce Privilège n’affecte en rien l’apprentissage des Sphères. Acquérir ce Privilège est assez aisé, mais impose au mage d’adopter la Loi du partage en plus d’autres Interdits déjà respectés. Ce Privilège n’est accessible qu’à partir du troisième Statut.",
      cost: 3
  ),
  maitriseDesEnergies(
      caste: Caste.mage,
      title: 'Maîtrise des énergies (Mage Questeur blanc)',
      description: "Le mage est capable de se transcender et de retrouver au plus profond de lui l'énergie magique que Nenya a insufflée dans chaque humain. Autant de fois par jour que son Statut, il peut transformer tout ou partie de ses points de Maîtrise disponibles en points de magie. Il peut alors les répartir dans ses Réserves de Sphère ou en Réserve personnelle. Cette transformation est spectaculaire et prend un tour complet. Le mage crépite alors de puissance brute, les bras écartés et hurlant pour canaliser son énergie.",
      cost: 4,
  ),
  messager(
    caste: Caste.mage,
    title: 'Messager',
    description: "Permet de disposer d’un oiseau, d’un petit animal ou d’un serviteur capable de porter des messages vers un endroit déterminé. Ce Privilège ne permet pas de communiquer, mais juste de faire acheminer des messages, écrits ou oraux, du personnage à un lieu ou à un correspondant fixe.",
    cost: 2,
    unique: false,
    requireDetails: true
  ),
  messagerOnirique(
    caste: Caste.mage,
    title: 'Messager onirique (Mage des Rêves)',
    description: "Permet d’éveiller l’âme éthérée résiduelle d’un banal fluix. Une fois, éveillé, le fluix peut pénétrer dans l’Ether et s’en servir pour voyager vers qui il désire, tant que ce dernier possède un lien normal avec l’Ether. Le corps du fluix s’endort et sa forme spectrale se détache pour pénétrer dans l’Ether. Ce Privilège nécessite un fluix. Désincarné, ce dernier est considéré comme une créature draconique et s’exprime par télépathie ou apparition onirique.",
    cost: 5
  ),
  mouvementDeFoule(
    caste: Caste.mage,
    title: 'Mouvement de foule (Mage des Cités)',
    description: "Le mage peut “sentir“ l’humeur d’une foule, savoir si elle est amicale ou en colère avant qu’elle ne déchaîne sa vindicte. Les serviteurs de Khy sont bien placés pour savoir qu’un mot de travers peut se terminer par un lynchage. Ce Privilège ne permet pas de contrôler une émeute, mais d’anticiper son action et, éventuellement, ses débordements. Il permet aussi de repérer les meneurs et les agitateurs.\nCe Privilège nécessite d'avoir le Désavantage “Mauvaise réputation“.",
    cost: 3
  ),
  nomDeKalimsshar(
    caste: Caste.mage,
    title: 'Nom de Kalimsshar (Mage de l\'Ombre)',
    description: "En évoquant à demi mots son affiliation au Héraut de la Fatalité, le personnage peut provoquer la crainte et le respect de son interlocuteur si celui-ci est de Statut équivalent ou inférieur (ou croit l'être). Le personnage effectue un jet de Social + Intimidation contre Mental + Volonté de sa cible. Avec un jet réussi, le personnage provoque la passivité, l'hésitation et la crainte. Avec un Niveau de Réussite, la victime est effrayée et incapable d'agir à l'encontre du personnage. Elle est tremblante et hésitante. Avec deux Niveaux de Réussite, la victime est paralysée de peur et sera incapable de parler de cette expérience par peur des représailles.",
    cost: 3
  ),
  passeur(
      caste: Caste.mage,
      title: 'Passeur',
      description: "Avec ce Privilège, le mage reçoit l'enseignement des techniques permettant d'ouvrir des Passages Eeriques et de les parcourir en toute sécurité, il apprend à reconnaître les brèches dans les parois du tunnel et à tisser la trame élémentaire pour les reboucher avant que le Passage ne s'effondre. Les Passeurs sont les seuls à pouvoir ouvrir ces passages et l'obtention de ce Privilège reste soumis à une réputation exemplaire.",
      cost: 5
  ),
  pelerinOnirique(
      caste: Caste.mage,
      title: 'Pèlerin onirique',
      description: "Par ce Privilège, Nenya donne au mage la possibilité d’apprendre et d’utiliser les sorts Fenêtre onirique et Psychonaute, ainsi que la compétence Cartographier les rêves. Il est placé sous la responsabilité d’un tuteur, la plupart du temps un mage de Nenya mais parfois aussi un Dragon des Rêves, chargé de lui enseigner les techniques pour explorer les rêves. Ce Privilège comprend aussi une instruction compréhensible par les hommes sur la nature de l’Ether, les poches du monde des Rêves et les dangers de cette dimension.",
      cost: 5
  ),
  pistesCachees(
    caste: Caste.mage,
    title: 'Pistes cachées (Mage des Vents)',
    description: "Le mage de Szyl peut deviner l’existence de routes secrètes empruntées par les siens avant lui. Ces sentiers passent le plus souvent par des nappes de brouillard ou des nuages bas et débouchent exactement là où le voyageur souhaitait aller. Abuser des pistes cachées est dangereux car certains chemins mènent aux Eeries dévastées et hantées de Szyl - où lui-même ne se rend plus.\nCe Privilège nécessite d'avoir le Désavantage “Curiosité“.",
    cost: 3
  ),
  predispositions(
    caste: Caste.mage,
    title: 'Prédispositions',
    description: "Permet au personnage de disposer d’une affinité particulière avec une Sphère ou une Discipline qui, lorsqu'il tente d’apprendre un sortilège de ce genre, réduit de 5 la Difficulté de l’apprentissage. Une fois la Sphère ou la Discipline choisies, il est impossible d’en changer. Ce Privilège peut être choisi deux fois, pour deux Compétences différentes.",
    cost: 3
  ),
  prevoyance(
    caste: Caste.mage,
    title: 'Prévoyance',
    description: "Permet de disposer à tout moment des ingrédients non périssables et de Clés matérielles dont il risque d’avoir besoin pour lancer ses sortilèges. Ce Privilège ne prend pas en compte les ingrédients rares et extrêmement coûteux, sauf si le personnage a déjà fait la démarche nécessaire pour se les procurer - auquel cas il les a conservés sur lui.",
    cost: 2
  ),
  privilegeDeVoyageur(
    caste: Caste.mage,
    title: 'Privilège de voyageur (Mage des Rêves ou des Vents)',
    description: "Le mage peut choisir un Privilège de son choix parmi ceux de la caste des voyageurs. En général, ce sont les mages hors structure qui choisissent ce Privilège de caste. Les mages de Nenya et de Szyl y ont accès.",
    cost: 0
  ),
  protectionDesEeries(
    caste: Caste.mage,
    title: 'Protection des Eeries (Mage des Rêve ou de la Nature)',
    description: "Le personnage peut recevoir l’aide des esprits de la nature mais aussi celle des créatures de Nenya. Cette aide n’est jamais prévisible et n’arrive jamais au moment où on l'attend. Le mage aura, par exemple, plus de chance de traverser sans danger des bois connus pour abriter des terribles loups de Tabasse.De plus, ce privilège protége le mage contre les créatures sauvages présentes dans les Eeries. Il n’affecte pas les dragons ou les créatures draconiques.",
    cost: 4
  ),
  puissanceDeSang(
    caste: Caste.mage,
    title: 'Puissance de sang (Mage de l\'Ombre)',
    description: "Lorsque l'Augure Noir décide de puiser dans ses Réserves et de se mutiler pour obtenir des Points de Magie, il obtient deux Points de Magie par case cochée au lieu d'un seul.",
    cost: 5
  ),
  puissanceElementaire(
    caste: Caste.mage,
    title: 'Puissance élémentaire (Mage Questeur blanc)',
    description: "Grâce à ce Privilège, le mage est en mesure d'augmenter les effets d'un sort en dépensant des points de magie supplémentaires. Ainsi, pour tout effet dépendant des NR, la dépense de 1 point de magie supplémentaire et de 1 point de maîtrise octroie 1 NR additionnel (il est nécessaire que le sort soit réussi). Par ailleurs, la mage est capable d'améliorer des effets quantifiables tels que la portée, le nombre de cible et les dégâts, même lorsque ce n'est pas prévu par le sort. En dépensant la totalité de ses points de Maîtrise disponibles (au moins 1) et le double des points de magie nécessaires au sort, il peut augmenter de moitié la valeur de l'un des effets du sort. Par exemple, un sort coûtant 4 PM ayant une portée de 10 m et infligeant 20 pts de dommage peut passer à une portée de 15m ou des dégâts de 30 pour un coût de 8 PM.",
    cost: 4
  ),
  refugeSylvestre(
    caste: Caste.mage,
    title: 'Refuge sylvestre (Mage de la Nature)',
    description: "Cet Avantage est un secret de Heyra et de tous ses adeptes, il doit le rester le plus longtemps possible. Dans chaque forêt — y compris certaines du domaine de Kalimsshar — il existe un Refuge pour les serviteurs de la Grande Dragonne. Ce Refuge peut être un simple trou, pour s’abriter le la pluie, une cabane, une auberge ou un arbre creux. Dans ces Refuges, nulle créature de Heyra ne pourra attaquer - certaines, même, protègent ce type d’endroit. Seuls les hommes, dont la nature est insaisissable, peuvent nuire à leur prochain dans les Refuges. Ces lieux portent la rune de Heyra - même si parfois elle est cachée - et seuls les possesseurs de l’Avantage peuvent la repérer. Attention, il n’y a jamais de Refuge dans les villes - même s’il y a une forêt dans les murs de la cité.",
    cost: 3
  ),
  renommee(
    caste: Caste.mage,
    title: 'Renommée (Mage de la Nature)',
    description: "Le mage bénéficie d'une grande renommée dans sa région d'origine - ou toute autre région précise. Ce privilège ne fonctionne que vis-à-vis des mages ou des prodiges. Il apport un +1 en Renommée. Tous ses jets utilisant des Compétences de Communication et d'Influence voient leur Difficulté réduite de 3 dans cette région.",
    cost: 2,
    requireDetails: true
  ),
  sacrificeElementaire(
      caste: Caste.mage,
      title: 'Sacrifice élémentaire',
      description: "Le mage peut drainer de l'énergie magique d'un lieu, d'un objet ou d'un élément lié à une Sphère particulière pour s'en servir immédiatement. Il permet donc de considérer un simple objet comme un minuscule focus utilisable une seule fois. Le gain est mineur et la source est réduite en cendres. La trame élémentaire drainée est intégralement détruite, avertissant tous les dragons de cet élément et de la magie dans un rayon de plusieurs kilomètres. Il est possible de récupérer un point d'Ombre dans un crâne humain, 2 points de Pierre pour un cristal naturel de la taille d'un poing ou encore 3 points de Nature dans un chêne centenaire. Au-delà de 5 points, l'objet sera nécessairement légendaire et il est inenvisageable d'espérer drainer plus de 10 points de cette manière. Ce Privilège s'utilise au contact et coûte une action (comptée comme Complexe et donc octroyant un malus cumulatif de 5). Les points doivent être utilisés dans les tours qui suivent (au maximum Volonté tours), mais il est possible de lancer un sort sans engager de points personnels, à la différence des focus. Ce Privilège est accordé uniquement aux Mages possédant une réputation exemplaire et une Renommée de 5.",
      cost: 3,
  ),
  sensDeLEther(
    caste: Caste.mage,
    title: "Sens de l'éther (Mage Gardien)",
    description: "Le mage a un contact particulier avec la magie et ressent son utilisation. Il est capable de s'en détacher afin de ne pas être distrait en permanence, mais en se concentrant sur un point précis (un mage, un lieu, un type de sort, un Passage éerique...), il pourra détecter à vue l'utilisation des Sphères sur un jet de Empathie + Sphère de Difficulté (30 - Difficulté du sort), les NR donnant des précisions sur le mage et sa localisation (au choix du MJ). Des événements particuliers comme des échecs particulièrement retentissants, la mort d'un grand mage ou d'un dragon peuvent l'atteindre. Si un tel événement se produit, le MJ peut demander au joueur d'effectuer un jet de Mental + Volonté de Difficulté égale à l’ampleur du phénomène (Difficulté du sort dont le lancement a échoué, Difficulté d'ouverture du Passage éerique, etc. et dans le cas de la mort d'un mage ou d'un dragon 5+5/Statut ou Tranche d'Age). S'il réussit, le personnage est juste marqué par l'événement, mais s'il échoue, il est ébranlé et incapable d'agir pendant 1 minute par point manquant pour réussir le jet ; au-delà de cette période, le doute restera en lui pendant la journée qui suivra et toutes ses actions subiront malus de 2.",
    cost: 5,
  ),
  siphonElementaire(
    caste: Caste.mage,
    title: "Siphon élémentaire (Mage Gardien)",
    description: "Grâce à ce Privilège, le Gardien est capable, autant de fois par jour que son Statut, d'absorber l'énergie magique d'un mage au moment de l'incantation d'un sort pour le faire avorter. Si le Gardien réussit un jet de Mental + Empathie + Statut de Difficulté 10, il absorbe 1 pt de magie + 1/NR, qui vont s'ajouter à sa Réserve personnelle à concurrence de son maximum. Le mage “parasité” peut percevoir la “fuite” sur un jet de Perception + Sphère dont la Difficulté est égale au jet du Gardien. S'il y parvient, il dispose d'une action pour dépenser des Points de Magie (ou des Blessures le cas échéant) supplémentaires afin que son sort ne soit pas annulé. Le mage dépense de toute façon ses points de magie, mais si le nombre finalement attribué au sort est insuffisant, l'effet avorte.",
    cost: 4,
  ),
  sortilegeFetiche(
    caste: Caste.mage,
    title: 'Sortilège fétiche',
    description: "Permet de maîtriser parfaitement la technique de lancement d’un sort. Grâce à ce Privilège, le personnage gagne un bonus de 3 chaque fois qu'il utilise ce sortilège précis. Il est possible de choisir ce Privilège deux fois.",
    cost: 4,
    unique: false,
    requireDetails: true
  ),
  sortilegeFeticheCites(
    caste: Caste.mage,
    title: 'Sortilège fétiche des Cités',
    description: "Permet de maîtriser parfaitement la technique de lancement d'un sortilège des cités. Grâce à ce privilège, le magicien gagne un bonus de 4 chaque fois qu'il lance ce sortilège précis. Ce Privilège peut être acheté autant de fois que son Statut (sans compter le Privilège Sortilège Fétiche simple).\nCe Privilège nécessite d'avoir le Désavantage “Mauvaise réputation“.",
    cost: 4,
    unique: false,
    requireDetails: true
  ),
  sortilegeFeticheFeu(
    caste: Caste.mage,
    title: 'Sortilège fétiche du Feu',
    description: "Permet de maîtriser parfaitement la technique de lancement d’un Sortilège du Feu. Grâce à ce Privilège, le magicien gagne un bonus de 4 chaque fois qu’il lance ce sortilège précis. Il est possible de choisir ce Privilège deux fois (sans compter le Privilège Sortilège fétiche simple), mais pour deux sortilèges différents.\nCe Privilège nécessite d'avoir le Désavantage “Malédiction de Nenya“.",
    cost: 4,
    unique: false,
    requireDetails: true
  ),
  sortilegeFeticheMetal(
    caste: Caste.mage,
    title: 'Sortilège fétiche du Métal',
    description: "Permet de maîtriser parfaitement la technique de lancement d’un sortilège du métal. Grâce à ce Privilège, le magicien gagne un bonus de 4 chaque fois qu’il lance ce sortilège précis.\nCe Privilège peut être acheté autant de fois que son Statut (sans compter le Privilège Sortilège Fétiche simple).\nCe Privilège nécessite d'avoir le Désavantage “Malédiction de Kezyr“.",
    cost: 4,
    unique: false,
    requireDetails: true
  ),
  sortilegeFeticheNature(
    caste: Caste.mage,
    title: 'Sortilège fétiche de la Nature',
    description: "Permet de maîtriser parfaitement la technique de lancement d’un sortilège de la nature. Grâce à ce Privilège, le magicien gagne un bonus de 4 chaque fois qu’il lance ce sortilège précis. Ce Privilège peut être acheté autant de fois que son Statut (sans compter le Privilège Sortilège Fétiche simple).\nCe Privilège nécessite d'avoir le Désavantage “Phobie des cités“.",
    cost: 4,
    unique: false,
    requireDetails: true
  ),
  sortilegeFeticheOceans(
    caste: Caste.mage,
    title: 'Sortilège fétiche des Océans',
    description: "Permet de maîtriser parfaitement la technique de lancement d’un sortilège de la Sphère des Océans. Grâce à ce Privilège, le mage gagne un bonus de 4 chaque fois qu’il lance ce sortilège précis. Ce Privilège peut être acheté autant de fois que son Statut (sans compter le Privilège Sortilège Fétiche simple).\nCe Privilège nécessite d'avoir le Désavantage “Instinct supérieur”.",
    cost: 4,
    unique: false,
    requireDetails: true
  ),
  sortilegeFeticheOmbre(
    caste: Caste.mage,
    title: 'Sortilège fétiche de l\'Ombre',
    description: "Permet de maîtriser parfaitement la technique de lancement d'un sortilège de l’ombre. Grâce à ce privilège, le magicien gagne un bonus de 4 chaque fois qu'il lance ce sortilège précis. Ce Privilège peut être acheté autant de fois que son Statut (sans compter le Privilège Sortilège Fétiche simple).",
    cost: 4,
    unique: false,
    requireDetails: true
  ),
  sortilegeFetichePierre(
    caste: Caste.mage,
    title: 'Sortilège fétiche de la Pierre',
    description: "Permet de maîtriser parfaitement la technique de lancement d’un sortilège de la Sphère de la Pierre. Grâce à ce Privilège, le magicien gagne un bonus de 4 chaque fois qu’il lance ce sortilège précis. Ce Privilège peut être acheté autant de fois que son Statut (sans compter le Privilège Sortilège Fétiche simple).\nCe Privilège nécessite d'avoir le Désavantage “Interdits de Brorne“.",
    cost: 4,
    unique: false,
    requireDetails: true
  ),
  sortilegeFeticheReves(
    caste: Caste.mage,
    title: 'Sortilège fétiche des Rêves',
    description: "Permet de maîtriser parfaitement la technique de lancement d’un sortilège du rêve. Grâce à ce Privilège, le magicien gagne un bonus de 4 chaque fois qu’il lance ce sortilège précis. Ce Privilège peut être acheté autant de fois que son Statut (sans compter le Privilège Sortilège Fétiche simple).\nCe Privilège nécessite d'avoir le Désavantage “Marque de Nenya“.",
    cost: 4,
    unique: false,
    requireDetails: true
  ),
  sortilegeFeticheVents(
    caste: Caste.mage,
    title: 'Sortilège fétiche des Vents',
    description: "Permet de maîtriser parfaitement la technique de lancement d’un sortilège de la Sphère des Vents. Grâce à ce Privilège, le mage gagne un bonus de 4 chaque fois qu’il lance ce sortilège précis. Ce Privilège peut être acheté autant de fois que son Statut (sans compter le Privilège Sortilège Fétiche simple).\nCe Privilège nécessite d'avoir le Désavantage “Curiosité“.",
    cost: 4,
    unique: false,
    requireDetails: true
  ),
  style(
    caste: Caste.mage,
    title: 'Style',
    description: "Permet de lancer ses sort d’une façon non conventionnelle, en employant des postures, des Clés ou des termes inédits. Le personnage peut remplacer des postures par d’autres, des chants ou des cris par d’autres sons, des runes par d’autres ou encore utiliser des Clés matérielles différentes, Il n’est pas possible de remplacer des Clés matérielles par une posture ou un chant par un simple geste.\nGrâce à ce Privilège, le mage peut être facilement reconnu lorsqu’il utilise son art, ce qui lui confère une solide réputation et le fait passer pour détenteur d’un Statut supérieur. En présence d’autres mages, le personnage gagne un bonus de 1 à sa Renommée, à partir du moment où il a été reconnu.",
    cost: 3
  ),
  transmutation(
    caste: Caste.mage,
    title: 'Transmutation (Mage du Métal)',
    description: "Ce Privilège n'est pas magique. Il permet, par un procédé alchimique, de transformer un métal en un autre métal. C'est une procédure longue, coûteuse en moyens et en hommes - c'est un type d'opération très dangereux. Suivant le Niveau de Réussite, le mage pourra transformer un métal pauvre en métal riche. La hiérarchie des métaux est : Cuivre (10) - Etain (15) - Bronze (15) - Fer (20) - Acier (20) - Plomb (25) - Argent (25) - Platine (30) - Or. La Difficulté du jet est indiquée pour chaque métal et permet de franchir un état +1/NR. A chaque passage d’un état à un autre, la matière perd 50 % de sa masse. Dans le cas d’un métal déjà issu d’une transmutation, la Difficulté est de +5 (cumulatif). Les abus de ce Privilège sont rares, la caste ne l’inculquant qu’à des mages triés sur le volet et s’autorégulant.\nCe Privilège nécessite d'avoir le Désavantage “Malédiction de Kezyr“.",
    cost: 4
  ),
  tuteur(
    caste: Caste.mage,
    title: 'Tuteur',
    description: "Permet de bénéficier de l'aide et de la bienveillance d’un mage de Statut supérieur, membre de la même école de magie que le personnage. Si ce mage n’est pas censé intervenir directement lors des aventures, il peut prodiguer des conseils, offrir son aide ou fournir au personnage des ingrédients rares - en échange de quelques petits services.",
    cost: 4,
    requireDetails: true
  ),
  tuteurSpecialise(
    caste: Caste.mage,
    title: 'Tuteur spécialisé',
    description: "Permet de bénéficier de l’aide et de la bienveillance d’un mage, mais aussi d’un protecteur, d’un Statut supérieur. Tout comme le tuteur, ce dernier peut aider par ses relations et ses conseils le mage (contre rémunération ou un service).",
    cost: 2,
    requireDetails: true
  ),
  visions(
    caste: Caste.mage,
    title: 'Visions (Mage des Océans)',
    description: "En utilisant un bassin ou une étendue d'eau comme support, le mage laisse dériver son esprit vers d’autres niveaux de conscience. Il peut alors entrer en contact empathique avec d’autres mages en Visions, communiquer avec des dragons, avoir des aperçus d’autres lieux ou capter des signes afférents à une situation épineuse. Le mage n’a aucun contrôle sur ses visions et il est courant qu’il ne perçoive que des éléments sans rapport avec ses centres d’intérêt. La vision dure (Tendance Dragon - Tendance Homme) minutes, l’approfondissement du sujet dévoilé étant souvent fonction de la durée de cet état.\nCe Privilège nécessite d'avoir le Désavantage “Instinct supérieur“.",
    cost: 3
  ),
  visionDeLaTrame(
    caste: Caste.mage,
    title: 'Vision de la trame',
    description: "Le mage peut percer le voile de la réalité pour contempler les torrents d'énergie élémentaire qui sillonnent le corps de l’Être Primordial. Le mage obtient un bonus égal à son Empathie pour toute action de détection magique (Compétence Analyse, détection de matrices, examen d'un lieu élémentaire...). Par contre, le personnage doit effectuer à chaque tour un jet de Mental + Volonté contre 25 pour supporter le contrecoup psychique d'un tel spectacle. Si le jet est raté, chaque point manquant est interprétable à loisir par le meneur comme des points de dommages subis cérébralement (donc sans armure) ou encore l'attribution d'un Désavantage liée à l'esprit (Phobie, Déviance...) d'une valeur de 1 point par 5 points manquants. Les éventuels NR obtenus sur ce jet octroient un tour par NR où les jets sont inutiles.",
    cost: 4
  ),
  voixDeKalimsshar(
    caste: Caste.mage,
    title: 'Voix de Kalimsshar (Mage de l\'Ombre)',
    description: "Lorsque le personnage effectue un jet en rapport avec l'Attribut Social, il peut doubler cet Attribut pour un jet. Ce Privilège est utilisable une fois par jour par Point de Tendance Fatalité.",
    cost: 3
  ),
  autoriteMagePierre(
    caste: Caste.mage,
    title: 'Autorité (Mage de la Pierre)',
    description: "C’est exactement le même Privilège que celui des protecteurs.\nPermet au personnage de faire valoir son Statut pour prendre la direction de toute investigation officielle au sein d’une cité respectant les Lois draconiques. Du moment qu’aucun protecteur (et pas mage) de Statut supérieur n’est présent, le personnage devient responsable des enquêtes, des rapports officiels et de la gestion des éventuels messages diplomatiques.",
    cost: 4
  ),
  apprentiMage(
    caste: Caste.mage,
    title: 'Apprenti',
    description: "Permet de disposer d’un apprenti qui, en plus de rendre de menus services au personnage, pourra s’occuper de son matériel en son absence, porter des messages, colporter des rumeurs et effectuer certaines tâches de base. L'apprenti doit être instruit et demandera un peu de temps et d’attention de la part de son maître. Au bout de quelques années, l’apprenti quittera le personnage pour se lancer seul.",
    cost: 6
  ),
  engagementMage(
    caste: Caste.mage,
    title: 'Engagement',
    description: "Permet d’ignorer, une fois par combat et pendant un tour complet, tous les malus découlant de ses blessures. Les malus reviennent normalement au début du tour suivant.",
    cost: 8
  ),
  memoireMage(
    caste: Caste.mage,
    title: 'Mémoire',
    description: "Permet de se remémorer un nom, une date, un événement ou une information oubliée du joueur qui l’incarne. Grâce à ce Privilège, le joueur peut demander au meneur de jeu de lui rappeler un détail vieux d’un mois à un an (en temps de jeu), selon l'importance de l'information.",
    cost: 8
  ),
  porteParoleMage(
    caste: Caste.mage,
    title: 'Porte-parole (Mage de la Pierre)',
    description: "C’est exactement le même Privilège que celui des protecteurs. Il est incompatible avec le Privilège de mage : Anonymat.\nPermet au personnage de faire office de porte parole au sein de n’importe quel groupe. Le protecteur peut ainsi servir d’interlocuteur auprès des milices locales, de seigneurs ou de dirigeants de cités, négocier des trêves ou des alliances diplomatiques, etc. La réussite de ces entreprises n’est absolument pas obligatoire, mais ce Privilège permet de prendre la parole dans des discussions que seuls les ambassadeurs attitrés sont normalement autorisés à mener.",
    cost: 4
  ),

  donDeBrorne(
    caste: Caste.prodige,
    title: 'Le don de Brorne',
    description: "Permet, en réussissant un jet de Physique + Volonté contre une Difficulté de 15, de diviser par deux les dommages d’une attaque physique portée contre le personnage. Ce Privilège peut être utilisé trois fois par jour à ce niveau de Difficulté ; toute tentative supplémentaire se voit infliger un malus cumulatif de 5.",
    cost: 4
  ),
  donDeHeyra(
    caste: Caste.prodige,
    title: 'Le don de Heyra',
    description: "Permet, en réussissant un jet de Mental + Volonté contre une Difficulté de 5, de soigner une case de blessure par Niveau de Réussite - en commençant par les plus graves. Un jet réussi permet d'effacer toutes les égratignures. Ce Privilège peut être utilisé trois fois par jour, mais jamais plus d'une fois par personne. Si ce Privilège parvient à être utilisé dans le même tour où un blessé décède, cette dernière passe en coma comme si elle avait été soignée par Chirurgie.\nCe Privilège n'a aucun effet si un critique entraîne une mort instantanée.",
    cost: 4
  ),
  donDeKali(
    caste: Caste.prodige,
    title: 'Le don de Kali',
    description: "Ce Don très particulier permet au Prodige d’infliger des blessures à n’importe quel être vivant, sans avoir à établir le moindre contact physique - grâce à la lune sombre, le Prodige atteint directement l’énergie vitale de son ennemi. Il n’y a pas de jet à effectuer : c’est le personnage choisit quel type de Blessure il souhaite infliger. En fonction de son Statut, il peut infliger une Blessure de type croissant par niveau qu’il a atteint. Ainsi, un Prodige de premier Statut ne pourra infliger qu’une Égratignure, tandis qu’un Prodige de troisième Statut pourra infliger - au choix - une Égratignure, une Légère ou une Grave. Seul le Grand Prodige peut donc causer la mort directement. Cependant, le personnage gagne automatiquement un nombre de cercles de Fatalité égal à 2 + le malus associé à la Blessure qu’il inflige - donc, par exemple, 5 cercles pour une Blessure Grave. Ces Blessures étant cumulatives avec celles que possède déjà la victime, il est toutefois possible de provoquer la mort de celle-ci. Dans ce cas, le Prodige gagne immédiatement 1 point de Fatalité qu’il ne pourra effacer qu'après une quête - laissée à l’appréciation du meneur de jeu. L'utilisation abusive de ce Don peut entraîner de graves sanctions de caste.\nUtilisable autant de fois par jour que sa Tendance Dragon plus sa Tendance Fatalité.",
    cost: 5
  ),
  donDeKalimsshar(
    caste: Caste.prodige,
    title: 'Le don de Kalimsshar',
    description: "Permet au personnage de soigner un individu ou un animal en “transférant” une case de blessure du blessé vers lui. Ce Privilège peut être utilisé sans limitation, mais il est impossible de transférer une case de mort de cette façon.",
    cost: 4
  ),
  donDeKezyr(
    caste: Caste.prodige,
    title: 'Le don de Kezyr',
    description: "Permet, deux fois par jour, de regagner tous ses Points de Maîtrise.",
    cost: 4
  ),
  donDeKhy(
    caste: Caste.prodige,
    title: 'Le don de Khy',
    description: "Permet, en réussissant un jet de Social + Empathie contre une Difficulté de 15, d'envoyer un message télépathique à un être humain. Le message ne peut comporter plus d’une phrase et ne peut être utilisé plus d’une fois par jour sur une même personne.",
    cost: 3
  ),
  donDeKhymera(
    caste: Caste.prodige,
    title: 'Le don de Khyméra',
    description: "Ce Don, comparable à celui de Kali, permet au personnage d’utiliser la corruption d’un être vivant contre lui. Le Prodige doit établir un contact physique pour déclencher le Don. Pour chaque point de Tendance Fatalité que possède la cible, cette dernière subit une Blessure, dans l’ordre croissant. Une créature ou un homme possédant 5 en Fatalité meurt donc instantanément, à moins qu’il ne réussisse un jet de Physique + Résistance contre une Difficulté de 20 - auquel cas, il reste en vie, mais noircit tout de même une case de Mort.\nSi le Prodige provoque la mort de cette façon, il gagne instantanément 1 point de Tendance Homme qu’il ne pourra effacer qu’après une quête - laissée à l’appréciation du meneur de jeu.",
    cost: 6
  ),
  donDeKroryn(
    caste: Caste.prodige,
    title: 'Le don de Kroryn',
    description: "Permet, une fois par tour, d'augmenter de 2 la valeur d’un dé d’Initiative ou des dommages de base d’une arme contondante.",
    cost: 4
  ),
  donDeMoryagorn(
    caste: Caste.prodige,
    title: 'Le don de Moryagorn',
    description: "Ce Don très puissant permet au personnage de localiser précisément n'importe quel être vivant dont il possède un objet que ce dernier a touché au moins une fois dans sa vie — c’est peut-être pour celte raison que les Prodiges portent sur eux tant de tatouages… En effaçant tous ses cercles de Tendance Dragon, 3 minimum, le Prodige peut instantanément voir où se trouve l’être de son choix et apprendre sa localisation exacte. Il sera ensuite capable de s’y rendre, en utilisant les moyens de transport classiques. En sacrifiant 1 point de Tendance Dragon, le Prodige peut de plus établir un contact télépathique avec sa cible, pendant une durée égale à la nouvelle valeur de sa Tendance Dragon en minutes.",
    cost: 4
  ),
  donDeNenya(
    caste: Caste.prodige,
    title: 'Le don de Nenya',
    description: "Permet, en réussissant un, jet de Mental + Volonté, d'annuler les effets d’un sort visant le personnage. La Difficulté de ce jet est de 10 + 5 par niveau du sort.\nCe Privilège ne peut être utilisé que trois fois par jour.",
    cost: 4
  ),
  donDOzyr(
    caste: Caste.prodige,
    title: "Le don d'Ozyr",
    description: "Permet, en réussissant un jet de Mental + Empathie contre une Difficulté de 15, de réveiller un savoir enfoui dans l'esprit d’un personnage. L'origine de ce savoir est mystérieuse (à la discrétion du meneur de jeu).\nLorsque ce Privilège est utilisé, l’esprit du personnage s'ouvre. Le meneur de jeu décide alors secrètement de l’information du savoir réveillé qu’il révélera au joueur à un moment critique, le personnage prenant subitement conscience de son potentiel. Ce Privilège ne peut être utilisé sur une personne avant qu’une réminiscence provoquée ne se soit révélée.",
    cost: 3
  ),
  donDeSolyr(
    caste: Caste.prodige,
    title: 'Le don de Solyr',
    description: "Ce Don, toujours actif, permet au personnage de gagner automatiquement un bonus de 2 sur tous ses jets impliquant l’Attribut Social, du moment qu’il ne fait pas appel aux Tendances. De plus, si le jet est réussi, il gagne automatiquement un Niveau de Réussite supplémentaire. Contrairement à la plupart des autres Privilèges, le bonus de 2 permet d’obtenir une réussite critique si le résultat arrive à 10.",
    cost: 4
  ),
  donDeSzyl(
    caste: Caste.prodige,
    title: 'Le don de Szyl',
    description: "Permet, une fois par combat, de lancer un dé supplémentaire d’Initiative. Il est toujours impossible de conserver plus de dés qu’un personnage ne possède de nombre d'actions.",
    cost: 3
  ),
  aplombProdige(
    caste: Caste.prodige,
    title: 'Aplomb',
    description: "Permet de contrôler ses émotions et de faire prévaloir sa condition de Prodige en toutes circonstances, aidant le personnage à éviter un combat, à engager une discussion posée ou à bénéficier du respect dû à sa caste. Le personnage peut alors ajouter son Statut à son premier jet destiné à bloquer une situation en train de dégénérer. Ce jet peut être un jet de Diplomatie dans le cas d’une négociation tendue ou de Commandement dans le cas d’un combat sur le point de débuter.",
    cost: 2
  ),
  engagementProdige(
    caste: Caste.prodige,
    title: 'Engagement',
    description: "Permet d'ignorer, une fois par combat et pendant un tour complet, tous les malus découlant de ses blessures. Les malus reviennent normalement au début du tour suivant.",
    cost: 8
  ),
  reflexesDeDegagement(
    caste: Caste.prodige,
    title: 'Réflexes de dégagement',
    description: "Permet, une fois par combat, de bénéficier d'une esquive gratuite, dont la Difficulté est toujours de 15.",
    cost: 6
  ),

  adopte(
    caste: Caste.protecteur,
    title: 'Adopté',
    description: "Permet de se faire reconnaître de n'importe quel dragon, autre qu’un enfant de Kalimsshar, comme porteur de l'autorité de Brorne. Grâce à ce Privilège, le personnage pourra ainsi être autorisé à communiquer par télépathie, à demander de l’aide ou à échanger des informations avec n’importe quel dragon.\nSelon la situation, il lui sera éventuellement possible d'obtenir le soutien momentané du dragon ou de proposer ses services reconnus à l’ailé. Si le dragon le souhaite, il pourra même le représenter dans certaines interactions avec les humains.",
    cost: 5
  ),
  autorite(
    caste: Caste.protecteur,
    title: 'Autorité',
    description: "Permet de faire valoir son Statut pour prendre la direction de toute investigation officielle au sein d’une cité respectant les Lois draconiques. Du moment qu’aucun protecteur de Statut supérieur n’est présent, le personnage devient responsable des enquêtes, des rapports officiels et de la gestion des éventuels messages diplomatiques.",
    cost: 4
  ),
  cuirasse(
    caste: Caste.protecteur,
    title: 'Cuirasse',
    description: "Permet de diviser par deux les dommages infligés par une attaque. Pour utiliser ce Privilège, le personnage doit impérativement porter une armure et annoncer qu’il ne tente aucune autre action de défense - ni esquive, ni parade. Ce Privilège ne peut être utilisé qu’une seule fois par combat et s'applique aux dégâts avant le décompte de l’armure.",
    cost: 5
  ),
  defense(
    caste: Caste.protecteur,
    title: 'Défense',
    description: "Permet d'effectuer une parade gratuite au bouclier par tour de combat. Cette parade ne compte pas dans le nombre d'actions du personnage et ne subit pas de Difficulté supplémentaire.",
    cost: 6
  ),
  influences(
    caste: Caste.protecteur,
    title: 'Influences',
    description: "Permet de disposer d’un réseau d’informateurs et de collaborateurs fidèles aux Lois draconiques, capables de lui apporter une aide non négligeable. Ce Privilège peut permettre d’obtenir des informations, de demander un soutien actif ou de disposer d’un petit nombre d'hommes de main en peu de temps. Il n’est applicable qu’au sein d’une cité comptant des groupes d'hommes et de femmes respectueux des Lois draconiques.",
    cost: 3,
    requireDetails: true
  ),
  lucidite(
    caste: Caste.protecteur,
    title: 'Lucidité',
    description: "Permet au personnage de conserver une vision claire et globale en toute circonstance - qu’il soit au cœur d’une mêlée, dans un tunnel enfumé, etc. Ce Privilège donne au personnage le droit d’effectuer un jet de Perception et de réduire de 5 la Difficulté de jets pénalisés par le chaos ambiant, le bruit, la confusion, etc.",
    cost: 3
  ),
  porteParole(
    caste: Caste.protecteur,
    title: 'Porte-parole',
    description: "Permet de faire office de porte-parole au sein de n'importe quel groupe. Le protecteur peut ainsi servir d’interlocuteur auprès de milices locales, de seigneurs ou de dirigeants de cités, négocier des trêves ou des alliances diplomatiques… La réussite de ces entreprises n’est absolument pas obligatoire, mais ce Privilège permet de prendre la parole dans des discussions que seuls les ambassadeurs attitrés sont normalement autorisés à mener.",
    cost: 3
  ),
  regardInquisiteur(
    caste: Caste.protecteur,
    title: 'Regard inquisiteur (Protecteur Inquisiteur)',
    description: "Avant d’interroger ou de torturer un individu, l’inquisiteur peut en juger d’un regard la Volonté (à un point près) et la force morale. Par ce regard, l’inquisiteur sait intuitivement quels vont être les forces et faiblesses du suspect, et quelle technique (interrogatoire ou torture) il doit employer pour un maximum d’efficacité. Il obtient un bonus de +3 sur son jet d’interrogatoire ou de torture, cumulable avec d’autres bonus éventuels. De plus, il affecte le subconscient du suspect et diminue sa résistance mentale et physique. S’il torture, pour chaque degré de Statut, il peut augmenter les malus de blessures de chaque seuil de 1 (les faisant passer par exemple de 0/-1/-3/-5 à -3/-4/-6/-8 pour un inquisiteur du 3e statut). S’il effectue un interrogatoire, le MJ diminue de moitié le temps nécessaire pour faire craquer le suspect. Ce Privilège n’est utilisable qu’en situation d’interrogatoire, de torture ou de procès.",
    cost: 3
  ),
  renseignement(
    caste: Caste.protecteur,
    title: 'Renseignement',
    description: "Permet au personnage d'obtenir des renseignements précis sur tout individu, guilde, faction ou groupe potentiellement connu de la caste des protecteurs. Pour ce faire, il doit prendre contact avec un relais de sa caste - poste de garde, garnison, ambassadeur, etc. - et réussir un jet de Social + Vie en cité, Diplomatie ou Présence, contre une Difficulté allant de 10, sil s’agit d’une information anodine ou d’un individu public, à 30, si l’information est confidentielle ou l’individu doté d’une identité secrète. Le personnage peut ajouter son niveau de Statut s’il utilise la voie hiérarchique et la Difficulté peut être augmentée ou réduite de 5 à 10 en fonction de l’importance du service de renseignements auquel le personnage s'adresse. Chaque Niveau de Réussite peut accélérer la procédure ou conférer une information supplémentaire au personnage.",
    cost: 4
  ),
  requisition(
    caste: Caste.protecteur,
    title: 'Réquisition',
    description: "Permet de réquisitionner tout matériel, renfort ou moyen financier qu’il juge indispensable au bon déroulement de sa mission. Les abus sont sévèrement punis par la caste.",
    cost: 4
  ),
  suspicion(
    caste: Caste.protecteur,
    title: 'Suspicion',
    description: "Permet au personnage, habitué aux interrogatoires et aux confrontations, de deviner qu’on lui ment ou qu'on tente de lui cacher, même partiellement, une information. Pour éviter de mettre la puce à l'oreille du joueur, il est conseillé au meneur de jeu de procéder lui-même à un jet de Social + Intellect contre une Difficulté de 10 à 20 et de donner au personnage les informations qu’il juge appropriées. Si le personnage pense être confronté à un mensonge, il peut demander à ce qu’un jet soit effectué.\nAttention cependant : un personnage par trop suspicieux risque fort, à terme, de devenir paranoïaque et de croire que tout le monde lui ment - au meneur de jeu de transformer ces abus de Privilège en un Désavantage…",
    cost: 4
  ),
  signesDeBatailleProtecteur(
      caste: Caste.protecteur,
      title: 'Signes de bataille',
      description: "Permet de manier un langage basé sur les signes, le mouvement des yeux et les postures, afin de communiquer silencieusement des informations. Il n’y aucun jet à effectuer, mais les informations doivent être simples (couvre-moi, attaque par le flanc, j'en vois deux, etc.) et l'interlocuteur du personnage doit obligatoirement posséder ce Privilège pour le comprendre.",
      cost: 4
  ),
  engagementProtecteur(
    caste: Caste.protecteur,
    title: 'Engagement',
    description: "Permet d’ignorer, une fois par combat et pendant un tour complet, tous les malus découlant de ses blessures. Les malus reviennent normalement au début du tour suivant.",
    cost: 8
  ),
  notorieteProtecteur(
    caste: Caste.protecteur,
    title: 'Notoriété',
    description: "Permet de s’être forgé une bonne réputation au sein d’une cité ou d’une région de petite taille. La Renommée du personnage est augmentée de 1 une fois qu’il est reconnu. Le personnage gagne un bonus de 1 à toutes ses actions sociales effectuées à l’intérieur de cette cité ou de cette région.\nCe Privilège peut être acheté plusieurs fois et s'applique à une cité ou à une petite région à chaque fois.",
    cost: 8,
    unique: false,
    requireDetails: true
  ),

  archer(
    caste: Caste.voyageur,
    title: 'Archer',
    description: "Permet de tirer une flèche supplémentaire lors d’un tour de combat. Cette attaque est gratuite, ne compte pas dans le nombre d'actions et n’est assortie d’aucune Difficulté supplémentaire. Son initiative est égale à celle du dé le plus faible.",
    cost: 6
  ),
  chasseur(
    caste: Caste.voyageur,
    title: 'Chasseur',
    description: "Permet au personnage d’effectuer une attaque à distance avant le début d’un tour de combat, sans dépenser d’action ou déterminer de rang d’Initiative. Pour cela, le joueur doit impérativement prévenir le meneur de jeu de la “préparation” de son personnage - flèche encochée, vigilance, etc. - et réussir un jet de Manuel + Perception + niveau de Statut contre une Difficulté de 20. Cette Difficulté peut être réduite ou augmentée de 5 selon que le personnage est particulièrement vigilant, aux aguets ou, au contraire, fatigué, inattentif, etc.\nLe jet d’attaque est géré de façon normale et peut faire l’objet d’un appel aux Tendances, de dépense de Points de Maîtrise ou de Chance, mais ne peut en aucun cas être couplé avec un autre Privilège de caste, quel qu’il soit.",
    cost: 6
  ),
  compagnons(
    caste: Caste.voyageur,
    title: 'Compagnons',
    description: "Permet de disposer d’une connaissance amicale dans n’importe quelle cité comptant plus de cinq mille habitants. Cet ami pourra rendre des services, fournir des renseignements ou apporter une aide variée - hébergement, prêt de matériel, etc.",
    cost: 3,
    unique: false,
    requireDetails: true
  ),
  connaissanceDuMonde(
    caste: Caste.voyageur,
    title: 'Connaissance du monde',
    description: "Permet de déterminer la provenance de n'importe quel objet, vêtement, animal ou être humain, rien qu’en l’observant. De simples détails suffisent au personnage pour définir avec précision la région d’origine de ce qu’il observe.",
    cost: 3
  ),
  enigmatique(
    caste: Caste.voyageur,
    title: 'Énigmatique',
    description: "Permet au personnage de masquer si bien ses émotions, ses valeurs personnelles et ses motivations que, s’il est soumis à la question ou sondé par des moyens magiques n’a que peu de chances de discerner la graduation de ses Tendances.\nLa difficulté de tout jet visant à définir les Tendances du personnage est, en secret, augmentée de 10. Le meneur de jeu doit se garder d’annoncer cette augmentation. Si le jet est réussi que contre la Difficulté de base, le personnage voyageur peut modifier tout ou partie des valeurs de ses Tendances, en les augmentant et/ou les réduisant chacune d’un nombre de points maximum égal à son niveau de Statut - tout en conservant la limite cumulée de 5 points. Cependant, si le jet est réussi contre la Difficulté réelle, soit celle de base augmentée de 10, le personnage ne parvient à altérer aucune des informations recherchées par l’observateur. Ce Privilège peut également servir à masquer ses motivations, ses origines ou ses buts.\nAttention, il ne permet pas de mentir mieux, mais simplement de maintenir un apparent mystère sur ses valeurs personnelles. Si le personnage est interprété de façon expansive, ce Privilège ne fonctionne plus.\nIl est inutilisable contre des pouvoirs ne nécessitant aucun jet.",
    cost: 3
  ),
  filsDeLaTerre(
    caste: Caste.voyageur,
    title: 'Fils de la terre',
    description: "Permet d'utiliser son environnement pour improviser un remède de fortune à n'importe quel mal - fracture, empoisonnement, paralysie, etc. En réussissant un jet de Manuel + Survie contre une Difficulté de 15, il peut annuler les effets d’un désagrément pour une période de 24 heures, après quoi l'intervention d’un soigneur ou d’un remède spécifique deviendra indispensable. Cette Difficulté peut être réduite de 5 si le personnage se trouve dans le milieu défini par sa survie, et augmentée de 5 dans un milieu différent.",
    cost: 4
  ),
  garantVoyageur(
    caste: Caste.voyageur,
    title: 'Garant',
    description: "Permet au personnage de jouer de sa réputation et de son statut de voyageur pour faire prévaloir la bonne foi, l'honnêteté de ses compagnons. En se portant ainsi garant de ses amis, il accorde à tous les membres de son groupe - à définir par le personnage lui-même, en fonction de ses propres critères - un bonus égal à son niveau de Statut pour tous les jets de Social effectués en sa présence. Ce bonus n’est applicable que dans des situations où le personnage peut de façon évidente se porter garant du groupe - droit d’entrée au sein d’une cité, partage d’informations, discussion avec des mages, des nobles, etc.\nEn contrepartie, le personnage subira seul les éventuelles retombées de propos ou d’actes déplacés commis sous son “autorité”. Les sanctions de caste et les malus aux futurs jets de Social n’en sont qu’un exemple.",
    cost: 3
  ),
  logistique(
    caste: Caste.voyageur,
    title: 'Logistique',
    description: "Permet de toujours disposer de croquis et de cartes sommaires détaillant les principales régions du monde. Seules les cités, les constructions et les souterrains n’ont aucune chance d’être affectés par ce Privilège.",
    cost: 2
  ),
  maitriseDArmure(
    caste: Caste.voyageur,
    title: "Maîtrise d'armure",
    description: "Permet de rendre son armure particulièrement résistante à une arme précise.\nPour utiliser ce Privilège, le personnage doit obligatoirement être spécialisé dans l’arme contre laquelle il souhaite renforcer son armure. L'Indice de protection augmente de 10 face à cette arme.",
    cost: 5
  ),
  rancune(
    caste: Caste.voyageur,
    title: 'Rancune',
    description: "Permet de connaître les points faibles d’une catégorie d'animaux ou de créatures et de bénéficier d’un bonus de 2 points à toutes les attaques visant une créature de cette espèce. En plus de la catégorie, le personnage doit choisir le type d'attaque sur lequel s'applique ce bonus - corps à corps, armes de mêlée, armes de jet ou armes à projectiles.",
    cost: 4,
    unique: false,
    requireDetails: true
  ),
  solitaire(
    caste: Caste.voyageur,
    title: 'Solitaire',
    description: "Permet d’agir plus efficacement lorsqu'il est seul et de gagner un bonus de 2 à ses actions de discrétion, de pister, de diplomatie et de Commumication.",
    cost: 4
  ),
  vigilanceVoyageur(
    caste: Caste.voyageur,
    title: 'Vigilance',
    description: "Permet au personnage de se maintenir dans un état de conscience aiguë de son environnement et de prévoir, de sentir, de deviner les signes annonciateurs de danger ou d'événement. Très utile pour se réveiller en pleine nuit ou deviner l'imminence d'une embuscade, sur les chemins de Kor. S’utilise systématiquement avant tout jet de réaction. Le jet de Mental + Perception s’effectue contre la Difficulté du jet de réaction à venir. Un jet réussi octroie un bonus indirect de 3+3/NR au jet de réaction qui est effectué normalement dans la seconde qui suit. Le personnage ne peut communiquer avec ses compagnons avant d’avoir résolu le jet de réaction. Le meneur de jeu pourra (et cela est même préférable) effectuer lui-même ce jet et annoncer au personnage les éventuels bonus dont il dispose.",
    cost: 5
  ),
  ambassadeVoyageur(
    caste: Caste.voyageur,
    title: 'Ambassade',
    description: "Permet de disposer d’un sceau, d’un sauf-conduit ou d’un laissez-passer officiel qui lui ouvrira les portes de nombreuses cités de Kor. En choisissant ce Privilège, le joueur doit préciser l’origine de son mandat, car il est évident qu’un document émanant de l’Empire de Solyr n’aura que peu d'influence en plein désert zûl…\nLes applications de ce Privilège sont laissées à la discrétion du meneur de jeu. En contrepartie de certains avantages, le personnage peut également avoir à rendre des services ou à servir de messager officiel entre deux États. De plus, le personnage devra conserver une position et un comportement exemplaire vis-à-vis du pays qu’il représente.",
    cost: 6
  ),
  familierVoyageur(
    caste: Caste.voyageur,
    title: 'Familier',
    description: "Permet de posséder un petit animal intelligent, généralement un oiseau ou un mammifère, capable d’échanger des émotions et des informations sommaires avec le personnage et de lui rendre quelques menus services (dénicher une source, flairer une piste, signaler l’approche d’humains ou de prédateurs, etc.)",
    cost: 2,
    unique: false,
    requireDetails: true
  ),
  linguistiqueVoyageur(
    caste: Caste.voyageur,
    title: 'Linguistique',
    description: "Permet de maîtriser les rudiments de suffisamment de dialectes issus du langage draconique pour comprendre, et se faire comprendre dans la majorité des régions de Kor sans passer de longues journées à comprendre les variations locales. Ce Privilège ne permet pas de poursuivre une discussion soutenue, mais au moins d’éviter tout malentendu.",
    cost: 4
  )
  ;

  final Caste caste;
  final String title;
  final String description;
  final int cost;
  final bool unique;
  final bool requireDetails;

  const CastePrivilege({
    required this.caste,
    required this.title,
    required this.description,
    required this.cost,
    this.unique = true,
    this.requireDetails = false,
  });
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CharacterCastePrivilege {
  CharacterCastePrivilege({ required this.privilege, this.description });

  CastePrivilege privilege;
  String? description;

  factory CharacterCastePrivilege.fromJson(Map<String, dynamic> j) => _$CharacterCastePrivilegeFromJson(j);
  Map<String, dynamic> toJson() => _$CharacterCastePrivilegeToJson(this);
}

class CareerInterdict {
  const CareerInterdict({ required this.title, required this.description });

  final String title;
  final String description;
}

class CareerBenefit {
  const CareerBenefit({ required this.title, required this.description });

  final String title;
  final String description;
}

enum Career {
  alchimiste(
    caste: Caste.artisan,
    title: "L'alchimiste",
    interdict: CareerInterdict(
      title: "Tu ne corrompras pas les éléments fondamentaux" ,
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Les secrets de la matière',
      description: "Grâce à ses connaissances alchimiques, le personnage peut substituer poudres et distillations aux ingrédients et aux Clés magiques en vue de produire des effets comparables à ceux d’un sortilège. Pour chaque niveau de Statut, il peut créer des poudres et des substances capables de provoquer les mêmes effets qu’un sortilège d’un niveau de Sorcellerie. Ainsi, au troisième Statut, le personnage peut “lancer” trois sorts de premier niveau, un du second et un du premier, un du troisième, etc. Le personnage doit cependant étudier ces sortilèges et être instruit par un mage les possédant. Chaque fois qu’il atteint un Statut supérieur, il peut librement choisir d’apprendre de nouveaux sorts et d’oublier ou de conserver certains anciens.\nLes jets de magie s’effectuent avec Manuel + Alchimie, mais le personnage devant préparer ses poudres auparavant, aucun “Point de Magie” n’est nécessaire.",
    ),
  ),
  architecte(
    caste: Caste.artisan,
    title: "L'architecte",
    interdict: CareerInterdict(
      title: "Tu n'entreprendras rien sans préparation",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'esquisse",
      description: "Grâce à ce Bénéfice, le personnage peut effectuer un jet de Mental + Plans + niveau de Statut contre une Difficulté de 15 - augmentée ou réduite de 5, en fonction de la situation - pour dresser une esquisse de n'importe quelle construction à venir. Chaque Niveau de Réussite obtenu sur ce jet réduit de 5 la Difficulté du jet d’Artisanat ou de fabrication à suivre, que ce soit le personnage ou un autre qui l’effectue. Il n’est possible de réduire ainsi la Difficulté que de 5 par niveau de Statut du personnage.",
    ),
  ),
  artisanElementaire(
    caste: Caste.artisan,
    title: "L'artisan élémentaire",
    interdict: CareerInterdict(
      title: "Tu resteras en harmonie avec les énergies fondamentales",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'écheveau élémentaire",
      description: "Le personnage devient capable de modeler une matière à mains nues. Si la matière est dangereuse (lave, verre en fusion, métal porté au rouge), il doit dépenser un point de magie (de sa Réserve ou de la Sphère concernée par la matière) pour ne pas en subir les effets. Cette immunité ne le protège pas contre les sorts mais peut s’appliquer à certains de leurs effets résultants (lave, eau bouillante) tant que le personnage dépense des points de magie. Lorsqu’il travaille la matière de cette façon, il utilise sa Compétence d’Artisanat élémentaire avec un bonus égal à la moitié de sa Sphère concernée (arrondi au supérieur), comme Nature pour le bois ou Pierre pour le marbre.",
    ),
  ),
  forgeron(
    caste: Caste.artisan,
    title: 'Le forgeron',
    interdict: CareerInterdict(
      title: 'Tu ne tiendras aucune œuvre pour parfaite',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'La beauté du geste',
      description: "Chaque fois qu’il réussit un jet de Forge, le personnage gagne automatiquement 1 Niveau de Réussite par niveau de Statut. Le résultat de son jet n’est pas modifié par ces Niveaux gratuits, mais ces derniers s’ajoutent à ceux déjà obtenus pour déterminer la qualité de l'objet.",
    ),
  ),
  mecaniste(
    caste: Caste.artisan,
    title: 'Le mécaniste',
    interdict: CareerInterdict(
      title: "Tu n'auras d'autre but que l'évolution",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'La liberté de pensée',
      description: "Le personnage peut utiliser de la Maîtrise APRES un jet et peut obtenir des NR par cet usage. Il ne peut pas cumuler une dépense de Chance et de Maîtrise. De plus, il ajoute son niveau de Statut à sa Tendance Homme pour calculer le niveau maximal des compétences y faisant référence.\nNote: Les mécanistes sont surveillés de près par leurs Parfaits et, dans une moindre mesure, les érudits, ce qui explique leurs obligations de Tendance afin qu’ils ne sombrent pas dans l’Humanisme…",
    ),
  ),
  mineur(
    caste: Caste.artisan,
    title: 'Le mineur',
    interdict: CareerInterdict(
      title: "Tu ne souilleras pas le corps de l'Être Primordial",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Le diamant brut',
      description: "Ce Bénéfice offre au personnage une faculté par niveau de Statut. Au premier, il lui permet de déterminer à 10% près la profondeur ou l'altitude à laquelle il se trouve. Au second, le personnage peut réduire de 5 la Difficulté de tous ses jets d’orientation en milieu montagneux - et de 10 en milieu souterrain. Au troisième, il peut déterminer sans risque d’erreur la nature exacte de n’importe quelle substance minérale. Au quatrième, il peut extraire à mains nues n’importe quel objet ou minerai enchâssé dans la roche. Enfin, au cinquième, il gagne - ou développe gratuitement - un niveau égal à sa Tendance Dragon dans la Sphère de la Pierre.",
    ),
  ),
  orfevre(
    caste: Caste.artisan,
    title: "L'orfèvre",
    interdict: CareerInterdict(
      title: 'Tu honoreras ta caste par ton talent',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'La source de beauté',
      description: "En puisant dans l’énergie des bijoux et des gemmes, le personnage peut se ressourcer et regagner des Points de Maîtrise - pour les premiers - ou de Magie d’une Sphère - pour les seconds. Il lui suffit de serrer l’objet dans ses mains pour récupérer en quelques secondes un nombre de points égal à son niveau de Statut. Ce Bénéfice n’est utilisable qu’une fois par jour et le meneur de jeu se réserve le droit de limiter le nombre de points ainsi conférés, en fonction de la nature ou de la “valeur” de la source.",
    ),
  ),
  tisserand(
    caste: Caste.artisan,
    title: 'Le tisserand',
    interdict: CareerInterdict(
      title: "Tu magnifieras les traditions",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'La fibre de la vie',
      description: "En touchant n'importe quelle matière textile manufacturée, le personnage est capable de déterminer instinctivement un nombre d’informations - origine d’un vêtement, sexe du porteur, climats traversés, etc. - égal à son niveau de Statut. Aucun jet n’est nécessaire.",
    ),
  ),

  aventurier(
    caste: Caste.combattant,
    title: "L'aventurier",
    interdict: null,
    benefit: CareerBenefit(
      title: "Forger l'expérience",
      description: "Â la fin de chaque aventure, le personnage gagne un nombre de Points d’Expérience supplémentaires, égal au niveau de son Statut.",
    ),
  ),
  chevalier(
    caste: Caste.combattant,
    title: 'Le chevalier',
    interdict: CareerInterdict(
      title: 'Tu feras honneur à ta caste',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Le cœur pur',
      description: "Une fois par jour, le personnage peut soigner de ses mains un nombre de Blessures égal au niveau de son Statut - et ce, quel que soit le type de Blessures. Cependant, pour chaque Blessure Grave qu’il soigne ainsi, il subit automatiquement une Égratignure ; et pour chaque Blessure Fatale, une Blessure Légère.\nDe plus, pour chaque point de Tendance Fatalité que possède le bénéficiaire de ces soins, le personnage subit automatiquement une Blessure supplémentaire, en commençant par les Égratignures.",
    ),
  ),
  duelliste(
    caste: Caste.combattant,
    title: 'Le duelliste',
    interdict: CareerInterdict(
      title: "Tu honoreras chaque adversaire",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'instant de vérité",
      description: "Lorsqu’il combat seul un adversaire, le duelliste peut dépenser des actions en début de tour afin de réduire le nombre de dés d’Initiative de son opposant. Ces actions doivent être déclarées avant le lancement des dés d’Initiative et ne peuvent réduire l’Initiative de la cible au-dessous de 1. Ce bénéfice est utilisable autant de fois par combat que le personnage possède de degrés de Statut. Il n’est pas possible d’appliquer ce Bénéfice à plusieurs cibles au cours d’un même combat.",
    ),
  ),
  gladiateur(
    caste: Caste.combattant,
    title: 'Le gladiateur',
    interdict: CareerInterdict(
      title: "Tu respecteras l'adversaire valeureux",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'art du combat",
      description: "Chaque fois qu’il atteint un Statut supérieur, le personnage peut choisir une attaque particulière, de corps à corps ou de combat armé, comme l’une de ses spécialités. Il gagnera automatiquement un bonus de +2 à tous ses jets d’attaque lorsqu'il utilisera l’un de ces coups spéciaux. En choisissant cette carrière, le personnage débute avec un nombre de spécialités égal au niveau de son Statut. Une fois les spécialités choisies, il est impossible d’en changer.",
    ),
  ),
  guerrier(
    caste: Caste.combattant,
    title: 'Le guerrier',
    interdict: CareerInterdict(
      title: "Tu ne feras preuve d'aucune lâcheté",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'engagement du combat",
      description: "Une fois par tour de combat, le personnage peut ajouter le niveau de son Statut à la valeur de l’un de ses dés d’Initiative. L'utilisation de ce Bénéfice doit être annoncée avant l’annonce des valeurs adverses et le personnage ne peut effectuer aucune action de défense grâce à ce dé.",
    ),
  ),
  lutteur(
    caste: Caste.combattant,
    title: 'Le lutteur',
    interdict: CareerInterdict(
      title: "Tu n'useras pas d'artifice",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "De chair et d'os",
      description: "Lorsqu'il se bat au corps à corps, le personnage peut relancer un nombre de dés de dommages égal au niveau de son Statut. Un même dé peut être relancé plusieurs fois, mais ce Bénéfice ne peut être utilisé qu’une seule fois par tour de combat.",
    ),
  ),
  maitreDArmes(
    caste: Caste.combattant,
    title: "Le maître d'armes",
    interdict: CareerInterdict(
      title: "Tu ne manieras d'autre arme que la tienne",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "La perfection ne retient qu'un nom",
      description: "Chaque fois qu’il affronte un adversaire maniant l’arme dans laquelle il s’est spécialisée, et qu’il combat avec cette même arme, le personnage gagne un bonus à tous ses jets de combat égal au niveau de son Statut.",
    ),
  ),
  mercenaire(
    caste: Caste.combattant,
    title: 'Le mercenaire',
    interdict: CareerInterdict(
      title: 'Tu ne trahiras point',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Une cause, un bras',
      description: "Chaque matin, le personnage doit choisir l’une des trois Tendances pour guider son bras durant la journée. Ensuite, chaque fois qu’il fera appel aux Tendances et qu’il conservera le dé correspondant, il pourra ajouter le niveau de son Statut au résultat du dé — mais il gagnera également 2 Cercles de Tendance.\nCe Bénéfice ne permet pas d’obtenir une réussite critique en atteignant 10 ou plus.",
    ),
  ),
  paladin(
    caste: Caste.combattant,
    title: 'Le paladin',
    interdict: CareerInterdict(
      title: 'Tu protégeras la vie',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Nulle place au doute',
      description: "Lorsqu’il affronte un adversaire possédant des points dans la Tendance qui lui est Opposée, le personnage peut choisir de gagner un bonus à tous les jets de défense de son adversaire. Ce modificateur est égal à son Statut + valeur de la Tendance Opposée de son adversaire. Le personnage doit choisir la façon dont il utilise ce Bénéfice au début du premier tour de combat et ne peut plus en changer tant qu’il s’agit du même adversaire.",
    ),
  ),
  strategeCombattant(
    caste: Caste.combattant,
    title: 'Le stratège',
    interdict: CareerInterdict(
      title: "Tu respecteras l'adversaire valeureux",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "La voie d'une armée",
      description: "Avant le premier tour de chaque combat, le personnage peut effectuer un jet de Mental + Stratégie contre une Difficulté de 5 pour conférer un bonus, égal au nombre de Niveaux de Réussite + 1, à un nombre de compagnons égal au niveau de son Statut. Ce bonus peut être utilisé pour augmenter n'importe quel jet d’attaque ou d’Initiative durant le tour. S'il n’est pas utilisé, il disparaît, mais le personnage peut effectuer ce jet au début de chaque tour - s’il choisit de n’effectuer aucune autre action. Le personnage doit être à portée de voix et de vue de ses compagnons pour utiliser ce Bénéfice. S'il est attaqué, la Difficulté de tous ses jets de défense est augmentée de 5.",
    ),
  ),

  courtisane(
    caste: Caste.commercant,
    title: 'La courtisane',
    interdict: CareerInterdict(
      title: 'Tu ne renieras pas ta condition',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Le sourire',
      description: "Une fois par jour par degré de statut, le personnage peut influencer le résultat de toute action en forçant un individu à conserver un autre dé que celui qu'il désire lorsqu'il utilise les Tendances. La victime gagne les points de Tendance découlant de ce choix comme si c'était le sien. Si cette dernière ne fait pas appel aux Tendances, le dé neutre peut devenir le dé d'une des trois Tendances et agir comme tel en ce qui concerne l'évolution des Tendances. Ce Bénéfice peut être utilisé lors de n'importe quelle action se déroulant autour du personnage, à partir du moment où ce dernier est en mesure de parler, séduire, distraire ou capter le regard de sa cible afin de la perturber.\nNote: Le comptoir marchand du Bénéfice de 2e Statut est remplacé par un boudoir isolé et quelques servantes.",
    ),
  ),
  diplomate(
    caste: Caste.commercant,
    title: 'Le diplomate',
    interdict: CareerInterdict(
      title: 'Tu ne laisseras aucune situation tendre verse le meurtre',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Les mots justes',
      description: "Ce Bénéfice à l'utilisation double permet au personnage de disposer, chaque jour, d'un nombre de Niveaux de Réussite gratuits égal à son niveau de Statut. Ces Niveaux peuvent être dépensés pour augmenter la réussite de n'importe quel jet de Social déjà réussi par le personnage. De plus, le personnage est immunisé contre tous les effets susceptibles de modifier la Difficulté d'un jet ou le choix d'un dé lorsqu'il annonce le dé de l'Homme en faisant appel aux Tendances.\n Note: Le comptoir marchand du Bénéfice de 2e Statut est remplacé par une maison et un scribe qualifié.",
    ),
  ),
  espion(
    caste: Caste.commercant,
    title: "L'espion",
    interdict: CareerInterdict(
      title: 'Tu ne trahiras pas tes secrets',
      description: "",
    ),
    benefit: CareerBenefit(
      title: "Le manteau d'ombre",
      description: "Chaque fois qu'il fait appel aux Tendances lors d'un jet impliquant l'Attribut Manuel, Physique ou Social pour réaliser une action de discrétion, de perception, d'investigation ou de mensonge, le personnage peut relancer une fois le dé de l'Homme. Il peut ensuite décider de conserver ce nouveau résultat, de conserver un autre dé ou relancer une fois de plus le dé de l'Homme. Ce Bénéfice peut être utilisé une fois par jour par niveau de Statut du personnage. L'espion ne gagne aucun Point de Tendance s'il conserve un autre dé après avoir relancé celui de l'Homme.\nNote: Le comptoir marchand du Bénéfice de 2e Statut est remplacé par un repaire discret muni de nombreuses sorties secrètes.",
    ),
  ),
  joueur(
    caste: Caste.commercant,
    title: 'Le joueur',
    interdict: CareerInterdict(
      title: "Tu prendras les riques qui s'imposent",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Relever le défi',
      description: "Lors de toute opposition avec un autre personnage (combat, discussion, jet d’opposition, etc.), le joueur peut spontanément défier son adversaire, verbalement ou par son attitude naturelle et son regard. Le défi est automatiquement géré avant toute action et n’a pas besoin d’être accepté, à moins que le meneur ne décide que l’adversaire ne comprend pas le défi (peuple ancien, animal enragé, monstre inintelligent). Il mise alors autant de Points de Chance et/ou de Maîtrise qu'il le souhaite. Son adversaire peut accepter le défi en en misant au moins autant, puis le personnage peut de nouveau dépenser des points, et ainsi de suite. Lorsque les deux protagonistes ont passé leur tour, celui qui a misé le plus de points cumulés gagne le défi. Il perd les points qu'il a misés, mais remporte les Points de Maîtrise ou de Chance misés par l'adversaire. Le perdant perd tous les points ainsi misés et subit un malus égal au total des points misés par le vainqueur sur le jet de sa prochaine action, quelle qu'elle soit. Si c'est le personnage qui gagne le défi, il inflige un malus supplémentaire égal à son niveau de Statut à son adversaire. Ce Bénéfice peut être utilisé une fois par jour par niveau de Statut.\nNote: Le comptoir marchand du Bénéfice de 2e Statut est remplacé par une connaissance de tous les videurs et gros bras de la cité de prédilection du personnage et des accès privilégiés dans les tavernes et maisons de jeu.",
    ),
  ),
  marchand(
    caste: Caste.commercant,
    title: 'Le marchand',
    interdict: CareerInterdict(
      title: "Tu ne ruineras jamais pour t'enrichir",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Le sens des réalités',
      description: "Habitué à manipuler les chiffres autant que les mots, le personnage peut faire varier la valeur de n'importe quelle transaction financière de 10% par niveau de Statut, que ce soit pour l'augmenter ou pour la réduire. Ainsi, il peut facilement - et sans le moindre jet - transformer le prix d'un objet, d'un service, d'une rétribution, etc. Ce Bénéfice ne peut être utilisé qu'une fois par transaction et s'emploie toujours après un éventuel jet de négociation ou de marchandage.",
    ),
  ),
  marchandItinerant(
    caste: Caste.commercant,
    title: 'Le marchand itinérant',
    interdict: CareerInterdict(
      title: 'Tu pousseras toujours plus loin ta bourse et ta monture',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'La poignée de main',
      description: "Depuis le temps qu'il parcourt le Royaume de Kor à la recherche de marchandises et de nouveaux clients, le personnage peut dissiper la méfiance des tribus et des communautés étrangères - et gagne un bonus de 2 par niveau de Statut à tous ses jets de Social effectués lors de discussions, transactions ou actions sociales vis-à-vis d'hommes étrangers à sa culture. Les limites des royaumes et les différences manifestes de culture, de religion ou de croyances semblent de bons critères pour déterminer la possibilité de ce pouvoir, qui peut également être utilisé sur des races humanoïdes intelligentes.\nNote: Le comptoir marchand du Bénéfice de 2e Statut est remplacé par deux écuries situées dans deux villes séparées de plus de 500 km et disposant d’un palefrenier et d’un petit entrepôt.",
    ),
  ),
  mendiant(
    caste: Caste.commercant,
    title: 'Le mendiant',
    interdict: CareerInterdict(
      title: 'Tu refuseras le confort et la possession matérielle',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'La roue de fortune',
      description: "Une fois par jour par niveau de Statut, le personnage peut utiliser ce Bénéfice dans l'une ou l'autre des deux optiques suivantes : regagner l'intégralité de ses Points de Chance ou obtenir des Niveaux de Réussite lors d'un jet, alors qu'il ne possède pas la Compétence appropriée. Dans ce dernier cas, le personnage ne peut obtenir plus de Niveaux de Réussite que le niveau de son Statut, quel que soit le résultat de son jet. De plus, un mendiant placé dans un lieu public sera systématiquement ignoré si les passants obtiennent un chiffre en dessous de son Statut sur 1D10 (non modifiable), à moins de le rechercher activement.\nNote: Le comptoir marchand du Bénéfice de 2e Statut est remplacé par un droit d’accès à la « cour des miracles » de la ville et une certaine tolérance des miliciens locaux, dans les limites de discrétion.",
    ),
  ),
  tenancier(
    caste: Caste.commercant,
    title: 'Le tenancier',
    interdict: CareerInterdict(
      title: "Tu ne refuseras pas l'hospitalité",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "Le coup d'œil",
      description: "Ce Bénéfice simule l'habitude qu'ont les tenanciers d'observer, d'analyser et de noter chaque détail de leurs rencontres et de leurs clients. En dépensant 1 Point de Maîtrise ou de Chance, au choix du joueur, ils peuvent à tout moment identifier une ou plusieurs des cinq informations suivantes chez un être humain - caste, Statut, Sphère de prédilection, Tendance majeure et degré d'affiliation aux Grands Dragons, qu'il soit fidèle, indifférent ou opposé. Le personnage n'effectue aucun jet mais doit dépenser 1 point par information qu'il désire obtenir - tous en même temps, s'il en cherche plusieurs - et ne peut demander qu'une seule information par niveau de Statut. La dernière information permise par ce Bénéfice permet de reconnaître facilement un dragon sous forme humaine.\nNote: Le comptoir marchand du Bénéfice de 2e Statut est remplacé par une taverne et quelques servants).",
    ),
  ),
  voleur(
    caste: Caste.commercant,
    title: 'Le voleur',
    interdict: CareerInterdict(
      title: 'Tu ne voleras pas la vie',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'La main sûre',
      description: "Chaque fois qu'il fait appel aux Tendances lors d'un jet impliquant l'Attribut Manuel ou Physique pour tenter de dérober un objet, d'être discret, d'escalader, d'accomplir toute action visant à voler ou à surprendre, le personnage peut relancer une fois le dé de l'Homme. Il peut ensuite décider de conserver ce nouveau résultat, de conserver un autre dé ou relancer une fois de plus le dé de l'Homme. Ce Bénéfice peut être utilisé une fois par jour par niveau de Statut du personnage. Le voleur ne gagne aucun Point de Tendance s'il conserve un autre dé après avoir relancé celui de l'Homme.\nNote: Le comptoir marchand du Bénéfice de Statut 2 est remplacé par un droit d’accès aux locaux de réunion de la guilde locale de la ville et le respect de quelques gosses de rues.",
    ),
  ),
  architectes(
    caste: Caste.erudit,
    title: 'Les architectes',
    interdict: CareerInterdict(
      title: 'Tu ne cautionneras aucune hérésie',
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'œil de l'expert",
      description: "La vocation théorique des architectes, versés dans la confection de plans plus que dans la réalisation des édifices, ne les prive pas d’une perception avisée des bâtiments, constructions, monuments et autres œuvres humaines de nature architecturale. D’un simple regard, en réussissant un jet de Mental + Architecture contre une Difficulté allant de 15 à 30, ils peuvent automatiquement définir un nombre d’informations égal à leur niveau de Statut, parmi les suivantes : âge / ancienneté, nature / origine, utilité / fonction, profondeur / hauteur et agencement général de l’édifice. Il appartient au personnage de définir, avant d’effectuer son jet, quelles sont les informations qu’il souhaite obtenir. Les éventuels Niveaux de Réussite obtenus lui permettent d’apprendre une information supplémentaire ou de préciser les réponses déjà obtenues.\nDe plus, si ce jet est réussi, le personnage peut participer à toute tentative d'orientation dans un édifice ou bâtiment en ajoutant le niveau de sa Compétence Architecture au score de base du jet d’Orientation. La Difficulté de ce jet est cependant augmentée de 5, pour simuler les discussions entre les deux personnages, si le jet d'Orientation n’est pas effectué par l’architecte.",
    ),
  ),
  astronomes(
    caste: Caste.erudit,
    title: 'Les astronomes',
    interdict: CareerInterdict(
      title: "Tu ne chercheras aucune vérité fondamentale dans les astres",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Sous les yeux du ciel',
      description: "Alors que la plupart des érudits voient en la parole draconique une vérité indiscutable, les astronomes ont découvert tant de réalités dans l’étude des astres que leur conception d’une vérité unique s’est lentement effritée. Loin de renier les enseignements draconiques, les astronomes ont simplement appris à voir en la voie de l’homme une solution possible. De fait, ils peuvent choisir de conserver le dé de l'Homme ou celui du Dragon lors de tout jet impliquant l’Attribut Mental ou Social, sans subir la moindre pénalité - et ce, quel que soit le dé qu’ils aient annoncé.",
    ),
  ),
  cartographes(
    caste: Caste.erudit,
    title: 'Les cartographes',
    interdict: CareerInterdict(
      title: "Tu peindras fidèlement le portrait de l'Être Primordial",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'expérience du terrain",
      description: "À force de sillonner le monde, le personnage a appris à tirer profit des moindres repères, des plus infimes détails topographiques, géographiques et climatiques pour dessiner les cartes les plus précises possibles. Sa Compétence de Cartographie est en quelque sorte devenue son instrument privilégié et il peut désormais l’utiliser lors de jets impliquant normalement les Compétences Pister, Orientation, Géographie ou Vie en cité. Pour chaque niveau de Statut qu’il possède, le personnage peut choisir une Compétence parmi ces quatre, à laquelle il pourra substituer sa Compétence Cartographie. Ainsi, lorsqu’il embrasse cette carrière, le personnage désigne une Compétence comme entrant dans le cadre de ce Bénéfice. L'expérience du terrain ne peut être utilisée que si le personnage se trouve dans les conditions “de terrain”, et uniquement à des fins pratiques - il ne connaît en effet rien de la théorie de ces cinq Compétences s’il ne les a pas développées.",
    ),
  ),
  conteurs(
    caste: Caste.erudit,
    title: 'Les conteurs',
    interdict: CareerInterdict(
      title: 'Tu ne souilleras le verbe d\'aucune pensée impure',
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'étincelle de la passion",
      description: "Si nombre de récits et de contes sont colportés en vue de distraire, d’éduquer, de transmettre un savoir ou de gagner un gîte et un couvert, il est des légendes que les conteurs narrent, avec plus de ferveur, plus de passion, dans l’espoir de mettre à nu l'âme de leur auditoire.\nEn jouant sur les mots et les situations qu’il décrit, le personnage peut chercher à faire réagir celui ou ceux qui l’écoutent, et obtenir ainsi des informations sur des éléments aussi variés que la caste, la Tendance principale, le passé, etc. Le personnage ajoute son niveau de Statut au score de base de son jet de Social + Conte, lorsqu’il cherche cet effet, et la Difficulté de base est égale à 15 + le nombre d’informations que le personnage cherche à obtenir. Les éventuels Niveaux de Réussite servent alors à préciser les informations obtenues.",
    ),
  ),
  erudits(
    caste: Caste.erudit,
    title: 'Les érudits',
    interdict: CareerInterdict(
      title: 'Tu ne laisseras aucune passion motiver ton jugement',
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'esprit clair",
      description: "Concentration et objectivité sont les deux maîtres mots du personnage, lorsqu’il est question d’analyser, de comprendre ou de faire un effort de mémoire. Chaque fois qu’il effectue un jet impliquant l’Attribut Mental, et pour lequel il peut choisir de ne pas faire appel aux Tendances, le personnage gagne un bonus égal à son niveau de Statut et un Niveau de Réussite automatique, si le jet est réussi.",
    ),
  ),
  herboristes(
    caste: Caste.erudit,
    title: 'Les herboristes',
    interdict: CareerInterdict(
      title: 'Tu ne corrompras la tature par aucune de tes pratiques',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'À la racine de tout bienfait',
      description: "En plus d’étudier les végétaux et d’en tirer chaque jour de nouvelles applications médicinales ou alchimiques, les herboristes savent combiner les effets des plantes à ceux, apparemment incompatibles, d’autres procédés et compétences. Pour chaque niveau de Statut qu’il possède, le personnage dispose d’un nombre de Niveaux de Réussite et/ou de bonus de 5 points qu’il peut attribuer, en annonçant son intention avant de lancer les dés, à n’importe quel jet impliquant les Compétences de Médecine, Premiers soins, Alchimie et Herboristerie, ainsi qu’aux actions permettant physiquement d'utiliser les propriétés de plantes, feuilles, fleurs, pollens ou graines - comme la cuisine, la confection de feux, de parfums, etc. Ces bonus et Niveaux de Réussite peuvent être cumulés sans aucune limite sur un ou plusieurs jets différents effectués au cours d’une même journée, mais les bonus non utilisés sont perdus au lendemain matin.",
    ),
  ),
  historiens(
    caste: Caste.erudit,
    title: 'Les historiens',
    interdict: CareerInterdict(
      title: "Tu n'occulteras aucune vérité, n'inventeras aucun mensonge",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "La mémoire de l'archiviste",
      description: "Habitué à lire, à écrire et à entendre fréquemment certains mots, certains termes chargés de références et d’anecdotes, le personnage a accumulé une connaissance particulière de quelques sujets qui, dans son esprit, sont définis par de simples mots-clefs. Pour chaque niveau de Statut qu’il possède, le personnage acquiert une connaissance étendue d’un concept ou d’un sujet susceptible d’être résumé par un mot - Dragons, guerres, Élus, Humanistes, etc. Ensuite, chaque fois qu’il effectuera un jet impliquant l’Attribut Mental et concernant l’un de ces mots, la Difficulté sera réduite de 5 et le personnage obtiendra une information supplémentaire gratuite, si le jet est réussi.\nCe Bénéfice ne peut s’appliquer qu’à des jets relatifs aux événements passés et en aucun cas à une connaissance pratique de l’un de ces domaines.",
    ),
  ),
  medecins(
    caste: Caste.erudit,
    title: 'Les médecins',
    interdict: CareerInterdict(
      title: "Tu ne seras l'agent d'aucune destruction",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'os et le ligament",
      description: "Si chaque blessure est différente d’une autre, le personnage a suffisamment replacé d’os, pansé de plaies, pratiqué de saignées et placé d’attelles pour bénéficier d’un savoir-faire applicable à tout type de contusion ou d’hémorragie. Chaque jour, il dispose d’un nombre de Niveaux de Réussite égal à son niveau de Statut qu’il peut attribuer à un jet de Médecine ou de Premiers soins réussi. Ces bonus ne peuvent en aucun cas réduire la Difficulté du jet, mais sont considérés comme des Niveaux de Réussite à part entière, au regard de tous les effets possibles.\nCes Niveaux de Réussite peuvent être cumulés sans aucune limite sur un ou plusieurs jets différents effectués au cours d’une même journée, mais les Niveaux de Réussite non utilisés sont perdus au lendemain matin.\nIl est impossible de faire appel aux Tendances sur un jet où le personnage souhaite utiliser ce Bénéfice.",
    ),
  ),
  navigateurs(
    caste: Caste.erudit,
    title: 'Les navigateurs',
    interdict: CareerInterdict(
      title: "Tu ne brigueras d'autre liberté que celle offerte par la Mère des Océans",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'La ferveur du large',
      description: "Arpenteurs téméraires des rivages de Kor, les navigateurs doivent recourir à l’aval de l’ordre marin pour pouvoir pratiquer leur passion du voyage maritime. Prêts à de nombreuses concessions, les navigateurs sont des citoyens passionnés, véritables meneurs d’hommes dans la solitude des voyages. Lorsqu'ils conservent le dé du Dragon dans un jet d’une Compétence d’Influence, ils peuvent ajouter leur Volonté au résultat, et ce autant de fois par jour que leur Tendance Dragon. Forts d’un tel ascendant sur leur équipage, on comprend bien que les marins soient étroitement surveillés par l’ordre marin.",
    ),
  ),
  scientifiques(
    caste: Caste.erudit,
    title: 'Les scientifiques',
    interdict: CareerInterdict(
      title: 'Tu ne créeras aucun instrument de rébellien',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'La quintessence du savoir',
      description: "Alors que la plupart des autres hommes se focalisent sur une conception pratique et orientée des sciences, les érudits de ce corps si particulier développent, avec l’expérience, un regard incroyablement objectif qui leur permet de comprendre, d’approfondir et de pratiquer les sciences sans aucune barrière psychologique. De fait, ils ne sont pas assujettis aux mêmes limitations que les autres personnages et voient le niveau maximal de toutes les Compétences limitées par la Tendance Homme augmenté du niveau de leur Statut.\nAinsi, une Compétence limitée à deux fois la Tendance Homme d’un personnage sera limitée à deux fois cette valeur, plus le Statut du personnage.",
    ),
  ),

  conjurateur(
    caste: Caste.mage,
    title: 'Conjurateur',
    interdict: CareerInterdict(
      title: "Tu ne faibliras point.",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Conjuration',
      description: "Le mage peut révoquer toute créature surgissant d’un portail (invoquée volontairement ou par erreur) en réussissant un jet de Mental + Magie invocatoire contre un jet de Mental + Volonté de la créature. Si le jet réussit, le mage doit dépenser des points de magie à hauteur de la Volonté de la créature. Celle-ci disparaît aussitôt, comme aspirée par le portail d’où elle a surgi. Cette conjuration est possible dans les (Statut) rangs d'Initiative qui suivent l'apparition du phénomène. Le mage peut également conjurer tout phénomène provenant d'un portail en réussissant un jet de Mental + Magie invocatoire contre une Difficulté égale à la Difficulté du sort qui a provoqué l'arrivée du phénomène. S'il réussit, il doit dépenser un nombre de points de magie égal au coût du sort. Si le mage meurt sans avoir pu couvrir les points de magie nécessaires, son sacrifice suffit à réussir la conjuration et son corps est totalement consumé. Cette technique est valable aussi bien contre un sort lancé par un autre mage que contre les effets d'un contrecoup.",
    ),
  ),
  enchanteur(
    caste: Caste.mage,
    title: "L'enchanteur",
    interdict: CareerInterdict(
      title: 'Tu ne créeras aucune forme de vie',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Le toucher de Nenya',
      description: "S'il réussit son jet d’Enchantement, le personnage gagne automatiquement un Niveau de Réussite supplémentaire. De plus, en réussissant un jet de Manuel + Sorcellerie + niveau de Statut contre une Difficulté de 20, le personnage peut conférer un bonus égal à son niveau de Statut à n'importe quel objet, et ce pendant 1 minute + 1 par Niveau de Réussite. Ce bonus peut se traduire, à la discrétion du meneur de jeu, par une augmentation momentanée des dommages, un bonus au toucher, etc.",
    ),
  ),
  fideleDeChimere(
    caste: Caste.mage,
    title: 'Le fidèle de Chimère',
    interdict: CareerInterdict(
      title: 'Nenya sera ton seul maître',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Guidé par Nenya',
      description: "Chaque matin, au réveil, le personnage peut effectuer un jet de Mental + Empathie contre une Difficulté de 10. S’il réussit, il gagne pour la journée un nombre de Points de Magie de sa Sphère égal à son niveau de Statut + le nombre de Niveaux de Réussite du jet. Les points non dépensés sont perdus au lendemain matin.\nDe plus, en établissant un contact physique avec un être vivant, un objet ou un lieu, le personnage peut effectuer un jet de Mental + Empathie contre une Difficulté de 10 pour déterminer quelles énergies sont présentes. Si plusieurs Sphères sont présentes, le mage apprend une information + une par Niveau de Réussite. En sacrifiant un Niveau de Réussite, il peut obtenir une précision sur la puissance d’une Sphère qu’il a d’ores et déjà identifiée.",
    ),
  ),
  gardienMage(
    caste: Caste.mage,
    title: 'Gardien',
    interdict: CareerInterdict(
      title: 'Tu veilleras à la pureté de la magie.',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Autorité de Nenya',
      description: "Le mage dispose de tout pouvoir pour intervenir dans une affaire impliquant la magie. Il peut ainsi dessaisir les autorités locales de leurs prérogatives dans ce domaine, enquêter personnellement, et procéder à des arrestations en vue d'un jugement, pour lesquelles il peut réquisitionner toutes les forces nécessaires, qu'il s'agisse de miliciens, de soldats, ou encore de mages quels qu'ils soient.\nCompétences devenant Réservées : Investigation, Commandement.",
    ),
  ),
  generaliste(
    caste: Caste.mage,
    title: 'Le généraliste',
    interdict: CareerInterdict(
      title: "Tu ne t'opposeras à aucun élément",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Le grimoire de Nenya',
      description: "Chaque fois qu’il atteint un Statut supérieur, le personnage peut apprendre gratuitement un sortilège de son choix - à la discrétion du meneur de jeu — sans effectuer aucun jet. Lorsqu’il embrasse cette carrière, le personnage peut immédiatement choisir un sortilège, qu’il apprend automatiquement.",
    ),
  ),
  guerisseurMage(
    caste: Caste.mage,
    title: 'Le guérisseur',
    interdict: CareerInterdict(
      title: "Tu ne refuseras pas ton aide",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'La sève qui nous lie',
      description: "Sans effectuer le moindre jet, le personnage peut transférer vers lui n'importe quelle Blessure causée à un être vivant, qu’il soit humain ou animal. La Blessure est effacée, purement et simplement, et infligée au personnage en échange — les malus afférents s'appliquent directement. Au moment du transfert, le personnage peut éviter de subir une Blessure en utilisant sa force intérieure. Pour cela, il dispose d’un point par niveau de Statut - chaque Blessure ainsi annulée lui consommant un point et un point de magie de sa Sphère de la Nature ou de sa Réserve (à son choix).",
    ),
  ),
  invocateur(
    caste: Caste.mage,
    title: "L'invocateur",
    interdict: CareerInterdict(
      title: "Tu ne mettras pas l'équilibre en péril",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Maîtrise des Portails',
      description: "Le personnage ajoute son niveau de Statut au score de base de tous ses jets d’Invocation. De plus, une fois par jour, il peut dépenser des points de Maîtrise après un jet d’Invocation, qu’il soit réussi ou raté, dans la limite de son niveau de Statut.",
    ),
  ),
  mageDeCombat(
    caste: Caste.mage,
    title: 'Le mage de combat',
    interdict: CareerInterdict(
      title: "Tu ne t'opposras pas aux faibles",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Le feu du combat',
      description: "Au début de chaque tour de combat, le personnage peut ajouter son niveau de Statut à la valeur de l'un de ses dés d’Initiative. De plus, s’il se bat sans arme et en usant de magie, il ajoute son de Statut à ses dommages et divise par deux l’indice de protection de l’armure adverse.",
    ),
  ),
  questeurBlanc(
    caste: Caste.mage,
    title: 'Questeur blanc',
    interdict: CareerInterdict(
      title: "Tu protégeras l'homme de la magie, et la magie de l'homme",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "Prééminence",
      description: "Dans le cadre d'une investigation, le Questeur blanc est tout puissant et s'impose à tous, ne répondant de ses actes que devant les Gardiens suprêmes, Tadd Lenkel et Nenya elle-même. De plus, il est investi d'une aura éthérée conférée par la Chimère qui lui attribue un bonus de 5 à tout jet de Social.\nCompétences devenant Réservées : Loi, Investigation, Commandement.",
    ),
  ),
  reveur(
    caste: Caste.mage,
    title: 'Le rêveur',
    interdict: CareerInterdict(
      title: "Tu ne pertuberas pas l'ordre naturel",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'illusion du corps",
      description: "En plongeant dans le monde éthéré de Nenya, l'esprit du personnage peut quitter son enveloppe charnelle et voyager quelques temps dans la réalité de Chimère. Pour cela, il doit effectuer un jet de Mental + Sphère des Rêves + niveau de Statut, contre une Difficulté de 20. S'il procède à un rituel de préparation, le mage peut dépenser des points de Maîtrise et des Points de Magie de sa Sphère des Rêves pour augmenter son score de base. Si le jet est réussi, il quitte corps son pendant 5 minutes + 3 par Niveau de Réussite. Une fois désincarné, le mage n'est plus soumis à aucune contrainte physique et peut donc, par exemple, traverser librement la matière. Il lui est également possible d'influencer le monde réel - faire bouger un objet ou toucher quelqu'un, par exemple – en dépensant 1 Point de Réserve de Magie de Volonté et en réussissant un jet de Mental + Volonté contre une Difficulté de 15. S'il obtient un Niveau de Réussite, il ne dépense rien. Il est impossible d'effectuer le moindre dommage direct de cette façon, d'utiliser des pouvoirs ayant des effets physiques ou de parler. Les pouvoirs mentaux fonctionnent normalement, du moment que le mage réussit son jet et dépense 1 point si besoin est.\nCependant, tant qu'il est dans l'éther, le personnage n'a aucune conscience de ce que ressent son corps - sauf, bien sûr, s'il l'observe depuis l'éther. En cas de contact physique, de douleur ou de grand bruit, le mage peut néanmoins effectuer un jet de Mental + Perception contre une Difficulté de 15 pour comprendre le danger. Ce pouvoir peut être utilisé une fois par jour.\nSi le personnage dort, la Difficulté du premier jet est réduite de 10 - mais il continue de dépenser ses points normalement.",
    ),
  ),
  specialisteDesRituels(
    caste: Caste.mage,
    title: 'Le spécialiste des rituels',
    interdict: CareerInterdict(
      title: 'Tu suivras la Voie du Secret',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Maîtrise des Rituels',
      description: "Le personnage ajoute son niveau au score de base de tous ses jets de Sorcellerie. De plus, il réduit la durée d’apprentissage des sorts de Sorcellerie de 10% par niveau de Statut (de -20% pour un 2e Statut à -50% pour un 5e Statut).",
    ),
  ),
  specialisteElementaire(
    caste: Caste.mage,
    title: 'Le spécialiste élémentaire',
    interdict: CareerInterdict(
      title: "Tu ne vivras que pour un élément",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "Guidé par l'élément",
      description: "Chaque matin, au réveil, le personnage peut effectuer un jet de Mental + Sphère spécialisée contre une Difficulté de 10. S’il réussit, il gagne pour la journée un nombre de Points de Magie de sa Sphère égal à son niveau de Statut + le nombre de Niveaux de Réussite du jet. Les points non dépensés sont perdus le lendemain matin.",
    ),
  ),

  gardienProdige(
    caste: Caste.prodige,
    title: 'Le gardien',
    interdict: CareerInterdict(
      title: "Tu n'abandonneras pas ton devoir",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'La justesse du devoir',
      description: "Lorsqu'il se bat pour la cause qui lui a été attribuée, le personnage ajoute la valeur de sa Tendance Dragon à tous ses jets d’attaque et de défense. De plus, une fois par tour, il peut ajouter le niveau de son Statut à l’un de ses dés d'attaque, de défense ou d’Initiative.",
    ),
  ),

  fervent(
    caste: Caste.prodige,
    title: 'Le fervent',
    interdict: CareerInterdict(
      title: 'Tu ne tueras point',
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'illusion des tendances",
      description: "En réussissant un jet de Mental + Tendance Dragon + niveau de Statut contre une Difficulté de 10, le personnage peut introduire le doute dans l’esprit de n'importe quel être humain et réduire la valeur d’une de ses Tendances de 1 point par Niveau de Réussite. Ce changement momentané dure 1 heure + 1 par point de Tendance Dragon du personnage. S’il obtient une réussite critique, la victime perd définitivement 1 point de Tendance.\nDe plus, une fois par jour, le personnage peut effacer un nombre de cercles de n’importe quelle Tendance égal à son niveau de Statut + 2. Il n’est besoin d’aucun jet, mais l’interlocuteur du personnage doit être consentant.",
    ),
  ),
  guerisseurProdige(
    caste: Caste.prodige,
    title: 'Le guérisseur',
    interdict: CareerInterdict(
      title: 'Tu ne refuseras pas ton aide',
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'amour de la terre",
      description: "En effectuant un jet de Mental + Empathie + niveau de Statut contre une Difficulté de 10, le personnage peut soigner 1 Blessure + 1 par Niveau de Réussite. Ces Blessures sont guéries dans l’ordre croissant, en commençant par les Légères. Il est impossible d’effacer une Blessure Mortelle de cette façon.\nDe plus, rien qu’en le touchant, le personnage peut effacer toutes les Égratignures de n’importe quel être vivant. Il n’est besoin d’effectuer aucun jet, du moment que le personnage parvient à établir un contact physique prolongé.\nCe pouvoir peut être utilisé autant de fois que le niveau de Statut du personnage.",
    ),
  ),
  mediateur(
    caste: Caste.prodige,
    title: 'Le médiateur',
    interdict: CareerInterdict(
      title: 'Tu ne permettras aucun conflit',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Le visage de Solyr',
      description: "Chaque fois qu’il intervient pour régler un différent, le personnage ajoute le niveau de son Statut à son Attribut Social. De plus, la notoriété de sa caste et de sa fonction lui assure une sécurité et une intégrité quasi totale — sur l’ensemble du Royaume de Kor, il est en effet considéré comme un crime que de s’en prendre à un diplomate de Heyra.\nDe plus, le personnage gagne un cercle de Tendance Dragon par conflit ainsi résolu.",
    ),
  ),
  missionnaire(
    caste: Caste.prodige,
    title: 'Le missionnaire',
    interdict: CareerInterdict(
      title: 'Tu ne subiras pas le doute',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Apporter la lumière',
      description: "En discutant avec des hérétiques, le personnage peut effacer son niveau de Statut en cercles de Tendance Homme ou Fatalité. Il lui suffit pour cela de réussir un jet de Volonté + Empathie contre une Difficulté de 15. Ce pouvoir fonctionne autant de fois par jour que sa Tendance Dragon et sur une seule cible à la fois. La victime n’a pas à être consentante, elle doit juste pouvoir écouter le prêche.",
    ),
  ),
  poeteDeLaNature(
    caste: Caste.prodige,
    title: 'Le poète de la nature',
    interdict: CareerInterdict(
      title: 'Tu ne briseras aucune harmonie',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'La terre est mon jardin',
      description: "Du moment qu’il se trouve entouré de végétation, le personnage peut, en réussissant un jet de Mental + Empathie contre une Difficulté de 15, disparaître à la vue de n’importe quel observateur humain ou animal pendant 1 minute par niveau de Statut + 1 par Niveau de Réussite. Tant que l’une de ses mains reste en contact avec un arbre ou le sol, le personnage peut se déplacer et effectuer toutes sortes d’actions — le vent et les craquements couvriront même ses bruits éventuels. Tous les jets de perception voient leur Difficulté augmentée de 10 pour le localiser ou comprendre sa présence.\nLes dragons et Élus de Heyra d'âge ou de niveau égal ou supérieur au Statut du personnage ne sont pas affectés par ce pouvoir.",
    ),
  ),
  prodigeAnimal(
    caste: Caste.prodige,
    title: 'Le prodige animal',
    interdict: CareerInterdict(
      title: "Tu n'enfreindras pas les lois de la nature",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Mon âme est celle de la nature',
      description: "Une fois par jour, en réussissant un jet de Mental + Empathie contre une Difficulté de 15, le personnage peut projeter son esprit dans le corps de n’importe quel animal pour partager ses sensations, voir par ses yeux et entendre par ses oreilles. Il peut ainsi rester 1 minute par Niveau de Réussite + niveau de Statut. Pour tenter d’influencer le corps de son hôte, le personnage doit réussir un jet de Mental + Volonté + niveau de Statut contre une Difficulté de 10. Chaque Niveau de Réussite lui donne le droit d’effectuer une action, dans la mesure des capacités physiques de son hôte — un serpent ne pourra jamais ouvrir une porte, par exemple. Si ce jet est raté, le Prodige est immédiatement expulsé du corps et ne peut plus utiliser son pouvoir pour le reste de la journée.\nIl est possible, en fonction des circonstances, que l’animal accepte de son plein gré d’aider le Prodige. Dans ce cas, aucun jet n’est nécessaire pour influencer le corps de l’animal. Les végétaux et les minéraux, considérés comme vivants par Heyra, peuvent être utilisés comme hôtes, mais le meneur de jeu est libre de décrire au personnage des émotions et des sensations quelque peu déstabilisantes…",
    ),
  ),
  prophete(
    caste: Caste.prodige,
    title: 'Le prophète',
    interdict: CareerInterdict(
      title: "Tu ne pertuberas pas l'ordre naturel",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Le cycle de la vie',
      description: "S’il n’a gagné aucun cercle de Tendance Homme ou Fatalité durant la journée, le personnage peut entrer en méditation et effectuer un jet de Mental + Méditation + niveau de Statut contre une Difficulté de 15. Pour chaque Niveau de Réussite qu’il obtient, il peut déterminer l'avenir et gagner réponse à une de ses questions. Certaines issues étant plus obscures que d’autres, le meneur de jeu reste libre de se montrer évasif ou d’exiger deux Niveaux de Réussite pour cette réponse.",
    ),
  ),
  sage(
    caste: Caste.prodige,
    title: 'Le sage',
    interdict: CareerInterdict(
      title: 'Tu ne garderas aucun secret',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Guider l’âme',
      description: "S’il est témoin d’une action entraînant le gain de cercles de Tendances, il peut annuler ce gain en entamant une discussion avec le personnage concerné moins d’une heure après l’action et si ce dernier est consentant. Il ne peut par ce Bénéfice agir sur les cercles gagnés par le choix des dés de Tendances. De plus, autant de fois par jour que son niveau de Statut, il peut percevoir intuitivement la Tendance dominante d’une cible en réussissant un jet de Volonté + Empathie contre une Difficulté de 20. Par NR, il peut obtenir la valeur chiffrée d’une Tendance. Cet examen de conscience est indétectable et ne demande que d’entendre quelques phrases prononcées par la cible.",
    ),
  ),
  tuteur(
    caste: Caste.prodige,
    title: 'Le tuteur',
    interdict: CareerInterdict(
      title: "Tu n'auras d'autre maître que la voie du savoir",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "Le Regard avisé",
      description: "Le personnage double ses points d’expérience acquis en Découverte, Magie et Implication. Il peut donner à un autre personnage une partie de ces points en plus afin de lui enseigner une Compétence qu’il possède. Pour cela, il doit posséder dans cette Compétence un score au moins égal à celui visé par le personnage recevant l’enseignement.",
    ),
  ),

  gardeDuCorps(
    caste: Caste.protecteur,
    title: 'Le garde du corps',
    interdict: CareerInterdict(
      title: 'Tu accepteras tout sacrifice',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Ton ennemi est le mien',
      description: "Lorsqu'il se bat aux côtés de son protégé, et que celui-ci est visé par une attaque, le personnage peut tenter de s’interposer et effectuer une parade à sa place ou en même temps que lui. Dans les deux cas, la Difficulté du jet est de 15 et ne subit que les malus liés aux éventuelles pénalités d’action ou de blessures du personnage. S’il part seul, sa réussite est comparée à celle de l’attaquant et, s’il échoue, c’est lui qui subit pleinement les effets de l'attaque - ainsi que la possibilité d’une riposte. Si les parades sont simultanées, les deux jets s’effectuent en parallèle, chacun contre sa Difficulté, et les Niveaux de Réussite s'additionnent. Là encore, c’est le garde du corps qui subit les effets d’un échec ou bénéficie de l'opportunité d’une riposte.\nCette technique ne peut être utilisée qu’une fois par tour, et seulement si le personnage dispose d’un dé d'action qu’il peut dépenser au moment de l'attaque - quelle que soit sa valeur.",
    ),
  ),
  ingenieurMilitaire(
    caste: Caste.protecteur,
    title: "L'ingénieur militaire",
    interdict: CareerInterdict(
      title: 'Tu ne te détourneras pas de ta voie',
      description: "",
    ),
    benefit: CareerBenefit(
      title: "Le jeu de l'ennemi",
      description: "La formation du personnage lui permet d'analyser avec précision la structure, la solidité, l’organisation et les points faibles de toutes sortes d’édifices et de fortifications. En réussissant un jet de Mental + Armes de siège contre une Difficulté de 10, le personnage peut obtenir une information sur la structure qu’il observe, plus une pour chaque Niveau de Réussite. Cette Difficulté est augmentée de 5 si l’édifice est particulièrement vaste ou complexe, mais aussi s’il est conçu dans une architecture inconnue. Par exemple, l’analyse d’une forteresse humaniste de grande taille pourra exiger une Difficulté de 20. Ces informalions permettent de déterminer la solidité, la composition, les éventuelles faiblesses et l’efficacité des systèmes de défense de n’importe quelle construction.\nDe plus, lorsqu’il est confronté à une arme mécanique, le personnage peut effectuer un jet de Mental + Armes mécaniques + Tendance Homme pour tenter d’en comprendre le fonctionnement. La Difficulté de ce jet est de 10 + le niveau de la Compétence Armes mécaniques du personnage. Si le jet est réussi, le personnage peut dépenser les Points d’Expérience correspondants et augmenter Armes mécaniques, Mécanismes ou Armes de siège de 1 - ou de 2 en cas de réussite critique. Il est impossible de faire appel aux Tendances et d’utiliser de la Maîtrise ou de la Chance sur ce jet. Le personnage doit impérativement disposer des Points d’Expérience nécessaires au moment du jet pour augmenter l’une de ces Compétences.\nIl gagne automatiquement autant de cercles en Tendance Homme que son nouveau score de Compétence, ce qui peut lui imposer une certaine réflexion et un ressourcement après ses découvertes.",
    ),
  ),
  inquisiteur(
    caste: Caste.protecteur,
    title: "L'inquisiteur",
    interdict: CareerInterdict(
      title: 'Tu ne connaîtras pas le doute',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Que justice soit faite !',
      description: "Lorsque le personnage affronte un adversaire jugé hérétique et reconnu comme tel du fait de ses actions ou de ses opinions, il dispose, par tour, d’un nombre de bonus égal à sa tendance Dragon. Chacun de ces bonus a une valeur égale à son Statut et peut s’appliquer à tous les jets à l’exception de l’Initiative. Chaque jet ne peut bénéficier que d’un bonus. Il n’est pas possible d’utiliser plusieurs de ces bonus lors d’une même action (comme au toucher ET aux dommages d’un même coup) à moins que le joueur n’ait annoncé en début de combat sa décision de ne plus faire appel aux Tendance pour l’ensemble de l’affrontement.",
    ),
  ),
  instructeur(
    caste: Caste.protecteur,
    title: "L'instructeur",
    interdict: CareerInterdict(
      title: 'Tu transmettras la tradition',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Les fruits de la tradition',
      description: "Du moment qu’il possède une Compétence d’un point supérieure au niveau que souhaite atteindre un de ses compagnons dans cette même Compétence, le personnage peut faciliter son apprentissage en effectuant un jet de Social + Compétence + niveau de Statut contre une Difficulté de 15 + niveau actuel de la Compétence de son compagnon. Un jet réussi annule les éventuels malus de Compétence Réservée, bien qu’il ne l’enseigne normalement qu’à un membre d’une caste connue pour l’utiliser. De plus, chaque NR obtenu permet d’économiser un point d’Expérience. En contrepartie, le personnage gagne un Point d'Expérience pour chaque niveau de Compétence ainsi acheté par son compagnon. Ce Bénéfice ne permet pas d’enseigner une Compétence Interdite tant que l’élève ne remplit pas les conditions normales d’apprentissage de cette Compétence.",
    ),
  ),
  legionnaire(
    caste: Caste.protecteur,
    title: 'Le légionnaire',
    interdict: CareerInterdict(
      title: 'Tu feras ton devoir',
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'appel du devoir",
      description: "Le personnage réduit de son niveau de Statut les malus découlants de ses blessures. De plus, lors de n’importe quel combat, il peut choisir un adversaire contre lequel il ajoutera son niveau de Statut aux dommages infligés. Il ne peut choisir qu’un seul ennemi par combat, même après la mort de celui-ci.",
    ),
  ),
  milicien(
    caste: Caste.protecteur,
    title: 'Le milicien',
    interdict: CareerInterdict(
      title: 'Tu respecteras la loi',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Le garant de la paix',
      description: "Le personnage ajoute son niveau de Statut à tous ses jets impliquant l’Attribut Social effectués au sein d’une cité soumise à l’autorité draconique.",
    ),
  ),
  protecteurItinerant(
    caste: Caste.protecteur,
    title: 'Le protecteur itinérant',
    interdict: CareerInterdict(
      title: "Tu n'oublieras jamais ta condition",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "La force d'un seul",
      description: "Au début de chaque combat, le personnage gagne un nombre de Niveaux de Réussite, égal à son niveau de Statut, qu'il peut dépenser pour augmenter la réussite de n'importe quel jet d'attaque, de parade ou de dommages. Il ne peut dépenser qu'un seul Niveau de Réussite à la fois, sauf s'il annonce et conserve le dé du Dragon en faisant appel aux Tendances, auquel cas il peut en dépenser deux. Si le personnage annonce, avant sa première action, qu'il refuse de faire appel aux Tendances pour l'ensemble du combat, il dispose alors de 2 fois son Statut en NR, qu’il peut alors dépenser deux par deux à son gré.",
    ),
  ),
  soldat(
    caste: Caste.protecteur,
    title: 'Le soldat',
    interdict: CareerInterdict(
      title: 'Tu respecteras ton supérieur',
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'esprit du corps",
      description: "Chaque fois qu'il combat aux côtés d'un nombre de compagnons égal à (10 -Statut), le personnage lance un dé d'Initiative de plus et choisit ses dés d’action à son gré. Ce Bénéfice est actif à tous les débuts de tour tant qu'il reste entouré d'un nombre de compagnon suffisant. Ses partenaires doivent tous être pareillement impliqués dans combat, que ce soit physiquement ou magiquement ; les observateurs ou les compagnons en fuite n'entrent pas dans le calcul.",
    ),
  ),
  strategeProtecteur(
    caste: Caste.protecteur,
    title: 'Le stratège',
    interdict: CareerInterdict(
      title: "Tu sacrifieras l'individu à l'armée",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'La voix du guide',
      description: "En combat, dès le premier tour, le personnage peut utiliser ses actions pour donner des conseils à ses compagnons au lieu d’agir lui-même. En observant la situation, le stratège est à même de déterminer la meilleure tactique, d’avertir d’un danger ou de coordonner une action collective. La justesse de ses conseils se traduit par un bonus, égal à son niveau de Statut, qui peut s'appliquer sur la valeur de n’importe quel jet d’Initiative, d’attaque ou de défense. Pour ce faire, le personnage ne doit avoir effectué aucune action autre que celles-ci depuis le début du tour - ce qui ne l'empêche pas d'agir après. Le bonus ne peut être attribué qu’à une action résolue après la valeur d'action du dé que le stratège utilise pour donner son conseil.\nCette technique peut être utilisée une fois par dé d’action dont le personnage dispose. Cependant, pour prévenir un compagnon d'un danger, il doit impérativement l'avoir remarqué - au prix d’un jet de Perception, par exemple.\nCe Bénéfice fonctionne tant que les compagnons aiguillés sont à portée de voix du personnage.",
    ),
  ),

  chasseurs(
    caste: Caste.voyageur,
    title: 'Les chasseurs',
    interdict: CareerInterdict(
      title: "Tu respecteras l'ordre naturel et le cycle de la vie",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Le carquois du chasseur',
      description: "Habitué à traquer et à se défendre contre toutes sortes d’espèces animales et monstrueuses du Royaume de Kor, le personnage a développé une solide connaissance de la faune qui lui permet, lors d’un combat, d’utiliser les points faibles pour accroître l’efficacité de ses coups. Pour chaque niveau de Statut qu’il possède, il peut choisir et nommer une espèce animale et une arme. En combat, lorsqu'il utilisera cette arme contre cette espèce précise, il pourra ajouter la valeur de son Attribut Manuel à chacun de ses jets de dommages.\nLe personnage ne peut choisir que des espèces qu'il connaît, pour avoir pu les rencontrer et les observer au cours de sa vie - l’homme n’est pas considéré comme une espèce animale dans ce cas précis, mais les dragons entrent naturellement dans cette catégorie, du moment que le personnage peut justifier d’une activité de “chasse draconique” plausible.",
    ),
  ),
  eclaireurs(
    caste: Caste.voyageur,
    title: 'Les éclaireurs',
    interdict: CareerInterdict(
      title: 'Tu ne refuseras aucun périple, aucune traversée',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Ouvrir la route',
      description: "Chaque fois qu'un danger ou qu'un événement imprévu survient en extérieur, le personnage peut réagir sans céder à la panique et ajouter son niveau de Statut à la valeur de son premier dé d'Initiative (dé le plus élevé). S'il le souhaite, il peut renoncer à ce gain pour tenter de prévenir ses compagnons du danger et leur faire gagner le même bonus - à tous sauf à lui-même - en réussissant un jet de Social + Perception contre une Difficulté de 20 ou un jet de Social + Commandement contre une Difficulté de 15. Il est possible de dépenser des Points de Chance sur ce jet, mais pas de Maîtrise. Si le jet est réussi, tous les membres du groupe voient leur premier dé d'Initiative augmenté du niveau de Statut du personnage éclaireur. Ce Bénéfice ne peut s'utiliser que si le jet de réaction a été réussi au moins simplement (pour le bonus personnel) ou au moins avec 2 NR (pour le bonus concernant ses compagnons). Si plusieurs éclaireurs préviennent ensemble une compagnie ou une caravane, c'est le voyageur possédant le plus haut Statut qui offre son bonus (mais lui pourra bénéficier de celui d'un éclaireur de Statut moindre).",
    ),
  ),
  errants(
    caste: Caste.voyageur,
    title: 'Les errants',
    interdict: CareerInterdict(
      title: 'Tu ne souilleras pas la mémoire des contrées que tu visites',
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'œil de l'Orphelin",
      description: "Alors que la plupart des aventuriers n’apprennent qu’en réalisant des actions et en expérimentant des situations liées à leur voie, leur caste, le personnage se nourrit des moindres sensations, des plus infimes paroles. Au moment du calcul des Points d’Expérience, le personnage ne peut gagner moins que son niveau de Statut dans les valeurs de Danger, de Découverte et d’Implication - les gains de ces trois valeurs sont donc rehaussés au niveau de Statut du personnage, s’ils lui sont inférieurs. La multiplication par deux des points de la valeur privilégiée s’eflectue après l’application de ce Bénéfice.",
    ),
  ),
  explorateurs(
    caste: Caste.voyageur,
    title: 'Les explorateurs',
    interdict: CareerInterdict(
      title: "Tu ne garderas secrète aucune découverte d'importance",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Le feu de camp',
      description: "Lorsqu'il est en voyage, en route vers une destination précise, le personnage peut préparer son expédition en attribuant un bonus à certaines Compétences. À la veille de chaque nouvelle journée, il dispose d’un nombre de points égal à son niveau de Statut qu’il peut attribuer - en les répartissant comme il l’entend - à une ou plusieurs de ses Compétences Mentales, Manuelles ou Sociales.\nDurant la journée qui suivra, tous les jets impliquant ces Compétences seront augmentés des points dépensés la veille au soir. Ce Bénéfice n’est utilisable que la veille et pour la journée qui suit - les points non dépensés sont perdus - et aucune Compétence ne peut être augmentée de plus de points que le niveau de la Tendance la plus élevée du personnage.",
    ),
  ),
  menestrels(
    caste: Caste.voyageur,
    title: 'Les ménestrels',
    interdict: CareerInterdict(
      title: "Tu n'altéreras pas la vérité de l'Histoire",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'La veillée',
      description: "Au terme de chaque événement important, comme la fin d'une quête ou le dénouement d'une intrigue l'impliquant, lui ou ses compagnons, le personnage petit écrire et réciter un conte, un poème, une interprétation poétique de ces événements, qui en gravera les enseignements dans les mémoires. En termes techniques, cette veillée permet au personnage d'effectuer un jet de Social + Conte au terme de chaque aventure, au moment où le meneur de jeu attribue les Points d'Expérience du groupe, mais aussi de la Compagnie. La Difficulté du jet est égale à 5 + le total des Points d'Expérience du scénario + le nombre de personnages impliqués dans le groupe. S'il est réussi, tous les membres du groupe ou de la Compagnie gagnent un bonus de points supplémentaires égal au niveau de Statut du ménestrel. Il est impossible de ne choisir qu'une partie du groupe et ce jet ne peut être effectué qu'une seule fois. S'il utilise ce Bénéfice au sein d'une Compagnie d'Inspirés, le personnage ne peut faire gagner plus de Points d'Expérience que le niveau de sa Compétence Astrologie. De plus, le personnage peut faire et défaire les réputations.\n Par un jet de Social + Eloquence d'une Difficulté de 15 + Renommée de la personne décrite, il peut faire varier sa Renommée de 1 point en plus ou en moins. Il faut effectuer (et réussir) ce jet tous les jours durant autant de jours que le Statut de la cible, et à chaque fois devant un public différent. Dans le cas d'un sans caste, il faut discourir durant une semaine complète, les sans castes n'étant pas très marquants pour les esprits. Le changement a alors lieu dans les (6-Statut du Ménestrel) jours qui suivent, le temps que la rumeur se répande. On ne peut modifier une Renommée qu'une fois par Augure, et jamais plus de fois que son Statut. Ce Bénéfice peut également servir à modifier une réputation sans altérer l'Attribut de Renommée.",
    ),
  ),
  messagers(
    caste: Caste.voyageur,
    title: 'Les messagers',
    interdict: CareerInterdict(
      title: "Tu ne priveras tes pairs d'aucune information",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'ambassadeur",
      description: "De par sa caste et sa fonction, jugée primordiale à l’acheminement des informations, le personnage peut demander à être entendu par n’importe quel représentant de caste d’un Statut égal au sien +1. Ainsi, au sein des cités draconiques ou fidèles aux Édits, le personnage pourra demander à rencontrer le citoyen de son choix et sera toujours entendu, ne serait-ce que par un autre représentant de Statut équivalent. Ce Bénéfice n’est pas utilisable dans les régions et les cités non affiliées aux Lois draconiques, mais sur une grande partie du Royaume de Kor, il est très malvenu de refuser une telle demande…",
    ),
  ),
  missionnaires(
    caste: Caste.voyageur,
    title: 'Les missionnaires',
    interdict: CareerInterdict(
      title: "Tu ne détourneras pas l'enseignement draconique",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'La patience du tuteur',
      description: "À force de parcourir les routes pour transmettre son savoir, le personnage a développé un sens aigu de la pédagogie et peut, sans effectuer le moindre jet, réduire le coût en Points d’Expérience des Compétences qu’il enseigne - et qu’un autre personnage apprend et/ou développe grâce à lui - de son niveau de Statut. De plus, le personnage réduit du même montant le coût d’apprentissage et/ou de développement des Compétences qu’il apprend auprès d’un autre tuteur, du moment que ce dernier possède la Compétence en question à un niveau supérieur à son propre Statut. Ce Bénéfice n’est utilisable que pour développer des Compétences et réduire le coût d’achat d’un nouveau Privilège pour le personnage, du moment que celui-ci en possède moins que son niveau de Statut +2,",
    ),
  )
  ;

  final Caste caste;
  final String title;
  final CareerInterdict? interdict;
  final CareerBenefit benefit;

  const Career({
    required this.caste,
    required this.title,
    this.interdict,
    required this.benefit,
  });
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class AttributeBasedCalculator {
  AttributeBasedCalculator({
    required this.static,
    required this.multiply,
    required this.add,
    required this.dice,
  });

  double calculate(int ability, { List<int>? throws }) {
    var rnd = 0;
    if(throws == null) {
      for (var i = 0; i < dice; ++i) {
        rnd += (Random().nextInt(10) + 1);
      }
    }
    else {
      rnd += throws.reduce((value, element) => value + element);
    }

    if(static > 0) {
      return (static + rnd).toDouble();
    }
    else {
      return ((ability * multiply) + add + rnd).toDouble();
    }
  }

  final double static;
  final int multiply;
  final int add;
  final int dice;

  Map<String, dynamic> toJson() => _$AttributeBasedCalculatorToJson(this);
  factory AttributeBasedCalculator.fromJson(Map<String, dynamic> json) => _$AttributeBasedCalculatorFromJson(json);
}
