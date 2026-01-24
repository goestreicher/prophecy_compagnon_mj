import '../caste/base.dart';

enum DisadvantageType {
  commun(title: 'Commun'),
  rare(title: 'Rare'),
  enfant(title: 'Enfant'),
  ancien(title: 'Ancien');

  final String title;

  const DisadvantageType({ required this.title });
}

enum Disadvantage {
  anomalie(
    title: 'Anomalie',
    description: "Le personnage est affligé d’une tare de naissance, Il peut s’agir d’une anomalie physique (albinos, main atrophiée, yeux dépareillés, tache de naissance disgracieuse, etc.), d’un défaut de prononciation, etc. Ce Désavantage augmente de 3 la Difficulté de toutes les actions sociales avec des inconnus et des tentatives de séduction.",
    cost: [2],
    type: DisadvantageType.commun,
    requireDetails: true,
  ),
  complexeDInferiorite(
    title: "Complexe d'infériorité",
    description: "Désabusé, le personnage ne croit plus guère en ses capacités. Face à une situation particulièrement délicate, il se sentira irrémédiablement faible et incompétent. Ce Désavantage fonctionne de deux manières. Tout d’abord, le personnage reçoit une Difficulté supplémentaire de 5 à tous les jets qu’il tentera au cours d’une situation de crise (empêcher un compagnon de tomber au fond d’un gouffre, atteindre d’une flèche un ennemi sur le point de tuer un compagnon, etc.). Ensuite, le meneur de jeu peut décider que le personnage est tout simplement incapable d'accomplir une action capitale.\nDans ce cas, le personnage gagne automatiquement deux Points d’Expérience et voit ses Points de Chance remonter à leur niveau maximum (bien qu’il soit impossible d’utiliser des Points de Chance pour tenter de réussir cette action). Le Complexe d’infériorité peut disparaître si le personnage réussit une action particulièrement importante pour sa survie ou celle de son groupe.",
    cost: [3],
    type: DisadvantageType.commun
  ),
  curiositeMageVents(
    title: 'Curiosité (Mage des Vents)',
    description: "Ce Désavantage s'apparente à la Loi de la Découverte, à la différence près que le mage ne doit jamais s’arrêter de chercher. Que ce soit un lieu, une idée, un fantasme, une personne ou un objet, le mage ne peut jamais s’arrêter de chercher. Et il doit absolument trouver avant de passer à une nouvelle quête. En termes de jeu, le personnage voudra toujours tout savoir, tout entendre et tout voir. Cela peut être gênant - sauf s’il est Questeur - car la curiosité est un vilain défaut, qui amène souvent des problèmes. Si le joueur ne respecte pas ce comportement, le meneur de jeu peut lui infliger des pénalités liées au manque de motivation du personnage, qui ne peut plus assouvir sa passion.",
    cost: [2],
    type: DisadvantageType.commun,
    reservedCastes: [Caste.mage]
  ),
  dette(
    title: 'Dette',
    description: "Le personnage est redevable d’une faveur ou d'une somme d'argent à un individu qui l’a aidé par le passé. Les détails de ce service rendu sont laissésà la discrétion du joueur et du meneur de jeu. Pour 1 point, la dette concerne une petite somme ou une faveur minime. Pour 2 points, il peut s'agir soit d’une dette importante (forte somme ou faveur conséquente), soit d’une dette que le destinataire prendra soin de récupérer sans ménager le personnage (par la force ou le chantage, en provoquant un scandale, etc.).\nUn scénario (ou un chapitre) spécifique devra toujours accompagner le remboursement.\nCe Désavantage peut survenir plusieurs fois.",
    cost: [1,2],
    type: DisadvantageType.commun,
    requireDetails: true,
  ),
  echec(
    title: 'Échec',
    description: "Le poids d’une expérience douloureuse pèse cruellement sur les épaules du personnage. Par le passé, il a lamentablement raté une action qu’il jugeait capitale et cet échec ne cesse de le tourmenter. C’est au joueur de définir le type d'action qui a provoqué ce sentiment d’échec : combat singulier, rituel magique, discussion importante, etc. Chaque fois qu’il sera confronté à une situation similaire, le personnage se sentira tellement incapable que la Difficulté de tous ses jets en rapport sera augmentée de 5.",
    cost: [3],
    type: DisadvantageType.commun,
    requireDetails: true,
  ),
  emotif(
    title: 'Émotif',
    description: "Certains êtres humains ont une sensibilité tellement développée qu'ils supportent mal les situations de conflit, les visions d'horreur et les périodes de pression intenses. Confronté à une telle situation, le personnage perd son sang-froid et voit la Difficulté de tous ses jets de Volonté augmenter de 5. Les jets d’Intimidation, de Commandement et d’autres actions liées à l’Influence reçoivent un bonus de 2 lorsqu'ils sont employés sur ce personnage.",
    cost: [3],
    type: DisadvantageType.commun
  ),
  ennemi(
    title: 'Ennemi',
    description: "Ce Désavantage impose un ennemi juré au personnage, un ennemi qui ne manquera aucune occasion de lui nuire. L'ennemi est ici plus qu’un simple personnage dont on pourrait se débarrasser d’un coup d’épée. L’ennemi peut aussi être une rumeur circulant au sein de la caste du personnage, une rancune que lui voue un groupe ou un avis défavorable qui l’empêchera de progresser dans la voie qu’il a choisie.\nCe Désavantage peut disparaître si le personnage réussit à tuer son ou ses ennemis, mais aussi s'il parvient à prouver sa valeur, à dissiper les rumeurs dont il fait l’objet.\nCe Désavantage peut survenir plusieurs fois.",
    cost: [3],
    type: DisadvantageType.commun,
    requireDetails: true,
  ),
  faiblesse(
    title: 'Faiblesse',
    description: "Le personnage est incapable de résister à l’appel d’un phénomène particulier - qu’il s'agisse des charmes d’une jolie femme, d’un défi à relever, de dangers à braver, etc. Chaque fois que le personnage se trouvera confronté à la situation définie par le joueur, il cédera immanquablement à son penchant. Il pourra s’y soustraire par un jet de Mental + Volonté contre une Difficulté de 20 (ou de 15, si le meneur de jeu estime que l’action est particulièrement dangereuse).",
    cost: [2],
    type: DisadvantageType.commun,
    requireDetails: true,
  ),
  fragilite(
    title: 'Fragilité',
    description: "La santé du personnage est mauvaise, tout comme sa faculté de rétablissement, sa résistance aux poisons et son système immunitaire. Tous ses jets de résistance aux agressions extérieures (maladies, poisons, alcool, etc.) voient leur Difficulté augmenter de 5.",
    cost: [2],
    type: DisadvantageType.commun
  ),
  instinctSuperieur(
    title: 'Instinct supérieur (Mage des Océans)',
    description: "Ce Désavantage résulte des enseignements très rigides d’Ozyr en ce qui concerne la mentalité humaine. Le mage qui choisit de consacrer sa vie à l’étude et la manipulation de la Sphère des Océans est depuis longtemps convaincu de la faiblesse qui caractérise l’hmmanité. Instruit par la Maîtresse du Savoir, le mage adopte un comportement scrutateur et supérieur qui lui procure une aura de suffisance. Souvent, il dictera leur conduite aux autres au nom d’une éthique et d’une rigueur morale dont il est persuadé d’être le dépositaire privilégié. Il posera toujours un regard inquisiteur sur les idées nouvelles, les discussions philosophiques et le respect des Ailés et de leurs enseignements. Il cherchera alors à faire aboutir son point de vue et pourra à l’occasion avoir une attitude parentale vis-à-vis de ses interlocuteurs.",
    cost: [0],
    type: DisadvantageType.commun,
    reservedCastes: [Caste.mage]
  ),
  interdit(
    title: 'Interdit',
    description: "Le personnage a décidé de moduler sa philosophie en prenant en compte un Interdit d’une autre caste. Il peut s’agir d’un promesse faite à un maître ou un ami, d’une conviction personnelle, d’une crise passagère de croyance. Le joueur doit veiller à choisir un Interdit qui ne soit pas trop proche de l’Interdit de son personnage.\nCe Désavantage peut survenir plusieurs fois.",
    cost: [3],
    type: DisadvantageType.commun,
    requireDetails: true,
  ),
  interditsDeBrorne(
    title: 'Interdits de Brorne (Mage de la Pierre)',
    description: "Le Dragon de la Pierre n’a jamais eu confiance en la magie. C’est pour cette raison qu’il n’attribue certains pouvoirs et certaines capacités qu’aux meilleurs de ses éléments. Ceux capables de s’imposer une telle discipline de vie sont dignes de sa confiance. Le joueur qui choisit ce Désavantage doit déterminer deux Interdits majeurs pour son personnage et les proposer à son meneur de jeu qui doit les approuver. Voici des exemples :\n- Ne jamais se battre à moins de trois contre un ou s’infliger un handicap en fonction de la force de son adversaire.\n- Ne jamais parler à une personne ayant plus de 3 dans la Tendance Fatalisme (le personnage le ressentira et aura un blocage inconscient).\n- Toujours venir en aide aux miséreux, même ses ennemis.\n- Ne jamais utiliser d’arme tranchante (ou de sortilège faisant jaillir le sang).\n- Ne jamais mentir, même pas par omission.\n- Relever tous les défis sans exception.\n\nCes obligations ou Interdits doivent pouvoir être une sérieuse contrainte pour le personnage mais pas pour le joueur. Évitez donc le vœu de silence (classique mais assez dur à jouer) ou l’intégriste total. Les mages de Brorne ne sont ni de véritables protecteurs, même s’ils en ont le comportement, ni des Inquisiteurs (même s’ils peuvent rejoindre leurs rangs) et encore moins des paladins aveuglés par la sainte justice des Dragons.",
    cost: [2],
    type: DisadvantageType.commun,
    reservedCastes: [Caste.mage]
  ),
  maladie(
    title: 'Maladie',
    description: "Le personnage a contracté par le passé une maladie chronique. Elle peut survenir par crise et se soigne difficilement. Les crises surviennent tous les 1D10 jours (le meneur de jeu tiendra le compte en secret). À 1 point, la maladie est bénigne (allergie, urticaire, etc.) et entraîne un malus de -1 pour la demi-journée. À 3 points, la maladie est sérieuse et génante (migraines, vertiges, ulcère, etc.). Elle entraîne un malus de -3 pour 1D10 heures. À 5 points, la mala die est sévère et handicapante (malaria, maladie du sommeil, etc.). Elle entraîne un malus de -5 pour 1D10 heures.\nCe Désavantage peut survenir plusieurs fois.",
    cost: [1,3,5],
    type: DisadvantageType.commun,
    requireDetails: true,
  ),
  malchance(
    title: 'Malchance',
    description: "Avec ce Désavantage, le personnage s’expose à deux types d’inconvénients. Tout d’abord, il ne regagne qu’un seul Point de Chance (au lieu de 2) lors d’un êchec critique. Ensuite, comme la Malchance se manifeste toujours quand la situation est délicate, le meneur de jeu peut, deux fois par partie, demander au joueur de relancer les dés d’une action réussie. Si ce second jet est raté, le personnage ne regagne bien évidemment aucun Point de Chance…",
    cost: [3],
    type: DisadvantageType.commun
  ),
  maledictionDeKezyr(
    title: 'Malédiction de Kezyr (Mage du Métal)',
    description: "Nenya rend plus difficile aux mages du métal l‘accès à la perfection magique. Lorsqu’un mage du métal obtient un Miracle (par un dé inférieur ou égal à la Sphère mise en oeuvre), il doit relancer une seconde fois ce test pour confirmer son Miracle. Si ce jet n’indique pas également un Miracle, le jet est simplement un 10 sur le dé du Dragon…",
    cost: [0],
    type: DisadvantageType.commun,
    reservedCastes: [Caste.mage]
  ),
  maledictionDeNenya(
    title: 'Malédiction de Nenya (Mage du Feu)',
    description: "Inactive chez les autres mages, cette malédiction apparaît durant les premières années de l’enseignement de la magie du feu. Les mages du feu l’ayant contractée sont considérés avec compassion par leurs frères d’armes et révérés pour leur courage à persister dans la Voie du feu. La vengeance de Nenya s’applique en rendant plus difficile leur relation avec les énergies magiques. Toute progression de leur Réserve, d’une Sphère ou d’une Discipline s’effectue comme s’ils possédaient un niveau d’un point supérieur. Passer de 8 à 9 coûte 10, comme s’ils passaient de 9 à 10.",
    cost: [0],
    type: DisadvantageType.commun,
    reservedCastes: [Caste.mage]
  ),
  manie(
    title: 'Manie',
    description: "Kleptomanie, grossièreté, collections étranges, les manies peuvent être de plusieurs natures, mais il doit forcément s'agir d’un travers qui provoquera des réactions négatives.\nCe Désavantage peut survenir plusieurs fois.",
    cost: [1],
    type: DisadvantageType.commun,
    requireDetails: true,
  ),
  marqueDeNenya(
    title: 'Marque de Nenya (Mage des Rêves)',
    description: "La Marque de Nenya n'est pas un désavantage quantitatif mais qualitatif. La Chimère confie ses plus grands secrets à ceux qui le méritent. Mais ils doivent en payer le prix. Quand elle pose sa griffe sur eux pendant une seconde - aussi longue qu'une vie - ils peuvent contempler la perfection du monde. Ils sont alors illuminés et passent à un niveau de conscience supérieur. Cette ouverture de leur esprit permet de comprendre et de maîtriser certains sorts inaccessibles aux autres mages. Mais le choc a été tel que leur esprit ne l'a pas supporté. Ils vivent donc des périodes de contemplation qui peuvent survenir n'importe quand, durant un combat, une discussion, une poursuite. Une réminiscence de cette expérience accapare leurs pensées.\nEn termes de jeu, le mage de Nenya ne peut se concentrer sur une tâche trop longtemps et aura des moments d'absence. A vous de décider, à la création du personnage, ce qui peut déclencher ces temps morts. Soit c'est le meneur de jeu qui vous les signale, soit vous les interprétez librement. Cela peut prendre plusieurs formes : amnésie partielle et momentanée, parler à des objets ou des animaux, schizophrénie légère, etc.\nCe Désavantage est une marque psychique indétectable, si ce n’est par le comportement. La marque n’offre aucun prestige officiel, mais constitue une marque honorifique officieuse. En effet, elle est considérée comme une bénédiction presque enviable, car tous sont persuadés que ces moments d'absence sont un rapprochement spirituel avec Nenya elle-même.\nUn mage qui la possède devra veiller à ajuster son jeu en fonction des circonstances et ne pourra en aucun cas en faire mention dans le but de profiter d'un prestige bassement matériel.",
    cost: [0],
    type: DisadvantageType.commun,
    reservedCastes: [Caste.mage]
  ),
  mauvaiseReputation(
    title: 'Mauvaise réputation (Mage des Cités)',
    description: "Les mages de Khy, même s’ils sont discrets, attirent naturellement la suspicion. Autant la population accepte les personnalités mystérieuses des serviteurs de Nenya, autant le côté énigmatique, commerçant et trompeur des mages des cités est plus mal perçu. Les lynchages publics ne sont pas rares et, dans les régions où l’Humanisme et les Dragons s’opposent, ils ont tendance à servir de bouc émissaire - les premiers se méfiant des mages et les seconds se méfiant des enfants de Khy. En termes de jeu, le personnage a attiré sur lui le regard de deux factions - secrètes ou pas - qui le suivent partout. Au meneur de jeu de décider secrètement de qui il s’agit et pourquoi.",
    cost: [2],
    type: DisadvantageType.commun,
    reservedCastes: [Caste.mage]
  ),
  obsession(
    title: 'Obsession',
    description: "Tout le monde a un but, un idéal qu’il entend réaliser par tous les moyens. Avec ce Désavantage, le personnage est obsédé par un objectif qu’il fera passer avant son devoir, ses compagnons et peut-être même sa survie.\nIl peut s'agir d’une simple soif de pouvoir comme d’une longue quête religieuse, d’une envie de découverte, d’une vengeance, etc.\nCe Désavantage peut survenir plusieurs fois.",
    cost: [2],
    type: DisadvantageType.commun,
    requireDetails: true,
  ),
  phobie(
    title: 'Phobie',
    description: "Le personnage a peur de quelque chose. Selon le coût du Désavantage, cela peut aller de la simple peur à la panique totale. Pour 1 point, cela peut être une peur liée à un mauvais souvenir ou une gêne passagère (vertige, claustrophobie, etc.). Le personnage subit un malus de -1 à toutes ses actions tant qu’il reste en présence du catalyseur. Pour 3 points, cette peur peut être liée à un environnement particulier (nuit, forêt, etc.) ou à des situations déjà subies par le passé (obscurité, foules, insectes, etc.). Le personnage subit un malus de -3 à toutes ses actions en présence du catalyseur et de -1 pendant une heure après l’avoir quitté. Pour 5 points, cette peur est liée à un traumatisme violent ou une vision récurrente (dragons, magie, etc.). Le personnage subit un malus de -5 à toutes ses actions en présence du catalyseur et de -3 durant une heure après l'avoir quitté du fait de sa panique.\nCe Désavantage ne se surmonte que progressivement. Le personnage retombe au stade inférieur à chaque dépense et ne s’en débarrassera qu’en surmontant le stade à 1.\nCe Désavantage peut survenir plusieurs fois.",
    cost: [1,3,5],
    type: DisadvantageType.commun,
    requireDetails: true,
  ),
  phobieDesCites(
    title: 'Phobie des cités (Mage de la Nature)',
    description: "Habitué dès son plus jeune âge aux forêts et à la nature, le personnage se sent mal à l’aise dès qu’il franchit les portes d’une cité. Ce malaise constant se traduit par une phobie, des crises d'angoisse et une Difficulté supplémentaire de 5 à tous les jets de Social et de Magie du personnage.",
    cost: [4],
    type: DisadvantageType.commun,
    reservedCastes: [Caste.mage]
  ),
  serment(
    title: 'Serment',
    description: "Le personnage a juré un jour d’effectuer une action particulière encore non réglée à ce jour. Il fera tout pour honorer sa parole. Il cherchera à honorer son serment au plus vite sans sombrer dans la précipitation aveugle. Le serment est au choix du joueur (avec l’accord du meneur de jeu).\nCe Désavantage peut survenir plusieurs fois.",
    cost: [2],
    type: DisadvantageType.commun,
    requireDetails: true,
  ),
  amnesie(
    title: 'Amnésie',
    description: "Sans perdre totalement la mémoire, le personnage oublie fréquemment des détails et des passages de sa vie. La raison peut en être variable (âge, coup à la tête, choc émotionnel, etc.) Chaque fois qu'il tente de se souvenir d’un nom, d’un visage, d’une phrase, ou de tout autre détail récent, le joueur doit réussir un jet de Mental + Intelligence contre une Difficulté de 15 (pour des détails mineurs ou très récents) ou de 20 (pour des éléments importants ou un peu plus anciens). Si un joueur dont le personnage est amnésique demande au meneur de jeu de lui répéter une information, ce dernier peut également utiliser ce Désavantage pour déclarer qu’il a oublié…",
    cost: [3],
    type: DisadvantageType.rare
  ),
  appelDeLaBete(
    title: 'Appel de la bête',
    description: "Le personnage est tourmenté par des pulsions brutales (suite à des insultes, le dépit, l'échec, la frustration, etc.) qui le poussent régulièrement à commettre des actes incontrôlables, tels que brutaliser un compagnon maladroit ou s'acharner sur l’objet de son irritation. De plus, chaque fois que le personnage est confronté à une situation susceptible de réveiller ses pulsions, il subit un accès de colère. La crise ne prend fin qu’une fois l’infortunée victime inerte (immobilisée ou inconsciente).\nDans cet état, le joueur est obligé de lancer les trois dés des Tendances, il conserve celui dont le résultat est le plus élevé (au risque de gagner des Points de Tendance indésirables) et double les cercles ainsi obtenus (eh oui !). Le joueur peut tenter un jet de Mental + Volonté contre une Difficulté de 20 pour réfréner sa rage.",
    cost: [5],
    type: DisadvantageType.rare
  ),
  autocrate(
    title: 'Autocrate (Mage de l\'Ombre)',
    description: "Le personnage est un utilisateur autodidacte de la Sphère de l'Ombre. Il peut avoir acquis ce savoir par l'étude de livres interdits subtilisés à des mages de l'ombre (quoi que cela soit rare, car les mages (draconistes ou de l’ombre) n’apprécient pas le verbiage littéraire et la forme écrite pour transmettre leur art), ou pire, avoir rencontré un mage de l'ombre peu regardant qui a eu l'inconscience de l'instruire de son propre chef. L'Autocrate peut alors développer la Sphère de l'Ombre et des sorts de l'ombre. Ce Désavantage doit systématiquement faire l'objet, d'une préparation conjointe avec le meneur de jeu, qui se chargera de déterminer les circonstances exactes de ces études autonomes. Le personnage Autocrate obtient automatiquement le Désavantage Ennemi (5) qui représente le dragon, la faction ou les membres de la caste noire qui recherchent les Autocrates et peuvent posséder des informations sur lui (à discrétion du MJ). Il obtient également Obsession (2), qui découle de sa crainte d'être découvert. Aucun de ces deux Désavantages ne rapporte bien sûr de pointe d'Avantages…",
    cost: [5],
    type: DisadvantageType.rare,
    reservedCastes: [Caste.mage]
  ),
  blessure(
    title: 'Blessure',
    description: "Suite à une bataille, le personnage a subi une blessure qui ne s’est jamais vraiment refermée. Quelles que soient ses valeurs de Résistance et de Volonté, le personnage perd définitivement une case d’égratignure et une case de blessure légère. Aucune tentative de soins, même magiques, ne peut rendre ces cercles perdus à ce personnage.\nCe Désavantage peut survenir plusieurs fois.",
    cost: [5],
    type: DisadvantageType.rare
  ),
  dependance(
    title: 'Dépendance',
    description: "Le personnage a l'habitude de consommer une substance (drogue, alcool) qui provoque de cruelles souffrances en cas de manque. La Difficulté de toutes ses actions est alors augmentée de 8. Le meneur de jeu a toute liberté pour rappeler à l’ordre les joueurs qui “oublieraient” de combler leurs besoins.",
    cost: [3],
    type: DisadvantageType.rare,
    requireDetails: true,
  ),
  deviance(
    title: 'Déviance',
    description: "Le personnage est perturbé par des envies pour le moins douteuses et dérangeantes, telles que des amitiés ambiguës, une avarice prononcée, un goût pour le mensonge pathologique, etc. Il appartient au joueur de décider de la déviance dont souffre son personnage, mais le meneur de jeu est libre de rappeler à l’ordre le joueur qui oublie de gérer son Désavantage.",
    cost: [3],
    type: DisadvantageType.rare,
    requireDetails: true,
  ),
  echecRare(
    title: 'Échec',
    description: "Comme décrit précédemment (cf. Échec commun) si ce n’est que la Difficulté de tous les jets en rapport sera augmentée de 10. Il est possible d'accorder un jet (et un seul) de Mental + Volonté contre une Difficulté de 15 pour réduire cette augmentation à 5.",
    cost: [5],
    type: DisadvantageType.rare,
    requireDetails: true,
  ),
  ennemiRare(
    title: 'Ennemi',
    description: "Comme décrit précédemment (cf. Ennemi commun) si ce n’est qu’il peut s'agir ici d’un ennemi irréductible ou d’un ennemi susceptible de freiner la progression du personnage au sein de sa caste ou du Lien draconique. En tant que meneur de jeu, arrangez-vous pour que le personnage puisse un jour ou l’autre découvrir l’origine exacte de ses “petits soucis”, de façon à ce que l’ennemi prenne forme et puisse expliquer ses motivations au personnage. Il n’est pas possible de se débarrasser d’un tel ennemi, ce dernier ayant toujours un proche, un frère d’arme ou encore un fidèle pour menacer à nouveau le personnage.\nCe Désavantage peut survenir plusieurs fois.",
    cost: [5],
    type: DisadvantageType.rare,
    requireDetails: true,
  ),
  harmonieNaturelle(
      title: 'Harmonie naturelle',
      description: "Les dryades sont touchées émotionnellement par les malheurs qui touchent le domaine de Heyra autour d'elles. Par des récits déchirants et en jouant sur les émotions des hommes qu'elles rencontrent, les dryades peuvent faire naître la culpabilité dans le cœur de ceux qui blessent la Nature. Elles créent alors un blocage mental de plus en plus fort qui va empêcher le personnage d'agir à l'encontre de la Nature. Sans que ce pouvoir soit utilisé volontairement ou à des fins néfastes, les dryades en font un usage courant.\nCe Désavantage peut évoluer et empirer au fur et à mesure des plaintes des dryades. A chaque fois que le personnage agit “mal” selon la dryade, celle-ci pourra effectuer un jet en Opposition de Social+Séduction contre Mental+Présence du personnage. Chaque échec indique un degré dans le Désavantage. Le personnage sera de plus en plus pacifique, attentif à la Nature et paisible. Dès qu'il voudra agir contre la Nature (de façon inutile s'entend), mais aussi être agressif ou violent, il devra effectuer à chaque tour un jet de Mental+Volonté contre 5 fois le degré du Désavantage. S'il échoue, il arrête son action et prend conscience de son erreur.",
      cost: [0],
      type: DisadvantageType.rare
  ),
  incompetence(
    title: 'Incompétence',
    description: "Il est parfois nécessaire de faire des sacrifices : ce Désavantage représente l'impasse que le personnage a faite sur une catégorie de Compétences (Combat, Mouvement, Théorie, etc.) au choix du joueur.\nLes Compétences de cette catégorie ne pourront être utilisées qu’avec une Difficulté augmentée de 5, quel que soit le type d'action. De plus, le niveau maximum que peut atteindre le personnage dans les Compétences de cette liste est réduit à 10.\nCe Désavantage peut survenir plusieurs fois, mais forcément pour des catégories de Compétences différentes.",
    cost: [5],
    type: DisadvantageType.rare,
    requireDetails: true,
  ),
  infirmite(
    title: 'Infirmité',
    description: "Le joueur doit définir le type d’infirmité dont souffre son personnage.\nPour 1 point, il peut s’agir d’un doigt, d’un ou de quelques orteils, d’un bout de narine, etc.\nPour 3 points, il peut s’agir d’un œil, des deux oreilles, d’une main ou d’un pied, etc. Tous les jets impliquant ces membres manquants (Perception, Manipulation) voient leur Difficulté augmenter de 5.\nPour 5 points, il peut s'agir des deux yeux, d’une jambe, d’un bras, de la langue, etc. Toutes les Difficultés des jets en rapport sont augmentées de 10. Dans certains cas, le jet est tout simplement impossible.",
    cost: [1,3,5],
    type: DisadvantageType.rare,
    requireDetails: true,
  ),
  maladresse(
    title: 'Maladresse',
    description: "Le personnage est maladroit, tout simplement. Ses jets de Manipulation voient leur Difficulté augmenter de 5. De plus, il lui arrivera très souvent de laisser tomber des objets fragiles, de perdre le contrôle de son arme, de lâcher la corde sur laquelle ses compagnons comptent pour gravir une paroi, etc.\nLe meneur de jeu peut donc utiliser ce Désavantage pour corser des situations ou interpréter des échecs critiques.",
    cost: [2],
    type: DisadvantageType.rare
  ),
  marqueAuFer(
    title: 'Marqué au fer',
    description: "Le personnage a été considéré comme coupable d’un méfait qui lui a valu d’être marqué au fer rouge. Il est exilé de ce lieu et sera tué s’il y revient.\nLa marque est toujours sur un endroit visible (cou, front, tempes, joue, dos de la main, etc.) et lui vaudra toujours des ennuis, même dans d’autres régions.",
    cost: [3],
    type: DisadvantageType.rare,
    requireDetails: true,
  ),
  mauvaisOeil(
    title: 'Mauvais œil',
    description: "Ce Désavantage transforme le personnage en croquemitaine, en monstre de légende qui fait peur aux enfants et inspire la méfiance. Quelque chose d’indéfinissable en lui provoque un mélange de peur, de suspicion et de dégoût. Tous les jets basés sur le relationnel (Communication et Influence) voient leur Difficulté augmenter de 5.\nDe plus, tous les membres du groupe le considéreront comme quelqu'un de “douteux”, à qui il ne faut jamais faire exagérément confiance.",
    cost: [3],
    type: DisadvantageType.rare
  ),
  personneACharge(
    title: 'Personne à charge',
    description: "Le personnage est responsable d'une personne dépendante pour qui il a de l'affection (enfant, vieillard, blessé, etc.). Il ne peut s’en défaire aisément et devra veiller sur elle au cours de ses aventures (ou payer des gens pour s’en occuper).\nCe Désavantage peut survenir plusieurs fois.",
    cost: [2],
    type: DisadvantageType.rare,
    requireDetails: true,
  ),
  regardDesDragons(
    title: 'Regard des Dragons',
    description: "Depuis que les hommes vivent aux côtés des dragons, le lien qui les unit à leurs créateurs a toujours été à double tranchant. Ce Désavantage place le personnage dans une situation des plus inconfortables, puisqu’un dragon a choisi de le surveiller en permanence pour mieux juger de son comportement.\nCette décision peut être prise suite à une action maladroite, une révolte plus ou moins flagrante contre l’autorité d’une cité, un meurtre, etc. La puissance du dragon et la durée de l’observation dépendent du gain en Points d’Avantage choisi.\nPour 3 points, le dragon est mineur et la surveillance ne dure que quelques mois. Pour 5 points, le dragon est très puissant et sa surveillance peut durer jusqu'à la mort du personnage, si celui-ci ne prouve pas sa valeur avant ce terme.\nLes interactions entre le dragon et le personnage sont laissées à l'appréciation du meneur de jeu. Le dragon n’est pas un juge, mais un observateur. Il n'ira pas jusqu’à tuer le personnage, sauf si celui-ci commet une action ouvertement hostile en sa présence, et préférera le manipuler, devenir progressivement son ennemi ou l’exposer à des situations toujours plus dangereuses.",
    cost: [3,5],
    type: DisadvantageType.rare,
    requireDetails: true,
  ),
  traumatismeMental(
    title: 'Traumatisme mental (Mage du Feu)',
    description: "Un mage de Kroryn peut avoir gardé des séquelles mentales de son passage dans un Foyer. Au lieu de combattre ses rêves comme on le lui a enseigné, il les subit complètement. Le plus souvent, il s'agit de cauchemars récurrents, dont l'intensité augmente avec l'utilisation de la magie dans la journée. Un mage qui n'aura pas usé de ses pouvoirs dans la journée n'aura qu'un sommeil agité. Mais un mage qui aura abusé de son don, en utilisant plus de la moitié de ses points de magie dans la même journée, ne pourra fermer l'œil de la nuit et ne récupérera que la moitié des points de sa Réserve de Sphère de Volonté.",
    cost: [4],
    type: DisadvantageType.rare,
    reservedCastes: [Caste.mage]
  ),
  troubleMental(
    title: 'Trouble mental',
    description: "Contrairement à la Déviance, ce Désavantage ne provoque pas de véritable pathologie chez le personnage, mais instaure un déséquilibre constant qui le pousse à douter de lui, à refuser des évidences et à adopter un comportement totalement imprévisible. Le personnage agit de façon incohérente aux yeux de tous, mais il aura toujours une bonne raison à fournir. Ses propos sont mystérieux, embrouillés, et ses actes risquent fort de surprendre ses compagnons au moment où ceux-ci s'y attendront le moins…",
    cost: [3],
    type: DisadvantageType.rare,
    requireDetails: true,
  ),
  chetif(
    title: 'Chétif',
    description: "Le personnage a un petit retard de croissance. La Difficulté de toutes les actions liées à l’Attribut Physique est augmentée de 3.",
    cost: [5],
    type: DisadvantageType.enfant
  ),
  curiosite(
    title: 'Curiosité',
    description: "L'enfant est irrésistiblement attiré par l’inconnu. Il cherche toujours à découvrir ce qui lui est méconnu, ce qui pourra lui valoir des désagréments réguliers qui pourront entraîner ses compagnons avec lui.",
    cost: [3],
    type: DisadvantageType.enfant
  ),
  illusions(
    title: 'Illusions',
    description: "L'enfant est convaincu que sa conception du monde est la seule vérité. Ce que certains pourraient qualifier de “confiance” se révèle être un terrible défaut, puisque le personnage refusera systématiquement de croire les explications de ses aînés et, pire encore, ira de son plein gré au devant de situations parfois mortelles. L'illusion peut être de nature variable : croire que tous les dragons sont pacifiques envers les humains, que le feu ne brûle pas un mage adepte de cette Sphère, qu’aucune flèche ne peut percer une armure bardée de métal, etc.",
    cost: [2],
    type: DisadvantageType.enfant
  ),
  insignifiant(
    title: 'Insignifiant',
    description: "L'enfant a toutes les peines à se faire entendre des adultes. Son avis est toujours mis de côté lors des discussions. Cela pourra provoquer de sa part des colères ou un mutisme prolongé parfois insupportables.",
    cost: [1],
    type: DisadvantageType.enfant
  ),
  lassitude(
    title: 'Lassitude',
    description: "L'enfant supporte mal les efforts prolongés où l’ennui l’emporte. Il devient alors assez pénible et irritable. Il pourra même faire des caprices afin de montrer sa désapprobation (ne plus marcher, refuser de dormir, etc.).",
    cost: [2],
    type: DisadvantageType.enfant
  ),
  mensongesInfantiles(
    title: 'Mensonges infantiles',
    description: "L'enfant ne peut s'empêcher de mentir lorsque cela l’arrange. Il ira jusqu’à inventer des excuses invraisemblables ou déformer allégrement la réalité pour attirer l’attention.",
    cost: [1],
    type: DisadvantageType.enfant
  ),
  naivete(
    title: 'Naïveté',
    description: "À l'inverse de la méfiance, la naïveté pousse le personnage à croire aveuglément tout ce qu'on lui dit, quand bien même on lui présenterait un terrible dragon du feu comme une créature bienveillante et protectrice.\nTous ses jets pour détecter un éventuel mensonge (avec la Compétence Psychologie, par exemple) voient leur Difficulté augmenter de 5.",
    cost: [2],
    type: DisadvantageType.enfant
  ),
  revolte(
    title: 'Révolte',
    description: "L'enfant révolté aura toujours tendance à contester l'autorité établie, qu’elle soit liée aux Dragons ou aux adultes. Son caractère bouillonnant et son refus d’obéir aux ordres risquent de le placer dans des situations délicates.",
    cost: [2],
    type: DisadvantageType.enfant
  ),
  transfert(
    title: 'Transfert',
    description: "La plupart des enfants et des jeunes sont facilement influençables, mais ce Désavantage est encore plus prononcé, puisqu'il établit un lien étrange entre l'enfant et un de ses compagnons (dans l'intérêt du jeu, mais il peut s'agir de n'importe qui d'autre). Une fois que le meneur de jeu a décidé de la “victime” du transfert, l’enfant se sent irrémédiablement attiré par celle-ci. Il croit reconnaître en lui/elle un parent, un proche disparu, un maître, etc. Le transfert risque de créer des rivalités, des conflits, des malentendus et une certaine gêne au sein du groupe.",
    cost: [2],
    type: DisadvantageType.enfant,
    requireDetails: true,
  ),
  versatilite(
    title: 'Versatilité',
    description: "L'enfant est incapable de fixer longtemps son attention.\nIl cédera fréquemment à l'attrait de nouvelles activités lorsqu'elles se présenteront.\nLe personnage ne gagne pas les Points d’Expérience en “Implication” lors de l'attribution des Points d’Expérience.",
    cost: [3],
    type: DisadvantageType.enfant
  ),
  cardiaque(
    title: 'Cardiaque',
    description: "Le personnage a des problèmes de cœur. Son souffle est court et de virulentes douleurs lui serrent parfois la poitrine.\nLors d’émotions très violentes (peur intense, joie euphorique, etc.) ou d’efforts physiques (course, combat, etc.) dépassant son score de Résistance en tours, le personnage peut subir une attaque. Il effectue alors un jet de Physique + Résistance contre une Difficulté de 20. En cas d’échec, il coche une case de blessure fatale pour une durée d’une demie-journée.\nEn cas d’échec critique, il coche une case de mort et décède en un nombre de tours égal à sa Résistance.",
    cost: [4],
    type: DisadvantageType.ancien
  ),
  edente(
    title: 'Édenté',
    description: "Le personnage a perdu la majorité de ses dents. Il bafouille et mange ses mots, Il subit un malus de -3 en Communication et ne peut en aucun cas obtenir de Clé parfaite lors du lancement d’un sort utilisant la voix.",
    cost: [3],
    type: DisadvantageType.ancien
  ),
  grincheux(
    title: 'Grincheux',
    description: "Le personnage a un caractère des plus désagréables. Il ronchonne et se plaint à longueur de temps. Nul doute que ses compagnons le trouveront vite pénible.",
    cost: [2],
    type: DisadvantageType.ancien
  ),
  impotent(
    title: 'Impotent',
    description: "Le personnage a de graves difficultés à se mouvoir seul. Il se déplace lentement et la station debout lui est pénible au-delà de quelques heures. Toutes ses actions dépendant de l’Attribut Physique (Combat et Mouvement) voient leurs Difficultés augmentées de 3.\nCe Désavantage ne peut être surmonté.",
    cost: [4],
    type: DisadvantageType.ancien
  ),
  maladeImaginaire(
    title: 'Malade imaginaire',
    description: "Le personnage est persuadé de souffrir de diverses afllictions irrégulières et parvient à s’en convaincre. Chaque matin, il jette 1D10 sous sa Volonté. Si son jet est supérieur ou égal à sa Caractéristique, il subit un malus de -1 à toutes ses actions pour la journée à cause de tous les désagréments et douleurs dus à sa “maladie”.",
    cost: [2],
    type: DisadvantageType.ancien
  ),
  nostalgieObsessionnelle(
    title: 'Nostalgie obsessionnelle',
    description: "Le personnage ressasse sans cesse des souvenirs de sa jeunesse. Il sombre fréquemment dans une mélancolie qui pourra peser sur les nerfs de ses cadets.",
    cost: [2],
    type: DisadvantageType.ancien
  ),
  rhumatismes(
    title: 'Rhumatismes',
    description: "Le personnage souffre de douleurs articulaires et osseuses qui sont déclenchées par l'humidité (marais, caves, pluie, brise matinale, etc.). À ces moments, ses actions dépendant des Attributs Physique et Manuel subissent un malus de -2.",
    cost: [3],
    type: DisadvantageType.ancien
  ),
  senile(
    title: 'Sénile',
    description: "Le personnage perd la tête. Il mélange ou oublie parfois des pans entiers de son passé ou de son savoir. Toutes ses actions impliquant la mémoire subissent un malus de -3.",
    cost: [4],
    type: DisadvantageType.ancien
  ),
  surdite(
    title: 'Surdité',
    description: "Le vieillard a de graves problèmes auditifs. Il est partiellement sourd et la Difficulté de tous ses jets de Perception auditive est augmentée de 5. Il ne peut guère entendre que ce qu’on lui crie.",
    cost: [3],
    type: DisadvantageType.ancien
  ),
  vueDefaillante(
    title: 'Vue défaillante',
    description: "Le vieillard souffre de graves troubles oculaires, dus à son âge et à son état de santé général. La Difficulté de tous ses jets de Perception visuelle est augmentée de 5 et sa vue défaillante rendra pénible la lecture et l'observation prolongées.",
    cost: [2],
    type: DisadvantageType.ancien
  )
  ;

  final String title;
  final String description;
  final List<int> cost;
  final DisadvantageType type;
  final bool requireDetails;
  final List<Caste> reservedCastes;

  const Disadvantage({
    required this.title,
    required this.description,
    required this.cost,
    required this.type,
    this.requireDetails = false,
    this.reservedCastes = const <Caste>[],
  });
}