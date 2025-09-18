import 'base.dart';

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