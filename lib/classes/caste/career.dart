import '../character/advantages.dart';
import '../character/tendencies.dart';
import '../entity/abilities.dart';
import '../entity/attributes.dart';
import '../entity/requirements.dart';
import '../entity/skill.dart';
import '../entity/skill_family.dart';
import '../magic.dart';
import 'base.dart';
import 'interdicts.dart';
import 'privileges.dart';

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
    castes: [Caste.artisan, Caste.artisanNoir],
    title: "L'alchimiste",
    motto: "Chaque ingrédient est appelé à faire partie d'un tout",
    motivations: "Expérimenter, mélanger, concevoir",
    description: "Cette voie regroupe les verriers et les alchimistes. Ils se séparent ensuite en deux groupes aux attributions spécifiques. D’un côté, on peut trouver les artisans spécialisés dans la préparation de produits destinés à la guerre - liquides inflammables, produits fumigènes, boules de verre contenant divers produits empoisonnés ou explosifs. De l’autre, on compte les artisans qui travaillent à des produits civils - teintures, peintures, verres, vitres, etc. - ou destinés à des applications médicales. Cette voie comprend de nombreux sympathisants de la cause humaniste.",
    interdict: CareerInterdict(
      title: "Tu ne corrompras pas les éléments fondamentaux" ,
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Les secrets de la matière',
      description: "Grâce à ses connaissances alchimiques, le personnage peut substituer poudres et distillations aux ingrédients et aux Clés magiques en vue de produire des effets comparables à ceux d’un sortilège. Pour chaque niveau de Statut, il peut créer des poudres et des substances capables de provoquer les mêmes effets qu’un sortilège d’un niveau de Sorcellerie. Ainsi, au troisième Statut, le personnage peut “lancer” trois sorts de premier niveau, un du second et un du premier, un du troisième, etc. Le personnage doit cependant étudier ces sortilèges et être instruit par un mage les possédant. Chaque fois qu’il atteint un Statut supérieur, il peut librement choisir d’apprendre de nouveaux sorts et d’oublier ou de conserver certains anciens.\nLes jets de magie s’effectuent avec Manuel + Alchimie, mais le personnage devant préparer ses poudres auparavant, aucun “Point de Magie” n’est nécessaire.",
    ),
    specialization: "Matières premières",
    requirements: [
      ProficiencyMinRequirement(min: 4),
      SingleSkillMinRequirement(skill: Skill.matieresPremieres, min: 6),
      SingleSkillMinRequirement(skill: Skill.alchimie, min: 6),
      SingleSkillAnyImplementationMinRequirement(skill: Skill.artisanat, min: 4, count: 3),
    ]
  ),
  architecte(
    castes: [Caste.artisan, Caste.artisanNoir],
    title: "L'architecte",
    motto: "Les distances prennent leurs mesures dans les yeux des mortels",
    motivations: "Comprendre, structurer, décrire",
    description: "La voie des architectes est double. Elle comprend la voie des concepteurs et celle des créateurs.\nLes concepteurs sont les fondateurs de la voie. Ils sont engagés pour dessiner les plans des bâtiments civils ou militaires. Au sein de cette voie, certains concepteurs se sont ainsi spécialisés dans les ouvrages militaires tels que des forteresses, tours et murs fortifiés, mais aussi des ouvrages plus temporaires tels que des tours d’assaut, béliers, palissades d’attaque, trébuchets… La plupart des autres concepteurs se sont spécialisés dans l’architecture civile et un certain nombre d’entre eux sont particulièrement réputés pour l’excellence et la magnificence de leurs ouvrages. C’est aussi au sein de cette voie que l’on peut trouver les quelques architectes maritimes qui dessinent les plans des navires marchands, civils ou militaires. Il est important de noter que cette voie semble être de plus en plus influencée par l’Humanisme.\nLa voie des créateurs regroupe les maçons, les terrassiers, les menuisiers et les charpentiers. En bref, toutes les professions travaillant de près ou de loin à la construction de bâtiments. Il existe des règles hiérarchiques tacites entre ces différentes professions. C’est ainsi que, sur un chantier, la parole d’un charpentier aura plus de poids que celle d’un maçon, qui pourra lui-même donner des ordres à un terrassier.",
    interdict: CareerInterdict(
      title: "Tu n'entreprendras rien sans préparation",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'esquisse",
      description: "Grâce à ce Bénéfice, le personnage peut effectuer un jet de Mental + Plans + niveau de Statut contre une Difficulté de 15 - augmentée ou réduite de 5, en fonction de la situation - pour dresser une esquisse de n'importe quelle construction à venir. Chaque Niveau de Réussite obtenu sur ce jet réduit de 5 la Difficulté du jet d’Artisanat ou de fabrication à suivre, que ce soit le personnage ou un autre qui l’effectue. Il n’est possible de réduire ainsi la Difficulté que de 5 par niveau de Statut du personnage.",
    ),
    specialization: "Plans (Spécialisation de Cartographie)",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.mental, min: 6),
      SingleSkillMinRequirement(skill: Skill.cartographie, min: 6),
      SingleSkillMinRequirement(skill: Skill.lireEtEcrire, min: 5),
      SkillAttributeTotalPointsRequirement(attribute: Attribute.mental, min: 20),
    ]
  ),
  artisanElementaire(
    castes: [Caste.artisan, Caste.artisanNoir],
    title: "L'artisan élémentaire",
    motto: "La beauté de la matière transcende les carcans de l'esprit",
    motivations: "Ressentir, canaliser, innover",
    description: "Cette voie est très peu connue du grand public. Les artisans élémentaires sont des Maîtres capables de modeler les éléments par la seule force de leur volonté. Après avoir été élèves d’autres voies durant de longues années, les adeptes de cette voie suivent un entraînement auprès de Kezyr lui-même. On raconte que ces artisans sont capables de modifier de manière permanente la nature de l’air (on raconte ainsi que dans un palais merveilleux, l’air de chaque pièce produit une émotion différente sur les visiteurs ; on parle aussi d’une forteresse en ruine où l’air est chargé de poison et de peur), la forme du métal ou des minéraux, la nature de l’eau (qui devient susceptible de provoquer des émotions) ou de contrôler le feu. Cette voie n’est accessible qu’à des Maîtres Artisans et seul Kezyr peut décider de leur donner le pouvoir de façonner les éléments. Ils sont bien évidemment tous de farouches défenseurs de la voie draconique.",
    interdict: CareerInterdict(
      title: "Tu resteras en harmonie avec les énergies fondamentales",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'écheveau élémentaire",
      description: "Le personnage devient capable de modeler une matière à mains nues. Si la matière est dangereuse (lave, verre en fusion, métal porté au rouge), il doit dépenser un point de magie (de sa Réserve ou de la Sphère concernée par la matière) pour ne pas en subir les effets. Cette immunité ne le protège pas contre les sorts mais peut s’appliquer à certains de leurs effets résultants (lave, eau bouillante) tant que le personnage dépense des points de magie. Lorsqu’il travaille la matière de cette façon, il utilise sa Compétence d’Artisanat élémentaire avec un bonus égal à la moitié de sa Sphère concernée (arrondi au supérieur), comme Nature pour le bois ou Pierre pour le marbre.",
    ),
    specialization: "Artisanat élémentaire (une matière)",
    requirements: [
      AbilityMinRequirement(ability: Ability.empathie, min: 7),
      AbilityMinRequirement(ability: Ability.volonte, min: 6),
      ProficiencyMinRequirement(min: 5),
      SingleSkillAnyImplementationMinRequirement(skill: Skill.donArtistique, min: 5, count: 2),
      MagicSphereAnyMinRequirement(min: 5),
    ]
  ),
  forgeron(
    castes: [Caste.artisan, Caste.artisanNoir],
    title: 'Le forgeron',
    motto: "La perfection n'est pas de ce monde",
    motivations: "Concevoir, façonner, peaufiner",
    description: "La carrière des artisans du métal est la plus prestigieuse qui soit. Ils obéissent consciencieusement aux règles édictées par Kezyr.\nCette voie regroupe tous les artisans du métal, qu’ils soient armuriers ou simples forgerons de village. C’est au sein de cette voie que l’on retrouve certains des plus grands enchanteurs de la caste - ces derniers forment un groupe prestigieux : les reliquaires. Ce sont eux qui sont responsables des contacts avec les autres castes afin de pouvoir rassembler les talents pour obtenir des enchantements particulièrement puissants. Traditionnellement, Kezyr est plus particulièrement associé à ces manipulateurs du métal et il est vrai que la plupart des Élus de dragons de Kezyr appartiennent à cette voie. Elle reste très traditionaliste et c’est parmi ses membres que l’on peut compter le plus grand nombre d’Élus.",
    interdict: CareerInterdict(
      title: 'Tu ne tiendras aucune œuvre pour parfaite',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'La beauté du geste',
      description: "Chaque fois qu’il réussit un jet de Forge, le personnage gagne automatiquement 1 Niveau de Réussite par niveau de Statut. Le résultat de son jet n’est pas modifié par ces Niveaux gratuits, mais ces derniers s’ajoutent à ceux déjà obtenus pour déterminer la qualité de l'objet.",
    ),
    specialization: "Forge. Le personnage doit se spécialiser dans une catégorie d'objets forgés",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.manuel, min: 6),
      AbilityMinRequirement(ability: Ability.force, min: 6),
      ProficiencyMinRequirement(min: 6),
      SingleSkillImplementationMinRequirement(skill: Skill.artisanat, implementation: "Forge", min: 7),
      SingleSkillAnyImplementationMinRequirement(skill: Skill.donArtistique, min: 3, comment: "en rapport avec le métal"),
    ]
  ),
  gardeMetallique(
    castes: [Caste.combattant, Caste.protecteur],
    isStandard: false,
    title: 'Garde métallique',
    motto: "L'esprit ne fait qu'un avec la lame : vif et affûté",
    motivations: "Protéger, servir, vaincre",
    description: "",
    interdict: CareerInterdict(
      title: 'Tu tempèreras ta colère',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Incarnat du métal',
      description: "Le personnage a réussi l'épreuve secrète du Creuset élémentaire. Sa peau s'est épaissie et une couche de métal souple comme le cuir court désormais entre ses muscles et son épiderme (armure naturelle de 14). Il entretient un lien élémentaire intuitif avec les énergies du métal et va acquérir rapidement une empathie colossale avec la Sphère du métal (elle devient Réservée et Spécialisée). Ce lien régénère immédiatement sa peau de métal (pas de baisse de l'Indice de protection en cas de perforation) et lui octroie une endurance surnaturelle (+1 en Résistance).",
    ),
    specialization: "Sphère du Métal (considérée comme Réservée)",
    requirements: [
      OneOfRequirements(
        requirements: [
          CasteMemberRequirement(caste: Caste.combattant, status: CasteStatus.expert),
          CasteMemberRequirement(caste: Caste.protecteur, status: CasteStatus.expert),
        ]
      ),
      TendencyMinRequirement(tendency: Tendency.human, min: 1),
      TendencyMinRequirement(tendency: Tendency.dragon, min: 3),
      WeaponSkillsMinRequirement(min: 10),
      SimpleDescriptionRequirement("Plusieurs fait d'arme notable en faveur de la caste des Artisans"),
      SimpleDescriptionRequirement("Le patronage d'au moins un dragon du Métal Adulte ou de plusieurs Artisans (15 niveaux de Statut cumulés)"),
    ],
  ),
  mecaniste(
    castes: [Caste.artisan, Caste.artisanNoir],
    title: 'Le mécaniste',
    motto: "L'appel du progrès ne peut souffrir d'aucune entrave",
    motivations: "Créer, modifier, améliorer",
    description: "Cette voie regroupe les artisans qui se sont spécialisés dans la construction de mécaniques plus ou moins complexes. On peut y trouver des artisans spécialisés dans la construction de structures destinées à aider aux travaux lourds - systèmes de grues et de poulies souvent utilisés par les architectes.\nCette voie est cependant surtout connue pour ses artisans spécialisés dans l’élaboration de petits mécanismes de précision. Leurs horloges et sabliers, qui font fureur auprès des plus riches habitants des grandes villes civilisées, mais aussi leurs automates, sont aussi prisés des nobles que proscrits par les dragons et les conservateurs.\nIl est important de noter que la plupart des artisans de cette voie sont des sympathisants humanistes. Ils sont aussi pourchassés et emprisonnés dans certains royaumes particulièrement traditionalistes - n’espérez pas trouver un horloger à Kern ou dans l’Empire Zûl…",
    interdict: CareerInterdict(
      title: "Tu n'auras d'autre but que l'évolution",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'La liberté de pensée',
      description: "Le personnage peut utiliser de la Maîtrise APRES un jet et peut obtenir des NR par cet usage. Il ne peut pas cumuler une dépense de Chance et de Maîtrise. De plus, il ajoute son niveau de Statut à sa Tendance Homme pour calculer le niveau maximal des compétences y faisant référence.\nNote: Les mécanistes sont surveillés de près par leurs Parfaits et, dans une moindre mesure, les érudits, ce qui explique leurs obligations de Tendance afin qu’ils ne sombrent pas dans l’Humanisme…",
    ),
    specialization: "Mécanismes",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.manuel, min: 6),
      ProficiencyMinRequirement(min: 6),
      SingleSkillMinRequirement(skill: Skill.mecanismes, min: 5),
      TendencyMinRequirement(tendency: Tendency.dragon, min: 2),
    ]
  ),
  mineur(
    castes: [Caste.artisan, Caste.artisanNoir],
    title: 'Le mineur',
    motto: "Tous les fruits de la terre se doivent d'être cueillis",
    motivations: "Explorer, analyser, répertorier",
    description: "Cette voie regroupe deux types d'artisans : les fouisseurs et les “termites”.\nLes fouisseurs sont les artisans chargés de récupérer les minerais rares au cœur de la terre. Ils travaillent généralement en accord avec les concepteurs, qui dessinent les plans des mines, ainsi qu’avec les érudits, qui guident les zones de fouilles. C’est aussi parmi les fouisseurs que l’on peut trouver quelques artisans spécialisés dans l’excavation de reliques des Temps Anciens.\nLes “termites” se sont spécialisés dans la destruction des bâtiments et tout particulièrement dans l’éradication des constructions militaires. Ils comptent des sapeurs, qui creusent des tunnels destinés à faire s'effondrer les murailles des forteresses, des artificiers, qui utilisent les trouvailles des alchimistes pour miner les bâtiments. Une très forte rivalité oppose les “termites” aux architectes spécialisés dans l’édification de constructions militaires.",
    interdict: CareerInterdict(
      title: "Tu ne souilleras pas le corps de l'Être Primordial",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Le diamant brut',
      description: "Ce Bénéfice offre au personnage une faculté par niveau de Statut. Au premier, il lui permet de déterminer à 10% près la profondeur ou l'altitude à laquelle il se trouve. Au second, le personnage peut réduire de 5 la Difficulté de tous ses jets d’orientation en milieu montagneux - et de 10 en milieu souterrain. Au troisième, il peut déterminer sans risque d’erreur la nature exacte de n’importe quelle substance minérale. Au quatrième, il peut extraire à mains nues n’importe quel objet ou minerai enchâssé dans la roche. Enfin, au cinquième, il gagne - ou développe gratuitement - un niveau égal à sa Tendance Dragon dans la Sphère de la Pierre.",
    ),
    specialization: "Matières premières (un minéral ou un métal)",
    requirements: [
      AbilityMinRequirement(ability: Ability.force, min: 5),
      AbilityMinRequirement(ability: Ability.coordination, min: 5),
      ProficiencyMinRequirement(min: 6),
      SingleSkillImplementationMinRequirement(skill: Skill.survie, implementation: "Sous-sol", min: 5),
      SingleSkillImplementationMinRequirement(skill: Skill.artisanat, implementation: "Terrassement", min: 7),
    ]
  ),
  orfevre(
    castes: [Caste.artisan, Caste.artisanNoir],
    title: "L'orfèvre",
    motto: "Les mains peuvent façonner tout ce qu'un cœur peut comprendre",
    motivations: "Ciseler, magnifier, embellir",
    description: "Cette voie regroupe les joailliers, les tailleurs de gemmes, les orfèvres… Les artisans de cette voie comptent certains des artistes les plus recherchés de tout Kor. Ils sont choyés par les nobles, mais aussi par les membres de toutes les autres castes. En effet, ce sont les membres de cette voie qui conçoivent la plupart des décorations de rang et de caste. Il est intéressant de noter qu’une grande partie des tailleurs de gemmes sont aussi des mages spécialisés dans les enchantements. Les orfèvres entretiennent des contacts privilégiés avec les horlogers et sont donc assez proches de la tendance humaniste. Les autres professions de cette voie sont cependant généralement très traditionalistes.",
    interdict: CareerInterdict(
      title: 'Tu honoreras ta caste par ton talent',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'La source de beauté',
      description: "En puisant dans l’énergie des bijoux et des gemmes, le personnage peut se ressourcer et regagner des Points de Maîtrise - pour les premiers - ou de Magie d’une Sphère - pour les seconds. Il lui suffit de serrer l’objet dans ses mains pour récupérer en quelques secondes un nombre de points égal à son niveau de Statut. Ce Bénéfice n’est utilisable qu’une fois par jour et le meneur de jeu se réserve le droit de limiter le nombre de points ainsi conférés, en fonction de la nature ou de la “valeur” de la source.",
    ),
    specialization: "Artisanat : Joaillerie (une pierre précieuse ou un métal précieux)",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.manuel, min: 7),
      AbilityMinRequirement(ability: Ability.coordination, min: 7),
      ProficiencyMinRequirement(min: 6),
      SingleSkillImplementationMinRequirement(skill: Skill.artisanat, implementation: "Joaillerie", min: 7),
    ]
  ),
  tisserand(
    castes: [Caste.artisan, Caste.artisanNoir],
    title: 'Le tisserand',
    motto: "Nous sommes les forgerons de l'apparence",
    motivations: "Parer, sublimer, respecter",
    description: "La voie des tisserands est celle qui regroupe le plus grand nombre de membres. Cette voie comprend les tanneurs, les couturiers, les tisserands et toutes les professions liées à la confection de tissus.\nQuelques artisans se sont illustrés en créant des vêtements enchantés et dotés de capacités extraordinaires. Certains de ces tissus sont ainsi connus pour être indéchirables, d’autres sont parfaitement imperméables, d’autres sont ininflammables ou calorifères… Ce sont les membres de cette caste qui conçoivent et réalisent les tenues cérémonielles de la plupart des autres castes. Ils sont généralement assez traditionalistes.",
    interdict: CareerInterdict(
      title: "Tu magnifieras les traditions",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'La fibre de la vie',
      description: "En touchant n'importe quelle matière textile manufacturée, le personnage est capable de déterminer instinctivement un nombre d’informations - origine d’un vêtement, sexe du porteur, climats traversés, etc. - égal à son niveau de Statut. Aucun jet n’est nécessaire.",
    ),
    specialization: "Artisanat : Couture (un type de produit en tissu)",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.manuel, min: 6),
      AbilityMinRequirement(ability: Ability.perception, min: 6),
      AbilityMinRequirement(ability: Ability.coordination, min: 6),
      SingleSkillImplementationMinRequirement(skill: Skill.artisanat, implementation: "Couture", min: 7),
      SingleSkillAnyImplementationMinRequirement(skill: Skill.donArtistique, min: 4, comment: "en rapport avec le tissu"),
    ]
  ),

  aventurier(
    castes: [Caste.combattant, Caste.combattantNoir],
    title: "L'aventurier",
    motto: "Va où le vent porte ton bras",
    motivations: "Découverte, danger, imprévu",
    description: "Les aventuriers sont des combattants solitaires qui voyagent de par le monde pour enseigner leur art du combat, mais aussi apprendre de nouvelles techniques qu’ils transmettent ensuite aux Maîtres de la caste. Ils sont les représentants de leur caste et se doivent d’en donner une image respectable. De plus en plus souvent, les aventuriers sont accompagnés de membres de la Caste des Voyageurs, avec lesquels ils ont de nombreux points communs — notamment avec les bardes de Szyl.",
    interdict: null,
    benefit: CareerBenefit(
      title: "Forger l'expérience",
      description: "Â la fin de chaque aventure, le personnage gagne un nombre de Points d’Expérience supplémentaires, égal au niveau de son Statut.",
    ),
    specialization: "Au moment où il choisit cette carrière, le personnage doit développer une nouvelle Spécialisation qui ne soit pas ume Compétence Physique.",
    requirements: [
      AllOfRequirements(
        requirements: [
          TendencyMaxRequirement(tendency: Tendency.dragon, max: 3),
          TendencyMaxRequirement(tendency: Tendency.human, max: 3),
          TendencyMaxRequirement(tendency: Tendency.fatality, max: 3),
        ]
      ),
      LuckMinRequirement(min: 4),
      SingleSkillMinRequirement(skill: Skill.geographie, min: 3),
    ]
  ),
  chevalier(
    castes: [Caste.combattant, Caste.combattantNoir],
    title: 'Le chevalier',
    motto: "Que mon cœur soit le maître de mes enseignements",
    description: "Le corps des chevaliers est considéré comme un corps d'élite qui n'accepte que ceux qui ont fait preuve d’une grande valeur. Il est régi par un code très strict, fondé avant tout sur le respect de la tradition et la défense des faibles. Les chevaliers sont sélectionnés par les instructeurs au sein des autres castes. On ne peut donc en faire partie que si l’on a été remarqué. Ce sont de redoutables cavaliers - qu’ils soient montés sur des chevaux, comme dans la plupart des cas, ou sur les rares dragons qui offrent ce privilège à leurs Élus.",
    motivations: "Honneur, accomplissement",
    interdict: CareerInterdict(
      title: 'Tu feras honneur à ta caste',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Le cœur pur',
      description: "Une fois par jour, le personnage peut soigner de ses mains un nombre de Blessures égal au niveau de son Statut - et ce, quel que soit le type de Blessures. Cependant, pour chaque Blessure Grave qu’il soigne ainsi, il subit automatiquement une Égratignure ; et pour chaque Blessure Fatale, une Blessure Légère.\nDe plus, pour chaque point de Tendance Fatalité que possède le bénéficiaire de ces soins, le personnage subit automatiquement une Blessure supplémentaire, en commençant par les Égratignures.",
    ),
    specialization: "Éloquence ou Lire et écrire",
    requirements: [
      TendencyMaxRequirement(tendency: Tendency.fatality, max: 0),
      InterdictCountMinRequirement(caste: Caste.combattant, min: 2),
      SingleSkillMinRequirement(skill: Skill.equitation, min: 6),
      HasAdvantageRequirement(advantage: Advantage.droiture),
    ]
  ),
  duelliste(
    castes: [Caste.combattant, Caste.combattantNoir],
    title: 'Le duelliste',
    motto: "Accepte chaque défi, honore chaque adversaire",
    description: "Les duellistes ne vivent que pour se mesurer aux meilleurs combattants. Les conflits ne les intéressent pas. Ils vont de ville en ville pour parfaire leur maîtrise des armes et affronter les champions des différentes communautés. Les duellistes sont souvent considérés comme les théoriciens de l’art du combat, car ils mettent au point leurs propres techniques et manient des bottes, des gardes et des postures connues d’eux seuls. Nombre d’entre eux finissent leur carrière comme instructeurs.",
    motivations: "Perfection, noblesse, dépassement de soi",
    interdict: CareerInterdict(
      title: "Tu honoreras chaque adversaire",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "Briser la concentration",
      description: "Lorsqu’il combat seul un adversaire, le duelliste peut dépenser des actions en début de tour afin de réduire le nombre de dés d’Initiative de son opposant. Ces actions doivent être déclarées avant le lancement des dés d’Initiative et ne peuvent réduire l’Initiative de la cible au-dessous de 1. Ce bénéfice est utilisable autant de fois par combat que le personnage possède de degrés de Statut. Il n’est pas possible d’appliquer ce Bénéfice à plusieurs cibles au cours d’un même combat.",
    ),
    specialization: "Une Compétence de Combat permettant le duel - épées, corps à corps, lancer, armes de distance, etc.",
    requirements: [
      AbilityMinRequirement(ability: Ability.coordination, min: 7),
      ProficiencyMinRequirement(min: 6),
      WeaponSkillsMinRequirement(min: 7, count: 2),
    ]
  ),
  gladiateur(
    castes: [Caste.combattant, Caste.combattantNoir],
    title: 'Le gladiateur',
    motto: "Le noble art du combat se transmet dans le spectacle que nous offrons chaque jour",
    description: "Les gladiateurs ont fait de l’art du combat un véritable spectacle. Peu attirés par les conflits et les guerres, ils préfèrent se mesurer à d’autres gladiateurs dans une arène, sous les acclamations de la foule. Certains considèrent ce corps comme le moins noble de la Caste des Combattants, mais nombre de gladiateurs sont réputés pour la maîtrise dont ils font preuve, ainsi que pour leur sens inné du commandement.",
    motivations: "Respect, maîtrise",
    interdict: CareerInterdict(
      title: "Tu respecteras l'adversaire valeureux",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'art du combat",
      description: "Chaque fois qu’il atteint un Statut supérieur, le personnage peut choisir une attaque particulière, de corps à corps ou de combat armé, comme l’une de ses spécialités. Il gagnera automatiquement un bonus de +2 à tous ses jets d’attaque lorsqu'il utilisera l’un de ces coups spéciaux. En choisissant cette carrière, le personnage débute avec un nombre de spécialités égal au niveau de son Statut. Une fois les spécialités choisies, il est impossible d’en changer.",
    ),
    specialization: "Une Compétence d’Arme ou de Corps à corps — le personnage ne peut désormais plus utiliser aucune Compétence d’Arme de distance, excepté le filet.",
    requirements: [
      AbilityMinRequirement(ability: Ability.force, min: 7),
      AbilityMinRequirement(ability: Ability.coordination, min: 6),
      AbilityMinRequirement(ability: Ability.presence, min: 6),
      MultipleSkillsInFamilyMinRequirement(family: SkillFamily.combat, count: 2, min: 6),
    ]
  ),
  guerrier(
    castes: [Caste.combattant, Caste.combattantNoir],
    title: 'Le guerrier',
    motto: "C'est dans l'action que se découvre la valeur",
    motivations: "Maîtrise, victoire, bravoure",
    description: "Le corps des guerriers réunit une grande majorité des fidèles de Kroryn - et de ceux, nombreux également, qui ne font aucun rapport entre la Caste des Combattants et le Grand Dragon du Feu. Ils se consacrent à l’art du combat sous toutes ses formes, sans privilégier un aspect plus qu’un autre, car leur seule préoccupation est de prouver leur héroïsme. La plupart d’entre eux ne conçoit effectivement la vie qu'une arme à la main, dans la fureur des combats. Ce corps est certainement le plus éclectique qui soit — les guerriers pouvant être tour à tour mercenaires, stratèges, chevaliers ou même gladiateurs.",
    interdict: CareerInterdict(
      title: "Tu ne feras preuve d'aucune lâcheté",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'engagement du combat",
      description: "Une fois par tour de combat, le personnage peut ajouter le niveau de son Statut à la valeur de l’un de ses dés d’Initiative. L'utilisation de ce Bénéfice doit être annoncée avant l’annonce des valeurs adverses et le personnage ne peut effectuer aucune action de défense grâce à ce dé.",
    ),
    specialization: "Une compétence de Mouvement",
    requirements: [
      AbilityMinRequirement(ability: Ability.force, min: 8),
      ProficiencyMinRequirement(min: 5),
      MultipleSkillsInFamilyMinRequirement(family: SkillFamily.combat, count: 2, min: 8),
    ]
  ),
  lutteur(
    castes: [Caste.combattant, Caste.combattantNoir],
    title: 'Le lutteur',
    motto: "L'arme n'est qu'un artifice",
    motivations: "Tradition",
    description: "Ce corps est très récent, mais l’art du pugilat et de la luite fut de tous temps enseigné au sein des autres corps. Le luiteur est très proche du gladiateur, car son art est pour lui un spectacle, mais il s'en différencie par une hygiène de vie et un comportement des plus monastiques. Ce corps est exclusivement réservé aux hommes, mais quelques combattantes d’autres corps ont fait de la lutte leur spécialité, qui offre de nombreux avantages au corps à corps.",
    interdict: CareerInterdict(
      title: "Tu n'useras pas d'artifice",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "De chair et d'os",
      description: "Lorsqu'il se bat au corps à corps, le personnage peut relancer un nombre de dés de dommages égal au niveau de son Statut. Un même dé peut être relancé plusieurs fois, mais ce Bénéfice ne peut être utilisé qu’une seule fois par tour de combat.",
    ),
    specialization: "Lutte (Corps-à-corps)",
    requirements: [
      AbilityMinRequirement(ability: Ability.force, min: 7),
      AbilityMinRequirement(ability: Ability.coordination, min: 6),
      SingleSkillMinRequirement(skill: Skill.corpsACorps, min: 8),
    ]
  ),
  maitreDArmes(
    castes: [Caste.combattant, Caste.combattantNoir],
    title: "Le maître d'armes",
    motto: "Le savoir se transmet dans l'honneur et la perfection",
    motivations: "Tradition, maîtrise, partage",
    description: "Les maîtres d’armes ne vivent que pour atteindre la perfection ultime du combat et du maniement d’une arme. La plupart des instructeurs de la caste sont issus de leurs rangs. Non seulement îls ne doivent plus faire qu’un avec leur arme mais, en plus, ils sont l’incarnation des enseignements de Kroryn. Les maîtres d’armes, plus que n'importe qui, se doivent d’être des exemples. On ne leur pardonne aucune faute et pour accéder au Statut le plus élevé de leur caste, ls sont jugés par Kroryn lui-même.",
    interdict: CareerInterdict(
      title: "Tu ne manieras d'autre arme que la tienne",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "La perfection ne retient qu'un nom",
      description: "Chaque fois qu’il affronte un adversaire maniant l’arme dans laquelle il s’est spécialisée, et qu’il combat avec cette même arme, le personnage gagne un bonus à tous ses jets de combat égal au niveau de son Statut.",
    ),
    specialization: "Le Maître d’armes ne peut posséder qu’une Spécialisation en Combat, qui doit être son domaine d’instruction.",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.manuel, min: 6),
      AttributeMinRequirement(attribute: Attribute.social, min: 6),
      MultipleSkillsInFamilyMinRequirement(family: SkillFamily.combat, count: 1, min: 9),
    ]
  ),
  mercenaire(
    castes: [Caste.combattant, Caste.combattantNoir],
    title: 'Le mercenaire',
    motto: "La compétence se vend au juste prix de chaque cause",
    motivations: "Honneur, loyauté",
    description: "Les mercenaires sont entraînés pour combattre dans n’importe quelles conditions. Comme les aventuriers, ils se doivent de faire honneur à leur caste, et ne prêtent donc leur bras à une cause que si elle est compatible avec les enseignements de Kroryn. Ce sont rarement des individus solitaires. Ils préfèrent nettement se réunir au sein de compagnies aux noms prestigieux. Le plus important pour un mercenaire est donc que sa compagnie soit réputée, la renommée individuelle n'ayant que peu d’importance. Les mercenaires sont plus redoutables eu groupe.",
    interdict: CareerInterdict(
      title: 'Tu ne trahiras point',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Une cause, un bras',
      description: "Chaque matin, le personnage doit choisir l’une des trois Tendances pour guider son bras durant la journée. Ensuite, chaque fois qu’il fera appel aux Tendances et qu’il conservera le dé correspondant, il pourra ajouter le niveau de son Statut au résultat du dé — mais il gagnera également 2 Cercles de Tendance.\nCe Bénéfice ne permet pas d’obtenir une réussite critique en atteignant 10 ou plus.",
    ),
    specialization: "Une Compétence de Mouvement",
    requirements: [
      AbilityMaxRequirement(ability: Ability.empathie, max: 7),
      AllOfRequirements(
        requirements: [
          TendencyMinRequirement(tendency: Tendency.dragon, min: 1),
          TendencyMinRequirement(tendency: Tendency.human, min: 1),
          TendencyMinRequirement(tendency: Tendency.fatality, min: 1),
        ]
      ),
      WeaponSkillsMinRequirement(min: 6, count: 3),
    ]
  ),
  paladin(
    castes: [Caste.combattant, Caste.combattantNoir],
    title: 'Le paladin',
    motto: "À chaque homme son destin, à chaque vie sa quête",
    motivations: "Loyauté, bravoure",
    description: "Souvent issus du corps des chevaliers, les paladins sont passés maîtres dans l’art du combat, mais ce sont également des individus profondément mystiques. C’est le corps qui compte le moins de membres, mais chacun d’entre eux est respecté et honoré. Ils se fixent tous un objectif qui va déterminer leur ligne de conduite. Leur principale motivation est leur idéal, qui peut prendre différentes formes - bien qu’en règle générale, un paladin se montre toujours vertueux, franc, droit et honnête. Certains se consacrent entièrement à la lutte contre le Fatalisme où l’Humanisme, d’autres, pour des raisons souvent personnelles, choisissent de défendre la justice et de rétablir la vérité.",
    interdict: CareerInterdict(
      title: 'Tu protégeras la vie',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Nulle place au doute',
      description: "Lorsqu’il affronte un adversaire possédant des points dans la Tendance qui lui est Opposée, le personnage peut choisir de gagner un bonus à tous à tous ses jets d’attaque ou d’infliger un malus à tous les jets de défense de son adversaire. Ce modificateur est égal à son Statut + valeur de la Tendance Opposée de son adversaire. Le personnage doit choisir la façon dont il utilise ce Bénéfice au début du premier tour de combat et ne peut plus en changer tant qu’il s’agit du même adversaire.",
    ),
    specialization: "Histoire ou Connaissance des dragons",
    requirements: [
      OneOfRequirements(
        requirements: [
          TendencyMaxRequirement(tendency: Tendency.human, max: 0),
          TendencyMaxRequirement(tendency: Tendency.fatality, max: 0),
        ]
      ),
      HasNoDraconicLinkRequirement(),
    ]
  ),
  strategeCombattant(
    castes: [Caste.combattant, Caste.combattantNoir],
    title: 'Le stratège',
    motto: "Un simple mot peut conduire cent mille hommes à la mort, ou à la victoire",
    motivations: "Respect, justesse",
    description: "Théoriciens de l’art de la guerre, les stratèges forment un corps à part dans la Caste des Combattants. En effet, il n’est nul besoin d'être un redoutable combattant pour en faire partie, même si de nombreux guerriers prestigieux ont un jour choisi cette voie. Le stratège, comme son nom l’indique, s'occupe de tactique et de stratégie. Il se doit de connaître la mentalité des combattants et la manière dont ils voient les choses. C’est pour cela qu’avant d’étudier la stratégie, ces individus passent souvent quelques années au sein des autres corps.",
    interdict: CareerInterdict(
      title: "Tu respecteras l'adversaire valeureux",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "La voie d'une armée",
      description: "Avant le premier tour de chaque combat, le personnage peut effectuer un jet de Mental + Stratégie contre une Difficulté de 5 pour conférer un bonus, égal au nombre de Niveaux de Réussite + 1, à un nombre de compagnons égal au niveau de son Statut. Ce bonus peut être utilisé pour augmenter n'importe quel jet d’attaque ou d’Initiative durant le tour. S'il n’est pas utilisé, il disparaît, mais le personnage peut effectuer ce jet au début de chaque tour - s’il choisit de n’effectuer aucune autre action. Le personnage doit être à portée de voix et de vue de ses compagnons pour utiliser ce Bénéfice. S'il est attaqué, la Difficulté de tous ses jets de défense est augmentée de 5.",
    ),
    specialization: "Stratégie ou Commandement",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.mental, min: 6),
      AbilityMinRequirement(ability: Ability.intelligence, min: 7),
      ProficiencyMinRequirement(min: 5),
      SingleSkillMinRequirement(skill: Skill.strategie, min: 7),
    ]
  ),

  courtisane(
    castes: [Caste.commercant, Caste.commercantNoir],
    title: 'La courtisane',
    motto: "Le charme est la clé de bien des portes",
    motivations: "Séduire, duper, abuser",
    description: "Afin d’assurer leur présence au sein des différents réseaux d’information et renforcer leur action au sein des cités, les guildes de voleurs, de diplomates et d’espions ont développé une nouvelle carrière - majoritairement réservée aux femmes. Les confidences sur l’oreiller ont toujours su ouvrir de nombreuses perspectives, tant du point de vue des “coups” à monter que des informations à négocier. À l'inverse des prostituées, qui ne fréquentent que les salles embrumées des auberges et les rues de la cité, les courtisanes se prélassent dans le luxe et le confort des palais des puissants. Spécialement entraînées à la politique, à la pensée militaire et aux technologies, mêmes interdites, les courtisanes se révèlent des interlocutrices difficiles à manipuler et des espionnes hors pair.",
    interdict: CareerInterdict(
      title: 'Tu ne renieras pas ta condition',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Le sourire',
      description: "Une fois par jour par degré de statut, le personnage peut influencer le résultat de toute action en forçant un individu à conserver un autre dé que celui qu'il désire lorsqu'il utilise les Tendances. La victime gagne les points de Tendance découlant de ce choix comme si c'était le sien. Si cette dernière ne fait pas appel aux Tendances, le dé neutre peut devenir le dé d'une des trois Tendances et agir comme tel en ce qui concerne l'évolution des Tendances. Ce Bénéfice peut être utilisé lors de n'importe quelle action se déroulant autour du personnage, à partir du moment où ce dernier est en mesure de parler, séduire, distraire ou capter le regard de sa cible afin de la perturber.\nNote: Le comptoir marchand du Bénéfice de 2e Statut est remplacé par un boudoir isolé et quelques servantes.",
    ),
    specialization: "Séduction",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.social, min: 6),
      AbilityMinRequirement(ability: Ability.presence, min: 7),
      SingleSkillMinRequirement(skill: Skill.seduction, min: 6),
      SingleSkillMinRequirement(skill: Skill.psychologie, min: 4),
      SingleSkillAnyImplementationMinRequirement(skill: Skill.donArtistique, min: 5),
      SingleSkillAnyImplementationMinRequirement(skill: Skill.artDeLaScene, min: 4),
      AbilityMaxRequirement(ability: Ability.empathie, max: 8),
    ],
  ),
  diplomate(
    castes: [Caste.commercant, Caste.commercantNoir],
    title: 'Le diplomate',
    motto: "Tout conflit humain possède une solution humaine",
    motivations: "Analyser, intercéder, résoudre",
    description: "Le diplomate vend son aisance verbale et son érudition à des fins pacifistes. Il est un artisan essentiel de paix aussi bien entre organisations politiques - royaumes, contrées - qu’économiques - structures commerciales, guildes - ou sociales - castes. Les temps sont à la crise et nombre de diplomates sont les cibles privilégiées d’attentats.",
    interdict: CareerInterdict(
      title: 'Tu ne laisseras aucune situation tendre verse le meurtre',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Les mots justes',
      description: "Ce Bénéfice à l'utilisation double permet au personnage de disposer, chaque jour, d'un nombre de Niveaux de Réussite gratuits égal à son niveau de Statut. Ces Niveaux peuvent être dépensés pour augmenter la réussite de n'importe quel jet de Social déjà réussi par le personnage. De plus, le personnage est immunisé contre tous les effets susceptibles de modifier la Difficulté d'un jet ou le choix d'un dé lorsqu'il annonce le dé de l'Homme en faisant appel aux Tendances.\n Note: Le comptoir marchand du Bénéfice de 2e Statut est remplacé par une maison et un scribe qualifié.",
    ),
    specialization: "Diplomatie",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.social, min: 6),
      AbilityMinRequirement(ability: Ability.perception, min: 6),
      AbilityMinRequirement(ability: Ability.intelligence, min: 6),
      SingleSkillMinRequirement(skill: Skill.psychologie, min: 6),
      SingleSkillMinRequirement(skill: Skill.vieEnCite, min: 4),
      TendencyCirclesMinRequirement(tendency: Tendency.dragon, min: 5),
      TendencyCirclesMinRequirement(tendency: Tendency.human, min: 5),
      TendencyCirclesMinRequirement(tendency: Tendency.fatality, min: 5),
    ],
  ),
  espion(
    castes: [Caste.commercant, Caste.commercantNoir],
    title: "L'espion",
    motto: "Aucune ombre n'obscurcit complètement le regard",
    motivations: "Chercher, découvrir, mémoriser",
    description: "Cette carrière fascinante n’est en fait embrassée que par peu de citoyens, car les sacrifices à faire sont énormes - perte des liens familiaux, voyages fréquents, etc. Les espions servent des intérêts aussi bien politiques que commerciaux ou technologiques. De même, toujours en vue de respecter les préceptes de Khy, ils ne s’attacheront jamais à vie à une seule contrée. Il n’est d’ailleurs pas rare que certains d’entre eux travaillent simultanément pour plusieurs royaumes. Enfin, l’espion est un homme d’action qui ne rechigne pas à éliminer ou détruire si cela s’avère nécessaire.",
    interdict: CareerInterdict(
      title: 'Tu ne trahiras pas tes secrets',
      description: "",
    ),
    benefit: CareerBenefit(
      title: "Le manteau d'ombre",
      description: "Chaque fois qu'il fait appel aux Tendances lors d'un jet impliquant l'Attribut Manuel, Physique ou Social pour réaliser une action de discrétion, de perception, d'investigation ou de mensonge, le personnage peut relancer une fois le dé de l'Homme. Il peut ensuite décider de conserver ce nouveau résultat, de conserver un autre dé ou relancer une fois de plus le dé de l'Homme. Ce Bénéfice peut être utilisé une fois par jour par niveau de Statut du personnage. L'espion ne gagne aucun Point de Tendance s'il conserve un autre dé après avoir relancé celui de l'Homme.\nNote: Le comptoir marchand du Bénéfice de 2e Statut est remplacé par un repaire discret muni de nombreuses sorties secrètes.",
    ),
    specialization: "Discrétion",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.mental, min: 5),
      AttributeMinRequirement(attribute: Attribute.manuel, min: 6),
      AbilityMinRequirement(ability: Ability.coordination, min: 6),
      SingleSkillMinRequirement(skill: Skill.deguisement, min: 6),
      SkillFamilyTotalPointsRequirement(family: SkillFamily.technique, min: 25),
      HasPrivilegeRequirement(privilege: CastePrivilege.paria),
    ],
  ),
  joueur(
    castes: [Caste.commercant, Caste.commercantNoir],
    title: 'Le joueur',
    motto: "Triché ? Je n'ai pas triché, j'ai gagné",
    motivations: "Jouer, risquer, gagner",
    description: "Troisième nouvelle carrière développée par des associations de voleurs de plus en plus entreprenantes. S’il est mal vu de rétablir l’équilibre commercial par le vol, les humains sont moins réticents - surtout les nantis - à perdre volontairement leurs richesses dans des jeux de hasard. Passés maîtres dans l’art de la comédie, du verbe et de la manipulation, les joueurs sont, au fil des ans, devenus un élément non négligeable de l’économie des cités. En environnement rural, toutefois, l'affirmation de leur rôle est plus difficile.",
    interdict: CareerInterdict(
      title: "Tu prendras les riques qui s'imposent",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Relever le défi',
      description: "Lors de toute opposition avec un autre personnage (combat, discussion, jet d’opposition, etc.), le joueur peut spontanément défier son adversaire, verbalement ou par son attitude naturelle et son regard. Le défi est automatiquement géré avant toute action et n’a pas besoin d’être accepté, à moins que le meneur ne décide que l’adversaire ne comprend pas le défi (peuple ancien, animal enragé, monstre inintelligent). Il mise alors autant de Points de Chance et/ou de Maîtrise qu'il le souhaite. Son adversaire peut accepter le défi en en misant au moins autant, puis le personnage peut de nouveau dépenser des points, et ainsi de suite. Lorsque les deux protagonistes ont passé leur tour, celui qui a misé le plus de points cumulés gagne le défi. Il perd les points qu'il a misés, mais remporte les Points de Maîtrise ou de Chance misés par l'adversaire. Le perdant perd tous les points ainsi misés et subit un malus égal au total des points misés par le vainqueur sur le jet de sa prochaine action, quelle qu'elle soit. Si c'est le personnage qui gagne le défi, il inflige un malus supplémentaire égal à son niveau de Statut à son adversaire. Ce Bénéfice peut être utilisé une fois par jour par niveau de Statut.\nNote: Le comptoir marchand du Bénéfice de 2e Statut est remplacé par une connaissance de tous les videurs et gros bras de la cité de prédilection du personnage et des accès privilégiés dans les tavernes et maisons de jeu.",
    ),
    specialization: "Jeu",
    requirements: [
      AbilityMinRequirement(ability: Ability.volonte, min: 7),
      AbilityMinRequirement(ability: Ability.presence, min: 5),
      AbilityMinRequirement(ability: Ability.perception, min: 6),
      AbilityMinRequirement(ability: Ability.coordination, min: 6),
      SingleSkillMinRequirement(skill: Skill.jeu, min: 5),
      HasPrivilegeRequirement(privilege: CastePrivilege.paria),
    ],
  ),
  marchand(
    castes: [Caste.commercant, Caste.commercantNoir],
    title: 'Le marchand',
    motto: "Même les plus beaux rêves ont un prix",
    motivations: "Échanger, écouter, partager",
    description: "La carrière de marchand est une des plus courantes de la caste. S’y retrouvent tous les individus qui pensent faire carrière à partir de leur bagou et espèrent faire prospérer leurs intérêts personnels au profit de la collectivité - selon le principe : lorsque l'argent circule, tous les citoyens peuvent tirer leur épingle du jeu.",
    interdict: CareerInterdict(
      title: "Tu ne ruineras jamais pour t'enrichir",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Le sens des réalités',
      description: "Habitué à manipuler les chiffres autant que les mots, le personnage peut faire varier la valeur de n'importe quelle transaction financière de 10% par niveau de Statut, que ce soit pour l'augmenter ou pour la réduire. Ainsi, il peut facilement - et sans le moindre jet - transformer le prix d'un objet, d'un service, d'une rétribution, etc. Ce Bénéfice ne peut être utilisé qu'une fois par transaction et s'emploie toujours après un éventuel jet de négociation ou de marchandage.",
    ),
    specialization: "Marchandage ou Estimation - Le personnage doit se spécialiser dans une catégorie de marchandises",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.social, min: 6),
      AbilityMinRequirement(ability: Ability.empathie, min: 6),
      TendencyMinRequirement(tendency: Tendency.human, min: 2),
      SingleSkillMinRequirement(skill: Skill.lireEtEcrire, min: 4),
    ],
  ),
  marchandItinerant(
    castes: [Caste.commercant, Caste.commercantNoir],
    title: 'Le marchand itinérant',
    motto: "Chaque route de ce monde est un nouveau marché",
    motivations: "Voyager, échanger, apprendre",
    description: "Cette carrière est une variante de la carrière de marchand et sied à des individus qui aiment voyager. Ces derniers ont souvent compris qu’élargir le cercle de circulation des biens peut être un facteur de progression sociale important : uniformisation de la société autour de certaines valeurs, propagation des innovations et des biens de consommation. Les marchands itinérants se considèrent, plus que les voyageurs, comme le ciment interculturel nécessaire à l’épanouissement du Royaume de Kor.",
    interdict: CareerInterdict(
      title: 'Tu pousseras toujours plus loin ta bourse et ta monture',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'La poignée de main',
      description: "Depuis le temps qu'il parcourt le Royaume de Kor à la recherche de marchandises et de nouveaux clients, le personnage peut dissiper la méfiance des tribus et des communautés étrangères - et gagne un bonus de 2 par niveau de Statut à tous ses jets de Social effectués lors de discussions, transactions ou actions sociales vis-à-vis d'hommes étrangers à sa culture. Les limites des royaumes et les différences manifestes de culture, de religion ou de croyances semblent de bons critères pour déterminer la possibilité de ce pouvoir, qui peut également être utilisé sur des races humanoïdes intelligentes.\nNote: Le comptoir marchand du Bénéfice de 2e Statut est remplacé par deux écuries situées dans deux villes séparées de plus de 500 km et disposant d’un palefrenier et d’un petit entrepôt.",
    ),
    specialization: "Géographie ou Langue des signes",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.social, min: 6),
      AttributeMinRequirement(attribute: Attribute.physique, min: 5),
      AbilityMinRequirement(ability: Ability.empathie, min: 7),
      SingleSkillMinRequirement(skill: Skill.geographie, min: 5),
      SingleSkillMinRequirement(skill: Skill.langueDesSignes, min: 5),
      OneOfRequirements(
        requirements: [
          SingleSkillMinRequirement(skill: Skill.equitation, min: 5),
          SingleSkillMinRequirement(skill: Skill.attelages, min: 5),
        ]
      )
    ],
  ),
  mendiant(
    castes: [Caste.commercant, Caste.commercantNoir],
    title: 'Le mendiant',
    motto: "L'argent a été inventé pour ceux qui en manquaient",
    motivations: "Observer, écouter, fureter",
    description: "Cette profession attire peu d’individus car elle souffre d’un important manque de prestige. Cependant, elle a trouvé sa place dans le tissu social urbain : les mendiants sont une arme aux mains des commerçants contre les voleurs ! En effet, mendier permet de faire circuler les richesses sans pour autant s’attaquer directement à des intérêts commerciaux, mais bien en s’appuyant sur “l'humanité” de ses interlocuteurs. De plus, certaines rivalités persistent entre les organisations de voleurs et de mendiants, ce dont profitent allègrement les marchands.",
    interdict: CareerInterdict(
      title: 'Tu refuseras le confort et la possession matérielle',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'La roue de fortune',
      description: "Une fois par jour par niveau de Statut, le personnage peut utiliser ce Bénéfice dans l'une ou l'autre des deux optiques suivantes : regagner l'intégralité de ses Points de Chance ou obtenir des Niveaux de Réussite lors d'un jet, alors qu'il ne possède pas la Compétence appropriée. Dans ce dernier cas, le personnage ne peut obtenir plus de Niveaux de Réussite que le niveau de son Statut, quel que soit le résultat de son jet. De plus, un mendiant placé dans un lieu public sera systématiquement ignoré si les passants obtiennent un chiffre en dessous de son Statut sur 1D10 (non modifiable), à moins de le rechercher activement.\nNote: Le comptoir marchand du Bénéfice de 2e Statut est remplacé par un droit d’accès à la « cour des miracles » de la ville et une certaine tolérance des miliciens locaux, dans les limites de discrétion.",
    ),
    specialization: "Vie en cité",
    requirements: [
      LuckMinRequirement(min: 5),
      SingleSkillMinRequirement(skill: Skill.baratin, min: 6),
      SingleSkillMinRequirement(skill: Skill.vieEnCite, min: 6),
      HasPrivilegeRequirement(privilege: CastePrivilege.paria),
    ],
  ),
  tenancier(
    castes: [Caste.commercant, Caste.commercantNoir],
    title: 'Le tenancier',
    motto: "L'aventure vient à la porte de ceux qui lui souhaitent la bienvenue",
    motivations: "Accueillir, rencontrer, échanger",
    description: "À la croisée de toutes les orientations de la caste, se trouvent les taverniers. Un peu commerçants, un peu voleurs, un peu espions, les aubergistes sont le moteur du développement social du Royaume de Kor. Que ce soit dans les grandes cités ou dans les petites bourgades, ils matérialisent toujours le centre névralgique de tous les échanges physiques ou philosophiques. Les idées neuves germent dans les auberges, les coups se préparent dans les auberges, les rencontres se déroulent dans les auberges. Consciente de son pouvoir, la guilde des taverniers tente de développer des règles d’éthique en vue de réguler le commerce de l’information.",
    interdict: CareerInterdict(
      title: "Tu ne refuseras pas l'hospitalité",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "Le coup d'œil",
      description: "Ce Bénéfice simule l'habitude qu'ont les tenanciers d'observer, d'analyser et de noter chaque détail de leurs rencontres et de leurs clients. En dépensant 1 Point de Maîtrise ou de Chance, au choix du joueur, ils peuvent à tout moment identifier une ou plusieurs des cinq informations suivantes chez un être humain - caste, Statut, Sphère de prédilection, Tendance majeure et degré d'affiliation aux Grands Dragons, qu'il soit fidèle, indifférent ou opposé. Le personnage n'effectue aucun jet mais doit dépenser 1 point par information qu'il désire obtenir - tous en même temps, s'il en cherche plusieurs - et ne peut demander qu'une seule information par niveau de Statut. La dernière information permise par ce Bénéfice permet de reconnaître facilement un dragon sous forme humaine.\nNote: Le comptoir marchand du Bénéfice de 2e Statut est remplacé par une taverne et quelques servants).",
    ),
    specialization: "Vie en cité ou Psychologie",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.social, min: 6),
      AbilityMinRequirement(ability: Ability.empathie, min: 6),
      AbilityMinRequirement(ability: Ability.perception, min: 6),
      SingleSkillMinRequirement(skill: Skill.castes, min: 4),
      SingleSkillMinRequirement(skill: Skill.vieEnCite, min: 5),
      SingleSkillMinRequirement(skill: Skill.psychologie, min: 4),
      TendencyMinRequirement(tendency: Tendency.human, min: 2),
    ],
  ),
  voleur(
    castes: [Caste.commercant, Caste.commercantNoir],
    title: 'Le voleur',
    motto: "Aucune propriété n'est jamais définitive",
    motivations: "Convoiter, atteindre, s'approprier",
    description: "Cette carrière a pris de plus en plus d’ampleur au fil des années, car ses représentants ont bien compris leur rôle de moteur de la société. Les voleurs sont continuellement sur le fil du rasoir car ils incarnent les deux principes fondateurs de la caste. D'une part, ils créent constamment des déséquilibres dans les processus sociaux mis en place et, d’autre part, ils luttent pour en maintenir l’équilibre grâce, entre autres, à la juste répartition des fruits de leurs larcins.",
    interdict: CareerInterdict(
      title: 'Tu ne voleras pas la vie',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'La main sûre',
      description: "Chaque fois qu'il fait appel aux Tendances lors d'un jet impliquant l'Attribut Manuel ou Physique pour tenter de dérober un objet, d'être discret, d'escalader, d'accomplir toute action visant à voler ou à surprendre, le personnage peut relancer une fois le dé de l'Homme. Il peut ensuite décider de conserver ce nouveau résultat, de conserver un autre dé ou relancer une fois de plus le dé de l'Homme. Ce Bénéfice peut être utilisé une fois par jour par niveau de Statut du personnage. Le voleur ne gagne aucun Point de Tendance s'il conserve un autre dé après avoir relancé celui de l'Homme.\nNote: Le comptoir marchand du Bénéfice de Statut 2 est remplacé par un droit d’accès aux locaux de réunion de la guilde locale de la ville et le respect de quelques gosses de rues.",
    ),
    specialization: "Faire les poches",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.manuel, min: 5),
      OneOfRequirements(
        requirements: [
          LuckMinRequirement(min: 7),
          ProficiencyMinRequirement(min: 7),
        ]
      ),
      SingleSkillMinRequirement(skill: Skill.faireLesPoches, min: 5),
      SingleSkillMinRequirement(skill: Skill.discretion, min: 5),
      SingleSkillMinRequirement(skill: Skill.estimation, min: 4),
      SkillAttributeTotalPointsRequirement(attribute: Attribute.manuel, min: 25),
      HasPrivilegeRequirement(privilege: CastePrivilege.paria),
    ],
  ),

  architectes(
    castes: [Caste.erudit, Caste.eruditNoir],
    title: 'Les architectes',
    motto: "Du néant de l'esprit à l'éternité du regard",
    motivations: "Concevoir, schématiser, innover",
    description: "Penseurs de la matière, les architectes d’Ozyr raisonnent en termes de conception et non de réalisation. Leurs travaux sont axés sur la recherche de la solidité, du renouvellement de l’esthétique et de la fonctionnalité. Ils laissent à leurs confrères de la caste des artisans le soin d’utiliser leurs plans et principes pour mener sur le terrain des chantiers bruyants et éreintants.",
    interdict: CareerInterdict(
      title: 'Tu ne cautionneras aucune hérésie',
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'œil de l'expert",
      description: "La vocation théorique des architectes, versés dans la confection de plans plus que dans la réalisation des édifices, ne les prive pas d’une perception avisée des bâtiments, constructions, monuments et autres œuvres humaines de nature architecturale. D’un simple regard, en réussissant un jet de Mental + Architecture contre une Difficulté allant de 15 à 30, ils peuvent automatiquement définir un nombre d’informations égal à leur niveau de Statut, parmi les suivantes : âge / ancienneté, nature / origine, utilité / fonction, profondeur / hauteur et agencement général de l’édifice. Il appartient au personnage de définir, avant d’effectuer son jet, quelles sont les informations qu’il souhaite obtenir. Les éventuels Niveaux de Réussite obtenus lui permettent d’apprendre une information supplémentaire ou de préciser les réponses déjà obtenues.\nDe plus, si ce jet est réussi, le personnage peut participer à toute tentative d'orientation dans un édifice ou bâtiment en ajoutant le niveau de sa Compétence Architecture au score de base du jet d’Orientation. La Difficulté de ce jet est cependant augmentée de 5, pour simuler les discussions entre les deux personnages, si le jet d'Orientation n’est pas effectué par l’architecte.",
    ),
    specialization: "Architecture (spécialisation de Don artistique)",
    requirements: [
      AbilityMinRequirement(ability: Ability.intelligence, min: 7),
      AbilityMinRequirement(ability: Ability.perception, min: 5),
      ProficiencyMinRequirement(min: 6),
      TendencyMinRequirement(tendency: Tendency.human, min: 1),
      SkillFamilyTotalPointsRequirement(family: SkillFamily.technique, min: 15),
      SingleSkillMinRequirement(skill: Skill.lireEtEcrire, min: 6),
      SingleSkillImplementationMinRequirement(skill: Skill.donArtistique, implementation: "Architecture", min: 6),
    ]
  ),
  astronomes(
    castes: [Caste.erudit, Caste.eruditNoir],
    title: 'Les astronomes',
    motto: "Le ciel est emplit de sagesse insoupçonnée",
    motivations: "Observer, décrypter, interpréter",
    description: "Descendants spirituels d’Alya, les astronomes forment une importante faction de chercheurs soutenus par Ozyr dans leur compréhension de la science des astres. Ils comptent parmi leur rang des historiens, des conteurs, des érudits et une forte proportion de scientifiques. Tous les membres de cette confrérie possèdent des Avals draconiques leur permettant d’utiliser des instruments proscrits afin de comprendre si une logique régule les phénomènes célestes. Soumis à la Loi du Secret, les astronomes n’ont pas le droit de divulguer leurs connaissances aux profanes et n’appliquent la Loi du Collège qu'entre eux. Cette confrérie est une faction malsaine, où les membres entretiennent une surveillance mutuelle d’ordre paranoïaque. En effet, à force de conserver leurs secrets, les astronomes en sont venus à douter de leurs confrères et à se suspecter mutuellement d’Humanisme. Si l’on trouve de nombreux Inspirés dans cette confrérie, il est bien rare que ces derniers se dévoilent, trop craintifs des réactions de leur hiérarchie à ce que beaucoup considèrent comme une possible affabulation. Si Alya a fièrement énoncé les Prophéties, ses descendants baignent dans un obscurantisme que l’on dit entretenu par Ozyr, en attendant qu’elle comprenne les secrets des Étoiles.",
    interdict: CareerInterdict(
      title: "Tu ne chercheras aucune vérité fondamentale dans les astres",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Sous les yeux du ciel',
      description: "Alors que la plupart des érudits voient en la parole draconique une vérité indiscutable, les astronomes ont découvert tant de réalités dans l’étude des astres que leur conception d’une vérité unique s’est lentement effritée. Loin de renier les enseignements draconiques, les astronomes ont simplement appris à voir en la voie de l’homme une solution possible. De fait, ils peuvent choisir de conserver le dé de l'Homme ou celui du Dragon lors de tout jet impliquant l’Attribut Mental ou Social, sans subir la moindre pénalité - et ce, quel que soit le dé qu’ils aient annoncé.",
    ),
    specialization: "Astrologie",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.mental, min: 5),
      AbilityMinRequirement(ability: Ability.intelligence, min: 7),
      AbilityMinRequirement(ability: Ability.volonte, min: 6),
      TendencyMinRequirement(tendency: Tendency.human, min: 2),
      ProficiencyMinRequirement(min: 6),
      SkillFamilyTotalPointsRequirement(family: SkillFamily.theorie, min: 20),
      SingleSkillMinRequirement(skill: Skill.astrologie, min: 6),
      HasPrivilegeRequirement(privilege: CastePrivilege.ecritTechnique),
    ]
  ),
  cartographes(
    castes: [Caste.erudit, Caste.eruditNoir],
    title: 'Les cartographes',
    motto: "Tenir le monde entre ses mains, et le transmettre à d'autres",
    motivations: "Explorer, répertorier, archiver",
    description: "Probablement les plus mobiles et les plus intrépides des érudits, les cartographes se consacrent fidèlement au relevé du corps de l’Être Primordial. Relativement indifférents aux affaires politiques de leur caste, les cartographes travaillent depuis longtemps avec les explorateurs de Szyl, archivant consciencieusement les découvertes de ces derniers par des cartes sans cesse ajustées par les nouvelles générations.",
    interdict: CareerInterdict(
      title: "Tu peindras fidèlement le portrait de l'Être Primordial",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'expérience du terrain",
      description: "À force de sillonner le monde, le personnage a appris à tirer profit des moindres repères, des plus infimes détails topographiques, géographiques et climatiques pour dessiner les cartes les plus précises possibles. Sa Compétence de Cartographie est en quelque sorte devenue son instrument privilégié et il peut désormais l’utiliser lors de jets impliquant normalement les Compétences Pister, Orientation, Géographie ou Vie en cité. Pour chaque niveau de Statut qu’il possède, le personnage peut choisir une Compétence parmi ces quatre, à laquelle il pourra substituer sa Compétence Cartographie. Ainsi, lorsqu’il embrasse cette carrière, le personnage désigne une Compétence comme entrant dans le cadre de ce Bénéfice. L'expérience du terrain ne peut être utilisée que si le personnage se trouve dans les conditions “de terrain”, et uniquement à des fins pratiques - il ne connaît en effet rien de la théorie de ces cinq Compétences s’il ne les a pas développées.",
    ),
    specialization: "Cartographie",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.manuel, min: 6),
      AbilityMinRequirement(ability: Ability.coordination, min: 5),
      ProficiencyMinRequirement(min: 6),
      SingleSkillAnyImplementationMinRequirement(skill: Skill.donArtistique, min: 4, comment: "en rapport avec le graphique (enluminures, dessin d’art, dorure…)"),
      SingleSkillMinRequirement(skill: Skill.cartographie, min: 6),
      SingleSkillMinRequirement(skill: Skill.lireEtEcrire, min: 6),
      SingleSkillMinRequirement(skill: Skill.geographie, min: 5),
    ]
  ),
  conteurs(
    castes: [Caste.erudit, Caste.eruditNoir],
    title: 'Les conteurs',
    motto: "Une plume en guise d'épée, quelques mots pour seule magie",
    description: "Très lié aux historiens, cet ordre se charge de relayer auprès des populations les facettes les plus communes de l’histoire. Ses membres sont autant des orateurs et des baladins que de véritables auteurs travaillant leurs textes pour en faire des outils de connaissance. Cet ordre compte assez peu de membres, mais les plus célèbres auteurs de contes, légendes et pièces de théâtre sont issus de ses rangs. Une querelle grandissante les oppose aux ménestrels, qui les accusent de déformer certains faits pour des motifs obscurs. Leur nombre réduit les désavantages, mais leur prestige leur permet tout de même de conserver l'attention du peuple et des puissants, toujours désireux de s'informer auprès des adeptes d’Ozyr.",
    motivations: "Colporter, émerveiller, transmettre",
    interdict: CareerInterdict(
      title: 'Tu ne souilleras le verbe d\'aucune pensée impure',
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'étincelle de la passion",
      description: "Si nombre de récits et de contes sont colportés en vue de distraire, d’éduquer, de transmettre un savoir ou de gagner un gîte et un couvert, il est des légendes que les conteurs narrent, avec plus de ferveur, plus de passion, dans l’espoir de mettre à nu l'âme de leur auditoire.\nEn jouant sur les mots et les situations qu’il décrit, le personnage peut chercher à faire réagir celui ou ceux qui l’écoutent, et obtenir ainsi des informations sur des éléments aussi variés que la caste, la Tendance principale, le passé, etc. Le personnage ajoute son niveau de Statut au score de base de son jet de Social + Conte, lorsqu’il cherche cet effet, et la Difficulté de base est égale à 15 + le nombre d’informations que le personnage cherche à obtenir. Les éventuels Niveaux de Réussite servent alors à préciser les informations obtenues.",
    ),
    specialization: "Conte",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.social, min: 5),
      AbilityMinRequirement(ability: Ability.empathie, min: 6),
      TendencyMinRequirement(tendency: Tendency.human, min: 1),
      SkillAttributeTotalPointsRequirement(attribute: Attribute.social, min: 20),
      SingleSkillAnyImplementationMinRequirement(skill: Skill.donArtistique, min: 4),
      MultipleSkillsInFamilyMinRequirement(family: SkillFamily.theorie, count: 2, min: 6),
      SingleSkillMinRequirement(skill: Skill.lireEtEcrire, min: 6),
      SingleSkillMinRequirement(skill: Skill.conte, min: 6),
      SingleSkillMinRequirement(skill: Skill.psychologie, min: 5),
    ]
  ),
  erudits(
    castes: [Caste.erudit, Caste.eruditNoir],
    title: 'Les érudits',
    motto: "Passions, désirs, ambitions et valeurs privent l'homme d'un véritable regard",
    motivations: "Étudier, comparer, comprendre",
    description: "Véritables gardiens du savoir, les érudits se considèrent comme responsables de la transmission de la connaissance aux générations actuelles et futures. Leur travail consiste à veiller à ce que toute découverte soit soigneusement compilée par écrit et conservée à l'abri des outrages du temps dans des bibliothèques soignées. Parfois considérés comme des rats de bibliothèque, les érudits sont probablement l’ordre le plus mésestimé car, sans eux, la quête du savoir serait vaine. Leurs actions en font une progression au travers des âges et non une perpétuelle redécouverte. Compilateurs, scribes, enlumineurs ou rénovateurs, ils sont plus intéressés par la préservation du savoir que par son acquisition. Bien connus des aventuriers, les érudits constituent l’ordre le plus souvent rencontré par ces hommes et ces femmes en quête de vieux écrits ou de livres d’un autre âge. Il est bien rare qu’ils soient raillés par leurs visiteurs et les aventuriers de Kor ont pour coutume de défendre cet ordre utile à tous et, surtout, gardien des traces de leurs exploits.",
    interdict: CareerInterdict(
      title: 'Tu ne laisseras aucune passion motiver ton jugement',
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'esprit clair",
      description: "Concentration et objectivité sont les deux maîtres mots du personnage, lorsqu’il est question d’analyser, de comprendre ou de faire un effort de mémoire. Chaque fois qu’il effectue un jet impliquant l’Attribut Mental, et pour lequel il peut choisir de ne pas faire appel aux Tendances, le personnage gagne un bonus égal à son niveau de Statut et un Niveau de Réussite automatique, si le jet est réussi.",
    ),
    specialization: "une des Connaissances développées",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.mental, min: 5),
      AbilityMinRequirement(ability: Ability.intelligence, min: 7),
      AbilityMinRequirement(ability: Ability.volonte, min: 6),
      ProficiencyMinRequirement(min: 6),
      TendencyMinRequirement(tendency: Tendency.dragon, min: 2),
      SkillAttributeTotalPointsRequirement(attribute: Attribute.mental, min: 35),
      MultipleSkillsInFamilyMinRequirement(family: SkillFamily.theorie, count: 4, min: 6),
      MultipleSkillsInFamilyMinRequirement(family: SkillFamily.theorie, count: 2, min: 8),
      MultipleSkillsMinRequirement(
        skills: [
          Skill.connaissanceDesDragons,
          Skill.connaissanceDesAnimaux,
          Skill.connaissanceDeLaMagie,
        ],
        min: 8,
        count: 1
      )
    ]
  ),
  herboristes(
    castes: [Caste.erudit, Caste.eruditNoir],
    title: 'Les herboristes',
    motto: "Chaque feuille, chaque fleur est source de savoir et de bienfaits",
    motivations: "Analyser, combiner, répertorier",
    description: "Dépositaires des secrets d’Heyra, les herboristes se sont rangés sous la bannière d’Ozyr, en raison de leur collaboration avec les médecins et de la rigueur des voies d’Ozyr dans la quête du savoir. Qu’ils soient alchimistes théoriciens cherchant à comprendre les principes fondamentaux des plantes ou patients observateurs des multiples espèces végétales, ce sont ceux qui répertorient l'usage des plantes par l’étude de leurs effets, plutôt que par une utilisation ancestrale, méthode préconisée par les Prodiges.",
    interdict: CareerInterdict(
      title: 'Tu ne corrompras la tature par aucune de tes pratiques',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'À la racine de tout bienfait',
      description: "En plus d’étudier les végétaux et d’en tirer chaque jour de nouvelles applications médicinales ou alchimiques, les herboristes savent combiner les effets des plantes à ceux, apparemment incompatibles, d’autres procédés et compétences. Pour chaque niveau de Statut qu’il possède, le personnage dispose d’un nombre de Niveaux de Réussite et/ou de bonus de 5 points qu’il peut attribuer, en annonçant son intention avant de lancer les dés, à n’importe quel jet impliquant les Compétences de Médecine, Premiers soins, Alchimie et Herboristerie, ainsi qu’aux actions permettant physiquement d'utiliser les propriétés de plantes, feuilles, fleurs, pollens ou graines - comme la cuisine, la confection de feux, de parfums, etc. Ces bonus et Niveaux de Réussite peuvent être cumulés sans aucune limite sur un ou plusieurs jets différents effectués au cours d’une même journée, mais les bonus non utilisés sont perdus au lendemain matin.",
    ),
    specialization: "Herboristerie",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.manuel, min: 5),
      AbilityMinRequirement(ability: Ability.intelligence, min: 6),
      AbilityMinRequirement(ability: Ability.empathie, min: 4),
      ProficiencyMinRequirement(min: 6),
      TendencyMinRequirement(tendency: Tendency.dragon, min: 2),
      SkillAttributeTotalPointsRequirement(attribute: Attribute.mental, min: 30),
      SingleSkillMinRequirement(skill: Skill.matieresPremieres, min: 5),
      SingleSkillMinRequirement(skill: Skill.herboristerie, min: 6),
      SingleSkillMinRequirement(skill: Skill.geographie, min: 5),
      SingleSkillMinRequirement(skill: Skill.connaissanceDesAnimaux, min: 4),
    ]
  ),
  historiens(
    castes: [Caste.erudit, Caste.eruditNoir],
    title: 'Les historiens',
    motto: "Si le monde est un livre, nous sommes les doigts qui en tournent les pages",
    motivations: "Apprendre, approfondir, consigner",
    description: "Soucieux de guider les hommes en leur permettant de bien connaître leur passé, les historiens sont aussi des philosophes. Outre la compilation des événements historiques, leur mission implique qu’ils en débattent longuement afin de bien cerner leur mise en place et de pouvoir offrir des garde-fous solides aux dirigeants du Royaume de Kor.",
    interdict: CareerInterdict(
      title: "Tu n'occulteras aucune vérité, n'inventeras aucun mensonge",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "La mémoire de l'archiviste",
      description: "Habitué à lire, à écrire et à entendre fréquemment certains mots, certains termes chargés de références et d’anecdotes, le personnage a accumulé une connaissance particulière de quelques sujets qui, dans son esprit, sont définis par de simples mots-clefs. Pour chaque niveau de Statut qu’il possède, le personnage acquiert une connaissance étendue d’un concept ou d’un sujet susceptible d’être résumé par un mot - Dragons, guerres, Élus, Humanistes, etc. Ensuite, chaque fois qu’il effectuera un jet impliquant l’Attribut Mental et concernant l’un de ces mots, la Difficulté sera réduite de 5 et le personnage obtiendra une information supplémentaire gratuite, si le jet est réussi.\nCe Bénéfice ne peut s’appliquer qu’à des jets relatifs aux événements passés et en aucun cas à une connaissance pratique de l’un de ces domaines.",
    ),
    specialization: "Histoire. Le personnage doit se spécialiser dans un sujet d'étude précis.",
    requirements: [
      AbilityMinRequirement(ability: Ability.intelligence, min: 6),
      TendencyMinRequirement(tendency: Tendency.dragon, min: 2),
      SkillFamilyTotalPointsRequirement(family: SkillFamily.theorie, min: 20),
      SingleSkillMinRequirement(skill: Skill.histoire, min: 6),
      OneOfRequirements(
        requirements: [
          SingleSkillMinRequirement(skill: Skill.connaissanceDesAnimaux, min: 5),
          SingleSkillMinRequirement(skill: Skill.connaissanceDeLaMagie, min: 5),
          SingleSkillMinRequirement(skill: Skill.connaissanceDesDragons, min: 5),
        ]
      )
    ]
  ),
  historiensFaction(
    castes: [Caste.erudit, Caste.mage, Caste.commercant],
    isStandard: false,
    title: "Les Historiens (Faction)",
    motto: "Nous sommes les esclaves, nous sommes les maîtres",
    motivations: "Surveiller, intervenir, contrôler",
    description: "",
    interdict: CareerInterdict(
      title: "Tu ne parleras pas",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "Écrire l'Histoire",
      description: "En regardant un individu droit dans les yeux, l'Historien est capable de modifier de manière superficielle ses connaissances. La magie d'Ozyr permet en effet à son agent de suggérer certaines informations qui viennent modifier ce que savait l'individu. Ce dernier doit réussir un jet de Mental + Volonté contre le jet de Social + Éloquence + Statut de l'Historien. Ce dernier peut préalablement utiliser Psychologie (Manipulation) pour trouver les mots les plus pertinents ou les informations à transformer pour faire de sa victime un pion ; en cas de réussite, il bénéficie d'un bonus de 1+1/NR à son jet. Si l'Historien a fait appel à sa compétence de Manipulation, la victime répandra les fausses informations à 5+5/NR personnes. Il revient alors au MJ de déterminer dans quelle mesure l'information va se répandre et se déformer de nouveau.",
    ),
    specialization: "Psychologie (Manipulation)",
    requirements: [
      OneOfRequirements(
        requirements: [
          CasteMemberRequirement(caste: Caste.erudit, status: CasteStatus.expert),
          CasteMemberRequirement(caste: Caste.mage, status: CasteStatus.expert),
          CasteMemberRequirement(caste: Caste.commercant, status: CasteStatus.expert),
          HasSphereDraconicLinkRequirement(sphere: MagicSphere.oceans),
        ]
      ),
      AttributeMinRequirement(attribute: Attribute.mental, min: 6),
      AttributeMinRequirement(attribute: Attribute.social, min: 6),
      SkillAttributeTotalPointsRequirement(attribute: Attribute.mental, min: 20),
      SkillAttributeTotalPointsRequirement(attribute: Attribute.social, min: 30),
      SingleSkillMinRequirement(skill: Skill.discretion, min: 5),
      TendencyMinRequirement(tendency: Tendency.dragon, min: 5),
      TendencyCirclesMaxRequirement(tendency: Tendency.human, max: 3),
      TendencyCirclesMaxRequirement(tendency: Tendency.fatality, max: 3),
      HasInterdictRequirement(interdict: CasteInterdict.loiDuSecret),
    ],
    reservedSkills: [Skill.interrogatoire, Skill.torture],
  ),
  medecins(
    castes: [Caste.erudit, Caste.eruditNoir],
    title: 'Les médecins',
    motto: "Chaque homme qui meurt ou souffre est une insulte à la vie",
    motivations: "Soigner, aider, protéger",
    description: "Bien que les érudits étudiant la médecine soient considérés par beaucoup comme de dangereux profanateurs de l’intégrité du corps offert par les Dragons, ils préfèrent se considérer comme les explorateurs d’un domaine indispensable à l’amélioration de la vie de tous. Dépositaires d'un savoir parfois douteux, les médecins sont presque tous obligés de recourir à un Aval draconique afin de pouvoir exercer leur art. Compatissants et dévoués, les médecins consacrent leur vie à l’application de la médecine plus qu’à sa recherche fondamentale, domaine dangereux qu’ils préfèrent laisser aux scientifiques. ",
    interdict: CareerInterdict(
      title: "Tu ne seras l'agent d'aucune destruction",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'os et le ligament",
      description: "Si chaque blessure est différente d’une autre, le personnage a suffisamment replacé d’os, pansé de plaies, pratiqué de saignées et placé d’attelles pour bénéficier d’un savoir-faire applicable à tout type de contusion ou d’hémorragie. Chaque jour, il dispose d’un nombre de Niveaux de Réussite égal à son niveau de Statut qu’il peut attribuer à un jet de Médecine ou de Premiers soins réussi. Ces bonus ne peuvent en aucun cas réduire la Difficulté du jet, mais sont considérés comme des Niveaux de Réussite à part entière, au regard de tous les effets possibles.\nCes Niveaux de Réussite peuvent être cumulés sans aucune limite sur un ou plusieurs jets différents effectués au cours d’une même journée, mais les Niveaux de Réussite non utilisés sont perdus au lendemain matin.\nIl est impossible de faire appel aux Tendances sur un jet où le personnage souhaite utiliser ce Bénéfice.",
    ),
    specialization: "Médecine",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.mental, min: 5),
      AttributeMinRequirement(attribute: Attribute.manuel, min: 3),
      AbilityMinRequirement(ability: Ability.intelligence, min: 7),
      AbilityMinRequirement(ability: Ability.volonte, min: 6),
      ProficiencyMinRequirement(min: 6),
      TendencyMinRequirement(tendency: Tendency.human, min: 1),
      SkillAttributeTotalPointsRequirement(attribute: Attribute.mental, min: 35),
      SkillFamilyTotalPointsRequirement(family: SkillFamily.pratique, min: 20),
      SingleSkillMinRequirement(skill: Skill.medecine, min: 6),
      SingleSkillMinRequirement(skill: Skill.premiersSoins, min: 4),
    ]
  ),
  navigateurs(
    castes: [Caste.erudit, Caste.eruditNoir],
    title: 'Les navigateurs',
    motto: "Par la force d'Ozyr, nous voguons sur les eaux de ce monde",
    motivations: "Acheminer, découvrir, former",
    description: "Les navigateurs constituent l’organisation la plus récente de celles patronnées par Ozyr. Elle rassemble les marins citoyens, qui représentent une faible proportion de la faction des marins, majoritairement formée de serviteurs. On trouve parmi eux les capitaines, les armateurs, les cartographes côtiers et les navigateurs proprement dits. Bon nombre d’entre eux sont des voyageurs contraints de suivre les enseignements d’Ozyr pour bénéficier de l’autorisation de circuler au long des côtes. À l’origine fidèles à Szyl et épris de liberté, ils ont dû se résigner à suivre les directives de l’ordre marin et accepter, en 1206 AdE, le joug du Dragon des Océans. Szyl dut se plier à cette interprétation des Édits draconiques, Ozyr arguant de sa suprématie sur les mers. Toujours attachés à Szyl, les navigateurs vivent leur asservissement comme un mal nécessaire afin de pouvoir continuer à voguer. Nombre d’entre eux continuent, du fond de leur cœur, de suivre le Dragon des Vents, persuadés qu’il ne les pas abandonnés mais plutôt “détachés” pour leur propre sécurité et qu’il continue en secret à guider leur organisation. Quelques voyages sacrilèges en haute mer, mystérieusement favorisés par les vents, accréditent cette thèse, sans que la moindre preuve n’ait jamais été découverte par l’ordre marin.",
    interdict: CareerInterdict(
      title: "Tu ne brigueras d'autre liberté que celle offerte par la Mère des Océans",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'La ferveur du large',
      description: "Arpenteurs téméraires des rivages de Kor, les navigateurs doivent recourir à l’aval de l’ordre marin pour pouvoir pratiquer leur passion du voyage maritime. Prêts à de nombreuses concessions, les navigateurs sont des citoyens passionnés, véritables meneurs d’hommes dans la solitude des voyages. Lorsqu'ils conservent le dé du Dragon dans un jet d’une Compétence d’Influence, ils peuvent ajouter leur Volonté au résultat, et ce autant de fois par jour que leur Tendance Dragon. Forts d’un tel ascendant sur leur équipage, on comprend bien que les marins soient étroitement surveillés par l’ordre marin.",
    ),
    specialization: "Navigation",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.manuel, min: 5),
      AbilityMinRequirement(ability: Ability.empathie, min: 6),
      AbilityMinRequirement(ability: Ability.coordination, min: 5),
      TendencyMinRequirement(tendency: Tendency.dragon, min: 2),
      SkillAttributeTotalPointsRequirement(attribute: Attribute.mental, min: 25),
      SkillAttributeTotalPointsRequirement(attribute: Attribute.manuel, min: 20),
      SingleSkillMinRequirement(skill: Skill.commandement, min: 4),
      SingleSkillMinRequirement(skill: Skill.geographie, min: 6),
      SingleSkillMinRequirement(skill: Skill.orientation, min: 6),
      SkillSpecializationMinRequirement(skill: Skill.orientation, specialization: "Navigation", min: 5),
    ]
  ),
  scientifiques(
    castes: [Caste.erudit, Caste.eruditNoir],
    title: 'Les scientifiques',
    motto: "Il n'est aucune science, aucun savoir, que les Dragons n'ont pas légués aux hommes",
    motivations: "Innover, expérimenter, institutionnaliser",
    description: "Récemment créée à partir de la Loge des Soigneurs, la formation scientifique se consacre au délicat décryptage des secrets du monde, pour mieux en saisir les lois fondamentales. Flirtant perpétuellement avec l’Humanisme, ces érudits se font aussi les gardiens de connaissances dangereuses, se contraignant eux-mêmes à la loi du Secret pour préserver l’humanité de dérives à l’égard des voies draconiques.",
    interdict: CareerInterdict(
      title: 'Tu ne créeras aucun instrument de rébellien',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'La quintessence du savoir',
      description: "Alors que la plupart des autres hommes se focalisent sur une conception pratique et orientée des sciences, les érudits de ce corps si particulier développent, avec l’expérience, un regard incroyablement objectif qui leur permet de comprendre, d’approfondir et de pratiquer les sciences sans aucune barrière psychologique. De fait, ils ne sont pas assujettis aux mêmes limitations que les autres personnages et voient le niveau maximal de toutes les Compétences limitées par la Tendance Homme augmenté du niveau de leur Statut.\nAinsi, une Compétence limitée à deux fois la Tendance Homme d’un personnage sera limitée à deux fois cette valeur, plus le Statut du personnage.",
    ),
    specialization: "Astrologie, Médecine, Alchimie, Chirurgie ou Mécanismes",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.mental, min: 6),
      AttributeMinRequirement(attribute: Attribute.manuel, min: 5),
      AbilityMinRequirement(ability: Ability.intelligence, min: 6),
      TendencyMinRequirement(tendency: Tendency.human, min: 1),
      ProficiencyMinRequirement(min: 6),
      SkillFamilyTotalPointsRequirement(family: SkillFamily.technique, min: 20),
      SkillFamilyTotalPointsRequirement(family: SkillFamily.pratique, min: 15),
      OneOfRequirements(
        requirements: [
          SingleSkillMinRequirement(skill: Skill.astrologie, min: 4),
          SingleSkillMinRequirement(skill: Skill.medecine, min: 4),
          SingleSkillMinRequirement(skill: Skill.alchimie, min: 4),
          SingleSkillMinRequirement(skill: Skill.chirurgie, min: 4),
          SingleSkillMinRequirement(skill: Skill.mecanismes, min: 4),
        ]
      )
    ]
  ),

  conjurateur(
    castes: [Caste.mage, Caste.mageNoir],
    title: 'Conjurateur',
    motto: "Certaines portes réclament des gardiens particuliers",
    motivations: "Protéger, éliminer, servir",
    description: "Les mages du métal furent les premiers à subir les contrecoups de l'utilisation des portails magiques. Nombre d'entre eux périrent sous les coups des redotables élémentaires du métal qui figurent parmi les créatures les plus meurtries et les plus enragées issues des guerres draconiques. D'autres n'eurent même pas le temps comprendree la cause de leur mort, lacérés par des veines de minerais métallique jaillissant des entrailles de la terre. C'est parmi leurs rangs qu'apparurent les premiers conjurateurs, des mages spécialisés dans la lutte contre les créature et phénomènes surgissant des portails. Constatant que ces accidents n'étaient pas propres à la Sphère du Métal, ils formèrent leurs confrères des autres Sphères, mais aujourd'hui encore, les conjurateurs sont essentiellement des mages du métal.",
    interdict: CareerInterdict(
      title: "Tu ne faibliras point.",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Conjuration',
      description: "Le mage peut révoquer toute créature surgissant d’un portail (invoquée volontairement ou par erreur) en réussissant un jet de Mental + Magie invocatoire contre un jet de Mental + Volonté de la créature. Si le jet réussit, le mage doit dépenser des points de magie à hauteur de la Volonté de la créature. Celle-ci disparaît aussitôt, comme aspirée par le portail d’où elle a surgi. Cette conjuration est possible dans les (Statut) rangs d'Initiative qui suivent l'apparition du phénomène. Le mage peut également conjurer tout phénomène provenant d'un portail en réussissant un jet de Mental + Magie invocatoire contre une Difficulté égale à la Difficulté du sort qui a provoqué l'arrivée du phénomène. S'il réussit, il doit dépenser un nombre de points de magie égal au coût du sort. Si le mage meurt sans avoir pu couvrir les points de magie nécessaires, son sacrifice suffit à réussir la conjuration et son corps est totalement consumé. Cette technique est valable aussi bien contre un sort lancé par un autre mage que contre les effets d'un contrecoup.",
    ),
    specialization: "Connaissance de la magie : créatures élémentaires",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.mental, min: 6),
      AbilityMinRequirement(ability: Ability.volonte, min: 5),
      MagicSkillMinRequirement(skill: MagicSkill.invocatoire, min: 8),
      ProficiencyMinRequirement(min: 8),
    ]
  ),
  enchanteur(
    castes: [Caste.mage, Caste.mageNoir],
    title: "L'enchanteur",
    motto: "Heyra crée la vie, Nenya la sublime",
    motivations: "Création, curiosité, innovation",
    description: "Les mages de Kezyr sont les plus nombreux à s’intéresser à cette carrière. Mélangeant l’art de l’artisanat à celui de la magie, les enchanteurs sont particulièrement appréciés par l’ensemble de la population.",
    interdict: CareerInterdict(
      title: 'Tu ne créeras aucune forme de vie',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Le toucher de Nenya',
      description: "S'il réussit son jet d’Enchantement, le personnage gagne automatiquement un Niveau de Réussite supplémentaire. De plus, en réussissant un jet de Manuel + Sorcellerie + niveau de Statut contre une Difficulté de 20, le personnage peut conférer un bonus égal à son niveau de Statut à n'importe quel objet, et ce pendant 1 minute + 1 par Niveau de Réussite. Ce bonus peut se traduire, à la discrétion du meneur de jeu, par une augmentation momentanée des dommages, un bonus au toucher, etc.",
    ),
    specialization: "Connaissance de la magie (Sorcellerie) ou un Artisanat. Le personnage ne peut posséder d’autres Spécialisations de Connaissance de la magie concernant les Disciplines",
    requirements: [
      AbilityMinRequirement(ability: Ability.empathie, min: 7),
      MagicSphereAnyMinRequirement(min: 6, count: 2),
      SingleSkillMinRequirement(skill: Skill.enchantement, min: 5),
      SingleSkillAnyImplementationMinRequirement(skill: Skill.artisanat, min: 5),
      SingleSkillAnyImplementationMinRequirement(skill: Skill.donArtistique, min: 5),
    ]
  ),
  fideleDeChimere(
    castes: [Caste.mage, Caste.mageNoir],
    title: 'Le fidèle de Chimère',
    motto: "Mếme aveugles, nous sommes tous Élus de Nenya",
    motivations: "Pratique, discipline, tradition",
    description: "Les mages d’Heyra, de Szyl et de Nenya sont nombreux à suivre cetie carrière — on raconte aussi qu'elle intéresse certains adeptes de Kalimsshar. Les étudiants y apprennent toutes les techniques visant à embellir toute chose, que ce soit un objet, un chant, de la musique, un paysage ou un être. De nombreux mages poètes, peintres ou sculpteurs sont issus de cetie carrière. C’est une profession totalement opposée à celle des mages combattants.",
    interdict: CareerInterdict(
      title: 'Nenya sera ton seul maître',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Guidé par Nenya',
      description: "Chaque matin, au réveil, le personnage peut effectuer un jet de Mental + Empathie contre une Difficulté de 10. S’il réussit, il gagne pour la journée un nombre de Points de Magie de sa Sphère égal à son niveau de Statut + le nombre de Niveaux de Réussite du jet. Les points non dépensés sont perdus au lendemain matin.\nDe plus, en établissant un contact physique avec un être vivant, un objet ou un lieu, le personnage peut effectuer un jet de Mental + Empathie contre une Difficulté de 10 pour déterminer quelles énergies sont présentes. Si plusieurs Sphères sont présentes, le mage apprend une information + une par Niveau de Réussite. En sacrifiant un Niveau de Réussite, il peut obtenir une précision sur la puissance d’une Sphère qu’il a d’ores et déjà identifiée.",
    ),
    specialization: "Ne peut se spécialiser en Connaissance de la magie",
    requirements: [
      MagicSphereAnyMinRequirement(min: 6, count: 3),
      MagicSkillAnyMinRequirement(min: 5, count: 2),
      AttributeMinRequirement(attribute: Attribute.mental, min: 5),
      TendencyMinRequirement(tendency: Tendency.dragon, min: 3),
      MagicPoolMinRequirement(min: 10),
    ]
  ),
  gardienMage(
    castes: [Caste.mage, Caste.mageNoir],
    isStandard: false,
    title: 'Gardien',
    motto: "Pour que la magie ne les consume",
    motivations: "Veiller, encadrer, protéger",
    description: "",
    interdict: CareerInterdict(
      title: 'Tu veilleras à la pureté de la magie.',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Autorité de Nenya',
      description: "Le mage dispose de tout pouvoir pour intervenir dans une affaire impliquant la magie. Il peut ainsi dessaisir les autorités locales de leurs prérogatives dans ce domaine, enquêter personnellement, et procéder à des arrestations en vue d'un jugement, pour lesquelles il peut réquisitionner toutes les forces nécessaires, qu'il s'agisse de miliciens, de soldats, ou encore de mages quels qu'ils soient.\nCompétences devenant Réservées : Investigation, Commandement.",
    ),
    specialization: "Aucune",
    requirements: [
      CasteMemberRequirement(caste: Caste.mage, status: CasteStatus.expert),
      MagicSphereAnyMinRequirement(min: 5, count: 3),
      MagicSphereAnyMinRequirement(min: 8, count: 1),
      MagicSkillAnyMinRequirement(min: 7),
      SingleSkillMinRequirement(skill: Skill.connaissanceDeLaMagie, min: 7),
      TendencyMinRequirement(tendency: Tendency.dragon, min: 3),
      ProficiencyMinRequirement(min: 8),
    ],
    reservedSkills: [Skill.investigation, Skill.commandement],
  ),
  generaliste(
    castes: [Caste.mage, Caste.mageNoir],
    title: 'Le généraliste',
    motto: "Puisse ma vie être assez longue pour en contempler tous les secrets",
    motivations: "Apprentissage, maîtrise, découverte",
    description: "Nombreux sont les magiciens, toutes tendances confondues, qui suivent cette carrière. Ils étudient toutes les formes de magie sans en privilégier aucune.",
    interdict: CareerInterdict(
      title: "Tu ne t'opposeras à aucun élément",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Le grimoire de Nenya',
      description: "Chaque fois qu’il atteint un Statut supérieur, le personnage peut apprendre gratuitement un sortilège de son choix - à la discrétion du meneur de jeu — sans effectuer aucun jet. Lorsqu’il embrasse cette carrière, le personnage peut immédiatement choisir un sortilège, qu’il apprend automatiquement.",
    ),
    specialization: "Ne peut se spécialiser en Connaissance de la magie.",
    requirements: [
      MagicSphereAnyMinRequirement(min: 5, count: 3),
      MagicSkillAnyMinRequirement(min: 5, count: 3),
      MagicSpellCountMinRequirement(min: 1, spheres: 3),
    ]
  ),
  guerisseurMage(
    castes: [Caste.mage, Caste.mageNoir],
    title: 'Le guérisseur',
    motto: "Le mage a le devoir de protéger la vie",
    motivations: "Générosité, respect, pacifisme",
    description: "Ces spécialistes de la Sorcellerie se consacrent à l’étude de l’utilisation de la magie sur les organismes. Bien qu’officiellement on parle de guérisseurs, il existe des écoles où les étudiants n’ont pas d'objectifs aussi nobles. On trouve donc des mages de toutes tendances dans cette carrière.",
    interdict: CareerInterdict(
      title: "Tu ne refuseras pas ton aide",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'La sève qui nous lie',
      description: "Sans effectuer le moindre jet, le personnage peut transférer vers lui n'importe quelle Blessure causée à un être vivant, qu’il soit humain ou animal. La Blessure est effacée, purement et simplement, et infligée au personnage en échange — les malus afférents s'appliquent directement. Au moment du transfert, le personnage peut éviter de subir une Blessure en utilisant sa force intérieure. Pour cela, il dispose d’un point par niveau de Statut - chaque Blessure ainsi annulée lui consommant un point et un point de magie de sa Sphère de la Nature ou de sa Réserve (à son choix).",
    ),
    specialization: "Connaissance de la magie (Sphère de la Nature) ou Premiers soins",
    requirements: [
      MagicSphereMinRequirement(sphere: MagicSphere.nature, min: 7),
      AbilityMinRequirement(ability: Ability.empathie, min: 7),
      AbilityMinRequirement(ability: Ability.volonte, min: 6),
      OneOfRequirements(
        requirements: [
          TendencyMinRequirement(tendency: Tendency.dragon, min: 3),
          TendencyMinRequirement(tendency: Tendency.human, min: 3)
        ]
      )
    ]
  ),
  invocateur(
    castes: [Caste.mage, Caste.mageNoir],
    title: "L'invocateur",
    motto: "Que les sceaux de Nenya s'ouvrent devant moi",
    motivations: "Étude, contrôle, tradition",
    description: "Ceux qui choisissent de se spécialiser dans la magie invocatoire suivent cette carrière. Ils maîtrisent la technique des Portails et tentent d’apporter une réponse sur l’existence ou non des autres mondes. De nombreux mages de Nenya et de Szyl sont attirés par cette profession.",
    interdict: CareerInterdict(
      title: "Tu ne mettras pas l'équilibre en péril",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Maîtrise des Portails',
      description: "Le personnage ajoute son niveau de Statut au score de base de tous ses jets d’Invocation. De plus, une fois par jour, il peut dépenser des points de Maîtrise après un jet d’Invocation, qu’il soit réussi ou raté, dans la limite de son niveau de Statut.",
    ),
    specialization: "Connaissance de la magie (Magie Invocatoire). Le personnage ne peut posséder d’autres Spécialisations de Connaissance de la magie concernant les Disciplines",
    requirements: [
      MagicSkillMinRequirement(skill: MagicSkill.invocatoire, min: 7),
      AbilityMinRequirement(ability: Ability.volonte, min: 6),
      AbilityMinRequirement(ability: Ability.perception, min: 6),
      OneOfRequirements(
        requirements: [
          TendencyMinRequirement(tendency: Tendency.dragon, min: 3),
          TendencyMinRequirement(tendency: Tendency.fatality, min: 3),
        ]
      ),
      TendencyMaxRequirement(tendency: Tendency.human, max: 0),
    ]
  ),
  mageDeCombat(
    castes: [Caste.mage, Caste.mageNoir],
    title: 'Le mage de combat',
    motto: "La noble arme du combat n'a ni garde, ni lame",
    motivations: "Courage, perfection",
    description: "Spécialisés dans la magie instinctive, les mages de combat sont souvent des fidèles de Kroryn, de Brorne ou de Kezyr. C’est ume carrière attirant souvent les plus jeunes au grand désespoir de Nenya.",
    interdict: CareerInterdict(
      title: "Tu ne t'opposras pas aux faibles",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Le feu du combat',
      description: "Au début de chaque tour de combat, le personnage peut ajouter son niveau de Statut à la valeur de l'un de ses dés d’Initiative. De plus, s’il se bat sans arme et en usant de magie, il ajoute son de Statut à ses dommages et divise par deux l’indice de protection de l’armure adverse.",
    ),
    specialization: "Connaissance de la magie (Magie Instinctive) ou une Compétence de Combat. Le personnage ne peut posséder d’autres Spécialisations de Connaissance de la magie concernant les Disciplines",
    requirements: [
      MagicSkillMinRequirement(skill: MagicSkill.instinctive, min: 7),
      AttributeMinRequirement(attribute: Attribute.physique, min: 6),
      AbilityMinRequirement(ability: Ability.coordination, min: 5),
      ProficiencyMinRequirement(min: 5),
    ]
  ),
  necromant(
    castes: [Caste.mageNoir],
    title: 'Le nécromant',
    motto: "La mort n'est qu'un passage, la mort n'est qu'un outil",
    motivations: "Outrepasser, contrôler, transcender",
    description: "",
    interdict: CareerInterdict(
      title: "L'Éternité n'existe pas",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Sacrifice',
      description: "Le nécromant peut canaliser l'énergie vitale d’un être en train de mourir, que ce soit de son fait ou d’une cause extérieure (maladie, vieillesse, combat, etc…). En se concentrant, il peut transformer cette énergie en Points de Magie. Il effectue un jet de Mental + Sphère de l’Ombre contre une Difficulté de 10. Le mage obtient 1 + 1 par Niveau de Réussite Point de Magie dans sa Sphère d’Ombre ou dans sa Réserve, jusqu'à un maximum égal au nombre de cases de blessures de la créature (cochées ou non). Il ne peut les attribuer à d’autres Sphères. Les Expert en Sphère de l'ombre sont les seuls à pouvoir utiliser ce Bénéfice sur un dragon ou une créature élémentaire (ou invoquée). Les morts vivants ne sont jamais affectés. Ces points sont durables et limités par la Sphère ou la Réserve. Ce Bénéfice doit être utilisé dans le même tour ou le tour suivant la mort de la victime.",
    ),
    specialization: "Nécromancie. Le personnage ne peut être spécialisé dans aucune Compétence Sociale",
    requirements: [
      AbilityMaxRequirement(ability: Ability.empathie, max: 4),
      TendencyMinRequirement(tendency: Tendency.fatality, min: 3),
      SingleSkillMinRequirement(skill: Skill.necromancie, min: 6),
      MagicSkillMinRequirement(skill: MagicSkill.invocatoire, min: 5),
    ]
  ),
  profanateur(
    castes: [Caste.mageNoir],
    title: 'Le profanateur',
    motto: "Nulle règle n'élève l'homme",
    motivations: "Libérer, corrompre, éveiller",
    description: "",
    interdict: CareerInterdict(
      title: "Tu ne t'engageras jamais",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Murmures des ombres',
      description: "Lorsqu’il tente de modifier les convictions d’une personne (que ce soit par l’utilisation d’un sort ou par Baratin ou Psychologie), le personnage peut ajouter sa Tendance Fatalité au résultat de son jet. Il est alors investi de la langue mielleuse de Kalimsshar et trouve plus facilement les mots qui sèmeront le doute, provoqueront la sédition et libéreront son interlocuteur du carcan de ses convictions. Bon nombre de ces mages sont alliés avec les Tentateurs, auxquels ils fournissent une aide magique considérable.",
    ),
    specialization: "Psychologie",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.social, min: 5),
      SingleSkillMinRequirement(skill: Skill.psychologie, min: 6),
      SingleSkillMinRequirement(skill: Skill.discretion, min: 5),
      SingleSkillMinRequirement(skill: Skill.castes, min: 5),
      MagicSkillMinRequirement(skill: MagicSkill.instinctive, min: 5),
    ]
  ),
  questeurBlanc(
    castes: [Caste.mage, Caste.mageNoir],
    isStandard: false,
    title: 'Questeur blanc',
    motto: "-",
    motivations: "Veiller, intervenir, sévir",
    description: "Chargés d'enquêter sur les affaires affectant la magie, son usage ou sa pureté, les Questeurs blancs appartenaient jusqu'en 1311 à la corporation des Questeurs. Ce quatre hommes et femmes désignés par Nenya agissaient sous la responsabilité directe du Grand Commandeur et étaient compétents sur l'ensemble de Kor. Lors du Conseil éthernien, les Questeurs blancs furent dissociés des Questeurs et placés sous la responsabilité du Collège des Gardiens suprêmes. À la demande de la Chimère, Tadd Lenkel recruta des membres supplémentaires, portant leur nombre à neuf.\nLes Questeurs blancs sont en quelque sorte l'élite des Gardiens ; ils ne leurs sont pas supérieurs hiérarchiquement mais dans les faits, ce sont des mages plus puissants qui choisissent eux-mêmes leurs affaires (en ce sens, ils peuvent s'emparer d'une affaire traitée par un autre Gardien) et ont la possiblité de les juger sans en référer au Collège des Gardiens suprêmes. Ces pouvoirs sont certes impressionnants, mais ils se sont pas placés entre les mains de n'importe qui : chacun des neuf Questeurs blancs est l'égal des grands maîtres de caste, et a rencontré Nenya qui a confirmé sa nomination. Lenkel, qui court-circuite souvent le Collège des Gardiens suprêmes en traintant directement les Questeurs blancs, les considère comme des frères et sœurs. Toujours à la recherche des Sorciers Obscurs, il est d'aileurs considéré comme “le Dixième Questeur”.\nContrairement aux Gardiens, les Questeurs blancs disposent de pouvoirs permanents adaptés à l'ampleur de leur mission. S'ils ont eux aussi vocation à encadrer l'usage de la magie, ils ont avant tout la lourde tâche de lutter contre les crimes magiques, c'est à dire les méfaits perpétrés par des individus faisant appel à la magie ainsi que les agissements de tous les individus ou groupes dévoyant la magie pour asseoir leur pouvoir. Outre les Sorciers Obscurs, les Questeurs blancs pourchassent également l'Ordre Fataliste et les mages-ingénieurs ayant refusé d'abandonner leurs recherches, et ils ont reçu pour mission de lutter aux côtés de certains dragons contre les Seigneurs ardents et leurs serviteurs.",
    interdict: CareerInterdict(
      title: "Tu protégeras l'homme de la magie, et la magie de l'homme",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "Prééminence",
      description: "Dans le cadre d'une investigation, le Questeur blanc est tout puissant et s'impose à tous, ne répondant de ses actes que devant les Gardiens suprêmes, Tadd Lenkel et Nenya elle-même. De plus, il est investi d'une aura éthérée conférée par la Chimère qui lui attribue un bonus de 5 à tout jet de Social.\nCompétences devenant Réservées : Loi, Investigation, Commandement.",
    ),
    specialization: "Aucune",
    requirements: [
      CasteMemberRequirement(caste: Caste.mage, status: CasteStatus.maitre),
      MagicSphereAnyMinRequirement(min: 1, count: 5),
      MagicSphereAnyMinRequirement(min: 8, count: 3),
      MagicSkillMinRequirement(skill: MagicSkill.instinctive, min: 7),
      MagicSkillMinRequirement(skill: MagicSkill.invocatoire, min: 7),
      MagicSkillMinRequirement(skill: MagicSkill.sorcellerie, min: 7),
      TendencyMinRequirement(tendency: Tendency.dragon, min: 4),
      ProficiencyMinRequirement(min: 8),
    ],
    reservedSkills: [Skill.lois, Skill.investigation, Skill.commandement],
  ),
  reveur(
    castes: [Caste.mage, Caste.mageNoir],
    title: 'Le rêveur',
    motto: "La vérité n'est pas de ce monde, mais le celui des Rêves",
    motivations: "Observer, comparer, analyser",
    description: "Ces magiciens apprennent toutes les techniques du rêve. La plupart souhaitent être aussi fidèles que possible aux enseignements de Nenya. C’est un métier difficile qui demande une prédisposition que tous n'ont pas. Les rêveurs sont souvent des gens qui passent le plus clair de leur temps la tête dans les nuages.",
    interdict: CareerInterdict(
      title: "Tu ne pertuberas pas l'ordre naturel",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'illusion du corps",
      description: "En plongeant dans le monde éthéré de Nenya, l'esprit du personnage peut quitter son enveloppe charnelle et voyager quelques temps dans la réalité de Chimère. Pour cela, il doit effectuer un jet de Mental + Sphère des Rêves + niveau de Statut, contre une Difficulté de 20. S'il procède à un rituel de préparation, le mage peut dépenser des points de Maîtrise et des Points de Magie de sa Sphère des Rêves pour augmenter son score de base. Si le jet est réussi, il quitte corps son pendant 5 minutes + 3 par Niveau de Réussite. Une fois désincarné, le mage n'est plus soumis à aucune contrainte physique et peut donc, par exemple, traverser librement la matière. Il lui est également possible d'influencer le monde réel - faire bouger un objet ou toucher quelqu'un, par exemple – en dépensant 1 Point de Réserve de Magie de Volonté et en réussissant un jet de Mental + Volonté contre une Difficulté de 15. S'il obtient un Niveau de Réussite, il ne dépense rien. Il est impossible d'effectuer le moindre dommage direct de cette façon, d'utiliser des pouvoirs ayant des effets physiques ou de parler. Les pouvoirs mentaux fonctionnent normalement, du moment que le mage réussit son jet et dépense 1 point si besoin est.\nCependant, tant qu'il est dans l'éther, le personnage n'a aucune conscience de ce que ressent son corps - sauf, bien sûr, s'il l'observe depuis l'éther. En cas de contact physique, de douleur ou de grand bruit, le mage peut néanmoins effectuer un jet de Mental + Perception contre une Difficulté de 15 pour comprendre le danger. Ce pouvoir peut être utilisé une fois par jour.\nSi le personnage dort, la Difficulté du premier jet est réduite de 10 - mais il continue de dépenser ses points normalement.",
    ),
    specialization: "Connaissance de la magie (Sphère des rêves) ou Cartographier les rêves",
    requirements: [
      MagicSphereMinRequirement(sphere: MagicSphere.reves, min: 7),
      AttributeMinRequirement(attribute: Attribute.mental, min: 7),
      AbilityMinRequirement(ability: Ability.empathie, min: 7),
    ]
  ),
  specialisteDesRituels(
    castes: [Caste.mage, Caste.mageNoir],
    title: 'Le spécialiste des rituels',
    motto: "La clé de toute puissance réside dans les traditions",
    motivations: "Expérimentation, tradition, découverte",
    description: "Les mages qui suivent cette carrière se spécialisent dans les sortilèges les plus complexes demandant beaucoup de temps et une grande coopération. Ce n’est pas une profession où l’on voyage beaucoup et elle ne s'adresse donc pas à des aventuriers.",
    interdict: CareerInterdict(
      title: 'Tu suivras la Voie du Secret',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Maîtrise des Rituels',
      description: "Le personnage ajoute son niveau au score de base de tous ses jets de Sorcellerie. De plus, il réduit la durée d’apprentissage des sorts de Sorcellerie de 10% par niveau de Statut (de -20% pour un 2e Statut à -50% pour un 5e Statut).",
    ),
    specialization: "Connaissance de la magie (Sorcellerie). Le personnage ne peut posséder d’autres Spécialisations de Connaissance de la magie concernant les Disciplines.",
    requirements: [
      MagicSkillMinRequirement(skill: MagicSkill.sorcellerie, min: 7),
      AbilityMinRequirement(ability: Ability.intelligence, min: 7),
      AttributeMinRequirement(attribute: Attribute.manuel, min: 6),
      SingleSkillAnyImplementationMinRequirement(skill: Skill.artisanat, min: 5),
    ]
  ),
  specialisteElementaire(
    castes: [Caste.mage, Caste.mageNoir],
    title: 'Le spécialiste élémentaire',
    motto: "La seule force est celle que procure la maîtrise",
    motivations: "Contrôle, expérimentation, maîtrise",
    description: "Les spécialistes élémentaires se consacrent à l'étude d’une seule Sphère. Ce sont les magiciens les plus répandus, car leur maîtrise de la Sphère est souvent source de grands pouvoirs.",
    interdict: CareerInterdict(
      title: "Tu ne vivras que pour un élément",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "Guidé par l'élément",
      description: "Chaque matin, au réveil, le personnage peut effectuer un jet de Mental + Sphère spécialisée contre une Difficulté de 10. S’il réussit, il gagne pour la journée un nombre de Points de Magie de sa Sphère égal à son niveau de Statut + le nombre de Niveaux de Réussite du jet. Les points non dépensés sont perdus le lendemain matin.",
    ),
    specialization: "Connaissance de la magie (Sphère de prédilection)",
    requirements: [
      MagicSphereAnyMinRequirement(min: 7, count: 1),
      AbilityMinRequirement(ability: Ability.volonte, min: 6),
      AbilityMinRequirement(ability: Ability.empathie, min: 7),
    ]
  ),
  tueurDeReves(
    castes: [Caste.mageNoir],
    title: 'Le tueur de rêves',
    motto: "L'inconscient sera notre champ de bataille",
    motivations: "Explorer, dévoiler, transformer",
    description: "",
    interdict: CareerInterdict(
      title: "Tu ne pénètreras jamais l'esprit des dragons",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Intrusion mentale',
      description: "Le tueur de rêves acquiert un bonus égal à sa Tendance Fatalité lorsqu’il utilise un sort visant à entrer dans l’esprit d’une victime plongée dans un cauchemar (le meneur de jeu est libre de décider de la présence de ce cauchemar). Une fois dans l’Éther, il peut ajouter sa Tendance Fatalité à tous ses jets impliquant l’Attribut Social.",
    ),
    specialization: "Cartographier les rêves",
    requirements: [
      MagicSphereMinRequirement(sphere: MagicSphere.reves, min: 4),
      MagicSphereMinRequirement(sphere: MagicSphere.ombre, min: 5),
      MagicSkillMinRequirement(skill: MagicSkill.invocatoire, min: 7),
      SingleSkillMinRequirement(skill: Skill.psychologie, min: 5),
    ]
  ),

  gardienProdige(
    castes: [Caste.prodige],
    title: 'Le gardien',
    motto: "Que Heyra me soutienne, je ne faillirai point",
    motivations: "Accompagner, défendre",
    description: "Les gardiens sont les combaitants de la Caste des Prodiges. Ils maîtrisent toutes les formes de combat visant à neutraliser un adversaire, mais sont aussi capables de tuer avec autant de savoir faire qu’un guerrier. Ils sont célèbres pour leur redoutable adresse avec des armes doubles. Protecteurs des lieux saints, des temples et des monastères, ce sont pour la plupart des individus d’un calme olympien.",
    interdict: CareerInterdict(
      title: "Tu n'abandonneras pas ton devoir",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'La justesse du devoir',
      description: "Lorsqu'il se bat pour la cause qui lui a été attribuée, le personnage ajoute la valeur de sa Tendance Dragon à tous ses jets d’attaque et de défense. De plus, une fois par tour, il peut ajouter le niveau de son Statut à l’un de ses dés d'attaque, de défense ou d’Initiative.",
    ),
    specialization: "Armes doubles (Shaaduk’t) ou Esquive",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.physique, min: 6),
      AbilityMinRequirement(ability: Ability.volonte, min: 6),
      TendencyCirclesMaxRequirement(tendency: Tendency.fatality, max: 0),
      MultipleSkillsInFamilyMinRequirement(family: SkillFamily.combat, count: 1, min: 7),
    ]
  ),
  ceuxQuiNeFontQuUn(
    castes: [Caste.prodige],
    isStandard: false,
    title: "Ceux qui ne font qu'un",
    motto: "Tout en un et un en tout",
    motivations: "Harmoniser, protéger, respecter",
    description: "",
    interdict: CareerInterdict(
      title: 'Tu ne domineras jamais la Nature',
      description: "",
    ),
    benefit: CareerBenefit(
      title: "Ne faire qu'un",
      description: "Le personnage devient capable de libérer son esprit de son enveloppe corporelle pour fusionner avec l'Esprit de la Nature. Il peut développer les Privilèges de Ceux-qui-ne-font- qu'un (voir ci-après). Lorsqu'il est désincarné, le personnage reste conscient de ce qu'il advient de son corps et peut se réincarner en un tour. Il peut rester désincarné jusqu'à (Sphère de la Nature) heures par jour, que ce soit d'une traite ou par fractions. Dans cet état spirituel, il ne peut entrer dans les cités ou les villages, ni y utiliser ses pouvoirs ou y voir quoi que ce soit, ces zones lui restant brumeuses. Il ne peut pas communiquer avec son environnement si ce n'est par ses Privilèges ou par magie (tous les sorts affectant son esprit lorsqu'il se désincarne restent actifs). Il peut toujours tenter d'utiliser la magie, mais n'est plus capable d'exécuter des gestes, des chants ou des postures.\nSi un Prodige meurt de façon violente lors d'une désincarnation, son corps devient de pierre et son esprit reste fusionné avec l'Esprit de la Nature. S'il décède de mort naturelle, son corps se dissipera en quelques secondes pour ne laisser que ses possessions.",
    ),
    specialization: "Sphère de la Nature (considérée comme Réservée)",
    requirements: [
      OneOfRequirements(
        requirements: [
          CasteMemberRequirement(caste: Caste.prodige, status: CasteStatus.expert),
          CasteMemberRequirement(caste: Caste.mage, status: CasteStatus.expert),
        ]
      ),
      MagicPoolMinRequirement(min: 12),
      MagicSphereMinRequirement(sphere: MagicSphere.nature, min: 5),
      AbilityMinRequirement(ability: Ability.empathie, min: 9),
      AbilityMinRequirement(ability: Ability.volonte, min: 7),
    ]
  ),
  fervent(
    castes: [Caste.prodige],
    title: 'Le fervent',
    motto: "Toute vie s'entretient, aucune n'est inutile",
    motivations: "Aider, pardonner",
    description: "Les fervents sont également appelés les jardiniers. Ils s’occupent des arbres, des plantes et des fleurs. Ils sont l’incarnation de la vie végétale à laquelle ils consacrent toute leur existence. Les plus grands fervents sont récompensés en acquérant une plus grande robustesse et en bénéficiant de la protection du règne végétal.",
    interdict: CareerInterdict(
      title: 'Tu ne tueras point',
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'illusion des tendances",
      description: "En réussissant un jet de Mental + Tendance Dragon + niveau de Statut contre une Difficulté de 10, le personnage peut introduire le doute dans l’esprit de n'importe quel être humain et réduire la valeur d’une de ses Tendances de 1 point par Niveau de Réussite. Ce changement momentané dure 1 heure + 1 par point de Tendance Dragon du personnage. S’il obtient une réussite critique, la victime perd définitivement 1 point de Tendance.\nDe plus, une fois par jour, le personnage peut effacer un nombre de cercles de n’importe quelle Tendance égal à son niveau de Statut + 2. Il n’est besoin d’aucun jet, mais l’interlocuteur du personnage doit être consentant.",
    ),
    specialization: "Tendance Dragon. Cette Spécialisation répond à des règles spécifiques. Elle ne se gère pas comme une Spécialisation de Compétence, mais compte dans le total des Spécialisations du personnage. Le personnage ne peut plus utiliser volontairement les Tendances, mais regagne un point de plus en Chance ou en Maîtrise lorsqu’il doit en gagner (en plus d’autres bonus). Il double tous les cercles d’Homme et de Fatalité obtenus par ses actions.",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.social, min: 6),
      AbilityMinRequirement(ability: Ability.empathie, min: 6),
      SingleSkillMinRequirement(skill: Skill.connaissanceDesDragons, min: 5),
      SingleSkillMinRequirement(skill: Skill.psychologie, min: 6),
      TendencyCirclesMaxRequirement(tendency: Tendency.fatality, max: 0),
      PrivilegeCountMinRequirement(min: 3),
    ]
  ),
  guerisseurProdige(
    castes: [Caste.prodige],
    title: 'Le guérisseur',
    motto: "Aucun fils de Heyra ne mérite de mourir",
    motivations: "Guérir, partager, servir",
    description: "Ce sont les champions de la vie et de la notion “d’humanité” appliquée à toutes les créatures vivantes. Ils ne vivent que pour guérir, jamais pour détruire. Ce sont généralement des êtres bons et généreux qui s’occupent de tous sans poser de questions ni porter de jugement. Un guérisseur soignera un Fataliste, et même un Humaniste, sans hésiter.",
    interdict: CareerInterdict(
      title: 'Tu ne refuseras pas ton aide',
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'amour de la terre",
      description: "En effectuant un jet de Mental + Empathie + niveau de Statut contre une Difficulté de 10, le personnage peut soigner 1 Blessure + 1 par Niveau de Réussite. Ces Blessures sont guéries dans l’ordre croissant, en commençant par les Légères. Il est impossible d’effacer une Blessure Mortelle de cette façon.\nDe plus, rien qu’en le touchant, le personnage peut effacer toutes les Égratignures de n’importe quel être vivant. Il n’est besoin d’effectuer aucun jet, du moment que le personnage parvient à établir un contact physique prolongé.\nCe pouvoir peut être utilisé autant de fois que le niveau de Statut du personnage.",
    ),
    specialization: "Médecine",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.mental, min: 6),
      AttributeMinRequirement(attribute: Attribute.manuel, min: 5),
      SingleSkillMinRequirement(skill: Skill.medecine, min: 5),
      SkillAttributeTotalPointsRequirement(attribute: Attribute.mental, min: 40),
    ]
  ),
  mediateur(
    castes: [Caste.prodige],
    title: 'Le médiateur',
    motto: "Le conflit n'existe que dans sa solution",
    motivations: "Intervenir, raisonner, résoudre",
    description: "Les médiateurs sont chargés d’aller de communauté en communauté pour arbitrer des conflits. Leur venue est souvent attendue par de nombreux villages pour régler des litiges ou juger des criminels. C’est une voie très difficile car le Prodige est rarement confronté à des affaires simples. De plus, le médiateur doit garantir la stabilité de la communauté et éviter de faire naître des rancunes. C’est une voie demandant une grande diplomatie et une très bonne connaissance des hommes. Il faut signaler qu’un médiateur peut également s’occuper des conflits entre humains et dragons et même entre des animaux et les humains.",
    interdict: CareerInterdict(
      title: 'Tu ne permettras aucun conflit',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Le visage de Solyr',
      description: "Chaque fois qu’il intervient pour régler un différent, le personnage ajoute le niveau de son Statut à son Attribut Social. De plus, la notoriété de sa caste et de sa fonction lui assure une sécurité et une intégrité quasi totale — sur l’ensemble du Royaume de Kor, il est en effet considéré comme un crime que de s’en prendre à un diplomate de Heyra.\nDe plus, le personnage gagne un cercle de Tendance Dragon par conflit ainsi résolu.",
    ),
    specialization: "Diplomatie",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.social, min: 7),
      AbilityMinRequirement(ability: Ability.intelligence, min: 6),
      SingleSkillMinRequirement(skill: Skill.psychologie, min: 4),
      SingleSkillMinRequirement(skill: Skill.diplomatie, min: 6),
    ]
  ),
  missionnaire(
    castes: [Caste.prodige],
    title: 'Le missionnaire',
    motto: "Nous sommes le souvenir des oubliés de Nature",
    motivations: "Voyager, révéler",
    description: "Les missionnaires voyagent au-delà des terres draconiques et visitent les communautés ignorantes des Lois Draconiques. Ce sont des explorateurs particulièrement ouverts. Certains se rendent même dans des villes humanistes ou fatalistes pour y prêcher la bonne parole. Les missionnaires sont ceux qui s’exposent le plus. Il arrive que certains renoncent à leurs vœux ou soient irrémédiablement attirés vers l’Humanisme ou le Fatalisme. Beaucoup trouvent la mort au cours de leurs voyages.",
    interdict: CareerInterdict(
      title: 'Tu ne subiras pas le doute',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Apporter la lumière',
      description: "En discutant avec des hérétiques, le personnage peut effacer son niveau de Statut en cercles de Tendance Homme ou Fatalité. Il lui suffit pour cela de réussir un jet de Volonté + Empathie contre une Difficulté de 15. Ce pouvoir fonctionne autant de fois par jour que sa Tendance Dragon et sur une seule cible à la fois. La victime n’a pas à être consentante, elle doit juste pouvoir écouter le prêche.",
    ),
    specialization: "Tendance Dragon. Cette Spécialisation répond à des règles spécifiques. Elle ne se gère pas comme une Spécialisation de Compétence, mais compte dans le total des Spécialisations du personnage. Le personnage ne peut plus utiliser volontairement les Tendances et double tous les cercles d’Homme et de Fatalité obtenus par ses actions.",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.social, min: 6),
      AbilityMinRequirement(ability: Ability.volonte, min: 6),
      PrivilegeCountMinRequirement(min: 3),
      SingleSkillMinRequirement(skill: Skill.geographie, min: 5),
      SingleSkillMinRequirement(skill: Skill.eloquence, min: 6),
      TendencyMaxRequirement(tendency: Tendency.human, max: 0),
      TendencyMaxRequirement(tendency: Tendency.fatality, max: 0),
    ]
  ),
  poeteDeLaNature(
    castes: [Caste.prodige],
    title: 'Le poète de la nature',
    motto: "Mille fleurs font un jardin, mille jardins, une ode",
    motivations: "Magnifier, louer, partager",
    description: "Artistes et poètes, ces Prodiges ne vivent que pour embellir la nature. Proches de Nenya et de ses fidèles, mais aussi de Szyl, ce sont des individus pacifiques. On dit que certains peuvent, grâce à leur art, faire s’épanouir des fleurs en plein hiver. Ils sont très proches de certains animaux, comme les oiseaux chanteurs.",
    interdict: CareerInterdict(
      title: 'Tu ne briseras aucune harmonie',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'La terre est mon jardin',
      description: "Du moment qu’il se trouve entouré de végétation, le personnage peut, en réussissant un jet de Mental + Empathie contre une Difficulté de 15, disparaître à la vue de n’importe quel observateur humain ou animal pendant 1 minute par niveau de Statut + 1 par Niveau de Réussite. Tant que l’une de ses mains reste en contact avec un arbre ou le sol, le personnage peut se déplacer et effectuer toutes sortes d’actions — le vent et les craquements couvriront même ses bruits éventuels. Tous les jets de perception voient leur Difficulté augmentée de 10 pour le localiser ou comprendre sa présence.\nLes dragons et Élus de Heyra d'âge ou de niveau égal ou supérieur au Statut du personnage ne sont pas affectés par ce pouvoir.",
    ),
    specialization: "Don artistique (au choix)",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.mental, min: 5),
      AbilityMinRequirement(ability: Ability.empathie, min: 6),
      SingleSkillAnyImplementationMinRequirement(skill: Skill.donArtistique, min: 5, comment: "en rapport avec la nature"),
      SingleSkillMinRequirement(skill: Skill.conte, min: 5),
      SingleSkillImplementationMinRequirement(skill: Skill.artisanat, implementation: "Horticulture", min: 6),
    ]
  ),
  prodigeAnimal(
    castes: [Caste.prodige],
    title: 'Le prodige animal',
    motto: "Nous sommes tous fils de Heyra",
    motivations: "Respecter, protéger",
    description: "Les Prodiges animaux sont liés aux créatures sauvages de la nature. Ils partagent leur vie et s’intègrent entièrement à la nature. Un tel Prodige s'associe généralement à une seule espèce dont il accepte les lois. En récompense, les animaux reconnaissent en lui un des leurs et Heyra lui donne le don de prendre la forme de cet animal. Ces Prodiges sont les plus solitaires et les plus éloignés des lois humaines.",
    interdict: CareerInterdict(
      title: "Tu n'enfreindras pas les lois de la nature",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Mon âme est celle de la nature',
      description: "Une fois par jour, en réussissant un jet de Mental + Empathie contre une Difficulté de 15, le personnage peut projeter son esprit dans le corps de n’importe quel animal pour partager ses sensations, voir par ses yeux et entendre par ses oreilles. Il peut ainsi rester 1 minute par Niveau de Réussite + niveau de Statut. Pour tenter d’influencer le corps de son hôte, le personnage doit réussir un jet de Mental + Volonté + niveau de Statut contre une Difficulté de 10. Chaque Niveau de Réussite lui donne le droit d’effectuer une action, dans la mesure des capacités physiques de son hôte — un serpent ne pourra jamais ouvrir une porte, par exemple. Si ce jet est raté, le Prodige est immédiatement expulsé du corps et ne peut plus utiliser son pouvoir pour le reste de la journée.\nIl est possible, en fonction des circonstances, que l’animal accepte de son plein gré d’aider le Prodige. Dans ce cas, aucun jet n’est nécessaire pour influencer le corps de l’animal. Les végétaux et les minéraux, considérés comme vivants par Heyra, peuvent être utilisés comme hôtes, mais le meneur de jeu est libre de décrire au personnage des émotions et des sensations quelque peu déstabilisantes…",
    ),
    specialization: "Connaissance des animaux ou Faune et flore",
    requirements: [
      AbilityMinRequirement(ability: Ability.empathie, min: 7),
      SingleSkillMinRequirement(skill: Skill.connaissanceDesAnimaux, min: 6),
      TendencyMaxRequirement(tendency: Tendency.human, max: 0),
      OneOfRequirements(
        requirements: [
          HasSphereDraconicLinkRequirement(sphere: MagicSphere.nature),
          HasSphereDraconicLinkRequirement(sphere: MagicSphere.oceans),
          HasSphereDraconicLinkRequirement(sphere: MagicSphere.vents),
          HasSphereDraconicLinkRequirement(sphere: MagicSphere.pierre),
        ]
      )
    ]
  ),
  prophete(
    castes: [Caste.prodige],
    title: 'Le prophète',
    motto: "Le printemps suit l'hiver, l'avenir suit le présent",
    motivations: "Observer, comprendre, enseigner",
    description: "S’adonnant entièrement à la méditation et à l’écoute de la nature, les prophètes sont les plus silencieux et les plus réfléchis de la caste. Il leur arrive de percevoir le futur et ils doivent alors prendre la terrible décision de le révéler ou non. Ils réfléchissent toujours à leurs actes et, s’ils révèlent un secret, ils le confient à tous. Il arrive qu’un prophète se rapproche tellement de la nature que son esprit s’y égare. Son âme quitte à jamais son corps et se mêle aux plaines et aux forêts. Sa dépouille ne pourrit pas mais se pétrifie lentement. On dit que ces âmes peuvent entrer en contact avec ceux qui les prient. Les statues de pierre de ces Prodiges sont souvent des lieux de recueillement.",
    interdict: CareerInterdict(
      title: "Tu ne pertuberas pas l'ordre naturel",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Le cycle de la vie',
      description: "S’il n’a gagné aucun cercle de Tendance Homme ou Fatalité durant la journée, le personnage peut entrer en méditation et effectuer un jet de Mental + Méditation + niveau de Statut contre une Difficulté de 15. Pour chaque Niveau de Réussite qu’il obtient, il peut déterminer l'avenir et gagner réponse à une de ses questions. Certaines issues étant plus obscures que d’autres, le meneur de jeu reste libre de se montrer évasif ou d’exiger deux Niveaux de Réussite pour cette réponse.",
    ),
    specialization: "Méditation (selon conditions extérieures : en forêt, la nuit, en montagne…).",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.mental, min: 6),
      AbilityMinRequirement(ability: Ability.intelligence, min: 5),
      AbilityMinRequirement(ability: Ability.empathie, min: 7),
      HasAdvantageRequirement(advantage: Advantage.pressentiment),
      HasNoDraconicLinkRequirement(),
    ]
  ),
  sage(
    castes: [Caste.prodige],
    title: 'Le sage',
    motto: "Le doute est l'allié de l'aveuglement",
    motivations: "Comprendre, enseigner",
    description: "Les sages sont des Prodiges qui aident les autres à trouver la réponse à leurs questions. Ce sont des conseillers et des rédempieurs. Ils tenteront toujours de ramener dans le droit chemin ceux qui se sont égarés. Ils sont ouverts à tous, aussi bien aux riches qu’aux pauvres, aux forts qu'aux faibles. Ils apportent la sagesse d’Heyra et peuvent, par conséquent, préconiser certaines mesures strictes pour résoudre un problème. Cependant, le recours à la violence et la condamnation sans appel d’une créature sont des solutions extrêmes, prises en désespoir de cause. Les sages sont souvent sollicités pour déterminer si une personne peut devenir Prodige. De plus, bon nombre de Prodiges n’arrivant pas à percevoir clairement leur voie font appel à eux.",
    interdict: CareerInterdict(
      title: 'Tu ne garderas aucun secret',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Guider l’âme',
      description: "S’il est témoin d’une action entraînant le gain de cercles de Tendances, il peut annuler ce gain en entamant une discussion avec le personnage concerné moins d’une heure après l’action et si ce dernier est consentant. Il ne peut par ce Bénéfice agir sur les cercles gagnés par le choix des dés de Tendances. De plus, autant de fois par jour que son niveau de Statut, il peut percevoir intuitivement la Tendance dominante d’une cible en réussissant un jet de Volonté + Empathie contre une Difficulté de 20. Par NR, il peut obtenir la valeur chiffrée d’une Tendance. Cet examen de conscience est indétectable et ne demande que d’entendre quelques phrases prononcées par la cible.",
    ),
    specialization: "Mental. Les autres attributs coûtent deux fois plus de points à augmenter.",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.mental, min: 7),
      AbilityMinRequirement(ability: Ability.intelligence, min: 6),
      AbilityMinRequirement(ability: Ability.presence, min: 6),
      SkillFamilyTotalPointsRequirement(family: SkillFamily.theorie, min: 20),
    ]
  ),
  tuteur(
    castes: [Caste.prodige],
    title: 'Le tuteur',
    motto: "Le vent porte partout la parole de notre Mère",
    motivations: "Apprendre, découvrir, partager",
    description: "Les tuteurs sont des Prodiges beaucoup moins spécialisés que la plupart des autres membres de la caste. Ce sont des voyageurs qui tentent d’apporter la sagesse d’Heyra aux communautés qu’il visitent. Leur rôle est de partager leur savoir avec les futurs Prodiges. Au début de leur carrière, ils voyagent beaucoup pour apprendre et, dans certains cas, pour trouver un Maître des Secrets. Puis, quand ils se sentent suffisamment formés, ils reviennent dans un monastère - ou vont de monastère en monastère - pour enseigner leur art.",
    interdict: CareerInterdict(
      title: "Tu n'auras d'autre maître que la voie du savoir",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "Le Regard avisé",
      description: "Le personnage double ses points d’expérience acquis en Découverte, Magie et Implication. Il peut donner à un autre personnage une partie de ces points en plus afin de lui enseigner une Compétence qu’il possède. Pour cela, il doit posséder dans cette Compétence un score au moins égal à celui visé par le personnage recevant l’enseignement.",
    ),
    specialization: "Psychologie",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.mental, min: 6),
      AttributeMinRequirement(attribute: Attribute.social, min: 5),
      AbilityMinRequirement(ability: Ability.empathie, min: 6),
      SingleSkillMinRequirement(skill: Skill.psychologie, min: 5),
      SkillAttributeTotalPointsRequirement(attribute: Attribute.mental, min: 40),
    ]
  ),

  gardeDuCorps(
    castes: [Caste.protecteur, Caste.protecteurNoir],
    title: 'Le garde du corps',
    motto: "Il n'y a pas de plus noble cause que celle de la vie",
    motivations: "Protéger, honorer, servir",
    description: "Cette profession attire peu d’individus car elle souffre d’un important manque de prestige. Tout à fait immérité d’ailleurs car ses membres comptent parmi les meilleurs soldats du royaume et, bien souvent, on leur confie des responsabilités écrasantes. Ils peuvent être employés pour protéger des dignitaires, pour escorter des convois marchands ou porter des messages de la plus haute importance.",
    interdict: CareerInterdict(
      title: 'Tu accepteras tout sacrifice',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Ton ennemi est le mien',
      description: "Lorsqu'il se bat aux côtés de son protégé, et que celui-ci est visé par une attaque, le personnage peut tenter de s’interposer et effectuer une parade à sa place ou en même temps que lui. Dans les deux cas, la Difficulté du jet est de 15 et ne subit que les malus liés aux éventuelles pénalités d’action ou de blessures du personnage. S’il part seul, sa réussite est comparée à celle de l’attaquant et, s’il échoue, c’est lui qui subit pleinement les effets de l'attaque - ainsi que la possibilité d’une riposte. Si les parades sont simultanées, les deux jets s’effectuent en parallèle, chacun contre sa Difficulté, et les Niveaux de Réussite s'additionnent. Là encore, c’est le garde du corps qui subit les effets d’un échec ou bénéficie de l'opportunité d’une riposte.\nCette technique ne peut être utilisée qu’une fois par tour, et seulement si le personnage dispose d’un dé d'action qu’il peut dépenser au moment de l'attaque - quelle que soit sa valeur.",
    ),
    specialization: "Bouclier",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.physique, min: 6),
      AbilityMinRequirement(ability: Ability.coordination, min: 3),
      AbilityMinRequirement(ability: Ability.perception, min: 6),
      MultipleSkillsInFamilyMinRequirement(family: SkillFamily.combat, count: 3, min: 6),
      PrivilegeCountMinRequirement(min: 3),
    ]
  ),
  hommeDragon(
    castes: [Caste.artisan, Caste.combattant, Caste.commercant, Caste.erudit, Caste.mage, Caste.prodige, Caste.protecteur, Caste.voyageur],
    isStandard: false,
    title: 'Homme-dragon',
    motto: "Le dragon a parlé. J'entends et j'obéis !",
    motivations: "Servir, glorifier, périr",
    description: "",
    interdict: CareerInterdict(
      title: 'Hésiter est déjà trahir',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Héritage des écailles',
      description: "Le personnage passe plusieurs semaines à subir une mystérieuse métamorphose dans un lieu où Brorne l'emporte. À son retour, il est irrémédiablement devenu un homme-dragon. Il peut développer les dons propres à cette carrière (et qui lui sont exclusifs). Il peut développer jusqu'à dix Spécialisations, toutes les Compétences sont comptées comme Générales et ses mentors seront toujours des dragons. Ses Caractéristiques peuvent atteindre 15, tout comme ses Attributs. Il ne subit plus les malus de blessure (toutes ses cases de Blessure sont fusionnées), son seuil de Mort passe à 51 et il obtient une seconde case de Mort. Son espérance de vie est d'environ RES siècles, mais il lui est interdit de se reproduire (tout manquement provoque la mise à mort du fautif, du partenaire et du descendant, qui s'il s'en sortait, aurait 1 chance sur 10 d'être un Orphelin). Il conserve toutes ses capacités spéciales découlant de son ancienne profession, mais brise tout Lien, sans toutefois provoquer de drame, vu qu'il cesse d'être un humain pour devenir lui même draconique.",
    ),
    specialization: "Une Compétence d'arme (quel que soit le nombre déjà développé)",
    requirements: [
      AbilityMinRequirement(ability: Ability.volonte, min: 10),
      AttributeMinRequirement(attribute: Attribute.physique, min: 8),
      SingleSkillMinRequirement(skill: Skill.connaissanceDesDragons, min: 8),
      TendencyMinRequirement(tendency: Tendency.dragon, min: 5),
      TendencyCirclesMaxRequirement(tendency: Tendency.human, max: 0),
      TendencyCirclesMaxRequirement(tendency: Tendency.fatality, max: 0),
      WeaponSkillsMinRequirement(min: 10),
      RenownMinRequirement(min: 6),
      SimpleDescriptionRequirement("Plusieurs exploits à son actif"),
      SimpleDescriptionRequirement("Le patronage d'au moins un Vieux dragon de Pierre ou d'un Ancien d'un autre lignage (sauf Cités et Ombre)"),
    ]
  ),
  ingenieurMilitaire(
    castes: [Caste.protecteur, Caste.protecteurNoir],
    title: "L'ingénieur militaire",
    motto: "L'homme a besoin d'armes comme le dragon de ses ailes",
    motivations: "Créer, éprouver, améliorer",
    description: "Cette profession tient à la fois du stratège et de l’architecte. L’ingénieur militaire a pour charge d’utiliser les ressources du terrain pour assurer la meilleure défense possible. Ils sont spécialisés dans la construction des fortifications.",
    interdict: CareerInterdict(
      title: 'Tu ne te détourneras pas de ta voie',
      description: "",
    ),
    benefit: CareerBenefit(
      title: "Le jeu de l'ennemi",
      description: "La formation du personnage lui permet d'analyser avec précision la structure, la solidité, l’organisation et les points faibles de toutes sortes d’édifices et de fortifications. En réussissant un jet de Mental + Armes de siège contre une Difficulté de 10, le personnage peut obtenir une information sur la structure qu’il observe, plus une pour chaque Niveau de Réussite. Cette Difficulté est augmentée de 5 si l’édifice est particulièrement vaste ou complexe, mais aussi s’il est conçu dans une architecture inconnue. Par exemple, l’analyse d’une forteresse humaniste de grande taille pourra exiger une Difficulté de 20. Ces informalions permettent de déterminer la solidité, la composition, les éventuelles faiblesses et l’efficacité des systèmes de défense de n’importe quelle construction.\nDe plus, lorsqu’il est confronté à une arme mécanique, le personnage peut effectuer un jet de Mental + Armes mécaniques + Tendance Homme pour tenter d’en comprendre le fonctionnement. La Difficulté de ce jet est de 10 + le niveau de la Compétence Armes mécaniques du personnage. Si le jet est réussi, le personnage peut dépenser les Points d’Expérience correspondants et augmenter Armes mécaniques, Mécanismes ou Armes de siège de 1 - ou de 2 en cas de réussite critique. Il est impossible de faire appel aux Tendances et d’utiliser de la Maîtrise ou de la Chance sur ce jet. Le personnage doit impérativement disposer des Points d’Expérience nécessaires au moment du jet pour augmenter l’une de ces Compétences.\nIl gagne automatiquement autant de cercles en Tendance Homme que son nouveau score de Compétence, ce qui peut lui imposer une certaine réflexion et un ressourcement après ses découvertes.",
    ),
    specialization: "Armes de siège",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.manuel, min: 7),
      AbilityMinRequirement(ability: Ability.perception, min: 7),
      ProficiencyMinRequirement(min: 6),
      SkillFamilyTotalPointsRequirement(family: SkillFamily.technique, min: 30),
      TendencyMinRequirement(tendency: Tendency.human, min: 1),
    ]
  ),
  inquisiteur(
    castes: [Caste.protecteur, Caste.protecteurNoir],
    title: "L'inquisiteur",
    motto: "Il n'y a de vie que par les Grands Dragons",
    motivations: "Traquer, juger, éliminer",
    description: "Les Inquisiteurs sont recrutés parmi les Lieutenants. Ils sont généralement sélectionnés pour leur fanatisme et leurs brillants résultats. Certaines mauvaises langues affirment que beaucoup d’Inquisiteurs sont engagés grâce à leurs relations ou celles de leurs parents. Tout nouveau candidat doit suivre un entraînement d’une année. Il sera alors jugé par Brorne ou ses représentants. S’il est digne de rejoindre les rangs des Inquisiteurs, on lui remettra les symboles sacrés de sa fonction. Sinon, il reprendra ses fonctions habituelles mais en bénéficiant d’une promotion.",
    interdict: CareerInterdict(
      title: 'Tu ne connaîtras pas le doute',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Que justice soit faite !',
      description: "Lorsque le personnage affronte un adversaire jugé hérétique et reconnu comme tel du fait de ses actions ou de ses opinions, il dispose, par tour, d’un nombre de bonus égal à sa tendance Dragon. Chacun de ces bonus a une valeur égale à son Statut et peut s’appliquer à tous les jets à l’exception de l’Initiative. Chaque jet ne peut bénéficier que d’un bonus. Il n’est pas possible d’utiliser plusieurs de ces bonus lors d’une même action (comme au toucher ET aux dommages d’un même coup) à moins que le joueur n’ait annoncé en début de combat sa décision de ne plus faire appel aux Tendance pour l’ensemble de l’affrontement.",
    ),
    specialization: "Lois",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.physique, min: 6),
      AttributeMinRequirement(attribute: Attribute.mental, min: 6),
      AttributeMinRequirement(attribute: Attribute.social, min: 6),
      SingleSkillMinRequirement(skill: Skill.lois, min: 6),
      SingleSkillMinRequirement(skill: Skill.castes, min: 4),
      SingleSkillMinRequirement(skill: Skill.connaissanceDesDragons, min: 4),
      SkillAttributeTotalPointsRequirement(attribute: Attribute.physique, min: 40),
      SkillFamilyTotalPointsRequirement(family: SkillFamily.influence, min: 20),
      TendencyMaxRequirement(tendency: Tendency.human, max: 0),
      TendencyMaxRequirement(tendency: Tendency.fatality, max: 0),
      TendencyCirclesMaxRequirement(tendency: Tendency.fatality, max: 0),
      InterdictCountMinRequirement(caste: Caste.combattant, min: 3),
    ]
  ),
  instructeur(
    castes: [Caste.protecteur, Caste.protecteurNoir],
    title: "L'instructeur",
    motto: "Toute lame se forge, toute vie se forme",
    motivations: "Apprendre, guider, évaluer",
    description: "Choisis à partir du grade de Lieutenant, les instructeurs abandonnent la gloire des champs de bataille pour se consacrer à la formation des futurs soldats. Ils jouissent d’une excellente réputation, surtout quand des élèves de leurs écoles se distinguent en service commandé. On a coutume de dire qu’un bon instructeur vaut une légion entière.",
    interdict: CareerInterdict(
      title: 'Tu transmettras la tradition',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Les fruits de la tradition',
      description: "Du moment qu’il possède une Compétence d’un point supérieure au niveau que souhaite atteindre un de ses compagnons dans cette même Compétence, le personnage peut faciliter son apprentissage en effectuant un jet de Social + Compétence + niveau de Statut contre une Difficulté de 15 + niveau actuel de la Compétence de son compagnon. Un jet réussi annule les éventuels malus de Compétence Réservée, bien qu’il ne l’enseigne normalement qu’à un membre d’une caste connue pour l’utiliser. De plus, chaque NR obtenu permet d’économiser un point d’Expérience. En contrepartie, le personnage gagne un Point d'Expérience pour chaque niveau de Compétence ainsi acheté par son compagnon. Ce Bénéfice ne permet pas d’enseigner une Compétence Interdite tant que l’élève ne remplit pas les conditions normales d’apprentissage de cette Compétence.",
    ),
    specialization: "Ne peut posséder qu'une seule Spécialisation, correspondant à la Compétence qu'il enseigne",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.social, min: 5),
      AbilityMinRequirement(ability: Ability.presence, min: 6),
      ProficiencyMinRequirement(min: 7),
    ]
  ),
  legionnaire(
    castes: [Caste.protecteur, Caste.protecteurNoir],
    title: 'Le légionnaire',
    motto: "Aucune guerre n'est perdue d'avance",
    motivations: "Combattre, triompher",
    description: "Les légions sont constituées de l’élite des soldats. Un légionnaire est craint mais on le respecte plus que tout autre protecteur. Ils suivent un entraînement beaucoup plus dur que les autres soldats. La moindre faute est sévèrement sanctionnée. Un légionnaire se doit d’être l’incarnation des enseignements de Brorne.",
    interdict: CareerInterdict(
      title: 'Tu feras ton devoir',
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'appel du devoir",
      description: "Le personnage réduit de son niveau de Statut les malus découlants de ses blessures. De plus, lors de n’importe quel combat, il peut choisir un adversaire contre lequel il ajoutera son niveau de Statut aux dommages infligés. Il ne peut choisir qu’un seul ennemi par combat, même après la mort de celui-ci.",
    ),
    specialization: "Une compétence de Combat",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.physique, min: 6),
      AbilityMinRequirement(ability: Ability.resistance, min: 7),
      ProficiencyMinRequirement(min: 5),
      SkillAttributeTotalPointsRequirement(attribute: Attribute.physique, min: 40),
      HasAdvantageRequirement(advantage: Advantage.santeDeFer),
    ]
  ),
  milicien(
    castes: [Caste.protecteur, Caste.protecteurNoir],
    title: 'Le milicien',
    motto: "La paix n'est pas une utopie, mais un devoir",
    motivations: "Protéger, apaiser, rassurer",
    description: "Spécialisés dans la protection civile et le maintien de l’ordre, ces protecteurs ne participent que très rarement à de grandes batailles. Leur lot quotidien consiste à régler les petites escarmouches, à surveiller les alentours des cités et à lutter contre les criminels. Ils participent généralement aux affaires des villes qu’ils protègent.",
    interdict: CareerInterdict(
      title: 'Tu respecteras la loi',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Le garant de la paix',
      description: "Le personnage ajoute son niveau de Statut à tous ses jets impliquant l’Attribut Social effectués au sein d’une cité soumise à l’autorité draconique.",
    ),
    specialization: "Vie en cité ou Commandement",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.physique, min: 5),
      AttributeMinRequirement(attribute: Attribute.social, min: 5),
      AbilityMinRequirement(ability: Ability.presence, min: 4),
      SingleSkillMinRequirement(skill: Skill.vieEnCite, min: 5),
      SkillAttributeTotalPointsRequirement(attribute: Attribute.social, min: 20),
    ]
  ),
  protecteurItinerant(
    castes: [Caste.protecteur, Caste.protecteurNoir],
    title: 'Le protecteur itinérant',
    motto: "Le monde entier est tribunal de justice",
    motivations: "Découvrir, honorer, juger",
    description: "Le protecteur itinérant est un solitaire qui parcourt le monde afin d’apporter son aide aux communautés isolées. Il est également le porte-parole de Brorne et se doit donc d’incarner ses valeurs.",
    interdict: CareerInterdict(
      title: "Tu n'oublieras jamais ta condition",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "La force d'un seul",
      description: "Au début de chaque combat, le personnage gagne un nombre de Niveaux de Réussite, égal à son niveau de Statut, qu'il peut dépenser pour augmenter la réussite de n'importe quel jet d'attaque, de parade ou de dommages. Il ne peut dépenser qu'un seul Niveau de Réussite à la fois, sauf s'il annonce et conserve le dé du Dragon en faisant appel aux Tendances, auquel cas il peut en dépenser deux. Si le personnage annonce, avant sa première action, qu'il refuse de faire appel aux Tendances pour l'ensemble du combat, il dispose alors de 2 fois son Statut en NR, qu’il peut alors dépenser deux par deux à son gré.",
    ),
    specialization: "Survie ou Géographie",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.physique, min: 6),
      SingleSkillMinRequirement(skill: Skill.geographie, min: 5),
      SingleSkillMinRequirement(skill: Skill.castes, min: 3),
      SingleSkillMinRequirement(skill: Skill.orientation, min: 4),
      SkillFamilyTotalPointsRequirement(family: SkillFamily.mouvement, min: 15),
    ]
  ),
  questeurGris(
    castes: [Caste.protecteur, Caste.commercant, Caste.erudit, Caste.mage],
    isStandard: false,
    title: "Questeur Gris",
    motto: "Que lumière soit faite !",
    motivations: "Servir, enquêter, élucider",
    description: "Composée essentiellement de protecteurs et d'érudits, mais également de commerçants et des mages, la corporation des Questeurs gris est une organisation tentaculaire formée il y a de nombreux siècles à linitiative des castes des protecteurs et des commerçants afin d'aider les représentants du pouvoir local à asseoir la justice et à protéger les intérêts des particuliers, notamment celui des marchands. Depuis, des académies ont été ouvertes dans la plupart des grandes villes pour former des citoyens au travail d'enquêteur. À sa sortie de l'académie, le Questeur gris est affecté à une région déterminée et se met à la disposition du seigneur local auquel il devra rendre compte de toute affaire dont il est saisi. Les Questeurs n'ont aucun lien hiérarchique entre eux et ne relèvent que du directeur de leur académie, et au plus haut niveau, du Grand Commandeur de l'ordre qui est en réalité un fils de Khy.",
    interdict: CareerInterdict(
      title: "Tu ne mentiras point",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "Réquisition",
      description: "Le Questeur Gris peut réquisitionner la milice locale ou les soldats du seigneur sur les terres duquel il agit afin de procéder à des arrestations (maximum 3 personnes par Statut quelle que soit la caste, cumulable avec d'autres capacités). Il peut également exiger de la milice le prêt de matériel afin de mener un enquête, dans la mesure où le matériel est disponible et pour un montant total n'excédant pas 50dA.",
    ),
    specialization: "Aucune",
    requirements: [
      OneOfRequirements(
        requirements: [
          CasteMemberRequirement(caste: Caste.protecteur, status: CasteStatus.initie),
          CasteMemberRequirement(caste: Caste.commercant, status: CasteStatus.initie),
          CasteMemberRequirement(caste: Caste.erudit, status: CasteStatus.expert),
          CasteMemberRequirement(caste: Caste.mage, status: CasteStatus.expert),
        ]
      ),
      AbilityMinRequirement(ability: Ability.intelligence, min: 7),
      AbilityMinRequirement(ability: Ability.perception, min: 6),
      WeaponSkillsMinRequirement(min: 6),
      SingleSkillMinRequirement(skill: Skill.corpsACorps, min: 6),
      SingleSkillMinRequirement(skill: Skill.lois, min: 6),
      SingleSkillMinRequirement(skill: Skill.vieEnCite, min: 5),
    ],
    reservedSkills: [Skill.commandement, Skill.lois, Skill.vieEnCite],
  ),
  soldat(
    castes: [Caste.protecteur, Caste.protecteurNoir],
    title: 'Le soldat',
    motto: "Que le Dragon ordonne, j'obéis",
    motivations: "Combattre, défendre, obéir",
    description: "La carrière de soldat est une des plus pratiquées de la caste. On y forme la plupart des protecteurs qui constitueront le gros des troupes envoyées à droite et à gauche pour assurer la défense des villes. Les soldats les plus doués peuvent rapidement grimper les échelons de la hiérarchie militaire.",
    interdict: CareerInterdict(
      title: 'Tu respecteras ton supérieur',
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'esprit du corps",
      description: "Chaque fois qu'il combat aux côtés d'un nombre de compagnons égal à (10 -Statut), le personnage lance un dé d'Initiative de plus et choisit ses dés d’action à son gré. Ce Bénéfice est actif à tous les débuts de tour tant qu'il reste entouré d'un nombre de compagnon suffisant. Ses partenaires doivent tous être pareillement impliqués dans combat, que ce soit physiquement ou magiquement ; les observateurs ou les compagnons en fuite n'entrent pas dans le calcul.",
    ),
    specialization: "Maîtrise - Le personnage ne peut dépenser ni regagner aucun point de Chance lors de jets de combat",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.physique, min: 5),
      ProficiencyMinRequirement(min: 5),
      SkillAttributeTotalPointsRequirement(attribute: Attribute.physique, min: 40),
      SingleSkillMinRequirement(skill: Skill.athletisme, min: 5),
      SingleSkillMinRequirement(skill: Skill.strategie, min: 2),
    ]
  ),
  strategeProtecteur(
    castes: [Caste.protecteur, Caste.protecteurNoir],
    title: 'Le stratège',
    motto: "Le glaive n'est rien sans la main qui le guide",
    motivations: "Analyser, conseiller, vaincre",
    description: "Rivaux des stratèges de Kroryn, ceux de la caste des protecteurs jouissent d’un plus grand prestige. Cependant, ils ont une approche beaucoup plus globale des problèmes militaires et on leur reproche souvent de ne pas se soucier assez des individus. Les pertes humaines ne signifient pas grand-chose pourvu que l’objectif est atteint. De plus, leur spécialité est l’organisation des défenses et non des assauts.",
    interdict: CareerInterdict(
      title: "Tu sacrifieras l'individu à l'armée",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'La voix du guide',
      description: "En combat, dès le premier tour, le personnage peut utiliser ses actions pour donner des conseils à ses compagnons au lieu d’agir lui-même. En observant la situation, le stratège est à même de déterminer la meilleure tactique, d’avertir d’un danger ou de coordonner une action collective. La justesse de ses conseils se traduit par un bonus, égal à son niveau de Statut, qui peut s'appliquer sur la valeur de n’importe quel jet d’Initiative, d’attaque ou de défense. Pour ce faire, le personnage ne doit avoir effectué aucune action autre que celles-ci depuis le début du tour - ce qui ne l'empêche pas d'agir après. Le bonus ne peut être attribué qu’à une action résolue après la valeur d'action du dé que le stratège utilise pour donner son conseil.\nCette technique peut être utilisée une fois par dé d’action dont le personnage dispose. Cependant, pour prévenir un compagnon d'un danger, il doit impérativement l'avoir remarqué - au prix d’un jet de Perception, par exemple.\nCe Bénéfice fonctionne tant que les compagnons aiguillés sont à portée de voix du personnage.",
    ),
    specialization: "Stratégie (différente de la première)",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.mental, min: 6),
      AbilityMinRequirement(ability: Ability.presence, min: 7),
      SingleSkillMinRequirement(skill: Skill.strategie, min: 6),
      SingleSkillMinRequirement(skill: Skill.commandement, min: 6),
      SingleSkillMinRequirement(skill: Skill.eloquence, min: 6),
      SkillSpecializationCountMinRequirement(skill: Skill.strategie, min: 1),
    ]
  ),

  chasseurs(
    castes: [Caste.voyageur, Caste.voyageurFataliste],
    title: 'Les chasseurs',
    motto: "La nature offre des fruits que la civilisation pourrit",
    motivations: "Vivre, observer, sauvegarder",
    description: "Respectés et honorés, les chasseurs sont les seuls citoyens à affronter les animaux sauvages et les dangers de la nature de leur propre gré. Souvent très respectueux des enseignements de Heyra, ils ont pleine connaissance de la portée de chacun de leurs actes. Ils épargnent volontiers les animaux jeunes ou rares et ne chassent pas plus que ce qui est nécessaire à la subsistance de leur communauté. Ce sont souvent des personnes pratiques, quoiqu’un peu frustres de par leurs trop rares contacts avec d’autres humains, mais toujours empreints de sagesse. Ils sont souvent chargés de surveiller les lieux sauvages et s’organisent en patrouilles redoutables si des incursions de monstres surviennent dans leur région.",
    interdict: CareerInterdict(
      title: "Tu respecteras l'ordre naturel et le cycle de la vie",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Le carquois du chasseur',
      description: "Habitué à traquer et à se défendre contre toutes sortes d’espèces animales et monstrueuses du Royaume de Kor, le personnage a développé une solide connaissance de la faune qui lui permet, lors d’un combat, d’utiliser les points faibles pour accroître l’efficacité de ses coups. Pour chaque niveau de Statut qu’il possède, il peut choisir et nommer une espèce animale et une arme. En combat, lorsqu'il utilisera cette arme contre cette espèce précise, il pourra ajouter la valeur de son Attribut Manuel à chacun de ses jets de dommages.\nLe personnage ne peut choisir que des espèces qu'il connaît, pour avoir pu les rencontrer et les observer au cours de sa vie - l’homme n’est pas considéré comme une espèce animale dans ce cas précis, mais les dragons entrent naturellement dans cette catégorie, du moment que le personnage peut justifier d’une activité de “chasse draconique” plausible.",
    ),
    specialization: "Pister",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.physique, min: 6),
      AttributeMinRequirement(attribute: Attribute.manuel, min: 5),
      AbilityMinRequirement(ability: Ability.perception, min: 6),
      AbilityMinRequirement(ability: Ability.resistance, min: 6),
      TendencyMaxRequirement(tendency: Tendency.human, max: 2),
      SingleSkillMinRequirement(skill: Skill.armesAProjectiles, min: 6),
      SingleSkillMinRequirement(skill: Skill.athletisme, min: 5),
      SingleSkillMinRequirement(skill: Skill.pister, min: 6),
      SingleSkillMinRequirement(skill: Skill.connaissanceDesAnimaux, min: 6),
      SingleSkillMinRequirement(skill: Skill.premiersSoins, min: 5),
      SkillAttributeTotalPointsRequirement(attribute: Attribute.physique, min: 25),
    ]
  ),
  eclaireurs(
    castes: [Caste.voyageur, Caste.voyageurFataliste],
    title: 'Les éclaireurs',
    motto: "Chaque route s'ouvre devant les clés des pionniers",
    motivations: "Guider, protéger, conseiller",
    description: "Ce sont les éclaireurs qui représentent la majorité des voyageurs. Bien connus des citoyens pour leur rôle de protecteurs des caravanes et des troupes, ils sont considérés comme la branche la plus militaire de la caste. Disciplinés et dévoués à leurs compagnons, les éclaireurs deviennent guides ou escorteurs car ils sont les seuls à pouvoir éviter les dangers de la nature. Il n’est pas rare de voir des liens se tisser entre protecteurs et éclaireurs, dans leur mission commune de protection de leurs compagnons. En cas de guerre, ils sont aussi les meneurs des grands corps d’armée et forment des groupes de reconnaissance incomparables. Parfois, il arrive que les plus violents éclaireurs recherchent les conflits et s’apparentent alors plus à des mercenaires. Mais ils sont assez mal considérés par les combattants en raison de leurs talents d’archers, qui en font des adversaires insaisissables taxés de lâcheté.",
    interdict: CareerInterdict(
      title: 'Tu ne refuseras aucun périple, aucune traversée',
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Ouvrir la route',
      description: "Chaque fois qu'un danger ou qu'un événement imprévu survient en extérieur, le personnage peut réagir sans céder à la panique et ajouter son niveau de Statut à la valeur de son premier dé d'Initiative (dé le plus élevé). S'il le souhaite, il peut renoncer à ce gain pour tenter de prévenir ses compagnons du danger et leur faire gagner le même bonus - à tous sauf à lui-même - en réussissant un jet de Social + Perception contre une Difficulté de 20 ou un jet de Social + Commandement contre une Difficulté de 15. Il est possible de dépenser des Points de Chance sur ce jet, mais pas de Maîtrise. Si le jet est réussi, tous les membres du groupe voient leur premier dé d'Initiative augmenté du niveau de Statut du personnage éclaireur. Ce Bénéfice ne peut s'utiliser que si le jet de réaction a été réussi au moins simplement (pour le bonus personnel) ou au moins avec 2 NR (pour le bonus concernant ses compagnons). Si plusieurs éclaireurs préviennent ensemble une compagnie ou une caravane, c'est le voyageur possédant le plus haut Statut qui offre son bonus (mais lui pourra bénéficier de celui d'un éclaireur de Statut moindre).",
    ),
    specialization: "Orientation",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.physique, min: 5),
      AttributeMinRequirement(attribute: Attribute.mental, min: 4),
      AbilityMinRequirement(ability: Ability.perception, min: 7),
      AbilityMinRequirement(ability: Ability.empathie, min: 5),
      LuckMinRequirement(min: 5),
      SkillAttributeTotalPointsRequirement(attribute: Attribute.physique, min: 25),
      SingleSkillMinRequirement(skill: Skill.equitation, min: 5),
      SingleSkillMinRequirement(skill: Skill.pister, min: 6),
      SingleSkillMinRequirement(skill: Skill.geographie, min: 7),
      SingleSkillMinRequirement(skill: Skill.orientation, min: 7),
      SingleSkillMinRequirement(skill: Skill.astrologie, min: 4),
      SingleSkillMinRequirement(skill: Skill.attelages, min: 4),
      HasPrivilegeRequirement(privilege: CastePrivilege.vigilanceVoyageur),
    ]
  ),
  errants(
    castes: [Caste.voyageur, Caste.voyageurFataliste],
    title: 'Les errants',
    motto: "Le voyage n'est-il pas assez beau en lui-même pour lui chercher une justification ?",
    motivations: "Voyager, ressentir, partager",
    description: "Amoureux du voyage par nature, les errants ne supportent pas de planifier le moindre élément de leur parcours. Lunatiques, ils peuvent s’enflammer pour une cause ou une autre, décider brutalement d’aider une troupe le long d’un trajet, mais laissent souvent leurs pas les guider au hasard. Les errants sont parfois considérés comme des gueux sans but ou comme de doux illuminés qui ne parviennent pas à trouver un sens à leur vie. En fait, l’errant est souvent avide de contacts humains, de découvertes et de nouveauté, passions qui les amènent à ne plus se soucier de leur propre vie ou confort, mais uniquement de leur richesse relationnelle. Il n’est pas rare que des errants se découvrent certaines affinités avec des prodiges, comme des sages ou des prophètes, enclins comme eux aux relations intérieures et profondes.",
    interdict: CareerInterdict(
      title: 'Tu ne souilleras pas la mémoire des contrées que tu visites',
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'œil de l'Orphelin",
      description: "Alors que la plupart des aventuriers n’apprennent qu’en réalisant des actions et en expérimentant des situations liées à leur voie, leur caste, le personnage se nourrit des moindres sensations, des plus infimes paroles. Au moment du calcul des Points d’Expérience, le personnage ne peut gagner moins que son niveau de Statut dans les valeurs de Danger, de Découverte et d’Implication - les gains de ces trois valeurs sont donc rehaussés au niveau de Statut du personnage, s’ils lui sont inférieurs. La multiplication par deux des points de la valeur privilégiée s’eflectue après l’application de ce Bénéfice.",
    ),
    specialization: "Astrologie",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.mental, min: 5),
      AttributeMinRequirement(attribute: Attribute.social, min: 6),
      AbilityMinRequirement(ability: Ability.intelligence, min: 6),
      AbilityMinRequirement(ability: Ability.empathie, min: 7),
      OneOfRequirements(
        requirements: [
          TendencyMinRequirement(tendency: Tendency.human, min: 3),
          TendencyMinRequirement(tendency: Tendency.dragon, min: 3),
        ]
      ),
      SkillAttributeTotalPointsRequirement(attribute: Attribute.mental, min: 30),
      SkillAttributeTotalPointsRequirement(attribute: Attribute.social, min: 20),
      SingleSkillMinRequirement(skill: Skill.geographie, min: 7),
      SingleSkillMinRequirement(skill: Skill.histoire, min: 5),
      SingleSkillMinRequirement(skill: Skill.astrologie, min: 5),
    ]
  ),
  explorateurs(
    castes: [Caste.voyageur, Caste.voyageurFataliste],
    title: 'Les explorateurs',
    motto: "Il est tant de merveilles inconnues en ce monde",
    motivations: "Apprendre, chercher, découvrir",
    description: "Toujours à l’affût de rumeurs et de légendes, les explorateurs se rencontrent à la frontière entre Kor et les régions inconnues. Ce sont des gens passionnés, souvent obsédés par la soif de découverte et le prestige qu’elle confère. Bien connus des érudits, les explorateurs sont souvent sollicités pour mener à bien des missions dangereuses d’exploration de ruines ou de récupération de livres ou d’objets anciens.",
    interdict: CareerInterdict(
      title: "Tu ne garderas secrète aucune découverte d'importance",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'Le feu de camp',
      description: "Lorsqu'il est en voyage, en route vers une destination précise, le personnage peut préparer son expédition en attribuant un bonus à certaines Compétences. À la veille de chaque nouvelle journée, il dispose d’un nombre de points égal à son niveau de Statut qu’il peut attribuer - en les répartissant comme il l’entend - à une ou plusieurs de ses Compétences Mentales, Manuelles ou Sociales.\nDurant la journée qui suivra, tous les jets impliquant ces Compétences seront augmentés des points dépensés la veille au soir. Ce Bénéfice n’est utilisable que la veille et pour la journée qui suit - les points non dépensés sont perdus - et aucune Compétence ne peut être augmentée de plus de points que le niveau de la Tendance la plus élevée du personnage.",
    ),
    specialization: "Géographie",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.mental, min: 6),
      AbilityMinRequirement(ability: Ability.intelligence, min: 6),
      LuckMinRequirement(min: 6),
      AllOfRequirements(
        requirements: [
          TendencyMaxRequirement(tendency: Tendency.dragon, max: 2),
          TendencyMaxRequirement(tendency: Tendency.human, max: 2),
          TendencyMaxRequirement(tendency: Tendency.fatality, max: 2),
        ]
      ),
      SkillAttributeTotalPointsRequirement(attribute: Attribute.mental, min: 25),
      SingleSkillMinRequirement(skill: Skill.orientation, min: 6),
      SingleSkillMinRequirement(skill: Skill.geographie, min: 6),
      SingleSkillMinRequirement(skill: Skill.histoire, min: 6),
    ]
  ),
  menestrels(
    castes: [Caste.voyageur, Caste.voyageurFataliste],
    title: 'Les ménestrels',
    motto: "Les mots ont des couleurs que les yeux ne peuvent peindre",
    motivations: "Apprendre, interpréter, conter",
    description: "Les ménestrels forment le seul réseau de communication durable existant dans Kor. Outre leur rôle de pourvoyeurs de distractions par des contes, poésies et musiques, ils sont pour le peuple la seule source d’information sur les régions situées à plus de deux jours de route. Les ménestrels sont très appréciés par toutes les couches de population, du noble s’informant des affaires en cours hors de son fief jusqu’au serviteur, ravi de pouvoir avoir des nouvelles de son village natal. Les Historiens recherchent souvent les écrits des ménestrels, car ce sont souvent des témoignages vivants d’une époque et d’une région lointaines.",
    interdict: CareerInterdict(
      title: "Tu n'altéreras pas la vérité de l'Histoire",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'La veillée',
      description: "Au terme de chaque événement important, comme la fin d'une quête ou le dénouement d'une intrigue l'impliquant, lui ou ses compagnons, le personnage petit écrire et réciter un conte, un poème, une interprétation poétique de ces événements, qui en gravera les enseignements dans les mémoires. En termes techniques, cette veillée permet au personnage d'effectuer un jet de Social + Conte au terme de chaque aventure, au moment où le meneur de jeu attribue les Points d'Expérience du groupe, mais aussi de la Compagnie. La Difficulté du jet est égale à 5 + le total des Points d'Expérience du scénario + le nombre de personnages impliqués dans le groupe. S'il est réussi, tous les membres du groupe ou de la Compagnie gagnent un bonus de points supplémentaires égal au niveau de Statut du ménestrel. Il est impossible de ne choisir qu'une partie du groupe et ce jet ne peut être effectué qu'une seule fois. S'il utilise ce Bénéfice au sein d'une Compagnie d'Inspirés, le personnage ne peut faire gagner plus de Points d'Expérience que le niveau de sa Compétence Astrologie. De plus, le personnage peut faire et défaire les réputations.\n Par un jet de Social + Eloquence d'une Difficulté de 15 + Renommée de la personne décrite, il peut faire varier sa Renommée de 1 point en plus ou en moins. Il faut effectuer (et réussir) ce jet tous les jours durant autant de jours que le Statut de la cible, et à chaque fois devant un public différent. Dans le cas d'un sans caste, il faut discourir durant une semaine complète, les sans castes n'étant pas très marquants pour les esprits. Le changement a alors lieu dans les (6-Statut du Ménestrel) jours qui suivent, le temps que la rumeur se répande. On ne peut modifier une Renommée qu'une fois par Augure, et jamais plus de fois que son Statut. Ce Bénéfice peut également servir à modifier une réputation sans altérer l'Attribut de Renommée.",
    ),
    specialization: "Conte",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.social, min: 6),
      AttributeMinRequirement(attribute: Attribute.mental, min: 4),
      AbilityMinRequirement(ability: Ability.presence, min: 6),
      AbilityMinRequirement(ability: Ability.empathie, min: 6),
      TendencyMinRequirement(tendency: Tendency.human, min: 3),
      SkillAttributeTotalPointsRequirement(attribute: Attribute.social, min: 25),
      SingleSkillMinRequirement(skill: Skill.histoire, min: 4),
      SingleSkillMinRequirement(skill: Skill.conte, min: 6),
      SingleSkillMinRequirement(skill: Skill.eloquence, min: 6),
      SingleSkillMinRequirement(skill: Skill.psychologie, min: 5),
    ]
  ),
  messagers(
    castes: [Caste.voyageur, Caste.voyageurFataliste],
    title: 'Les messagers',
    motto: "Le savoir est un feu qu'il faut entretenir, un tableau sans cesse renouvelé",
    motivations: "Écouter, transmettre, communiquer",
    description: "Les messagers sont probablement les voyageurs les plus solitaires en raison de leur constante mobilité et de la rapidité de leurs déplacements. Les messagers sont parmi les meilleurs cavaliers de Kor, très habiles pour déjouer pièges et embuscades ou semer des poursuivants. Certains usent de la vitesse pure pour accomplir leurs missions, mais bon nombre d’entre eux sont de rusés comédiens, dissimulés sous de fausses identités afin de garantir la discrétion de leurs actes.",
    interdict: CareerInterdict(
      title: "Tu ne priveras tes pairs d'aucune information",
      description: "",
    ),
    benefit: CareerBenefit(
      title: "L'ambassadeur",
      description: "De par sa caste et sa fonction, jugée primordiale à l’acheminement des informations, le personnage peut demander à être entendu par n’importe quel représentant de caste d’un Statut égal au sien +1. Ainsi, au sein des cités draconiques ou fidèles aux Édits, le personnage pourra demander à rencontrer le citoyen de son choix et sera toujours entendu, ne serait-ce que par un autre représentant de Statut équivalent. Ce Bénéfice n’est pas utilisable dans les régions et les cités non affiliées aux Lois draconiques, mais sur une grande partie du Royaume de Kor, il est très malvenu de refuser une telle demande…",
    ),
    specialization: "Vie en cité",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.mental, min: 6),
      AttributeMinRequirement(attribute: Attribute.social, min: 4),
      AbilityMinRequirement(ability: Ability.empathie, min: 6),
      TendencyMinRequirement(tendency: Tendency.human, min: 2),
      TendencyMaxRequirement(tendency: Tendency.fatality, max: 0),
      SkillAttributeTotalPointsRequirement(attribute: Attribute.physique, min: 25),
      SkillAttributeTotalPointsRequirement(attribute: Attribute.social, min: 20),
      SingleSkillMinRequirement(skill: Skill.equitation, min: 6),
      SingleSkillMinRequirement(skill: Skill.geographie, min: 5),
      SingleSkillMinRequirement(skill: Skill.orientation, min: 6),
      SingleSkillMinRequirement(skill: Skill.vieEnCite, min: 6),
      SingleSkillMinRequirement(skill: Skill.baratin, min: 6),
    ]
  ),
  missionnaires(
    castes: [Caste.voyageur, Caste.voyageurFataliste],
    title: 'Les missionnaires',
    motto: "Le dons des Grands Dragons se transmet, tel le don de la vie",
    motivations: "Instruire, transmettre, célébrer",
    description: "Ces voyageurs sont parmi les plus fanatiques de la cause draconique connus. Ayant pris conscience des bienfaits des Édits draconiques, ils cherchent à instruire les peuplades les plus lointaines afin de leur faire partager ces enseignements. Ils sont souvent associés aux missionnaires Prodiges qui partagent la même flamme qu’eux. On ne les rencontre que rarement, mais la plupart du temps au-delà des frontières connues, bravant des cultures parfois très hostiles. Leur prosélytisme leur vaut un grand respect lorsqu’ils passent en Kor, car ils y sont considérés comme des incarnations vivantes du savoir draconique, dotées d’un courage sans limite pour oser aller instruire les infidèles.",
    interdict: CareerInterdict(
      title: "Tu ne détourneras pas l'enseignement draconique",
      description: "",
    ),
    benefit: CareerBenefit(
      title: 'La patience du tuteur',
      description: "À force de parcourir les routes pour transmettre son savoir, le personnage a développé un sens aigu de la pédagogie et peut, sans effectuer le moindre jet, réduire le coût en Points d’Expérience des Compétences qu’il enseigne - et qu’un autre personnage apprend et/ou développe grâce à lui - de son niveau de Statut. De plus, le personnage réduit du même montant le coût d’apprentissage et/ou de développement des Compétences qu’il apprend auprès d’un autre tuteur, du moment que ce dernier possède la Compétence en question à un niveau supérieur à son propre Statut. Ce Bénéfice n’est utilisable que pour développer des Compétences et réduire le coût d’achat d’un nouveau Privilège pour le personnage, du moment que celui-ci en possède moins que son niveau de Statut +2,",
    ),
    specialization: "Psychologie",
    requirements: [
      AttributeMinRequirement(attribute: Attribute.mental, min: 5),
      AttributeMinRequirement(attribute: Attribute.social, min: 6),
      AbilityMinRequirement(ability: Ability.intelligence, min: 7),
      AbilityMinRequirement(ability: Ability.volonte, min: 6),
      AbilityMinRequirement(ability: Ability.presence, min: 6),
      TendencyMinRequirement(tendency: Tendency.dragon, min: 3),
      SkillAttributeTotalPointsRequirement(attribute: Attribute.mental, min: 30),
      SkillAttributeTotalPointsRequirement(attribute: Attribute.social, min: 25),
      SingleSkillMinRequirement(skill: Skill.connaissanceDesDragons, min: 5),
      SingleSkillMinRequirement(skill: Skill.histoire, min: 6),
      SingleSkillMinRequirement(skill: Skill.lireEtEcrire, min: 6),
      SingleSkillMinRequirement(skill: Skill.eloquence, min: 5),
      SingleSkillMinRequirement(skill: Skill.psychologie, min: 6),
      SingleSkillMinRequirement(skill: Skill.diplomatie, min: 5),
    ]
  )
  ;

  final List<Caste> castes;
  final String title;
  final String motto;
  final String motivations;
  final String description;
  final CareerInterdict? interdict;
  final CareerBenefit benefit;
  final String specialization;
  final List<EntityRequirement> requirements;
  final List<Skill> reservedSkills;
  final bool isStandard;

  const Career({
    required this.castes,
    required this.title,
    required this.motto,
    required this.motivations,
    required this.description,
    this.interdict,
    required this.benefit,
    required this.specialization,
    this.requirements = const <EntityRequirement>[],
    this.reservedSkills = const <Skill>[],
    this.isStandard = true,
  });
}
