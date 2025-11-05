import 'base.dart';

enum CastePrivilege {
  laForceDeLAme(
    caste: Caste.sansCaste,
    title: "La force de l'âme (Humaniste)",
    description: "Grâce à ce Privilège, le personnage peut ajouter sa Tendance Homme à la valeur de base de tous ses jets de résistance face à un sortilège, un pouvoir ou une capacité d'origine draconique. Ce Privilège n'est utilisable que lorsque le personnage est directement visé par un effet de ce type, mais il peut s'agir d'une “agression” physique, mentale ou psychologique.",
    cost: 0,
  ),
  lesCerclesDuProgres(
    caste: Caste.sansCaste,
    title: "Les cercles du progrès (Humaniste)",
    description: "Rompu à toutes les formes de progrès, les Humanistes ignorent tous les malus et toutes les pénalités de non maîtrise lors de jets impliquant des Compétences techniques ou scientifiques. Il peuvent donc obtenir des Niveaux de Réussite et dépenser des Points de Maîtrise.",
    cost: 0,
  ),
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
      cost: 3,
      requireDetails: true,
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