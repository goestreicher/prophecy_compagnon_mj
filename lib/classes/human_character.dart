import 'package:json_annotation/json_annotation.dart';

import 'entity_base.dart';
import 'combat.dart';
import 'equipment.dart';
import 'exportable_binary_data.dart';
import 'magic.dart';
import 'magic_user.dart';
import 'object_location.dart';
import 'place.dart';
import 'weapon.dart';
import 'character/base.dart';
import 'character/injury.dart';
import 'character/skill.dart';

part 'human_character.g.dart';

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
    description: "Suite à une bataille, le personnage a subi une blessure qui ne s’est jamais vraiment refermée. Quelles que soient ses valeurs de Résistance et de Volonté, 1e personnage perd définitivement une case d’égratignure et une case de blessure légère. Aucune tentative de soins, même magiques, ne peut rendre ces cercles perdus à ce personnage.\nCe Désavantage peut survenir plusieurs fois.",
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

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CharacterDisadvantage {
  CharacterDisadvantage({
    required this.disadvantage,
    required this.cost,
    required this.details,
  });

  final Disadvantage disadvantage;
  final int cost;
  final String details;

  factory CharacterDisadvantage.fromJson(Map<String, dynamic> json) => _$CharacterDisadvantageFromJson(json);
  Map<String, dynamic> toJson() => _$CharacterDisadvantageToJson(this);
}

enum AdvantageType {
  general(title: 'Général'),
  enfant(title: 'Enfant'),
  ancien(title: 'Ancien');

  final String title;

  const AdvantageType({ required this.title });
}

