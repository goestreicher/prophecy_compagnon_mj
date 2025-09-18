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