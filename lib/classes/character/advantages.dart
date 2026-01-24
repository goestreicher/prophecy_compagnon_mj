import '../caste/base.dart';

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
  humaniste(
    title: 'Humaniste',
    description: "Cet Avantage montre une véritable conversion du personnage aux thèses humanistes. En tant qu'Humaniste, le personnage peut ignorer la règle concernant l'Avantage “Art Interdit” requis avant le développement de Compétences Interdites. Il n'est donc plus obligé de l'acheter et peut accéder à ces Compétences à tout âge. De plus, il peut développer les Pouvoirs de l'esprit, une puissance psychique propre aux Humanistes qui lerr vaut les foudres des draconistes.\nLa Tendance Dragon d'un Humaniste convaincu ne peut jamais dépasser 1, tout comme sa Tendance Homme ne doit jamais descendre au-dessous de 3. Si l'une de ces conditions est brisée, le personnage perd l'usage de tous ses Pouvoirs de l'esprit, et ses points de Ferveur tombent à 0. Ses pouvoirs reviennedront à raison de un par semaine une fois ses Tendances rétablies. De même, ses points de Ferveur ne reviendront qu'à raison de un par jour suivant ce rééquilibrage de Tendances.",
    cost: [7],
    type: AdvantageType.general,
  ),
  magieIntuitive(
    title: 'Magie intuitive',
    description: "Cet avantage confère au personnage une base de 2 dans une Sphère de magie et un sort gratuit de Magie Instinctive de niveau 1 dans cette même Sphère (à définir avec le meneur). Les limitations liées aux Sphères doivent être respectées. Cet Avantage ne peut être choisi qu'une seule fois et est incompatible avec l'Avantage “Magie naturelle”.\nLe sort de Magie instinctive choisi doit être lié à une situation “traumatisante” vécue par le personnage (peur du noir, angoisse de la solitéde, crainte de ne plus voir les couleurs…). Lorsque les conditions sont réunies pour rappeler l'aspect traumatisant de la situation, l'effet du sort se déclenche automatiquement sur un jet de Volonté + Sphère concernée contre la Difficulté du sort diminuée de 5. Le sorte utilise les énergies élémentaires ambiantes et l'angoisse du lanceur pour s'activer, il ne consomme donc aucun point de magie et ne nécessite aucune Clé. Un personnage désirant empêcher l'effet automatique peut tenter de le contrôler en se raisonnant et en réussissant un jet d'Intelligence + Sphère concernée contre une Difficulté égale à son propre jet de Volonté + Sphère utilisé lors du déclenchement accidentel. En dehors des situations critiques, le sort peut être lancé normalement : jet normal, dépense de points de magie et usage de Clés.",
    cost: [5],
    type: AdvantageType.general,
    requireDetails: true,
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
    description: "La Chance inouïe permet à l’enfant de défier les lois de la probabilité et de réussir miraculeusement les actions qu’il était sur le point de rater. Que son jet soit raté ou réussi, le joueur peut dépenser des Points de Chance pour obtenir des NR (c’est l'exception qui confirme la règle de dépense des Points de Chance).",
    cost: [3],
    type: AdvantageType.enfant
  ),
  empathieNaturelle(
    title: 'Empathie naturelle',
    description: "Cet Avantage permet au personnage de “sentir” son environnement comme s’il pouvait établir un contact empathique avec les éléments qui l’entourent. Cette faculté lui permet de ressentir des impressions, des émotions, des peurs. Cet Avantage s'utilise avec un jet de Mental + Empathie contre une Difficulté variable, en fonction de l’action entreprise. Pour ressentir des émotions sur des animaux et des créatures dénuées d'intelligence, la Difficulté est de 10. Sur des êtres intelligents, la Difficulté passe à 15. Le meneur de jeu se réserve le droit de faire effectuer à la cible un jet de Mental + Volonté contre une Difficulté de 15, s’il estime que cette dernière cherche à masquer ses émotions. Ce jet est alors un jet d'opposition.",
    cost: [4],
    type: AdvantageType.enfant
  ),
  faeGardienne(
      title: 'Faë gardienne',
      description: "L'enfant a attiré l'attention d'une faë qui veille sur lui. Elle ne se révèlera jamais franchement, mais laissera des signes discrets de son attachement. Outre des interventions matérielles mineures (déplacer un petit objet, dérober une épingle à cheveux qui lui plaît…), la faë peut dépenser des points de magie comme des points de Chance en plus de ceux de l'enfant. Ce pouvoir n'est pas automatique et la faë est toujours gérée par le MJ. La faë regagne ses points de magie tous les jours de la Nature ou dans les sites élémentaires.",
      cost: [3],
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