enum Advantage {
  agilite(
    title: 'Agilité',
    description: "Le personnage est particulièrement agile et bénéficie d’un bonus de 2 à toutes ses actions de mouvement : escalader, se déplacer silencieusement, grimper à une corde, etc.",
    cost: [3],
    type: AdvantageType.general
  ),
  allie(
    title: 'Allié',
    description: "L'allié est un individu ou un groupe d'individus qui fera de son mieux pour aider le personnage en cas de besoin. Cette relation est fondée sur le respect et la sympathie, voire l’amitié, et n’obligera donc pas les alliés à se sacrifier où à accepter des aides qui les exposeraient à de graves dangers.\nPour 3 points, il s’agit généralement d’un allié unique, de puissance et de réputation équivalentes à celles du personnage.\nPour 5 points, il peut s'agir d’un groupe d’alliés (comme une faction mineure, une guilde, une école de magie, etc.) ou d’un allié unique beaucoup plus puissant et connu que le personnage (un combattant reconnu, un responsable de la milice, un mage respecté, etc.).\nLe choix de l’allié reste soumis à l’approbation du meneur de jeu.\nCet Avantage peut être choisi plusieurs fois.",
    cost: [3,5],
    type: AdvantageType.general,
    requireDetails: true,
  ),
  ambidextre(
    title: 'Ambidextre',
    description: "Cet Avantage permet au personnage d'utiliser ses deux mains indifféremment. Le fait d’être ambidextre ne permet en aucun cas d'effectuer deux attaques pour un dé d'action.\nLors d’un combat à deux armes, il permettra de réduire le malus lié à la mauvaise main.",
    cost: [3],
    type: AdvantageType.general
  ),
  armeDuMaitre(
    title: 'Arme du maître',
    description: "De nombreux instructeurs remettent à leurs élèves une épée, une masse qui leur servira d'arme de prédilection. Cette arme est unique aux yeux du personnage, qui la considère comme une relique. Tant que le personnage utilise cette arme, il gagne un bonus de 1 à tous ses jets d’attaque et de parade. S'il vient à la perdre ou bien si l’arme est brisée, il perd définitivement ce bonus.",
    cost: [2],
    type: AdvantageType.general,
    requireDetails: true,
  ),
  augureFavorable(
    title: 'Augure favorable',
    description: "L'Augure de naissance du personnage est particulièrement marqué et lui confère des aptitudes innées dans certaines Compétences ainsi que des cercles supplémentaires dans certaines Tendances. En plus d’attribuer des bonus, il va sans dire que cet Augure favorable influence plus profondément encore le caractère et les motivations du personnage. Tous ces bonus s'appliquent après avoir déterminé son profil de base mais avant la dépense des Points de Compétence.\n\nLe fataliste : Fatalité +5 / +1 à une Compétence d'Influence et +1 à une Compétence de Communication\nLe volcan : Dragon +4, Fatalité +1 / +1 à deux Compétences de Combat\nLe métal : Dragon +3, Homme +2 / +1 à une Compétence de Combat et +1 à une Compétence de Technique\nLa cité : Dragon +1, Homme +4 / +1 à deux Compétences de Communication\nLe vent : Dragon +4, Homme +1 / +1 à deux Compétences de Mouvement\nL'océan : Dragon +5 / +1 à une Compétence de Théorie et +1 à une Compétence de Pratique\nLa chimère : Dragon +3, Homme +1, Fatalité +1 / +1 à une Sphère et +1 en Magie instinctive\nLa nature : Dragon +4, Fatalité+1 / +1 à une Compétence de Mouvement et +1 à une Compétence de Pratique\nLa pierre : Dragon +5 / +1 à une Compétence de Combat et +1 à une Compétence d'Influence\nL'homme : Homme +5 / +1 à une Compétence de Communication et +1 à une Compétence au choix (sauf Sphères et Disciplines)",
    cost: [3],
    type: AdvantageType.general
  ),
  chance(
    title: 'Chance',
    description: "Cet Avantage permet au personnage de récupérer un Point de Chance supplémentaire à chaque action ratée (soit 2 pour un échec normal et 3 pour un échec critique).",
    cost: [2],
    type: AdvantageType.general
  ),
  charme(
    title: 'Charme',
    description: "Le personnage dispose d’un charme naturel qui augmente ses facultés de séduction, de dialogue et de communication. Tous ses jets basés sur le relationnel (Baratin ou Psychologie) bénéficient d’un bonus de 2 et ceux de Séduction d’un bonus de 5.",
    cost: [1],
    type: AdvantageType.general
  ),
  confidences(
    title: 'Confidences',
    description: "Le personnage a la faculté d’inspirer la confiance et de provoquer le dialogue. Cet Avantage donne un bonus de 5 à tous les jets de Communication portant sur des informations que son interlocuteur tient à garder secrètes. Attention : cet Avantage ne permet pas d'obtenir spontanément des informations vitales (position de l’armée ennemie, son appartenance à une secte humaniste ou fataliste, révéler un secret draconique, etc.). Au sein du groupe, les compagnons du personnage auront de plus tendance à se confier à lui et à lui demander conseil en cas de problème.",
    cost: [3],
    type: AdvantageType.general
  ),
  corpsAguerri(
    title: 'Corps aguerri',
    description: "Cet Avantage permet au personnage de résister à la douleur et à la fatigue découlant de ses blessures. En réussissant un jet de Mental + Volonté contre une Difficulté de 15, il peut réduire de (1 + NR) points les malus liés à ses Seuils de blessure, et cela pour toute la durée du combat, après quoi ils s'appliquent de nouveau normalement. Ce jet ne s’effectue qu’une fois par combat.",
    cost: [3],
    type: AdvantageType.general
  ),
  droiture(
    title: 'Droiture',
    description: "L'honneur et le respect sont des valeurs fondamentales aux yeux du personnage. Ses certitudes sont telles que ses interlocuteurs peuvent sentir sa droiture. La Présence du personnage est augmentée de 2 lors de tous les jets basés sur l'honneur, le courage et le moral.",
    cost: [1],
    type: AdvantageType.general
  ),
  fortunePersonnelle(
    title: 'Fortune personnelle',
    description: "Cet Avantage confère au personnage une somme de 1 000 dracs de fer par point dépensé.",
    cost: [],
    type: AdvantageType.general
  ),
  heritageDraconique(
    title: 'Héritage draconique',
    description: "Le personnage s’est vu octroyer une Faveur draconique issue du Lien d’un de ses parents. Le personnage est donc capable d'utiliser cette Faveur sans pour autant avoir de Lien.\nLe dragon l’ayant choisi ne s’est pas manifesté depuis son plus jeune âge. Le dragon peut ressurgir n’importe quand pour vérifier que le personnage reste fidèle à ses convictions familiales et donc à la mentalité appréciée par l’ailé.\nLe personnage ne connaît pas le dragon et peut décider de briser les traditions en ayant combattu ses capacités “innées” (à ses risques et périls lorsque le dragon ressurgira).\nIl va sans dire que tout Prélude entamé au cours de sa vie restera figé, le nouveau dragon refusant le Lien au personnage car il ressent l'influence d’un de ses pairs. Lors du retour du dragon, le personnage peut être remis à l'épreuve et avoir à assujettir son comportement à la mentalité du dragon sous peine de se voir ôter cet héritage.\nCet Avantage ne peut être choisi qu'une fois et doit impérativement être tiré sur le tableau ci-dessous (1D10).\n\n1 La marque de l'ombre (Kalimsshar)\n2 L'œil incandescent (Kroryn)\n3 La main du maître (Kezyr)\n4 L'esprit des cités (Khy)\n5 L'élan des brises (Szyl)\n6 Le secret du verbe (Ozyr)\n7 Le monde éthéré (Nenya)\n8 Le sang et la sève (Heyra)\n9 La peau de pierre (Brorne)\n10 Relancer sur cette table",
    cost: [6],
    type: AdvantageType.general
  ),
  magieNaturelle(
    title: 'Magie naturelle',
    description: "Cet Avantage confère au personnage une base de 2 dans une Sphère de magie et un sort de niveau 1 gratuit de cette Sphère.\nLes limitations liées aux Sphères doivent être respectées.\nCet Avantage ne peut être choisi qu’une seule fois.",
    cost: [4],
    type: AdvantageType.general,
    requireDetails: true,
  ),
  mentor(
    title: 'Mentor',
    description: "Le mentor est l’instructeur qui a le plus compté dans l'apprentissage du personnage. C’est lui qui a forgé son savoir-faire et qui a orienté la plupart de ses choix. En choisissant cet Avantage, le joueur gagne un total de 2 points qu’il peut attribuer à une ou plusieurs Compétences dans son profil de caste. Cet Avantage est le seul qui permette de dépasser les limitations dues à l’âge de départ du personnage - mais il est toujours impossible de dépasser 10 à la création.\nCet Avantage ne peut être choisi qu’une seule fois.",
    cost: [4],
    type: AdvantageType.general,
    requireDetails: true,
  ),
  present(
    title: 'Présent',
    description: "Permet au personnage d’avoir eu l’honneur d’offrir un présent de sa facture à un dignitaire, un noble, une personnalité influente, un dragon, etc. La valeur du présent en question varie en fonction du coût payé pour acheter cet Avantage - et de la dette que le bénéficiaire se promettra d’honorer un jour. Le coût de l’Avantage, la description du présent, l’identité du bénéficiaire et la nature de la dette sont laissés à l’appréciation du meneur de jeu. À titre d'exemple, chaque point dépensé peut correspondre à un Statut de caste pour déterminer la qualité du bénéficiaire - ou 6 points correspondront à un dragon d’importance ou un héros du Royaume de Kor. Les valeurs matérielle et symbolique de l’objet offert évolueront en parallèle, tout comme la dette.\nCet Avantage peut être choisi deux fois, mais pour deux bénéficiaires différents.",
    cost: [1,2,3,4,5,6],
    type: AdvantageType.general,
    requireDetails: true,
    reservedCastes: [Caste.artisan]
  ),
  prestance(
    title: 'Prestance',
    description: "Le prestige du personnage et l’expérience qu’il a acquis donnent à sa parole un poids évident lors des discussions. Chaque fois qu’il tentera une action sociale liée à son charisme, telle que faire aboutir une discussion, exposer un point de vue ou orienter une prise de décision, son Attribut Social sera augmenté de 2.",
    cost: [2],
    type: AdvantageType.general
  ),
  pressentiment(
    title: 'Pressentiment',
    description: "Le personnage possède une sorte de sixième sens qui lui permet de déterminer certains éléments de son avenir proche. Par exemple, si le personnage s'approche d’une grotte, il pourra deviner si ce lieu est habité, si l’occupant sera éventuellement agressif, si un piège est à soupçonner, etc. Les utilisations de cet Avantage sont limitées à trois fois par jour. À chaque utilisation, le joueur doit effectuer un jet de Mental + Empathie contre une Difficulté de 15. Si le jet est réussi, le personnage obtient (1 + NR) informations. Par exemple, dans le cas de la grotte : “Elle est habitée (jet réussi), ses occupants sont nombreux (premier NR) et te semblent instinctivement dangereux (deuxième NR).”",
    cost: [3],
    type: AdvantageType.general
  ),
  resistanceALaMagie(
    title: 'Résistance à la magie',
    description: "Certains humains possèdent une résistance à la magie qui les protège de nombreux effets. Lorsqu’il choisit cet Avantage, le joueur doit décider entre les deux facultés suivantes. Soit il obtient une protection efficace contre tous les sortilèges d’une Sphère précise, auquel cas son jet de résistance bénéficiera d’un bonus de 8, soit une protection moindre mais contre toutes les Sphères, auquel cas le bonus est de 2.\nCette résistance n’influe pas sur les capacités surnaturelles du personnage (Techniques, bénéfices, Faveurs, Privilèges) ou le lancement de ses propres sortilèges. En revanche, cette résistance s'applique à tous les effets de sorts (et uniquement des sorts) lui étant lancés, qu’ils soient bénéfiques ou néfastes.\nCet Avantage ne peut être sélectionné qu’une seule fois.",
    cost: [5],
    type: AdvantageType.general,
    requireDetails: true,
  ),
  santeDeFer(
    title: 'Santé de fer',
    description: "Cet Avantage confère au personnage une capacité de résistance aux maladies et aux agressions extérieures. Tous ses jets de résistance pour lutter contre les maladies, les poisons ou toutes autres substances nocives bénéficient d’un bonus de 5.\nDe plus, l'organisme du personnage lui permet de mieux bénéficier des soins.\nIl est toujours considéré comme ayant atteint un Seuil de blessure inférieur à celui où il se trouve actuellement pour déterminer la Difficulté du jet de soins.\nPar exemple, si le personnage est en blessure fatale, les soins et les tentatives pour stopper d’éventuelles hémorragies seront effectués comme s’il n’avait atteint que le Seuil de blessures graves.\nCet Avantage n’annule pas les malus liés aux Seuils de blessure.",
    cost: [4],
    type: AdvantageType.general
  ),
  sensAccru(
    title: 'Sens accru',
    description: "L'un des sens du personnage est particulièrement développé. Tous ses jets de perception utilisant ce sens gagnent un bonus de 3.\nCet Avantage peut être choisi plusieurs fois, mais à chaque fois pour un sens différent (vue, ouïe, odorat, goût, toucher).",
    cost: [2],
    type: AdvantageType.general,
    requireDetails: true,
  ),
  sensDeLOrientation(
    title: "Sens de l'orientation",
    description: "Grâce à cet Avantage, le personnage peut toujours se repérer. Il sait avec certitude si certains endroits se trouvent devant, derrière, à gauche ou à droite, vers le nord, le sud, etc. Ceci se traduit par un bonus de 3 à ses jets d’Orientation (en milieu naturel) et de Vie en cité (dans une ville).",
    cost: [1],
    type: AdvantageType.general
  ),
  sensEnAlerte(
    title: 'Sens en alerte',
    description: "Cet Avantage permet au personnage d’être toujours en alerte et, lors des combats, de garder une vue d'ensemble des événements, de façon à pouvoir intervenir au meilleur moment.\nAu premier tour de chaque combat, le joueur lance un dé supplémentaire pour déterminer le rang d’Initiative des actions de son personnage - il choisit ensuite les meilleurs résultats, en conservant un nombre de dés égal à son nombre d'actions.",
    cost: [3],
    type: AdvantageType.general
  ),
  statutSocial(
    title: 'Statut social',
    description: "Le personnage est connu à l’intérieur de sa caste, quel que soit son Statut. Cet Avantage augmente sa Renommée de 2 points pour toutes les actions liées à l'influence hiérarchique (obtenir des informations, négocier un marché, faire aboutir une demande, demander de l’aide, etc.).",
    cost: [2],
    type: AdvantageType.general
  ),
  surprise(
    title: 'Surprise',
    description: "Permet au personnage de gagner un bonus de +5 sur le jet de sa première action d’un tour, ou, au contraire, d’imposer un malus de +5 à la Difficulté du premier jet d’action de son adversaire. Ce Privilège n’est applicable que sur le jet correspondant à la première action du personnage ou de son adversaire - une seule fois par combat, donc. Il peut s’utiliser plusieurs fois sur une même personne, mais toujours seulement une fois par combat (à la première action).",
    cost: [6],
    type: AdvantageType.general,
    reservedCastes: [Caste.commercant]
  ),
  chanceInouie(
    title: 'Chance inouïe',
    description: "La Chance inouïe permet à l’enfant de défier les lois de la probabilité et de réussir miraculeusement les actions qu’il était sur le point de rater. Que son jet soit raté ou réussi, 1e joueur peut dépenser des Points de Chance pour obtenir des NR (c’est l'exception qui confirme la règle de dépense des Points de Chance).",
    cost: [3],
    type: AdvantageType.enfant
  ),
  empathieNaturelle(
    title: 'Empathie naturelle',
    description: "Cet Avantage permet au personnage de “sentir” son environnement comme s’il pouvait établir un contact empathique avec les éléments qui l’entourent. Cette faculté lui permet de ressentir des impressions, des émotions, des peurs. Cet Avantage s'utilise avec un jet de Mental + Empathie contre une Difficulté variable, en fonction de l’action entreprise. Pour ressentir des émotions sur des animaux et des créatures dénuées d'intelligence, la Difficulté est de 10. Sur des êtres intelligents, la Difficulté passe à 15. Le meneur de jeu se réserve le droit de faire effectuer à la cible un jet de Mental + Volonté contre une Difficulté de 15, s’il estime que cette dernière cherche à masquer ses émotions. Ce jet est alors un jet d'opposition.",
    cost: [4],
    type: AdvantageType.enfant
  ),
  fetiche(
    title: 'Fétiche',
    description: "Les enfants aiment croire que certains objets qui leur sont chers possèdent des pouvoirs magiques, ainsi qu’une personnalité propre. Tant qu’il porte cet objet sur lui, le personnage voit son Attribut Chance augmenter de 1. Si l’objet est perdu, volé ou détruit, le personnage sombre immédiatement dans une période de morosité qui durera une vingtaine de jours, et durant laquelle le personnage ne pourra plus regagner qu’un seul Point de Chance à chaque action ratée, quel que soit le type d’échec. Il sera également très irritable et aura nettement moins confiance en lui. L'Avantage est définitivement perdu dès la disparition du fétiche, et il est impossible de le remplacer.",
    cost: [1],
    type: AdvantageType.enfant
  ),
  instinctProtecteur(
    title: 'Instinct protecteur',
    description: "L'enfant provoque au sein du groupe un instinct de protection. Lorsqu’il est en danger (combat, chute imminente, noyade, etc.), l’un de ses compagnons se porte immanquablement à son secours. Pour ce faire, le sauveur bénéficie d’un bonus de 3 à UNE action destinée à le tirer d'affaire (parer une attaque fatale, rattraper la corde qui glisse, plonger à son secours, etc.) une fois par jour. Le joueur est en droit de réclamer l'assistance d’un des personnages si la situation l’exige. Le meneur de jeu pourra, en dernier recours, désigner un personnage si aucun ne réagit spontanément.",
    cost: [2],
    type: AdvantageType.enfant
  ),
  precoce(
    title: 'Précoce',
    description: "L'enfant est en avance sur les autres enfants de son âge. Sa maturité lui vaut l'intérêt des adultes et une certaine distance de la part de ses camarades. Le personnage peut développer ses Compétences jusqu’à un niveau de 8 (soit autant qu’un adulte) à la création. Cet écart, perceptible lors de l'enfance, se perdra dans la masse à l’âge adulte.",
    cost: [2],
    type: AdvantageType.enfant
  ),
  artInterdit(
    title: 'Art interdit',
    description: "Cet Avantage permet aux anciens et aux vénérables de développer dès la création l’une des quatre Compétences suivantes : Armes mécaniques, Chirurgie, Explosifs ou Mécanismes. Au cours de sa vie, il aura rencontré un maître capable de lui enseigner les rudiments de l’une de ces Compétences qu’il pourra développer jusqu’à un niveau maximum de 5 + Tendance Homme. Cet Avantage autorise uniquement la dépense de points à la création dans une de ces Compétences. Cet Avantage n’autorise aucunement le personnage à pratiquer cet art. À sa charge d'obtenir les rares autorisations délivrées par certaines castes.\nCet Avantage peut être choisi plusieurs fois et doit être acheté pour chaque Compétence désirée.",
    cost: [3],
    type: AdvantageType.ancien,
    requireDetails: true,
  ),
  conviction(
    title: 'Conviction',
    description: "Cet Avantage permet au personnage de rester de marbre face à des attaques, des tentatives d’intimidation et des situations où ses principes seraient mis en cause. Cet Avantage confère un bonus de 5 à tous les jets de Social et de Volonté basés sur l’intimidation, le chantage ou le harcèlement psychologique.",
    cost: [2],
    type: AdvantageType.ancien
  ),
  culture(
    title: 'Culture',
    description: "Cet Avantage procure au personnage une connaissance restreinte de tous les sujets théoriques auxquels il peut être confronté. Il permet d’obtenir un bonus de 1 à tous les jets de Mental + Compétence de Théorie.",
    cost: [3],
    type: AdvantageType.ancien
  ),
  habileteReconnue(
    title: 'Habileté reconnue',
    description: "L'apprentissage et l’expérience ont permis au personnage de se forger la maîtrise parfaite d’une certaine catégorie de Compétences. Lorsqu'il choisit cet Avantage, le joueur doit désigner l’un des huit groupes de Compétences (Combat, Manipulation, Théorie, etc.). Pour tous les jets qu’il effectuera avec une Compétence de ce groupe ET l’Attribut Majeur correspondant, il gagnera un bonus de 1 sur son jet. Par exemple : donner un coup d'épée (Physique + Combat), négocier le prix d’un objet (Social + Communication), etc. Ce bonus ne s'applique pas si le jet met en cause un Attribut et une Compétence de catégorie différente (Mental + Combat ou Manuel + Combat, par exemple). Cette Habileté reconnue peut s'appliquer aux Disciplines de magie, auquel cas, chacune se voit gratifiée d’un bonus de 1 au jet.\nCet Avantage ne peut être choisi qu’une seule fois.",
    cost: [5],
    type: AdvantageType.ancien,
    requireDetails: true,
  ),
  objetDePredilection(
    title: 'Object de prédilection',
    description: "Le personnage possède un objet de prédilection (il ne peut pas s’agir d’une arme). Le personnage gagne un bonus de 2 à chaque fois qu’il utilise cet objet. Si l’objet est perdu, volé ou détruit, le personnage perd définitivement cet Avantage.\nCet Avantage ne peut être choisi qu’une seule fois.",
    cost: [3],
    type: AdvantageType.ancien,
    requireDetails: true,
  ),
  techniquePersonnelle(
    title: 'Technique personnelle',
    description: "Grâce à cet Avantage, le personnage a développé une technique totalement inédite. Cette technique est applicable au combat, à l'artisanat, à la magie, à la diplomatie, etc. Le personnage peut choisir d’utiliser différemment ses Points de Maîtrise. En annonçant AVANT son jet cette dépense, il peut dépenser 3 points pour obtenir un NR automatique qu’il pourra faire valoir si son jet est, bien sûr, réussi. Le personnage peut toujours utiliser ses Points de Maîtrise non utilisés par ce biais de façon conventionnelle. Par exemple, Yhunn, légendaire Maître de la caste des combattants, utilise sa technique personnelle. Son Attribut Physique est de 9, sa Compétence d’Armes tranchantes est de 15 et il a 10 Points de Maîtrise. Son score de base est de 9 + 15 soit 24. La Difficulté est de 15 mais il veut impressionner son adversaire. Il dépense donc 1 Point de Maîtrise pour arriver à 25 et en dépense 9 autres pour obtenir trois NR automatiques. Il obtient un 6 sur son jet de dé. Son score final est de 31. Il obtient ainsi trois NR grâce à son jet auxquels il ajoute les trois NR automatiques. Il arrive à un impressionnant résultat final de six NR.\nCet Avantage ne peut être sélectionné qu'une fois.",
    cost: [5],
    type: AdvantageType.ancien,
    requireDetails: true,
  )
  ;

  final String title;
  final String description;
  final List<int> cost;
  final AdvantageType type;
  final bool requireDetails;
  final List<Caste> reservedCastes;

  const Advantage({
    required this.title,
    required this.description,
    required this.cost,
    required this.type,
    this.requireDetails = false,
    this.reservedCastes = const <Caste>[],
  });
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CharacterAdvantage {
  CharacterAdvantage({
    required this.advantage,
    required this.cost,
    required this.details,
  });

  final Advantage advantage;
  final int cost;
  final String details;

  factory CharacterAdvantage.fromJson(Map<String, dynamic> json) => _$CharacterAdvantageFromJson(json);
  Map<String, dynamic> toJson() => _$CharacterAdvantageToJson(this);
}

enum Tendency {
  dragon,
  human,
  fatality,
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TendencyAttribute {
  TendencyAttribute({ required this.value, required this.circles });

  int value;
  int circles;

  factory TendencyAttribute.fromJson(Map<String, dynamic> json) => _$TendencyAttributeFromJson(json);
  Map<String, dynamic> toJson() => _$TendencyAttributeToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CharacterTendencies {
  CharacterTendencies.empty()
    : dragon = TendencyAttribute(value: 0, circles: 0),
      human = TendencyAttribute(value: 0, circles: 0),
      fatality = TendencyAttribute(value: 0, circles: 0);

  CharacterTendencies({
    required this.dragon,
    required this.human,
    required this.fatality,
  });

  TendencyAttribute dragon;
  TendencyAttribute human;
  TendencyAttribute fatality;

  factory CharacterTendencies.fromJson(Map<String, dynamic> json) => _$CharacterTendenciesFromJson(json);
  Map<String, dynamic> toJson() => _$CharacterTendenciesToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class HumanCharacter extends EntityBase with MagicUser {
  HumanCharacter(
      {
        super.uuid,
        super.location = ObjectLocation.memory,
        required super.name,
        super.initiative,
        super.injuryProvider = humanCharacterDefaultInjuries,
        super.size,
        super.description,
        super.image,
        super.icon,
        this.caste = Caste.sansCaste,
        this.casteStatus = CasteStatus.none,
        this.career,
        this.luck = 0,
        this.proficiency = 0,
        this.renown = 0,
        this.age = 25,
        this.height = 1.7,
        this.weight = 60.0,
        Place? origin,
        List<CasteInterdict>? interdicts,
        List<CharacterCastePrivilege>? castePrivileges,
        List<CharacterDisadvantage>? disadvantages,
        List<CharacterAdvantage>? advantages,
        CharacterTendencies? tendencies,
      })
    : origin = origin ?? Place.byId('empireDeSolyr')!,
      interdicts = interdicts ?? <CasteInterdict>[],
      castePrivileges = castePrivileges ?? <CharacterCastePrivilege>[],
      disadvantages = disadvantages ?? <CharacterDisadvantage>[],
      advantages = advantages ?? <CharacterAdvantage>[],
      tendencies = tendencies ?? CharacterTendencies.empty()
  {
    _initialize();
  }

  Caste caste;
  CasteStatus casteStatus;
  @JsonKey(defaultValue: null)
    Career? career;
  int age;
  double height;
  double weight;
  Place origin;
  int luck;
  int proficiency;
  int renown;
  @JsonKey(defaultValue: <CasteInterdict>[])
    List<CasteInterdict> interdicts;
  @JsonKey(defaultValue: <CharacterCastePrivilege>[])
    List<CharacterCastePrivilege> castePrivileges;
  List<CharacterDisadvantage> disadvantages;
  List<CharacterAdvantage> advantages;
  CharacterTendencies tendencies;

  static bool _staticInitialized = false;
  static late final Weapon _naturalWeaponFists;
  static late final Weapon _naturalWeaponFeet;

  void _initialize() {
    _initializeStatic();

    addNaturalWeapon(WeaponRange.contact, _naturalWeaponFists);
    addNaturalWeapon(WeaponRange.contact, _naturalWeaponFeet);
  }

  static void _initializeStatic() {
    if(_staticInitialized) return;
    _staticInitialized = true;

    var contactRange = AttributeBasedCalculator(
        static: 0.4,
        multiply: 1,
        add: 0,
        dice: 0);

    var sk = SpecializedSkill.create(
        'corpsACorps:naturalWeaponFists',
        Skill.corpsACorps,
        title: 'Coup de poing');
    var wm = WeaponModel(
        name: 'Poings',
        id: 'poings',
        skill: sk,
        weight: 0.0,
        bodyPart: EquipableItemBodyPart.hand,
        hands: 0,
        requirements: [],
        initiative: {
          WeaponRange.contact: 2,
          WeaponRange.melee: 0,
        },
        damage: AttributeBasedCalculator(
          static: 0.0,
          multiply: 1,
          add: 0,
          dice: 1
        ),
        rangeEffective: contactRange,
        rangeMax: contactRange);
    _naturalWeaponFists = wm.instantiate();

    sk = SpecializedSkill.create(
        'corpsACorps:naturalWeaponFeet',
        Skill.corpsACorps,
        title: 'Coup de pied');
    wm = WeaponModel(
        name: 'Pieds',
        id: 'pieds',
        skill: sk,
        weight: 0.0,
        bodyPart: EquipableItemBodyPart.feet,
        hands: 0,
        requirements: [],
        initiative: {
          WeaponRange.contact: 2,
          WeaponRange.melee: 0,
        },
        damage: AttributeBasedCalculator(
            static: 0.0,
            multiply: 1,
            add: 2,
            dice: 1
        ),
        rangeEffective: contactRange,
        rangeMax: contactRange);
    _naturalWeaponFeet = wm.instantiate();
  }

  @override
  void saveNonExportableJson(Map<String, dynamic> json) {
    super.saveNonExportableJson(json);

    json['magic_skills'] = Map<String, int>.fromEntries(
      MagicSkill.values.map(
        (MagicSkill s) => MapEntry<String, int>(s.name, magicSkill(s))
      )
    );

    json['magic_spheres'] = Map<String, int>.fromEntries(
      MagicSphere.values.map(
        (MagicSphere s) => MapEntry<String, int>(s.name, magicSphere(s))
      )
    );

    json['magic_sphere_pools'] = Map<String, int>.fromEntries(
        MagicSphere.values.map(
                (MagicSphere s) => MapEntry<String, int>(s.name, magicSpherePool(s))
        )
    );
  }

  @override
  void loadNonRestorableJson(Map<String, dynamic> json) {
    super.loadNonRestorableJson(json);

    if(json.containsKey('magic_skills') && json['magic_skills']! is Map) {
      for(var s in json['magic_skills']!.keys) {
        setMagicSkill(MagicSkill.values.byName(s), json['magic_skills']![s]!);
      }
    }

    if(json.containsKey('magic_spheres') && json['magic_spheres']! is Map) {
      for(var s in json['magic_spheres']!.keys) {
        setMagicSphere(MagicSphere.values.byName(s), json['magic_spheres']![s]!);
      }
    }

    if(json.containsKey('magic_sphere_pools') && json['magic_sphere_pools']! is Map) {
      for(var s in json['magic_sphere_pools']!.keys) {
        setMagicSpherePool(MagicSphere.values.byName(s), json['magic_sphere_pools']![s]!);
      }
    }
  }

  @override
  Map<String, dynamic> toJson() {
    var j = _$HumanCharacterToJson(this);
    saveNonExportableJson(j);
    return j;
  }

  factory HumanCharacter.fromJson(Map<String, dynamic> json) {
    HumanCharacter c = _$HumanCharacterFromJson(json);
    c.loadNonRestorableJson(json);
    return c;
  }
}

InjuryManager humanCharacterDefaultInjuries(EntityBase? entity, InjuryManager? source) =>
    InjuryManager.simple(injuredCeiling: 40, injuredCount: 3, deathCount: 1, source: source);

InjuryManager fullCharacterDefaultInjuries(EntityBase? entity, InjuryManager? source) {
  if(entity == null) return humanCharacterDefaultInjuries(entity, source);

  return InjuryManager.getInjuryManagerForAbilities(
    resistance: entity.ability(Ability.resistance),
    volonte: entity.ability(Ability.volonte),
    source: source,
  );
}
